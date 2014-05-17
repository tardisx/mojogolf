package MojoGolf::Authen::Simple::Test;

use strict;
use warnings;

use base 'Authen::Simple::Adapter';

sub check {
    my ($self, $username, $password) = @_;

    if ($username eq 'test' && $password eq 'test') {
        return 1;
    }
    return 0;
}

1;
