#! /usr/bin/perl
use strict;
use warnings;

my $num = 361527;

# Extract integer part of square root
my $rt = int(sqrt($num - 1));

# Compute the highest odd number above it
my $hi = $rt + (($rt + 1) & 1) + (($rt & 1) << 1);

# Default solution, if starting from square 1
my $ret = 0;

if ($hi > 1) {
    # Compute the actual index in the current run
    my $ind = $num - (($hi - 2) ** 2) - 1;
    # Determine whether the run is descending
    my $desc = ($ind / (($hi - 1) >> 1)) & 1;
    # Position within the run
    my $sub = $ind % (($hi - 1) >> 1);
    if ($desc) {
        $ret = (($hi - 1) >> 1) + 1 + $sub;
    } else {
        $ret = $hi - 2 - $sub;
    }
}

print("It takes $ret steps to carry the data to square 1\n");

# Specify the eight directions (only first four used for movement)
my @dx = (0, -1, 0, 1, 1, 1, -1, -1);
my @dy = (1, 0, -1, 0, 1, -1, 1, -1);

# Specify the starting position and direction
my ($it, $xt, $yt, $dt) = (0, 0, 0, 0); 

# Initialise a hash table with starting value
my %grid = (
    "0,0" => 1,
);

# Loop until the field is found
while (1) {
    $ret = ($grid{"$xt,$yt"} || 0); # for the special case
    for (my $i = 0; $i < @dx; $i++) {
        # If undefined, use the value of zero
        my ($xt1, $yt1) = ($xt + $dx[$i], $yt + $dy[$i]);
        $ret += ($grid{"$xt1,$yt1"} || 0);
    }
    $grid{"$xt,$yt"} = $ret;
    last if $ret > $num;
    ($it, $xt, $yt) = ($it + 1, $xt + $dx[$dt], $yt + $dy[$dt]);
    # See whether to flip direction (is field free)
    my $ndt = ($dt + 1) % 4;
    my ($cx, $cy) = ($xt + $dx[$ndt], $yt + $dy[$ndt]);
    $dt = defined $grid{"$cx,$cy"} ? $dt : $ndt;
}

print("The first value to exceed the input is $ret\n");

