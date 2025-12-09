# https://adventofcode.com/2025/day/7

## BEGIN BOILERPLATE
use strict;
use warnings;
use List::MoreUtils 'uniq';
use Memoize;
no warnings 'recursion';

my ($day) = split /\./, $0;
open(my $in,  "<",  "input/$day.txt") or die "Can't open input/$day.txt: $!";
## END BOILERPLATE

my @lines = <$in>;
for my $line (@lines) {
    chomp $line;
}

memoize('count_timelines_from');
sub count_timelines_from {
    my ($lines_ref, $row, $x) = @_;

    if ($row == scalar(@$lines_ref) - 1) {
        return 1;
    } elsif (substr($lines_ref->[$row + 1], $x, 1) eq '^') {
        return count_timelines_from($lines_ref, $row + 1, $x - 1) + count_timelines_from($lines_ref, $row + 1, $x + 1);
    } else {
        return count_timelines_from($lines_ref, $row + 1, $x);
    }
}

sub part_1 {
    my (@lines) = @_;
    my $ans = 0;
    my @x_coordinates = (index($lines[0], 'S'));

    for my $row (0..@lines - 2) {
        my @new_x_coordinates;

        for my $x (@x_coordinates) {
            if (substr($lines[$row + 1], $x, 1) eq '^') {
                $ans++;
                push @new_x_coordinates, $x - 1;
                push @new_x_coordinates, $x + 1;
            } else {
                push @new_x_coordinates, $x;
            }
        }

        @x_coordinates = uniq @new_x_coordinates;
    }

    return $ans;
}

sub part_2 {
    my (@lines) = @_;
    return count_timelines_from(\@lines, 0, index($lines[0], 'S'));
}

print("@{[part_1(@lines)]}\n");
print("@{[part_2(@lines)]}\n");