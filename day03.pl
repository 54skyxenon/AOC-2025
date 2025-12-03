# https://adventofcode.com/2025/day/3

## BEGIN BOILERPLATE
use strict;
use warnings;
use List::Util 'sum';
use List::Util 'max';
use Memoize;
use POSIX qw(INFINITY);
no warnings 'recursion';

my ($day) = split /\./, $0;
open(my $in,  "<",  "input/$day.txt") or die "Can't open input/$day.txt: $!";
## END BOILERPLATE

my @lines = <$in>;

# There's trailing \n's we need to yeet
for my $line (@lines) {
    chomp $line;
}

sub best_joltage {
    my ($line) = @_;
    my $ans = 0;
    my $best_second_digit = -INFINITY;

    foreach my $digit (split //, reverse $line) {
        $ans = max($ans, 10 * $digit + $best_second_digit);
        $best_second_digit = max($best_second_digit, $digit);
    }

    return $ans;
}

memoize('best_joltage_subset');
sub best_joltage_subset {
    my ($line, $index, $digits_to_fill) = @_;

    # cannot fulfill quota if used up all digits already
    return 0 if $digits_to_fill == 0;

    # check if there's insufficient digits left
    return -INFINITY if length($line) - $index < $digits_to_fill;

    # do the DP
    my $defer = best_joltage_subset($line, $index + 1, $digits_to_fill);
    my $digit_here = substr($line, $index, 1);
    my $take_here = 10 ** ($digits_to_fill - 1) * $digit_here + best_joltage_subset($line, $index + 1, $digits_to_fill - 1);
    return max($defer, $take_here);
}

sub part_1 {
    my (@lines) = @_;
    return sum map { best_joltage($_) } @lines;
}

sub part_2 {
    my (@lines) = @_;
    return sum map { best_joltage_subset($_, 0, 12) } @lines;
}

print("@{[part_1(@lines)]}\n");
print("@{[part_2(@lines)]}\n");