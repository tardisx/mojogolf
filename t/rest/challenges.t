use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use Test::Exception;

# fake the user
local $ENV{MOJOGOLF_USER} = 'TestRest';

my $t = Test::Mojo->new('MojoGolf');

$t->get_ok('/rest/v1/challenges')
  ->status_is(200);

# create a challenge
$t->post_ok('/rest/v1/challenges', json =>
                                   { name => "great_challenge_$$",
                                     short_descr => "this is short",
                                     long_descr => "this is longer",
                                     finishes => DateTime->now->add(days => 2),
                                     })

  ->status_is(200);

# first get id
my $id = $t->tx->res->json->{id};

# try getting it
$t->get_ok('/rest/v1/challenges/'.$id)
  ->status_is(200)
  ->json_is('/id', $id);

# lets change the descr
# PUT to it
$t->put_ok('/rest/v1/challenges/'.$id, json => { long_descr => 'long descr is loooooooong', short_descr => 'very short' })
  ->status_is(200);

# DEL it
$t->delete_ok('/rest/v1/challenges/'.$id)
  ->status_is(200);

# check it's really gone
$t->get_ok('/rest/v1/challenges/'.$id)
  ->status_is(404);

done_testing();
