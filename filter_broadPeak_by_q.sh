#!/bin/bash

# This script filters a MACS2 broadPeak file based on q-value threshold.
# The 9th column is assumed to be -log10(q-value).
#
# Usage:
#   ./filter_broadPeak_by_q.sh input.broadPeak 0.001 [output_filename] [output_directory]
#
# Arguments:
#   input.broadPeak       Path to the input broadPeak file
#   0.001                 Q-value threshold
#   output_filename       (Optional) Output file name (e.g., filtered.broadPeak)
#   output_directory      (Optional) Output directory path (e.g., ./filtered_peaks/)

# Check for minimum required arguments
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <input.broadPeak> <qvalue_threshold> [output_filename] [output_directory]"
    exit 1
fi

INPUT_FILE="$1"
Q_THRESHOLD="$2"

# Convert q-value threshold to -log10(q)
LOG_Q_THRESHOLD=$(awk -v q="$Q_THRESHOLD" 'BEGIN { print -log(q)/log(10) }')

# Determine output filename
if [ -n "$3" ]; then
    OUTPUT_FILENAME="$3"
else
    BASENAME=$(basename "$INPUT_FILE" .broadPeak)
    OUTPUT_FILENAME="${BASENAME}_q${Q_THRESHOLD}.broadPeak"
fi

# Determine output directory
if [ -n "$4" ]; then
    OUTPUT_DIR="$4"
    mkdir -p "$OUTPUT_DIR"
else
    OUTPUT_DIR="."
fi

# Full path to the output file
OUTPUT_PATH="${OUTPUT_DIR%/}/$OUTPUT_FILENAME"

# Perform filtering using awk: keep rows where -log10(q) >= threshold
awk -v q="$LOG_Q_THRESHOLD" '$9 >= q' "$INPUT_FILE" > "$OUTPUT_PATH"

echo "Filtered peaks with q ≤ $Q_THRESHOLD (i.e., -log10(q) ≥ $LOG_Q_THRESHOLD) written to: $OUTPUT_PATH"

