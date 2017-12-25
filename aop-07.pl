#! /usr/bin/perl
use strict;
use warnings;

my $fname = 'input.txt';

open(my $fh, '<', $fname)
    or die "Could not open file '$fname' $!";

my %wts;
my %adj;
my %indeg;

while (my $line = <$fh>) {
    $line =~ s/,//g;
    my @row = $line =~ /(\S+)/g;
    my $name = $row[0];
    my @wt = $row[1] =~ /(\d+)/;
    $wts{$name} = $wt[0];
    $adj{$name} = [()];
    for (my $i = 3; $i < @row; $i++) {
        push($adj{$name}, $row[$i]);
        $indeg{$row[$i]}++;
    }
}

my @keys = keys(%wts);

my $ret = "";

foreach (@keys) {
    $ret = $_;
    last unless $indeg{$_};
}

print("The bottom program name is $ret\n");

my $root = $ret;

my %stw;

$ret = 0;

# Helper subroutine. Will assign to each node the weight of its subtree.
# Then, if node is not OK, will store the correction in ret.
sub is_balanced {
    my ($n) = @_;
    $stw{$n} = $wts{$n};
    
    # First extract the reference to the array from the hash
    my $a_ref = $adj{$n};
    # _Then_ dereference it
    my @a = @$a_ref;

    my $dff = 0;
    my $did = '';
    my $dwt = 0;
    my $dval = 0;
    foreach my $id (@a) {
        is_balanced($id);
        if ($stw{$id} != $stw{$a[0]}) {
            $dff++;
            $did = $id;
            $dwt = $wts{$id};
            $dval = $stw{$id};
        }
    }
    if ($dff) {
        if ($dff == 1) {
            # If there's exactly one difference, it's at this position
            $ret = $dwt + $stw{$a[0]} - $dval;
            $stw{$did} = $stw{$a[0]};
        } else {
            # Otherwise it's at position 0
            $ret = $wts{$a[0]} + $dval - $stw{$a[0]};
            $stw{$a[0]} = $stw{$did};
        }
    }
    foreach (@a) {
        $stw{$n} += $stw{$_};
    }
}

is_balanced($root);

print("The new weight of the wrong program is $ret\n");

close($fh);
