use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use Test::Exception;

# fake the user
local $ENV{MOJOGOLF_USER} = 'TestRest';

my $t = Test::Mojo->new('MojoGolf');

$t->get_ok('/rest/v1/challenges/schema')
  ->status_is(200)
  ->json_is('/0/name', 'id')
  ->json_is('/0/type', 'serial')
  ->json_has('/0/not_null')
  ->json_has('/0/display_name');

# test an overridden display name
$t->get_ok('/rest/v1/languages/schema')
  ->status_is(200)
  ->json_is('/5/display_name', 'Boilerplate Wrapper');



done_testing();
