#! /usr/bin/perl
use strict;
use warnings;

my $fname = 'input.txt';

open(my $fh, '<', $fname)
    or die "Could not open file '$fname' $!";

# Unset the input record separator ($/) to read in entire file
local $/ = undef;

# Get all tokens (digit blocks) from the file
my @arr = <$fh> =~ /(\d+)/g;
my $pos = 0;
my $skp = 0;

my @seq = (0..255);

foreach (@arr) {
    next if $_ > @seq;
    if ($pos + $_ <= @seq) {
        my @sub = @seq[$pos..($pos + $_ - 1)];
        splice(@seq, $pos, $_, reverse(@sub));
    } else {
        my $rem = $pos + $_ - @seq - 1;
        my @sub = @seq[$pos..(@seq - 1), 0..$rem];
        @sub = reverse(@sub);
        splice(@seq, $pos, @seq - $pos, @sub[0..(@seq - $pos - 1)]);
        splice(@seq, 0, $_ - @seq + $pos, @sub[(@seq - $pos)..(@sub - 1)]);
    }
    $pos += $_ + $skp++;
    $pos %= @seq;
}

my $ret = $seq[0] * $seq[1];

print("The product of the first two elements is $ret\n");

# Seek back to start
seek($fh, 0, 0);

my $str = <$fh>;
$str =~ s/(\s+)//g;

# Convert all chars to ascii ords
@arr = map(ord, map(substr($str, $_, 1), 0 .. length($str) - 1));

# Append the magic termination sequence
my @magic = (17, 31, 73, 47, 23);
push(@arr, @magic);

my $rnd = 64;

@seq = (0..255);
$pos = 0;
$skp = 0;

for (my $i = 0; $i < $rnd; $i++) {
    foreach (@arr) {
        next if $_ > @seq;
        if ($pos + $_ <= @seq) {
            my @sub = @seq[$pos..($pos + $_ - 1)];
            splice(@seq, $pos, $_, reverse(@sub));
        } else {
            my $rem = $pos + $_ - @seq - 1;
            my @sub = @seq[$pos..(@seq - 1), 0..$rem];
            @sub = reverse(@sub);
            splice(@seq, $pos, @seq - $pos, @sub[0..(@seq - $pos - 1)]);
            splice(@seq, 0, $_ - @seq + $pos, @sub[(@seq - $pos)..(@sub - 1)]);
        }
        $pos += $_ + $skp++;
        $pos %= @seq;
    }
}

print("The dense hash is: ");

for (my $i = 0; $i < 16; $i++) {
    my $xor = 0;
    for (my $j = 0; $j < 16; $j++) {
        $xor ^= $seq[$i * 16 + $j];
    }
#    print("Value: $xor\n");
    printf("%02lx", $xor);
}

close($fh);
