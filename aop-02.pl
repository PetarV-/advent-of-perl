#! /usr/bin/perl
use strict;
use warnings;

my $fname = 'input.txt';

open(my $fh, '<', $fname)
    or die "Could not open file '$fname' $!";

my $ret = 0;

while (my $line = <$fh>) {
    # Match a regular expression (=~), extracting consecutive digits (\d+), globally (g)
    my @row = $line =~ /(\d+)/g;
    my ($min, $max) = ($row[0], $row[0]);
    for (@row) {
        # $_ will hold the current value
        $min = $_ if $_ < $min;
        $max = $_ if $_ > $max;
    }
    $ret += $max - $min;
}

print("The spreadsheet checksum is ", $ret, "\n");

# Seek back to beginning of file
seek($fh, 0, 0);

$ret = 0;

while (my $line = <$fh>) {
    # Match a regular expression (=~), extracting consecutive digits (\d+), globally (g)
    my @row = $line =~ /(\d+)/g;
    my $fnd = 0;
    for (my $i = 0; $i < @row; $i++) {
        for (my $j = 0; $j < @row; $j++) {
            next if $i == $j;
            if ($row[$i] % $row[$j] == 0) {
                $fnd = 1;
                $ret += $row[$i] / $row[$j];
                last;
            }
        }
        last if $fnd;
    }
}

print("The sum of each row's result is ", $ret, "\n");

close($fh);
