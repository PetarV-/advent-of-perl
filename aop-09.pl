#! /usr/bin/perl
use strict;
use warnings;

my $fname = 'input.txt';

open(my $fh, '<', $fname)
    or die "Could not open file '$fname' $!";

my $ret = 0;
my $dt = 0;

# Unset the input record separator ($/) to read in entire file
local $/ = undef;

# Here comes the crazy regex :)
# Explanation: 
#  Group := { Content }
#  Content := (Group | Gibberish | Garbage) Content
#  Gibberish := (anything except '{', '}' or '<')
#  Garbage := < GarbageContent >
#  GarbageContent := (Bang | GarbageGibberish) GarbageContent
#  Bang := ! (any char)
#  GarbageGibberish := (anything except '>')
<$fh> =~ /({(?{$ret += ++$dt})((?1)|[^{}<]*|<(!.|[^>])*>)*}(?{$dt--}))/;

print("The total score is $ret\n");

# Seek back to beginning of file
seek($fh, 0, 0);

$ret = 0;

# Another loony regex.
# Same gist as before, only now we count how many times we hit GarbageGibberish.
<$fh> =~ /({((?1)|[^{}<]*|<(!.|[^>](?{$ret++}))*>)*})/;

print("The number of non-canceled garbage characters is $ret\n");

close($fh);
