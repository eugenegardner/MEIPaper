#!/usr/bin/perl

use strict;
use warnings;

open (VCF, "-|","bcftools view -S $ARGV[1] --force-samples -c 1 $ARGV[0]") || die "Cannot open file: $!";
open (pLI, "</lustre/scratch115/projects/ddd/users/eg15/WXS_10K/VCF/VCF_v6/vep/ExacPLI.txt") || die "Cannot open file: $!";

my %pli;

foreach my $p (<pLI>) {

	chomp $p;
	my @data = split('\t', $p);
	
	if ($data[0] =~/(ENST\d{11})\.\d+/) {

		$pli{$1} = $data[6];

	}

}

close pLI;

foreach my $vcf (<VCF>) {

	chomp $vcf;
	my @data = split('\t', $vcf);

	if ($vcf =~ /\#/) {

		next;

	} else {

		my @info = split(";", $data[7]);
		my $total = scalar(@info);
		my $vep;
		if ($ARGV[0] =~ /LINE1/) {
			$vep = $info[13];
		} else {
			$vep = $info[12];
		}
		
		##INFO field 12 (0-based) is the VEP annotation
		my $caught_annot = 'false';
		if ($vep =~ /CSQ=(\S+)/) {
			
			my $vep_string = $1;
			my @vep = split(",", $vep_string);
			my $gene_total = scalar(@vep);
			
			my $found_can = 'false';
			my $found_pli = 'false';

			my %annot;
			foreach my $gene (@vep) {
			
				my @current = split('\|',$gene);
				#p(@current);
				my $consequence = $current[1] ? $current[1] : 'none';
				my $canonical = $current[24] ? $current[24] : 'NO';
				my $subtype = $current[7] ? $current[7] : '';
				my $transcript = $current[6];
				
				if ($canonical eq 'YES') {
					$found_can = 'true';
				}

				if ($consequence =~ /intron/) {
					$consequence = 'intron';
				} elsif ($consequence =~ /5_prime/) {
					$consequence = '5_prime';
				} elsif ($consequence =~ /3_prime/) {
					$consequence = '3_prime';
				} elsif ($consequence =~ /coding_sequence_variant/) {
					$consequence = 'exon';
				} else {
					next;
				}

				## Check for a pli score
				if (exists $pli{$transcript}) {
					
					$found_pli = 'true';
					$annot{$transcript} = {cqs => $consequence, pli=> $pli{$transcript}, canonical => $canonical, subtype => $subtype};
					
				} else {
					
					$annot{$transcript} = {cqs => $consequence, pli=> 'null', canonical => $canonical, subtype => $subtype};
					
				}

			}

			foreach my $a (sort {$annot{$a}->{pli} cmp $annot{$b}->{pli}} keys %annot) {

				if ($annot{$a}{canonical} eq 'YES' && $annot{$a}{pli} ne 'null') {
					print "$data[0]\t$data[1]\t$data[1]\t$a\t$annot{$a}{cqs}\t$annot{$a}{pli}\t$annot{$a}{canonical}\t$annot{$a}{subtype}\n";
					$caught_annot = 'true';
					last;
				}
			   
			}
		}
		if ($caught_annot eq 'false') {
			print "$data[0]\t$data[1]\t$data[1]\tnull\tnull\tnull\tnull\tnull\n";
		}
		
	}

}

close VCF;
