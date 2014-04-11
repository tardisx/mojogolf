package MojoGolf::User;
use Mojo::Base 'Mojolicious::Controller';

use Authen::Simple::LDAP;

sub check_auth {
  my $self = shift;
  if ($ENV{MOJOGOLF_USER}) {
    $self->stash->{username} = $ENV{MOJOGOLF_USER};
    return 1;
  }

  my $auth = $self->basic_auth(
    realm => sub {
      my $u = shift;
      my $p = shift;
      return 0 unless ($u && $p);
      return $self->_auth($u, $p); 
    }
  );

  if ($auth) {
    return 1;
  }
  else {
    # $self->app->log->error("bad auth");
    # $self->render(status => 200, text => "oh you are a very naughty boy");
  }
}

sub _auth {
  my $self = shift;
  my $username = shift;
  my $password = shift;

  $self->app->log->info("authing for $username");

  my $ldap = Authen::Simple::LDAP->new(
    host    => $self->config->{auth}->{ldap_host},
    basedn  => $self->config->{auth}->{ldap_dn},
    port    => $self->config->{auth}->{ldap_port},

  );

  if ( $ldap->authenticate( $username, $password ) ) {
    $self->app->log->info("authing for $username - success");
    $self->stash->{usernane} = $username;
    return 1;
  }
  $self->app->log->info("authing for $username - failed");
  return 0;

}

1;
