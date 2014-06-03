package MojoGolf::Web::Controller::REST;

use strict;
use warnings;

use Mojo::Base 'Mojolicious::Controller';

use Carp qw/confess/;
use Module::Load qw/load/;
use Data::Dumper;

sub query_args       { return () }
sub db_class_read    { confess "was not overridden" }
sub db_class_write   { confess "was not overridden" }
sub get_method       { confess "was not overridden" }
sub get_extra_fields { () }
sub post_fields      { confess "was not overridden" }
sub load_with        { () }
sub sanitise         { }

sub schema {
    my $self  = shift;
    my $class = $self->db_class_read;
    load $class;
    my $data = [];
    foreach ( $class->meta->columns ) {
        push @$data,
          { name         => $_->name,
            type         => $_->type,
            not_null     => $_->not_null,
            display_name => $class->display_name($_),
          };
    }
    $self->render( json => $data );
}

sub get_one {
    my $self  = shift;
    my $class = $self->db_class_read;
    my $id    = $self->stash('id');

    if ( !$id ) {
        return $self->render(
            status => 404,
            json   => { error => 'no id provided' }
        );
    }
    if ( $id !~ /^\d+$/ ) {
        return $self->render(
            status => 400,
            json   => { error => "bad id $id provided" }
        );
    }

    load $class;

    my %with = ();
    $with{with} = [ $self->load_with ] if ( $self->load_with );

    my $new = $class->new( id => $id )->load( speculative => 1, %with );
    if ( !$new ) {
        return $self->render(
            status => 404,
            json   => { error => 'no such object id: ' . $id }
        );
    }

    my $data = $new->as_tree();
    $self->sanitise($data);

    return $self->render(
        status => 200,
        json   => { %{$data}, $self->get_extra_fields($new) }
    );
}

sub get_collection {
    my $self   = shift;
    my $limit  = $self->param('limit') || 50;
    my $offset = $self->param('offset') || 0;
    my $sort   = $self->param('sort') || 'id ASC';

    my $class = $self->db_class_read . "::Manager";
    load $class;

    my %extra_args = $self->query_args;

    my $method     = $self->get_method;
    my $collection = $class->$method(
        with_objects => [ $self->load_with ],
        query        => [%extra_args],
        limit        => $limit,
        offset       => $offset,
        sort_by      => $sort
    );

    my $data = [
        map {
            { %{ $_->as_tree }, $self->get_extra_fields($_) }
        } @$collection
    ];
    $self->sanitise($_) foreach @$data;

    return $self->render( status => 200, json => $data );
}

sub delete {
    my $self  = shift;
    my $class = $self->db_class_write;
    my $id    = $self->stash('id');

    if ( !$id ) {
        return $self->render(
            status => 404,
            json   => { error => 'no id provided' }
        );
    }
    if ( $id !~ /^\d+$/ ) {
        return $self->render(
            status => 400,
            json   => { error => "bad id $id provided" }
        );
    }

    load $class;

    my $object = $class->new( id => $id )->load( speculative => 1 );

    if ( !$object ) {
        return $self->render(
            status => 404,
            json   => { error => 'no such object id: ' . $id }
        );
    }
    eval { $object->delete };

    if ($@) {
        return $self->render( status => 400, json => { error => $@ } );
    }
    return $self->render( status => 200, json => {} );
}

sub post {
    my $self  = shift;
    my $class = $self->db_class_write;
    my $req   = $self->req->json;

    load $class;

    my $new = $class->new();
    foreach my $param ( $self->post_fields ) {
        if ( $req->{$param} && !ref( $req->{$param} ) ) {
            eval { $new->$param( $req->{$param} ) };
            return $self->_render_set_exception( $param, $@ ) if $@;
        }
    }
    my %extra = $self->query_args;
    foreach my $param ( keys %extra ) {
        eval { $new->$param( $extra{$param} ) };
        return $self->_render_set_exception( $param, $@ ) if $@;
    }

    if ( $new->can('user_id') ) {
        $new->user_id( $self->stash->{user}->id );
    }

    $self->_eval_save($new);
}

sub put {
    my $self  = shift;
    my $class = $self->db_class_write;
    my $req   = $self->req->json;
    my $id    = $self->param('id');

    $self->_log( 'PUT', "id: $id" );

    load $class;

    my $new = $class->new( id => $id )->load( speculative => 1 );
    if ( !$new ) {
        return $self->render(
            status => 404,
            json   => { error => 'no such object' }
        );
    }

    foreach my $param ( $self->post_fields ) {
        if ( $req->{$param} && !ref( $req->{$param} ) ) {
            eval { $new->$param( $req->{$param} ) };
            return $self->_render_set_exception( $param, $@ ) if $@;
        }
    }

    $self->_eval_save($new);
}

sub _render_set_exception {
    my $self      = shift;
    my $field     = shift;
    my $exception = shift;
    my $error     = $exception;

    if ( $exception =~ /invalid timestamp/i ) {
        $error = "an invalid timestamp was provided for the field '$field'";
    }

    return $self->render( status => 400, json => { error => $error } );
}

sub _eval_save {
    my $self = shift;
    my $obj  = shift;

    eval { $obj->save() };
    my $error = $@;
    if ( !$error ) {
        return $self->render( json => $obj->as_tree );
    }
    my $error_msg = $error;
    if ( $error
        =~ /null value in column "(\w+)" violates not-null constraint/ )
    {
        $error_msg = "no value provided for required field '$1'";
    }
    elsif ( $error =~ /invalid input syntax for type numeric/ ) {
        $error_msg = "invalid value for numeric field";
    }

    $self->render( status => 400, json => { error => $error_msg } );
}

sub _log {
    my $self   = shift;
    my $class  = $self->db_class_read;
    my $method = shift;
    my $msg    = shift;

    $self->app->log->info("REST: $class $method: $msg");
    return;
}

1;
