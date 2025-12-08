# https://adventofcode.com/2025/day/6

## BEGIN BOILERPLATE
use strict;
use warnings;
use List::MoreUtils 'uniq';
use List::Util 'product';

my ($day) = split /\./, $0;
open(my $in,  "<",  "input/$day.txt") or die "Can't open input/$day.txt: $!";
## END BOILERPLATE

# change between sample and real input
my $STEPS = 1000;

my @lines = <$in>;
for my $line (@lines) {
    chomp $line;
}

sub dsu_find {
    my ($root_ref, $x) = @_;

    return $x if ($root_ref->[$x] == $x);
    return $root_ref->[$x] = dsu_find($root_ref, $root_ref->[$x]);
}

# returns 1 if a non-redundant union happened, otherwise 0
sub dsu_union {
    my ($root_ref, $size_ref, $x, $y) = @_;

    my $xr = dsu_find($root_ref, $x);
    my $yr = dsu_find($root_ref, $y);

    return 0 if ($xr == $yr);

    if ($size_ref->[$yr] > $size_ref->[$xr]) {
        ($xr, $yr) = ($yr, $xr);    
    }

    $size_ref->[$xr] += $size_ref->[$yr];
    $root_ref->[$yr] = $root_ref->[$xr];
    return 1;
}

sub solve {
    my (@lines) = @_;
    my $n = scalar(@lines);
    my @split_pts = map { [ split ',' ] } @lines;

    # We can ID the coordinates by their index for union find
    my @edges_dist_sq;

    for my $i (0 .. $n - 2) {
        for my $j ($i + 1 .. $n - 1) {
            my ($x1, $y1, $z1) = @{$split_pts[$i]};
            my ($x2, $y2, $z2) = @{$split_pts[$j]};
            my $dist_sq = ($x1 - $x2) ** 2 + ($y1 - $y2) ** 2 + ($z1 - $z2) ** 2;
            push @edges_dist_sq, [ $dist_sq, $i, $j ];
        }
    }

    # Now, run Kruskal's
    my $edge_index = 0;
    my @dsu_root = 0 .. $n - 1;
    my @dsu_size = (1) x $n;
    @edges_dist_sq = sort { $a->[0] <=> $b->[0] } @edges_dist_sq;

    # Do the union'ing for part 1
    for (1 .. $STEPS) {
        my (undef, $i, $j) = @{$edges_dist_sq[$edge_index]};
        dsu_union(\@dsu_root, \@dsu_size, $i, $j);
        $edge_index++;
    }

    my @circuits = uniq map { dsu_find(\@dsu_root, $_) } (0 .. $n - 1);
    my @circuit_sizes = sort { $a <=> $b } (map { $dsu_size[$_] } @circuits);
    my $num_sizes = scalar(@circuit_sizes);
    my $part_1 = product @circuit_sizes[$num_sizes - 3 .. $num_sizes - 1];

    # And then continue union'ing, keep it in same function this time for code reuse
    my $part_2;
    my $circuits_left = scalar(@circuits);

    while ($circuits_left > 1) {
        my (undef, $i, $j) = @{$edges_dist_sq[$edge_index]};
        $circuits_left -= dsu_union(\@dsu_root, \@dsu_size, $i, $j);

        if ($circuits_left == 1) {
            my $x1 = $split_pts[$i]->[0];
            my $x2 = $split_pts[$j]->[0];
            $part_2 = $x1 * $x2;
        }

        $edge_index++;
    }

    return ($part_1, $part_2);
}

my ($part_1, $part_2) = solve(@lines);
print("$part_1\n$part_2\n");