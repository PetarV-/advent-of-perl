#! /usr/bin/perl
use strict;
use warnings;

my $fname = 'input.txt';

open(my $fh, '<', $fname)
    or die "Could not open file '$fname' $!";

my %scan;

while (my $line = <$fh>) {
    $line =~ s/://g;
    my @row = $line =~ /(\S+)/g;
    my ($dt, $rt) = ($row[0], $row[1]);
    $scan{$dt} = $rt;
}

my $ret = 0;

foreach (keys(%scan)) {
    my $rt = $scan{$_};
    my $nb = $rt == 1 ? 1 : 2 + ($rt - 2) * 2;
    if ($_ % $nb == 0) {
        $ret += $_ * $rt; 
    }
}

print("The total trip severity is $ret\n");

# Helper subroutine for computing a GCD
sub gcd {
    my ($a, $b) = @_;
    return ($a % $b == 0) ? $b : gcd($b, $a % $b);
}

# a will be in not_eq{b} iff sol =/= a (mod b)
my %not_eq;

foreach (keys(%scan)) {
    my $rt = $scan{$_};
    my $nb = $rt == 1 ? 1 : 2 + ($rt - 2) * 2;
    # The solution cannot be divisible by the modulus when it arrives (so add -$_) 
    $not_eq{$nb}{(-$_) % $nb} = 1;
}

# Store the LCM of all moduli
my $lcm = 1;
# Store the all possible remainders wrt the LCM (recombined using CRT)
my @sol = (0);

# Process moduli in ascending order, to minimise recombining
foreach (sort {$a <=> $b} keys(%not_eq)) {
    my $g = gcd($_, $lcm);
    
    my $next_lcm = $lcm * $_ / $g;
    my @next_sol = ();
    
    # Recombine using CRT: take all possibilities, excluding ones that are impossible
    foreach my $res (@sol) {
        for (my $i = $res; $i < $next_lcm; $i += $lcm) {
            if (!$not_eq{$_}{$i % $_}) {
                push(@next_sol, $i);
            }
        }
    }
    
    $lcm = $next_lcm;
    @sol = @next_sol;
}

my @fin = sort {$a <=> $b} @sol;
$ret = $fin[0];

print("The minimal waiting time is $ret\n");

close($fh);
