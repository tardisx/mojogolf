package MojoGolf::Web::Controller::User;

use Mojo::Base 'Mojolicious::Controller';

use Authen::Simple;
use MojoGolf::DB::User;

sub check_auth {
  my $self = shift;
  if ($ENV{MOJOGOLF_USER}) {
      $self->_fetch_or_create_user($ENV{MOJOGOLF_USER});
      return 1;
  }

  my $username;
  my $auth = $self->basic_auth(
    mojogolf => sub {
      my $u = shift;
      my $p = shift;
      return 0 unless ($u && $p);
      if ($self->_auth($u, $p)) {
          $username = $u;
          return 1;
      }
      return 0;
    }
  );

  if ($auth) {
      $self->_fetch_or_create_user($username);
      return 1;
  }
  else {
    # $self->app->log->error("bad auth");
    # $self->render(status => 200, text => "oh you are a very naughty boy");
  }
}

sub _fetch_or_create_user {
    my $self     = shift;
    my $username = shift;

    my $user = MojoGolf::DB::User->new(username => $username)->load(speculative => 1);
    if (! $user) {
        $user = MojoGolf::DB::User->new(username => $username)->save();
    }
    $self->stash->{user} = $user;
}

sub _auth {
  my $self = shift;
  my $username = shift;
  my $password = shift;

  $self->app->log->info("authing for $username");

  my @auth_simple_objects;
  foreach my $auth_simple_method (@{ $self->app->config->{auth} }) {
      eval "use $auth_simple_method->{module}; 1;"
        or do { $self->app->log->error($@); };
      push @auth_simple_objects,
        $auth_simple_method->{module}->new($auth_simple_method->{args});
  }
  my $auth = Authen::Simple->new(@auth_simple_objects);

  if ( $auth->authenticate( $username, $password ) ) {
    $self->app->log->info("authing for $username - success");
    $self->stash->{username} = $username;
    return 1;
  }

  $self->app->log->info("authing for $username - failed");
  return 0;

}

1;
