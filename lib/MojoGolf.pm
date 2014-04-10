package MojoGolf;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;

  $self->plugin('config');
  $self->plugin('basic_auth');

  # Router
  my $r = $self->routes;

  my $auth = $r->bridge->to('user#check_auth');

  # Normal route to controller
  $auth->get('/')->to('example#welcome');

  $auth->get('/challenges')->to('challenges#index');
}

1;
