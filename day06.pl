# https://adventofcode.com/2025/day/6

## BEGIN BOILERPLATE
use strict;
use warnings;
use List::Util 'sum';
use List::Util 'product';
use List::Util 'max';
use List::Util 'all';

my ($day) = split /\./, $0;
open(my $in,  "<",  "input/$day.txt") or die "Can't open input/$day.txt: $!";
## END BOILERPLATE

my @lines = <$in>;
for my $line (@lines) {
    chomp $line;
}

my $BLOCKER_DELIMITER = '-';

sub parse_lines {
    my (@lines) = @_;
    my @matrix = map { [ split ' ' ] } @lines[0..scalar(@lines) - 2];
    my @operations = split ' ', $lines[-1];

    return (\@matrix, \@operations);
}

sub parse_lines_part_2 {
    my (@lines) = @_;
    my @matrix = @lines[0..scalar(@lines) - 2];
    my $m = length($matrix[0]);

    # Set blockers at all cells that aren't the dividing columns
    my %dividing_columns = map { $_ => 1 } grep {
        my $col = $_;
        all { substr($_, $col, 1) eq ' ' } @matrix
    } (0..$m - 1);

    my @nice_matrix;
    foreach my $line (@matrix) {
        my @line_split = split //, $line;
        my @line_marked;
        for my $col (0..$m - 1) {
            if (!exists($dividing_columns{$col}) && $line_split[$col] eq ' ') {
                push @line_marked, $BLOCKER_DELIMITER;
            } else {
                push @line_marked, $line_split[$col];
            }
        }
        my @nice_row = split ' ', (join '', @line_marked);
        push @nice_matrix, \@nice_row;
    }

    # This remains the same as in part 1
    my @operations = split ' ', $lines[-1];
    return (\@nice_matrix, \@operations);
}

sub part_1 {
    my (@lines) = @_;
    my ($matrix, $operations) = parse_lines(@lines);
    my $n = scalar(@$matrix);
    my $m = scalar(@{$matrix->[0]});
    my $ans = 0;

    for my $col (0..$m - 1) {
        my @operands = map { @{$matrix->[$_]}[$col] } (0..$n - 1);
        my $operation = $operations->[$col];

        if ($operation eq '*') {
            $ans += product @operands;
        } else {
            $ans += sum @operands;
        }
    }
    
    return $ans;
}

sub part_2 {
    my (@lines) = @_;
    my ($matrix, $operations) = parse_lines_part_2(@lines);
    my $n = scalar(@$matrix);
    my $m = scalar(@{$matrix->[0]});
    my @column_sums;

    for my $col (0..$m - 1) {
        my @rows = map { @{$matrix->[$_]}[$col] } (0..$n - 1);
        my $num_inner_cols = length($rows[0]);
        my @operands;

        # Build the numbers column-wise, skipping blockers
        for my $inner_col (reverse 0..$num_inner_cols - 1) {
            my $operand = join '', (map {
                my $ch = substr($_, $inner_col, 1);
                $ch eq $BLOCKER_DELIMITER ? '' : $ch;
            } @rows);
            push @operands, $operand;
        }

        # Same as part 1 here
        my $operation = $operations->[$col];

        if ($operation eq '*') {
            push @column_sums, product @operands;
        } else {
            push @column_sums, sum @operands;
        }
    }
    
    return sum @column_sums;
}

print("@{[part_1(@lines)]}\n");
print("@{[part_2(@lines)]}\n");