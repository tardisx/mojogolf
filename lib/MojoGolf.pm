package MojoGolf;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;

  $self->plugin('config');
  $self->plugin('basic_auth');

  # Router
  my $r = $self->routes;

  $r->namespaces([qw/MojoGolf::Web::Controller/]);

  my $auth = $r->bridge->to('user#check_auth');

  $auth->get('/challenges')->to('challenges#index');
  $auth->get('/challenges/:challenge_id')->to('challenges#challenge');

}

1;
