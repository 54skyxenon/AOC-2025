# https://adventofcode.com/2025/day/2

## BEGIN BOILERPLATE
use strict;
use warnings;
use List::Util 'all';
use List::Util 'sum';

my ($day) = split(/\./, $0);
open(my $in,  "<",  "input/$day.txt") or die "Can't open input/$day.txt: $!";
## END BOILERPLATE

my $line = <$in>;

sub count_invalid {
    my ($arg) = @_;
    my ($start, $end) = split(/-/, $arg);
    my $ans = 0;

    for my $i ($start..$end) {
        # Don't bother with an odd number of digits
        if (length($i) % 2 == 1) {
            next;
        }

        # Otherwise, do the gritty halving and comparison
        my $half = int(length($i) / 2);
        my $left = substr($i, 0, $half);
        my $right = substr($i, $half);
        if ($left eq $right) {
            $ans += $i;
        }
    }

    return $ans;
}

sub count_invalid_part_2 {
    my ($arg) = @_;
    my ($start, $end) = split(/-/, $arg);
    my $ans = 0;

    for my $i ($start..$end) {
        my $i_length = length($i);
        my @divisors = grep { $i_length % $_ == 0 } 1..($i_length - 1);

        foreach my $divisor (@divisors) {
            my @chunks = unpack("(A$divisor)*", $i);
            
            # All chunks should be the same to count this as an invalid ID
            if (all { $_ eq $chunks[0] } @chunks) {
                $ans += $i;
                last;
            }
        }
    }

    return $ans;
}

sub part_1 {
    my ($line) = @_;
    my @tokens = split(/,/, $line);
    return sum map { count_invalid($_) } @tokens;
}

sub part_2 {
    my ($line) = @_;
    my @tokens = split(/,/, $line);
    return sum map { count_invalid_part_2($_) } @tokens;
}

print("@{[part_1($line)]}\n");
print("@{[part_2($line)]}\n");