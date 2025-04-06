#!/bin/bash

###############################################################################
# elbow_plot_broadpeak_simple.sh
#
# DESCRIPTION:
# This script analyzes a MACS2 broadPeak file to evaluate how the number of
# peaks varies as a function of q-value threshold. It:
#
#   1. Takes a MACS2 broadPeak file as input.
#   2. Tests a range of q-value thresholds, spaced logarithmically.
#   3. Counts the number of peaks that pass each q-value threshold.
#   4. Creates an elbow plot showing the number of peaks vs. q-value threshold.
#   5. Outputs the elbow plot as a PDF.
#
# USAGE:
#   ./elbow_plot_broadpeak_simple.sh <broadPeak_file> <name> <start_qval> <end_qval> <num_steps> 
#
# EXAMPLE:
#   ./elbow_plot_broadpeak_simple.sh H3K27ac.broadPeak H3K27ac 0.01 1e-5 20 
#
# INPUTS:
#   <broadPeak_file> : A MACS2 broadPeak file (tab-delimited, 9 columns). 9th column should contain the -log10(qValue). This works with default MACS2 broadPeak files.
#   <name>           : Name of the histone mark or factor (e.g., H3K27ac)
#   <start_qval>     : Starting q-value threshold (e.g., 0.01)
#   <end_qval>       : Ending q-value threshold (e.g., 1e-10)
#   <num_steps>      : Number of steps between start and end thresholds (e.g. 20)
#
# OUTPUTS:
#   - qvalue_peak_counts_<name>.txt : Table of q-values and peak counts
#   - elbow_plot_<name>.pdf         : Elbow plot showing optimal q-value cutoff
###############################################################################

# Inputs
PEAK_FILE="$1" # 9th column contains the -log10(qValue)
FACTOR_NAME="$2"
START_Q="$3"
END_Q="$4"
N_STEPS="$5"

OUTFILE="qvalue_peak_counts_${FACTOR_NAME}.txt"
PLOTFILE="elbow_plot_${FACTOR_NAME}.pdf"

rm -f "$OUTFILE"
echo "QvalueThreshold NumPeaks" > "$OUTFILE"

# Convert q-values to log10 space
LOG_START=$(awk -v q="$START_Q" 'BEGIN {print log(q)/log(10)}')
LOG_END=$(awk -v q="$END_Q" 'BEGIN {print log(q)/log(10)}')

# Loop over log-spaced values
for i in $(seq 0 $((N_STEPS-1))); do
    LOG_STEP=$(awk -v s="$LOG_START" -v e="$LOG_END" -v n="$N_STEPS" -v i="$i" \
        'BEGIN {step = (e - s) / (n - 1); print s + i * step}')
    Q=$(awk -v l="$LOG_STEP" 'BEGIN {printf "%.10g", 10^l}')
    LOG10Q=$(awk -v q="$Q" 'BEGIN {print -log(q)/log(10)}')
    
    COUNT=$(awk -v logq="$LOG10Q" '$9 >= logq {count++} END {print count+0}' "$PEAK_FILE")
    echo "$Q $COUNT" >> "$OUTFILE"
done

echo "Saved q-value curve to $OUTFILE"

# Generate elbow plot using R 
Rscript - <<EOF
data <- read.table("$OUTFILE", header=TRUE)

library(ggplot2)

pdf("$PLOTFILE")
ggplot(data, aes(x=-log10(QvalueThreshold), y=NumPeaks)) +
  geom_line(color="firebrick") +
  geom_point(size=2) +
  labs(title=paste("Peak count vs q-value —", "$FACTOR_NAME"),
       x="-log10(q-value threshold)", y="Number of peaks") +
  theme_minimal()
dev.off()
EOF

echo "Generated $PLOTFILE"
