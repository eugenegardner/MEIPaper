#!/bin/bash

vcftools --gzvcf ALU.vcf.gz --keep parents_dddp.unaffected.txt --freq --out ALU.bait --mac 1 --bed masks/ddd_accessible_genome.sorted.bed
vcftools --gzvcf LINE1.vcf.gz --keep parents_dddp.unaffected.txt --freq --out LINE1.bait --mac 1 --bed masks/ddd_accessible_genome.sorted.bed
vcftools --gzvcf SVA.vcf.gz --keep parents_dddp.unaffected.txt --freq --out SVA.bait --mac 1 --bed masks/ddd_accessible_genome.sorted.bed

sed -i /CHROM/d ALU.bait.frq
sed -i /CHROM/d LINE1.bait.frq
sed -i /CHROM/d SVA.bait.frq

rm ALU.bait.log
rm LINE1.bait.log
rm SVA.bait.log

vcftools --gzvcf ALU.vcf.gz --keep parents_dddp.unaffected.txt --freq --out ALU --mac 1
vcftools --gzvcf LINE1.vcf.gz --keep parents_dddp.unaffected.txt --freq --out LINE1 --mac 1
vcftools --gzvcf SVA.vcf.gz --keep parents_dddp.unaffected.txt --freq --out SVA --mac 1

sed -i /CHROM/d ALU.frq
sed -i /CHROM/d LINE1.frq
sed -i /CHROM/d SVA.frq

rm ALU.log
rm LINE1.log
rm SVA.log
