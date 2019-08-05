#!/bin/bash

MEI=$1

./parse_vep.pl $MEI.vep_annotated.dupes_indv_removed.vcf.gz parents_dddp.unaffected.txt > $MEI.pli.txt

bedtools intersect -a $MEI.pli.txt -b /lustre/scratch115/projects/ddd/users/eg15/WXS_10K/mei_mutation_rate/ddd_accessible_genome/ddd_accessible_genome.sorted.bed > $MEI.pli.acc.txt

perl -ane 'chomp $_; if ($F[4] eq  "intron") {print "$F[0]\t$F[1]\t$F[1]\n";}' $MEI.pli.acc.txt > $MEI.intron_sites.txt
perl -ane 'chomp $_; if ($F[4] eq  "exon") {print "$F[0]\t$F[1]\t$F[1]\n";}' $MEI.pli.acc.txt > $MEI.exon_sites.txt

/software/vcftools-0.1.15/bin/vcftools --gzvcf $MEI.vep_annotated.dupes_indv_removed.vcf.gz --positions $MEI.intron_sites.txt --out $MEI.intron --keep parents_dddp.unaffected.txt --non-ref-ac 1 --freq
/software/vcftools-0.1.15/bin/vcftools --gzvcf $MEI.vep_annotated.dupes_indv_removed.vcf.gz --positions $MEI.exon_sites.txt --out $MEI.exon --keep parents_dddp.unaffected.txt --non-ref-ac 1 --freq

sed -i /CHROM/d $MEI.intron.frq
sed -i /CHROM/d $MEI.exon.frq

rm $MEI.intron.log
rm $MEI.exon.log
