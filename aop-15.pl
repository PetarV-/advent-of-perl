#! /usr/bin/perl
use strict;
use warnings;

my $fname = 'input.txt';

open(my $fh, '<', $fname)
    or die "Could not open file '$fname' $!";

# Unset the input record separator ($/) to read in entire file
local $/ = undef;

# Fetch all numbers (we know there are only two)
my $str = <$fh>;
my ($a, $b) = $str =~ /(\d+)/g;

my $ret = 0;

for (my $i = 0; $i < 40000000; $i++) {
    $a = ($a * 16807) % 2147483647;
    $b = ($b * 48271) % 2147483647;
    if (($a & 0xFFFF) == ($b & 0xFFFF)) {
        $ret++;
    }
}

print("The judge's final count is $ret\n");

# Seek back to start of file
seek($fh, 0, 0);

$str = <$fh>;
($a, $b) = $str =~ /(\d+)/g;
$ret = 0;

for (my $i = 0; $i < 5000000; $i++) {
    do {
        $a = ($a * 16807) % 2147483647;
    } while ($a & 3);
    do {
        $b = ($b * 48271) % 2147483647;
    } while ($b & 7);
    if (($a & 0xFFFF) == ($b & 0xFFFF)) {
        $ret++;
    }
}

print("Under the new generator logic, the final count is $ret\n");

close($fh);
