#!/usr/bin/perl

use strict;
use warnings;

open (R, "<$ARGV[0]") || die "Cannot open file: $!";

my %tot;
my %pli;

foreach (<R>) {

	chomp $_;
	my @data = split('\t', $_);

	next if ($data[0] eq 'CHR' || $data[8] eq 'DENOVO');

	$tot{$data[4]}++;
	if ($data[5] eq 'null') {
		
	} elsif ($data[5] > 0.9) {
		$pli{$data[4]}++;
	}

}

foreach (sort keys %tot) {

	if (exists $pli{$_}) {
		my $prop = $pli{$_} / $tot{$_};
		my $stderr = 1.96*sqrt((($prop*(1-$prop))/$tot{$_}));
		my $upper = $prop + $stderr;
		my $lower = $prop - $stderr;
		print "$_\t$prop\t$tot{$_}\t$lower\t$upper\n";
	} else {
		my $prop = 0 / $tot{$_};
		my $stderr = 1.96*sqrt((($prop*(1-$prop))/$tot{$_}));
		my $upper = $prop + $stderr;
		my $lower = $prop - $stderr;
		print "$_\t0\t$tot{$_}\t$lower\t$upper\n";
	}

}

