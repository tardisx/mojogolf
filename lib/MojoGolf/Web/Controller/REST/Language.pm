package MojoGolf::Web::Controller::REST::Language;

use Time::Duration qw/duration concise/;

use Mojo::Base 'MojoGolf::Web::Controller::REST';

sub db_class_read   { "MojoGolf::DB::Language" }
sub db_class_write  { "MojoGolf::DB::Language" }
sub get_method      { "get_languages" }
sub post_fields     { qw/name compile source_filename run boilerplate/ }


1;
