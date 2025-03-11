#!/bin/bash
#SBATCH --job-name=fastqc
#SBATCH --nodes=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=16G
#SBATCH --time=6:00:00
#SBATCH --output=merge_%j.out
#SBATCH --error=merge_%j.err


#activate the Conda environment
source activate /hpc/uu_epigenetics/davide/software/miniconda3/envs/DR_QC



#check if a directory was provided as an argument, if not, exit
if [ -z "$1" ]; then
  echo "Usage: $0 /path/to/fastq_directory"
  exit 1
fi


#set the directory containing the fastq files
FASTQ_DIR="$1"

#make  output directory within the specified directory
OUTPUT_DIR="${FASTQ_DIR}/fastqc_output"

mkdir -p "$OUTPUT_DIR"


#run fastqc on all fastq.gz files in the specified directory
fastqc -o "$OUTPUT_DIR" "${FASTQ_DIR}"/*.fastq.gz 

#run multiccc to aggregate the fastqc reports in the otuput dir
multiqc "$OUTPUT_DIR" -o "$OUTPUT_DIR"


