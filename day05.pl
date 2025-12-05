# https://adventofcode.com/2025/day/5

## BEGIN BOILERPLATE
use strict;
use warnings;
use List::Util 'any';
use List::Util 'sum';
use List::Util 'max';

my ($day) = split /\./, $0;
open(my $in,  "<",  "input/$day.txt") or die "Can't open input/$day.txt: $!";
## END BOILERPLATE

my @lines = <$in>;
for my $line (@lines) {
    chomp $line;
}

sub parse_lines {
    my (@lines) = @_;
    my $n = scalar(@lines);
    my ($blank_idx) = grep { $lines[$_] eq '' } 0..$n - 1;
    my @ranges = map { [ split /-/, $_ ] } @lines[0..$blank_idx - 1];
    my @ids = @lines[$blank_idx + 1..$n - 1];

    return (\@ranges, \@ids);
}

sub part_1 {
    my (@lines) = @_;
    my ($ranges, $ids) = parse_lines(@lines);
    my $ans = 0;
    
    foreach my $available_ingredient (@$ids) {
        if (any { @$_[0] <= $available_ingredient && $available_ingredient <= @$_[1] } @$ranges) {
            $ans++;
        }
    }
    
    return $ans;
}

sub part_2 {
    my (@lines) = @_;
    my ($ranges, $ids) = parse_lines(@lines);
    my @merged_ranges;

    foreach my $range (sort { $a->[0] <=> $b->[0] || $a->[1] <=> $b->[1] } @$ranges) {
        my ($start, $end) = @$range;

        if (!@merged_ranges || $merged_ranges[-1][1] < $start) {
            push @merged_ranges, $range;
        } else {
            $merged_ranges[-1][1] = max($merged_ranges[-1][1], $end);
        }
    }

    return sum map { @$_[1] - @$_[0] + 1 } @merged_ranges;
}

print("@{[part_1(@lines)]}\n");
print("@{[part_2(@lines)]}\n");