#! /usr/bin/perl
use strict;
use warnings;

# Helper function to concatenate an array into a string (for the hash table)
sub mk_hash {
    my $ret = "";
    foreach (@_) {
        $ret = "$ret,$_";
    }
    return $ret;
}

my $fname = 'input.txt';

open(my $fh, '<', $fname)
    or die "Could not open file '$fname' $!";

my $ret = 0;

# Unset the input record separator ($/) to read in entire file
local $/ = undef;

# Get all tokens (non-whitespace blocks) from the file
my @arr = <$fh> =~ /(\S+)/g;

my %mark;

$mark{mk_hash(@arr)}++;

while (1) {
    $ret++;
    my $hi = $arr[0];  
    my $pos = 0;
    for (my $i = 0; $i < @arr; $i++) {
        if ($arr[$i] > $hi) {
            $hi = $arr[$i];
            $pos = $i;
        }
    }
    $arr[$pos] = 0;
    for (my $i = 0; $i < @arr; $i++) {
        my $j = ($i + $pos + 1) % @arr;
        $arr[$j] += int($hi / @arr) + (($i < ($hi % @arr)) ? 1 : 0);
    }

    last if $mark{mk_hash(@arr)}++;
}

print("The number of steps until exiting is $ret\n");

$ret = 0;
my @stor = @arr;

while (1) {
    $ret++;
    my $hi = $arr[0];  
    my $pos = 0;
    for (my $i = 0; $i < @arr; $i++) {
        if ($arr[$i] > $hi) {
            $hi = $arr[$i];
            $pos = $i;
        }
    }
    $arr[$pos] = 0;
    for (my $i = 0; $i < @arr; $i++) {
        my $j = ($i + $pos + 1) % @arr;
        $arr[$j] += int($hi / @arr) + (($i < ($hi % @arr)) ? 1 : 0);
    }

    last if mk_hash(@arr) eq mk_hash(@stor);
}

print("The size of the loop is $ret cycles\n");

close($fh);
