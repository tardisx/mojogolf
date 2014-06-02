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

  my $rest = $r->bridge('/rest/v1');

  # challenges
  $rest->get('/challenges/schema')->to(controller => 'REST::Challenge', action => 'schema');
  $rest->get('/challenges')       ->to(controller => 'REST::Challenge', action => 'get_collection');
  $rest->get('/challenges/:id')   ->to(controller => 'REST::Challenge', action => 'get_one');
  $rest->post('/challenges')      ->to(controller => 'REST::Challenge', action => 'post');
  $rest->put('/challenges/:id')   ->to(controller => 'REST::Challenge', action => 'put');
  $rest->delete('/challenges/:id')->to(controller => 'REST::Challenge', action => 'delete');

  # languages
  $rest->get('/languages/schema')->to(controller => 'REST::Language', action => 'schema');
  $rest->get('/languages')       ->to(controller => 'REST::Language', action => 'get_collection');
  $rest->get('/languages/:id')   ->to(controller => 'REST::Language', action => 'get_one');
  $rest->post('/languages')      ->to(controller => 'REST::Language', action => 'post');
  $rest->put('/languages/:id')   ->to(controller => 'REST::Language', action => 'put');
  $rest->delete('/languages/:id')->to(controller => 'REST::Language', action => 'delete');

}

sub setup_helpers {
    my $self = shift;
    $self->helper( from_now => sub { my $dt = $_[1]; return concise(from_now($dt->epoch - time())); } );
}

1;
