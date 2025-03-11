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

multiBigwigSummary bins --bwfiles /hpc/uu_epigenetics/davide/cutandrun/xDR119/cutnrun_analysis_2/analyzed/merged/bigwig/xDR119_*_DMSO_merged_bt2.mm10.fragments.manualCPM.bigwig \
    --labels "BRD4" "BRD9" "CHD4" "IgG" "INO80" "INTS11" "KMT2D" "MED12" "P300" "P400" "POU5F1" "YY1" \
    --outFileName /hpc/uu_epigenetics/davide/cutandrun/xDR119/cutnrun_analysis_2/plots_cofactors_noTreatments/deeptools_multiBigwigSummary/CoFs_coverage_over_1kb_bins.npz \
    --binSize 1000 \
    --blackListFileName /hpc/uu_epigenetics/davide/annotations/blacklists/mm10-blacklist.v2.bed \
    --numberOfProcessors 32 \




echo "running plotCorrelation"

# Plot correlation plot
plotCorrelation -in /hpc/uu_epigenetics/davide/cutandrun/xDR119/cutnrun_analysis_2/plots_cofactors_noTreatments/deeptools_multiBigwigSummary/CoFs_coverage_over_1kb_bins.npz \
    --corMethod spearman \
    --whatToPlot heatmap \
    --plotFile /hpc/uu_epigenetics/davide/cutandrun/xDR119/cutnrun_analysis_2/plots_cofactors_noTreatments/deeptools_multiBigwigSummary/CoFs_coverage_over_1kb_bins_spearman.pdf \
    --skipZeros \
    --labels "BRD4" "BRD9" "CHD4" "IgG" "INO80" "INTS11" "KMT2D" "MED12" "P300" "P400" "POU5F1" "YY1" \


# Plot correlation plot
plotCorrelation -in /hpc/uu_epigenetics/davide/cutandrun/xDR119/cutnrun_analysis_2/plots_cofactors_noTreatments/deeptools_multiBigwigSummary/CoFs_coverage_over_1kb_bins.npz \
    --corMethod pearson \
    --whatToPlot heatmap \
    --plotFile /hpc/uu_epigenetics/davide/cutandrun/xDR119/cutnrun_analysis_2/plots_cofactors_noTreatments/deeptools_multiBigwigSummary/CoFs_coverage_over_1kb_bins_pearson.pdf \
    --skipZeros \
    --labels "BRD4" "BRD9" "CHD4" "IgG" "INO80" "INTS11" "KMT2D" "MED12" "P300" "P400" "POU5F1" "YY1" \













