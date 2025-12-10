# https://adventofcode.com/2025/day/10

## BEGIN BOILERPLATE
use strict;
use warnings;
use List::Util 'sum';
use List::Util 'min';
use POSIX 'INFINITY';

my ($day) = split /\./, $0;
open(my $in,  "<",  "input/$day.txt") or die "Can't open input/$day.txt: $!";
## END BOILERPLATE

my @lines = <$in>;
for my $line (@lines) {
    chomp $line;
}

sub fewest_presses_lights {
    my ($line) = @_;
    my @tokens = (split ' ', $line);

    my $desired_mask_str = substr($tokens[0], 1, -1);
    my $desired_mask = 0;
    for my $ch (split '', $desired_mask_str) {
        if ($ch eq '#') {
            $desired_mask = ($desired_mask << 1) + 1;
        } else {
            $desired_mask = ($desired_mask << 1);
        }
    }

    my @masks;
    my @buttons = @tokens[1 .. scalar(@tokens) - 2];
    for my $button (@buttons) {
        my @ones_positions = (map { length($desired_mask_str) - 1 - $_ } (split ',', substr($button, 1, -1)));
        my $mask = 0;
        for my $ones_position (@ones_positions) {
            $mask = $mask | (1 << $ones_position);
        }
        push @masks, $mask;
    }

    my $ans = INFINITY;
    for my $subset_mask (0 .. (2 ** scalar(@buttons) - 1)) {
        my $built_mask = 0;
        my $ones_used = 0;

        for my $i (0 .. scalar(@buttons) - 1) {
            if ($subset_mask & (1 << $i)) {
                $built_mask ^= $masks[$i];
                $ones_used++;
            }
        }

        if ($built_mask == $desired_mask) {
            $ans = min($ans, $ones_used);
        }
    }

    return $ans;
}

sub part_1 {
    my (@lines) = @_;
    return sum map { fewest_presses_lights($_) } @lines;
}

sub fewest_presses_joltage {
    my ($line) = @_;
    my @tokens = (split ' ', $line);
    my @buttons = @tokens[1 .. scalar(@tokens) - 2];
    my @joltages = (split ',', substr($tokens[-1], 1, -1));
    my @vars = (map { "x$_"; } (1 .. scalar(@buttons)));

    my @constraints_lhs = map { [] } 1 .. scalar(@joltages);
    for my $i (1 .. scalar(@buttons)) {
        my @button_digits = (split ',', substr($buttons[$i - 1], 1, -1));
        for my $digit (@button_digits) {
            push @{$constraints_lhs[$digit]}, "x$i";
        }
    }

    # Solve ILP problem with glpsol (since Perl doesn't have maintained package)
    my @constraints;
    for my $i (0 .. scalar(@joltages) - 1) {
        my $lhs = join ' + ', @{$constraints_lhs[$i]};
        my $rhs = $joltages[$i];
        push @constraints, "$lhs = $rhs";
    }

    # https://web.mit.edu/lpsolve/doc/CPLEX-format.htm
    my $objective_fn = join(" + ", @vars);    
    my $lp = "Minimize\n  obj: $objective_fn\n\n";

    $lp .= "Subject To\n";
    my $i = 1;
    for my $c (@constraints) {
        $lp .= "  c$i: $c\n";
        $i++;
    }

    $lp .= "\nBounds\n";
    for my $v (@vars) {
        $lp .= "  $v >= 0\n";
    }

    # This section makes them ints
    my $general_section = join(" ", @vars);
    $lp .= "\nGeneral\n  $general_section\n\nEnd\n";

    # Call gplsol and parse its output
    my $sol = `echo "$lp" | glpsol --lp /dev/stdin --write /dev/stdout 2>/dev/null`;
    my ($ans) = $sol =~ /Objective:\s+\S+\s+=\s+(\S+)/;
    return $ans;
}

sub part_2 {
    my (@lines) = @_;
    return sum map { fewest_presses_joltage($_) } @lines;
}

print("@{[part_1(@lines)]}\n");
print("@{[part_2(@lines)]}\n");