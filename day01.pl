# https://adventofcode.com/2025/day/1

## BEGIN BOILERPLATE
use strict;
use warnings;

my ($day) = split /\./, $0;
open(my $in,  "<",  "input/$day.txt")  or die "Can't open input/$day.txt: $!";
my @lines = <$in>;
## END BOILERPLATE

sub part_1 {
    my (@lines) = @_;
    my $ans = 0;
    my $position = 50;

    foreach my $line (@lines) {
        my ($direction, $magnitude) = (substr($line, 0, 1), substr($line, 1));

        if ($direction eq 'R') {
            $position = ($position + $magnitude) % 100;
        } else {
            $position = ($position - $magnitude + 100) % 100;
        }

        if ($position == 0) {
            $ans += 1;
        }
    }

    return $ans;
}

sub part_2 {
    my (@lines) = @_;
    my $ans = 0;
    my $position = 50;

    foreach my $line (@lines) {
        my $prev_position = $position;
        my ($direction, $magnitude) = (substr($line, 0, 1), substr($line, 1));
        my ($full_turns, $leftover_turn) = (int($magnitude / 100), $magnitude % 100);

        if ($direction eq 'R') {
            $position = ($position + $leftover_turn) % 100;
        } else {
            $position = ($position - $leftover_turn + 100) % 100;
        }

        $ans += $full_turns;

        if ($position == 0) {
            $ans += 1;
        } elsif ($prev_position != 0 && (($position > $prev_position && $direction eq 'L') || ($position < $prev_position && $direction eq 'R'))) {
            $ans += 1;
        }
    }

    return $ans;
}

print("@{[part_1(@lines)]}\n");
print("@{[part_2(@lines)]}\n");