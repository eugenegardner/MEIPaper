#!/usr/bin/perl

use strict;
use warnings;

open (VCF, "-|","zcat $ARGV[0]") || die "Cannot open file: $!";

my @indvs;
my %totals;

foreach my $line (<VCF>) {

	chomp $line;

	if ($line =~ /\#\#/) {

		next;

	} elsif ($line =~ /\#CHROM/) {

		@indvs = split('\t', $line);
		for (my $x = 9; $x < scalar(@indvs); $x++) {
			$totals{$indvs[$x]} = {ac => 0, nc => 0};
		}			
		
	} else {

		my @data = split('\t', $line);

		for (my $x = 9; $x < scalar(@data); $x++) {

			if ($data[$x] =~ /0\/1/) {

				$totals{$indvs[$x]}{ac}++;

			} elsif ($data[$x] =~ /1\/1/) {

				$totals{$indvs[$x]}{ac}+=2;

			} elsif ($data[$x] =~ /\.\/\./) {

				$totals{$indvs[$x]}{nc}++;

			}

		}

	}

}

close VCF;

foreach (sort keys %totals) {

	my $name = $_;
	print "$name\t$totals{$_}{ac}\t$totals{$_}{nc}\n";

}
