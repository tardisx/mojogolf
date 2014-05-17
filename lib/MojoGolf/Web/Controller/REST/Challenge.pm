package MojoGolf::Web::Controller::REST::Challenge;

use Time::Duration qw/duration concise/;

use Mojo::Base 'MojoGolf::Web::Controller::REST';

sub db_class_read   { "MojoGolf::DB::Challenge" }
sub db_class_write  { "MojoGolf::DB::Challenge" }
sub get_method      { "get_challenges" }
sub post_fields     { qw/name short_descr long_descr finishes/ }


1;
