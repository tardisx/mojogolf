use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use Test::Exception;

# fake the user
local $ENV{MOJOGOLF_USER} = 'TestRest';

my $t = Test::Mojo->new('MojoGolf');

$t->get_ok('/rest/v1/languages')
  ->status_is(200);

# create a language, bad parameter
$t->post_ok('/rest/v1/languages', json => {})
  ->status_is(400)
  ->json_has('/error');

like($t->tx->res->json->{error}, qr/not null/i, 'correct error');

# create one for real - will work
$t->post_ok('/rest/v1/languages', json => { name => "test_language_$$" })
  ->status_is(200)
  ->json_has('/id');

my $id = $t->tx->res->json->{id};

# try for duplicate
$t->post_ok('/rest/v1/languages', json => { name => "test_language_$$" })
  ->status_is(400)
  ->json_has('/error');

like($t->tx->res->json->{error}, qr/unique/i, 'correct error');

# fetch the one we made earlier
$t->get_ok('/rest/v1/languages/'.$id)
  ->status_is(200)
  ->json_is('/name', "test_language_$$");

# fetch many
$t->get_ok('/rest/v1/languages')
  ->status_is(200)
  ->json_has('/0'); # at least one element

my $all = $t->tx->res->json;

my $found = 0;
foreach (@$all) {
    $found = 1 if ($_->{id} == $id);
}

ok ($found, 'found the created language');

# modify it
$t->put_ok('/rest/v1/languages/'.$id, json => { name => "test_language2_$$" })
  ->status_is(200);

# fetch again, check the name
$t->get_ok('/rest/v1/languages/'.$id)
  ->status_is(200)
  ->json_is('/id', $id)
  ->json_is('/name', "test_language2_$$");

# delete it
$t->delete_ok('/rest/v1/languages/'.$id)
  ->status_is(200);

# ensure it is no longer here
$t->get_ok('/rest/v1/languages')
  ->status_is(200);

$all = $t->tx->res->json;

$found = 0;
foreach (@$all) {
    $found = 1 if ($_->{id} == $id);
}

ok(!$found, 'did not find the deleted language');

done_testing();

