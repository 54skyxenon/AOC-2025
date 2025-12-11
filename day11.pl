# https://adventofcode.com/2025/day/11

## BEGIN BOILERPLATE
use strict;
use warnings;
use Memoize;
use List::Util 'sum';

my ($day) = split /\./, $0;
open(my $in,  "<",  "input/$day.txt") or die "Can't open input/$day.txt: $!";
## END BOILERPLATE

my @lines = <$in>;
for my $line (@lines) {
    chomp $line;
}

sub make_graph {
    my (@lines) = @_;

    my %graph;
    for my $line (@lines) {
        my ($node, $neighbors) = split ': ', $line;
        $graph{$node} = [split ' ', $neighbors];
    }

    return \%graph;
}

memoize('paths_out');
sub paths_out {
    my ($graph_ref, $node) = @_;

    if ($node eq 'out') {
        return 1;
    }

    return sum map { paths_out($graph_ref, $_) } @{$graph_ref->{$node}}
}

sub part_1 {
    my (@lines) = @_;
    return paths_out(make_graph(@lines), 'you');
}

memoize('paths_out_dac_fft');
sub paths_out_dac_fft {
    my ($graph_ref, $node, $saw_dac, $saw_fft) = @_;

    if ($node eq 'out') {
        return $saw_dac && $saw_fft;
    }

    return sum map { paths_out_dac_fft($graph_ref, $_, $saw_dac || ($_ eq 'dac'), $saw_fft || ($_ eq 'fft')) } @{$graph_ref->{$node}}
}

sub part_2 {
    my (@lines) = @_;
    return paths_out_dac_fft(make_graph(@lines), 'svr', 0, 0);
}

print("@{[part_1(@lines)]}\n");
print("@{[part_2(@lines)]}\n");