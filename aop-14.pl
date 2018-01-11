#! /usr/bin/perl
use strict;
use warnings;

sub popcount {
    my ($a) = @_;
    my $ret = 0;
    while ($a) {
        $ret += $a & 1;
        $a >>= 1;
    }
    return $ret;
}

my $str = "jxqlasbh-";
my @magic = (17, 31, 73, 47, 23);

# Convert all chars to ascii ords
my @base_arr = map(ord, map(substr($str, $_, 1), 0 .. length($str) - 1));

my $ret = 0;

my @hashes = ();

# For each row of the disk
for (my $row = 0; $row < 128; $row++) {
    # Append the current id
    my @app = map(ord, map(substr($row, $_, 1), 0 .. length($row) - 1));
    my @arr = @base_arr;
    push(@arr, @app);
    # Append the magic termination sequence
    push(@arr, @magic);

    my $rnd = 64;

    my @seq = (0..255);
    my $pos = 0;
    my $skp = 0;

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

    my $hash = 0;

    for (my $i = 0; $i < 16; $i++) {
        my $xor = 0;
        for (my $j = 0; $j < 16; $j++) {
            $xor ^= $seq[$i * 16 + $j];
        }
        push(@hashes, $xor);
    }
}

foreach (@hashes) {
    $ret += popcount($_);
}

print("The total number of used squares is $ret\n");

my @dx = (1, 0, -1, 0);
my @dy = (0, 1, 0, -1);

# Now actually construct the grid
my @grid;
my @mark;

sub dfs {
    my ($x, $y) = @_;
    $mark[$x][$y] = 1;
    for (my $i = 0; $i < 4; $i++) {
        my $xt = $x + $dx[$i];
        my $yt = $y + $dy[$i];
        next if ($xt < 0 || $xt > 127 || $yt < 0 || $yt > 127);
        next if !$grid[$xt][$yt];
        next if $mark[$xt][$yt];
        $mark[$xt][$yt] = 1;
        dfs($xt, $yt);
    }
}

my $ptr = 0;

for (my $i = 0; $i < 128; $i++) {
    for (my $j = 0; $j < 16; $j++, $ptr++) {
        for (my $k = 0; $k < 8; $k++) {
            $grid[$i][$j * 8 + $k] = ($hashes[$ptr] >> (7 - $k)) & 1;
        }
    }
}

$ret = 0;

# Now use simple DFS to count fields

for (my $i = 0; $i < 128; $i++) {
    for (my $j = 0; $j < 128; $j++) {
        if ($grid[$i][$j] && !$mark[$i][$j]) {
            dfs($i, $j);
            $ret++;
        }
    }
}

print("The total number of connected regions is $ret\n");

