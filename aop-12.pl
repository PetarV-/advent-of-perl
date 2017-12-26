#! /usr/bin/perl
use strict;
use warnings;

my $fname = 'input.txt';

open(my $fh, '<', $fname)
    or die "Could not open file '$fname' $!";

my %adj;

while (my $line = <$fh>) {
    $line =~ s/,//g;
    my @row = $line =~ /(\S+)/g;
    my $name = $row[0];
    $adj{$name} = [()];
    for (my $i = 2; $i < @row; $i++) {
        push($adj{$name}, $row[$i]);
    }
}

my $ret = 0;

my %mark;

# Helper DFS subroutine.
sub dfs {
    my ($n) = @_;

    $mark{$n}++;
    $ret++;

    # First extract the reference to the array from the hash
    my $a_ref = $adj{$n};
    # _Then_ dereference it
    my @a = @$a_ref;
    
    foreach (@a) {
        if (!$mark{$_}++) {
            dfs($_);
        }
    }
}

dfs(0);

print("The number of programs in program 0's group is $ret\n");

my $grps = 1;

foreach (keys(%adj)) {
    if (!$mark{$_}) {
        dfs($_);
        $grps++;
    }
}

print("The total number of groups is $grps\n");

close($fh);
