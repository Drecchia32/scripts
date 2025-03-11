#!/bin/bash
#SBATCH --job-name=mito
#SBATCH --nodes=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=16G
#SBATCH --time=6:00:00
#SBATCH --output=mito_%j.out
#SBATCH --error=mito_%j.err


# Activate the Conda environment
source activate /hpc/local/CentOS7/uu_epigenetics/SOFT/miniconda3/envs/DR_chip




# Directory containing BAM files
bam_dir="/hpc/uu_epigenetics/davide/cutandrun/xDR119/cutnrun_analysis_2/analyzed/merged/mapped"

#make output dir
mkdir -p $bam_dir/mito_info

# Loop through each BAM file in the directory
for bam in "$bam_dir"/*.bam; do

    echo "Checking mito reads for $bam"
    
    # Count the total number of reads
    total_reads=$(samtools view -c "$bam")
    
    # Count the number of reads mapped to mitochondrial chromosome (chrM)
    mito_reads=$(samtools view "$bam" | grep -w "chrM" | wc -l)
    
    # Calculate the percentage of mitochondrial reads
    if [ "$total_reads" -gt 0 ]; then
        mito_percentage=$(echo "scale=2; ($mito_reads / $total_reads) * 100" | bc)
        echo "Percentage of mitochondrial reads: $mito_percentage%"
    else
        echo "No reads found in $bam."
    fi


    make results file for each sample
    touch $bam_dir/mito_info/${bam%bam}mitoInfo.txt
 
    # Print the results to the output file
    echo -e "$(basename "$bam")\t$total_reads\t$mito_reads\t$mito_percentage" >> $bam_dir/mito_info/${bam%bam}mitoInfo.txt
    
    
    echo "-------------------------------------"
done

