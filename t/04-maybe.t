#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';

use Type::Simple qw(
    validate
    Any
    Maybe
    Str
    Int
    ArrayRef
    HashRef
);

my @tests = (
    {
        value  => 123,
        isa    => Maybe( Int() ),
        result => 1,
    },
    {
        value  => undef,
        isa    => Maybe( Int() ),
        result => 1,
    },
    {
        value  => 'xyz',
        isa    => Maybe( Int() ),
        result => 0,
    },
    {
        value  => [ 1, undef, 2, 3 ],
        isa    => ArrayRef( Maybe( Int() ) ),
        result => 1,
    },
    {
        value  => [ 1, undef, 2, 'xyz' ],
        isa    => ArrayRef( Maybe( Int() ) ),
        result => 0,
    },
    {
        value  => [ 1, undef, 2, 'xyz' ],
        isa    => ArrayRef( Maybe( Str() ) ),
        result => 1,
    },
    {
        value  => { foo => 1, bar => undef },
        isa    => HashRef( Maybe( Int() ) ),
        result => 1,
    },
    {
        value  => { foo => 1, bar => 'xyz' },
        isa    => HashRef( Maybe( Int() ) ),
        result => 0,
    },
);

foreach my $test (@tests) {
    my $value = $test->{value};
    my $isa   = $test->{isa};

    is( validate( $test->{isa}, $test->{value} ), $test->{result} );
}

# final test: test the @tests :-)

ok( validate( ArrayRef( HashRef( Any() ) ), \@tests ) );
