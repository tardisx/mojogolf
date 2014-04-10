#
# Note that UNLIKE the other files in this directory, this one is not
# automatically generated - take care of it.
#
package MojoGolf::DB::Object;

use strict;
use warnings;

use MojoGolf::DB;

use Rose::DB::Object::Helpers 'insert_or_update';

use base qw(Rose::DB::Object);

sub init_db { return MojoGolf::DB->new; }

sub as_hashref {
  my $self = shift;
  return { map { $_ => $self->$_ } sort $self->meta->columns };
}


1;
