#!/bin/bash

MEI=$1
vcftools --gzvcf $MEI.vcf.gz --keep parents_dddp.unaffected.txt --out $MEI.tot --mac 1 --recode --recode-INFO-all

bgzip $MEI.tot.recode.vcf
tabix -p vcf $MEI.tot.recode.vcf.gz

##Get len estimates for 
bcftools query $MEI.tot.recode.vcf.gz -f "%SVLEN\n" | grep -v "\-1" > $MEI.len

rm $MEI.tot.recode.vcf.gz
rm $MEI.tot.recode.vcf.gz.tbi
