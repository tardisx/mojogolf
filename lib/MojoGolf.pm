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

  foreach my $rt (qw/challenges languages/) {
    my $class = "REST::" . ucfirst $rt;  # REST::Challenges
    chop $class;                         # REST::Challenge
    $rest->get("/$rt/schema")->to(controller => $class, action => 'schema');
    $rest->get("/$rt")       ->to(controller => $class, action => 'get_collection');
    $rest->get("/$rt/:id")   ->to(controller => $class, action => 'get_one');
    $rest->post("/$rt")      ->to(controller => $class, action => 'post');
    $rest->put("/$rt/:id")   ->to(controller => $class, action => 'put');
    $rest->delete("/$rt/:id")->to(controller => $class, action => 'delete');
  }

}

sub setup_helpers {
    my $self = shift;
    $self->helper( from_now => sub { my $dt = $_[1]; return concise(from_now($dt->epoch - time())); } );
}

1;
