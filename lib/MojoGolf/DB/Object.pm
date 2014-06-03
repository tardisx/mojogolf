#
# Note that UNLIKE the other files in this directory, this one is not
# automatically generated - take care of it.
#
package MojoGolf::DB::Object;

use strict;
use warnings;

use MojoGolf::DB;

use Rose::DB::Object::Helpers 'insert_or_update', 'as_tree';

use base qw(Rose::DB::Object);

sub init_db { return MojoGolf::DB->new; }

sub display_name {
    my $class    = shift;
    my $col_name = shift;
    return $col_name;
}


1;
