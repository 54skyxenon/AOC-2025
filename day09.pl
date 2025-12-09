# https://adventofcode.com/2025/day/9

## BEGIN BOILERPLATE
use strict;
use warnings;
use List::Util 'max';
use List::Util 'min';
use List::Util 'uniq';
use List::Util 'any';

my ($day) = split /\./, $0;
open(my $in,  "<",  "input/$day.txt") or die "Can't open input/$day.txt: $!";
## END BOILERPLATE

my @DIRECTIONS = ([1, 0], [-1, 0], [0, 1], [0, -1]);

my @lines = <$in>;
for my $line (@lines) {
    chomp $line;
}

sub part_1 {
    my (@lines) = @_;
    my $n = scalar(@lines);
    my $ans = 0;

    for my $i (0 .. $n - 2) {
        for my $j ($i + 1 .. $n - 1) {
            my ($x1, $y1) = (split ',', $lines[$i]);
            my ($x2, $y2) = (split ',', $lines[$j]);
            $ans = max($ans, (abs($x1 - $x2) + 1) * (abs($y1 - $y2) + 1));
        }
    }

    return $ans;
}

sub part_2 {
    my (@lines) = @_;
    my $n = scalar(@lines);

    # You can check every cell for every possible rectangle by compressing coordinates
    my %x_compressed;
    $x_compressed{'0'} = 0;
    my $x_index = 1;
    for my $x (sort { $a <=> $b } (uniq map { (split ',', $_)[0] } @lines)) {
        $x_compressed{$x} = $x_index++;
    }
    
    my %y_compressed;
    $y_compressed{'0'} = 0;
    my $y_index = 1;
    for my $y (sort { $a <=> $b } (uniq map { (split ',', $_)[1] } @lines)) {
        $y_compressed{$y} = $y_index++;
    }

    # Block off every wall coordinate
    my %walls;
    for my $i (0 .. $n - 2) {
        for my $j ($i + 1 .. $n - 1) {
            my ($x1, $y1) = (split ',', $lines[$i]);
            my ($x2, $y2) = (split ',', $lines[$j]);
            my $xc1 = $x_compressed{$x1};
            my $xc2 = $x_compressed{$x2};
            my $yc1 = $y_compressed{$y1};
            my $yc2 = $y_compressed{$y2};

            if ($yc1 == $yc2) {
                for my $x_mid (min($xc1, $xc2) .. max($xc1, $xc2)) {
                    $walls{"$x_mid,$yc1"} = 1;
                }
            }

            if ($xc1 == $xc2) {
                for my $y_mid (min($yc1, $yc2) .. max($yc1, $yc2)) {
                    $walls{"$xc1,$y_mid"} = 1;
                }
            }
        }
    }

    # And flood fill the outside region
    my $x_bound = max(values %x_compressed) + 1;
    my $y_bound = max(values %y_compressed) + 1;
    my %outside_seen = ("0,0" => 1);
    my @bfs = ("0,0");

    while (@bfs) {
        my @bfs_next_gen;

        for my $coordinate (@bfs) {
            my ($x, $y) = split ',', $coordinate;

            for my $adj (@DIRECTIONS) {
                my $xr = $x + $adj->[0];
                my $yr = $y + $adj->[1];
                my $adj_coordinate = "$xr,$yr";

                if (0 <= $xr && $xr <= $x_bound && 0 <= $yr && $yr <= $y_bound && !(exists $outside_seen{$adj_coordinate}) && !(exists $walls{$adj_coordinate})) {
                    push @bfs_next_gen, $adj_coordinate;
                    $outside_seen{$adj_coordinate} = 1;
                }
            }
        }

        @bfs = @bfs_next_gen;
    }

    # So you can then just evaluate areas of rectangles that are inside
    my $ans = 0;

    for my $i (0 .. $n - 2) {
        for my $j ($i + 1 .. $n - 1) {
            my ($x1, $y1) = (split ',', $lines[$i]);
            my ($x2, $y2) = (split ',', $lines[$j]);
            my $xc1 = $x_compressed{$x1};
            my $xc2 = $x_compressed{$x2};
            my $yc1 = $y_compressed{$y1};
            my $yc2 = $y_compressed{$y2};

            my $outside = 0;
            for my $x (min($xc1, $xc2) .. max($xc1, $xc2)) {
                $outside = $outside || any { exists $outside_seen{"$x,$_"} } (min($yc1, $yc2) .. max($yc1, $yc2));
                last if $outside;
            }
            
            if (!$outside) {
                $ans = max($ans, (abs($x1 - $x2) + 1) * (abs($y1 - $y2) + 1));
            }
        }
    }

    return $ans;
}

print("@{[part_1(@lines)]}\n");
print("@{[part_2(@lines)]}\n");