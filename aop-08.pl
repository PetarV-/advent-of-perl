#! /usr/bin/perl
use strict;
use warnings;

my $fname = 'input.txt';

open(my $fh, '<', $fname)
    or die "Could not open file '$fname' $!";

my %env;

my $hi = 0;

while (my $line = <$fh>) {
    my @row = $line =~ /(\S+)/g;
    my $cond = 0;
    my $lval = $env{$row[4]} || 0;
    my $rval = $row[6];
    # First find the condition
    if ($row[5] eq '>') {
        $cond = ($lval > $rval);
    } elsif ($row[5] eq '>=') {
        $cond = ($lval >= $rval);
    } elsif ($row[5] eq '<') {
        $cond = ($lval < $rval);
    } elsif ($row[5] eq '<=') {
        $cond = ($lval <= $rval);
    } elsif ($row[5] eq '==') {
        $cond = ($lval == $rval);
    } elsif ($row[5] eq '!=') {
        $cond = ($lval != $rval);
    } else {
        die "Unknown comparator: $row[5]"; # Should never happen!
    }
    if ($cond) {
        if ($row[1] eq 'inc') {
            $env{$row[0]} += $row[2];
        } elsif ($row[1] eq 'dec') {
            $env{$row[0]} -= $row[2];
        } else {
            die "Unknown instruction: $row[1]"; # Should never happen!
        }
    } else {
        $env{$row[0]} = ($env{$row[0]} || 0); # Makes sure the register is created
    }
    if ($env{$row[0]} > $hi) {
        $hi = $env{$row[0]};
    }
}

my @vals = sort(values(%env));

my $ret = $vals[-1];

print("The largest register value after executing is $ret\n");

print("The largest value ever held in a register is $hi\n");

close($fh);
