# https://adventofcode.com/2025/day/4

## BEGIN BOILERPLATE
use strict;
use warnings;

my ($day) = split /\./, $0;
open(my $in,  "<",  "input/$day.txt") or die "Can't open input/$day.txt: $!";
## END BOILERPLATE

my @DIRECTIONS = ([1, 0], [-1, 0], [0, 1], [0, -1], [1, -1], [1, 1], [-1, 1], [-1, -1]);

my @lines = <$in>;
for my $line (@lines) {
    chomp $line;
}

sub get_accessible_rolls {
    my (@grid) = @_;
    my $n = scalar(@grid);
    my $m = length($grid[0]);
    my @ans;

    for my $r (0..$n - 1) {
        for my $c (0..$m - 1) {
            next if (substr($grid[$r], $c, 1) ne '@');

            my $rolls = 0;

            for my $adj (@DIRECTIONS) {
                my ($dr, $dc) = @$adj;
                if (0 <= $r + $dr && $r + $dr < $n && 0 <= $c + $dc && $c + $dc < $m && substr($grid[$r + $dr], $c + $dc, 1) eq '@') {
                    $rolls++;
                    last if ($rolls >= 4);
                }
            }

            if ($rolls < 4) {
                push @ans, [$r, $c];
            }
        }
    }

    return @ans;
}

sub part_1 {
    my (@grid) = @_;
    return scalar(get_accessible_rolls(@grid));
}

sub part_2 {
    my (@grid) = @_;
    my $ans = 0;

    while (my @removable_rolls = get_accessible_rolls(@grid)) {
        $ans += scalar(@removable_rolls);
        for my $pair (@removable_rolls) {
            my ($r, $c) = @$pair;
            substr($grid[$r], $c, 1) = '.';
        }
    }

    return $ans;
}

print("@{[part_1(@lines)]}\n");
print("@{[part_2(@lines)]}\n");