#!/bin/bash
#SBATCH --job-name=merge
#SBATCH --nodes=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=16G
#SBATCH --time=5:00:00
#SBATCH --output=merge_%j.out
#SBATCH --error=merge_%j.err

#merging DMSO samples

CORES=1
INPUT_DIR="/hpc/uu_epigenetics/davide/cutandrun/xDR119/DMSO_treatments_merged"
PROJECTPATH="/hpc/uu_epigenetics/davide/cutandrun/xDR119/cutnrun_analysis_2/analyzed"



#make output directories
mkdir -p $PROJECTPATH/merged
mkdir -p $PROJECTPATH/merged/fasta


#Iterate over rep1 of each factor/treatment combo
#R1 reads first
for fq in $INPUT_DIR/*DMSO*rep1_R1_001.fastq.gz
do

echo "merging fastq files for the following replicates:"
echo "rep1 ${fq%rep1_R1_001.fastq.gz}rep1_R1_001.fastq.gz"
echo "rep2 ${fq%rep1_R1_001.fastq.gz}rep2_R1_001.fastq.gz"
echo "rep3 ${fq%rep1_R1_001.fastq.gz}rep3_R1_001.fastq.gz"

#getting basename for new merged file
base=${fq##*/}
echo "saving merged file: $PROJECTPATH/merged/fasta/${base%rep1_R1_001.fastq.gz}merged_R1_001.fastq.gz"

cat ${fq%rep1_R1_001.fastq.gz}rep1_R1_001.fastq.gz ${fq%rep1_R1_001.fastq.gz}rep2_R1_001.fastq.gz ${fq%rep1_R1_001.fastq.gz}rep3_R1_001.fastq.gz > $PROJECTPATH/merged/fasta/${base%rep1_R1_001.fastq.gz}merged_R1_001.fastq.gz

done


#for R2 reads
for fq in $INPUT_DIR/*DMSO*rep1_R2_001.fastq.gz
do

echo "merging fastq files for the following replicates:"
echo "rep1 ${fq%rep1_R2_001.fastq.gz}rep1_R1_001.fastq.gz"
echo "rep2 ${fq%rep1_R2_001.fastq.gz}rep2_R1_001.fastq.gz"
echo "rep3 ${fq%rep1_R2_001.fastq.gz}rep3_R1_001.fastq.gz"

#getting basename for new merged file
base=${fq##*/}
echo "saving merged file: $PROJECTPATH/merged/fasta/${base%rep1_R2_001.fastq.gz}merged_R1_001.fastq.gz"

cat ${fq%rep1_R2_001.fastq.gz}rep1_R2_001.fastq.gz ${fq%rep1_R2_001.fastq.gz}rep2_R2_001.fastq.gz ${fq%rep1_R2_001.fastq.gz}rep3_R2_001.fastq.gz > $PROJECTPATH/merged/fasta/${base%rep1_R2_001.fastq.gz}merged_R2_001.fastq.gz

done


