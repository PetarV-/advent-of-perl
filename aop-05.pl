#! /usr/bin/perl
use strict;
use warnings;

my $fname = 'input.txt';

open(my $fh, '<', $fname)
    or die "Could not open file '$fname' $!";

my $ret = 0;

# Unset the input record separator ($/) to read in entire file
local $/ = undef;

# Get all tokens (non-whitespace blocks) from the file
my @arr = <$fh> =~ /(\S+)/g;

my $pos = 0;

while ($pos >= 0 and $pos < @arr) {
    $pos += $arr[$pos]++;
    $ret++;
}

print("The number of steps until exiting is $ret\n");

# Seek back to beginning of file
seek($fh, 0, 0);

$ret = 0;

@arr = <$fh> =~ /(\S+)/g;

$pos = 0;

while ($pos >= 0 and $pos < @arr) {
    $pos += $arr[$pos] > 2 ? $arr[$pos]-- : $arr[$pos]++;
    $ret++;
}

print("With modified jumps, the number of steps is $ret\n");

close($fh);
