#! /usr/bin/perl
use strict;
use warnings;

my $fname = 'input.txt';

open(my $fh, '<', $fname)
	or die "Could not open file '$fname' $!";

# Get the number from the file (as a string)
my $num = <$fh>;
# Chop off trailing newline
chomp($num);

# Obtain the individual digits
my @digits = map(substr($num, $_, 1), 0 .. length($num) - 1);

my $ret = 0;

for (my $i = 0; $i < @digits; $i++) {
	if ($digits[$i] == $digits[($i + 1) % @digits]) {
		$ret += $digits[$i];
	}
}

print("The captcha solution is ", $ret, "\n");

my $gap = @digits / 2;

$ret = 0;

for (my $i = 0; $i < @digits; $i++) {
	if ($digits[$i] == $digits[($i + $gap) % @digits]) {
		$ret += $digits[$i];
	}
}

print("The new captcha solution is ", $ret, "\n");

close($fh);
