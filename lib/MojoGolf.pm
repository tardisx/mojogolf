package MojoGolf;
use Mojo::Base 'Mojolicious';

use MojoGolf::DB;
use Time::Duration qw/from_now concise/;

# This method will run once at server start
sub startup {
  my $self = shift;

  $self->plugin('config');
  $self->plugin('basic_auth');
  $self->setup_helpers;

  # Router
  my $r = $self->routes;

  # Set controller namespace
  $r->namespaces([qw/MojoGolf::Web::Controller/]);

  # Default template layout
  $self->defaults(layout => 'default');

  my $auth = $r->bridge->to('user#check_auth');

  $auth->get('/challenges')->to('challenge#index');
  $auth->get('/challenges/:challenge_id')->to('challenges#challenge');
}

sub setup_helpers {
    my $self = shift;
    $self->helper( from_now => sub { my $dt = $_[1]; return concise(from_now($dt->epoch - time())); } );
}


1;
