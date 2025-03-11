#!/bin/bash
#SBATCH --job-name=compute_matrix
#SBATCH --cpus-per-task=32
#SBATCH --mem=16G
#SBATCH --time=6:00:00
#SBATCH --output=compute_matrix_%j.out
#SBATCH --error=compute_matrix_%j.err

# Activate Conda environment (if needed)
source activate /hpc/local/CentOS7/uu_epigenetics/SOFT/miniconda3/envs/DR_chip


echo "running compute matrix on 12 files"

# Compute Matrix
computeMatrix reference-point --referencePoint center \
    -S /hpc/uu_epigenetics/davide/cutandrun/xDR119/cutnrun_analysis_2/analyzed/merged/bigwig/xDR119_*_DMSO_merged_bt2.mm10.fragments.manualCPM.bigwig \
    -R /hpc/uu_epigenetics/davide/cutandrun/xDR119/cutnrun_analysis_2/analyzed/merged/peaks/macs/broad/xDR119_P300_DMSO_merged_overIgG_macs2_q0.01_broad_peaks.broadPeak \
    --beforeRegionStartLength 2000 \
    --afterRegionStartLength 2000 \
    --skipZeros \
    -p 32 \
    -o /hpc/uu_epigenetics/davide/cutandrun/xDR119/cutnrun_analysis_2/plots_cofactors_noTreatments/CoFs_clustered_over_P300_DMSO_consensus_peaks/xDR119_CoFs_DMSO_over_P300_consensus_peaks_matrix.mat.gz




echo "running plotHeatmap"

# Plot Heatmap
plotHeatmap -m /hpc/uu_epigenetics/davide/cutandrun/xDR119/cutnrun_analysis_2/plots_cofactors_noTreatments/CoFs_clustered_over_P300_DMSO_consensus_peaks/xDR119_CoFs_DMSO_over_P300_consensus_peaks_matrix.mat.gz \
    -out /hpc/uu_epigenetics/davide/cutandrun/xDR119/cutnrun_analysis_2/plots_cofactors_noTreatments/CoFs_clustered_over_P300_DMSO_consensus_peaks/xDR119_CoFs_DMSO_over_P300_consensus_peaks_heatmap.png \
    --sortUsing sum \
    --perGroup --interpolationMethod nearest --dpi 1000 --missingDataColor white --zMin 0 --zMax 0.2 \
    --samplesLabel "BRD4" "BRD9" "CHD4" "IgG" "INO80" "INTS11" "KMT2D" "MED12" "P300" "P400" "POU5F1" "YY1" \
    --refPointLabel "center" \
    --xAxisLabel "p300 peaks"

