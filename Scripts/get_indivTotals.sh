#!/bin/bash

MEI=$1

##Get bait regions
vcftools --gzvcf $MEI.vcf.gz --keep parents_dddp.unaffected.txt --out $MEI.tot --mac 1 --recode --recode-INFO-all --bed masks/ddd_accessible_genome.sorted.bed

bgzip $MEI.tot.recode.vcf
tabix -p vcf $MEI.tot.recode.vcf.gz

scripts/get_totals.pl $MEI.tot.recode.vcf.gz > $MEI.totals.bait.txt

rm $MEI.tot.recode.vcf.gz
rm $MEI.tot.recode.vcf.gz.tbi

##Get not bait regions
vcftools --gzvcf $MEI.vcf.gz --keep parents_dddp.unaffected.txt --out $MEI.tot --mac 1 --recode --recode-INFO-all

bgzip $MEI.tot.recode.vcf
tabix -p vcf $MEI.tot.recode.vcf.gz

scripts/get_totals.pl $MEI.tot.recode.vcf.gz > $MEI.totals.txt

rm $MEI.tot.recode.vcf.gz
rm $MEI.tot.recode.vcf.gz.tbi
