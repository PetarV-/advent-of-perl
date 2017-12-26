#! /usr/bin/perl
use strict;
use warnings;

my $fname = 'input.txt';

open(my $fh, '<', $fname)
    or die "Could not open file '$fname' $!";

# Unset the input record separator ($/) to read in entire file
local $/ = undef;

my $str = <$fh>;
$str =~ s/(\s+)//g;

# Get all tokens (directions) from the comma-separated file
my @arr = $str =~ /([^,]+)/g;

my ($px, $py) = (0, 0);

my $hi = 0;
my $ret = 0;

foreach (@arr) {
    if ($_ eq 'n') {
        $py--;
    } elsif ($_ eq 'ne') {
        $px++; $py--;
    } elsif ($_ eq 'se') {
        $px++;
    } elsif ($_ eq 's') {
        $py++;
    } elsif ($_ eq 'sw') {
        $px--; $py++;
    } elsif ($_ eq 'nw') {
        $px--;
    } else {
        die "Unexpected direction: $_"; # Should never happen
    }
    $ret = (abs($px) + abs($py) + abs($px + $py)) >> 1;
    if ($ret > $hi) {
        $hi = $ret;
    }
}

print("The final distance is $ret\n");
print("The largest distance is $hi\n");

close($fh);
