#! /usr/bin/perl
use strict;
use warnings;

my $fname = 'input.txt';

open(my $fh, '<', $fname)
    or die "Could not open file '$fname' $!";

my $ret = 0;

while (my $line = <$fh>) {
    # Match a regular expression (=~), extracting words (\w+), globally (g)
    my @row = $line =~ /(\S+)/g;
    # Check for duplicates via a hash table
    my $ok = 1;
    my %mark;
    foreach (@row) {
        next unless $mark{$_}++;
        $ok = 0;
    }
    $ret += $ok;
}

print("The number of valid passphrases is $ret\n");

# Seek back to beginning of file
seek($fh, 0, 0);

$ret = 0;

while (my $line = <$fh>) {
    # Match a regular expression (=~), extracting words (\w+), globally (g)
    my @row = $line =~ /(\S+)/g;
    # Check for duplicates via a hash table
    my $ok = 1;
    my %mark;
    foreach (@row) {
        # Now we're checking for anagrams, so sort the string before feeding
        my $cur = join('', sort(split(//, $_))); # here we must split string into chars, then sort, then rejoin it
        next unless $mark{$cur}++;
        $ok = 0;
    }
    $ret += $ok;
}

print("Under the new policy, the number of valid passphrases is $ret\n");

close($fh);
