#!/usr/bin/perl

use strict;
use warnings;

use Scalar::Util qw(looks_like_number);

use Test::More 'no_plan';

use Type::Simple qw(
  validate
  Any
  Bool
  Maybe
  Undef
  Defined
  Value
  Str
  Num
  Int
  Ref
  ScalarRef
  ArrayRef
  HashRef
  CodeRef
  RegexpRef
  Object
);

my @tests = (
    {
        value => undef,
        isa   => {
            Any  => 1,
            Bool => 1,
        },
    },
    {
        value => '',
        isa   => {
            Any   => 1,
            Bool  => 1,
            Value => 1,
            Str   => 1,
        },
    },
    {
        value => 0,
        isa   => {
            Any   => 1,
            Bool  => 1,
            Value => 1,
            Str   => 1,
        },
    },
    {
        value => 1,
        isa   => {
            Any   => 1,
            Bool  => 1,
            Value => 1,
            Str   => 1,
        },
    },
    {
        value => 1000,
        isa   => {
            Any   => 1,
            Bool  => 0,
            Value => 1,
            Str   => 1,
        },
    },
    {
        value => 3.14,
        isa   => {
            Any   => 1,
            Bool  => 0,
            Value => 1,
            Str   => 1,
        },
    },
    {
        value => 'abc',
        isa   => {
            Any   => 1,
            Bool  => 0,
            Value => 1,
            Str   => 1,
        },
    },
    {
        value => \123,
        isa   => {
            Any       => 1,
            Ref       => 1,
            ScalarRef => 1,
        },
    },
    {
        value => [],
        isa   => {
            Any      => 1,
            Ref      => 1,
            ArrayRef => 1,
        },
    },
    {
        value => {},
        isa   => {
            Any     => 1,
            Ref     => 1,
            HashRef => 1,
        },
    },
    {
        value => sub {123},
        isa   => {
            Any     => 1,
            Ref     => 1,
            CodeRef => 1,
        },
    },
    {
        value => qr/foo/,
        isa   => {
            Any       => 1,
            Ref       => 1,
            RegexpRef => 1,
            Object    => 1,    # Scalar::Util::blessed() says that a Regexp reference is blessed!
        },
    },
    {
        value => bless( {}, 'FOO' ),
        isa   => {
            Any    => 1,
            Ref    => 1,
            Object => 1,
        },
    },
);

foreach my $test (@tests) {
    my $value = $test->{value};
    my $isa   = $test->{isa};

    note( sprintf '===== %s =====', $value // 'undef' );

    is( !!validate( Any(),       $value ), !!$isa->{Any},       'Any' );
    is( !!validate( Bool(),      $value ), !!$isa->{Bool},      'Bool' );
    is( !!validate( Value(),     $value ), !!$isa->{Value},     'Value' );
    is( !!validate( Str(),       $value ), !!$isa->{Str},       'Str' );
    is( !!validate( Ref(),       $value ), !!$isa->{Ref},       'Ref' );
    is( !!validate( ScalarRef(), $value ), !!$isa->{ScalarRef}, 'ScalarRef' );
    is( !!validate( ArrayRef(),  $value ), !!$isa->{ArrayRef},  'ArrayRef' );
    is( !!validate( HashRef(),   $value ), !!$isa->{HashRef},   'HashRef' );
    is( !!validate( CodeRef(),   $value ), !!$isa->{CodeRef},   'CodeRef' );
    is( !!validate( RegexpRef(), $value ), !!$isa->{RegexpRef}, 'RegexpRef' );
    is( !!validate( Object(),    $value ), !!$isa->{Object},    'Object' );

    is( !!validate( Defined(), $value ), !!( defined($value) ),     'Defined' );
    is( !!validate( Undef(),   $value ), !!( not defined($value) ), 'Undef' );

    is( !!validate( Num(), $value ), !!looks_like_number($value), 'Num' );
    is( !!validate( Int(), $value ), !!( looks_like_number($value) and int($value) == $value ), 'Int' );
}
