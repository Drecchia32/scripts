#!/bin/bash
#SBATCH --job-name=peak_overlap
#SBATCH --nodes=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=16G
#SBATCH --time=6:00:00
#SBATCH --output=merge_%j.out
#SBATCH --error=merge_%j.err


# Activate the Conda environment
source activate /hpc/local/CentOS7/uu_epigenetics/SOFT/miniconda3/envs/DR_chip


# Define the directory containing your CoF peak files and the P300 peak file
cof_peak_dir="/hpc/uu_epigenetics/davide/cutandrun/xDR119/cutnrun_analysis_2/analyzed/merged/peaks/macs/narrow"
p300_peak_file="/hpc/uu_epigenetics/davide/cutandrun/xDR119/cutnrun_analysis_2/analyzed/merged/peaks/macs/narrow/xDR119_P300_DMSO_merged_overIgG_macs2_q0.01_peaks.narrowPeak"
output_dir="/hpc/uu_epigenetics/davide/cutandrun/xDR119/cutnrun_analysis_2/analyzed/merged/peaks/macs/narrow/overlapping_peaks_p300_with_CoFs_mergedConsensus"

# Create the output directory if it doesn't exist
mkdir -p $output_dir

# Loop through each CoF peak file
for cof_peak_file in $cof_peak_dir/*DMSO*.narrowPeak
	do



    # Get the cofactor name by extracting the string between 'xDR119_' and '_DMSO_merged_overIgG_macs2_q0.01_peaks'
    cof_name=${cof_peak_file#*xDR119_}
    cof_name=${cof_name%_merged_overIgG_macs2_q0.01_peaks.narrowPeak}
    
    # Define the output file name
    output_file="$output_dir/xDR119_${cof_name}_overlapping_with_P300_DMSO_mergedConsensus.narrowPeak"
    
    # Find overlapping peaks and save to the output file
    bedtools intersect -a $cof_peak_file -b $p300_peak_file > $output_file
    
    echo "Created $output_file with peaks overlapping with P300"
done
