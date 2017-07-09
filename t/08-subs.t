#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';

use Type::Simple qw(
    validate
    ArrayRef
    HashRef
);

my $less_than_ten = sub {
    my ($value) = @_;
    return $value < 10 ? 1 : 0;
};

my @tests = (
    {
        value  => 1,
        isa    => $less_than_ten,
        result => 1,
    },
    {
        value  => 100,
        isa    => $less_than_ten,
        result => 0,
    },
    {
        value  => [ 1..9 ],
        isa    => ArrayRef( $less_than_ten ),
        result => 1,
    },
    {
        value  => [ 10..20 ],
        isa    => ArrayRef( $less_than_ten ),
        result => 0,
    },
);

foreach my $test (@tests) {
    is( validate( $test->{isa}, $test->{value} ), $test->{result} );
}
