# https://adventofcode.com/2025/day/12

## BEGIN BOILERPLATE
use strict;
use warnings;
use List::Util 'sum';

my ($day) = split /\./, $0;
open(my $in,  "<",  "input/$day.txt") or die "Can't open input/$day.txt: $!";
## END BOILERPLATE

my @lines = <$in>;
for my $line (@lines) {
    chomp $line;
}

# ! This doesn't work for the sample, FWIW
sub part_1 {
    my (@lines) = @_;
    my $ans = 0;

    # Skip garbage lines
    for my $line (@lines[6 * 5 .. scalar(@lines) - 1]) {
        my ($dimensions, $quantities) = split ': ', $line;
        my ($columns, $rows) = split 'x', $dimensions;
        my $squares_3x3 = int($rows / 3) * int($columns / 3);

        if ((sum split ' ', $quantities) <= $squares_3x3) {
            $ans++;
        }
    }

    return $ans;
}

print("@{[part_1(@lines)]}\n");
print("Congratulations!\n");