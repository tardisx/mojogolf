package MojoGolf::DB;

use strict;
use warnings;

use Rose::DB;
use base 'Rose::DB';

# Use a private registry for this class
__PACKAGE__->use_private_registry;

# Set the default domain and type
__PACKAGE__->default_domain('development');
__PACKAGE__->default_type('SQLite');

# Register the data sources

# Development:
__PACKAGE__->register_db(
  domain   => 'development',
  type     => 'SQLite',
  driver   => 'SQLite',
  database => 'db.db',
  print_error => 0,
);


1;
