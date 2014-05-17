package MojoGolf::Web::Controller::Challenge;

use Mojo::Base 'Mojolicious::Controller';

# use MojoGolf::DB::User;
use MojoGolf::DB::Challenge::Manager;

sub index {
    my $self = shift;

    $self->stash->{challenges} = MojoGolf::DB::Challenge::Manager->get_challenges();
}


1;
