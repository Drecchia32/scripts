#! /bin/bash

#modified peak calling script for xDR084
#calling peaks for 5 different drug treatments
#normal script, but iterating it over different drug treatments


#DMSO

CORES=1
INPUT_DIR="/hpc/uu_epigenetics/davide/cutandrun/xDR119/cutnrun_analysis_2/analyzed/merged/fasta"
PROJECTPATH="/hpc/uu_epigenetics/davide/cutandrun/xDR119/cutnrun_analysis_2/analyzed/merged"


#make output directories
mkdir -p $PROJECTPATH/sbatch_output/peaks
mkdir -p $PROJECTPATH/peaks/seacr/stringent
mkdir -p $PROJECTPATH/peaks/seacr/relaxed
mkdir -p $PROJECTPATH/peaks/macs/broad
mkdir -p $PROJECTPATH/peaks/macs/narrow



#DMSO

#manually set the IgG controls
#for seacr
IGG_CONTROL_MERGED=$PROJECTPATH/bedgraph/xDR119_IgG_DMSO_merged_bt2.mm10.fragments.manualCPM.bedgraph
#for MACS2
IGG_Control_MERGED_BAM=$PROJECTPATH/mapped/xDR119_IgG_DMSO_merged_bt2.mm10.mapped.bam





#run for loop to go over all files. Then call peaks over different inputs based off of rep1, rep2, or rep3
for fq in $INPUT_DIR/*DMSO*R1_001.fastq.gz; do
    filename=$(basename $fq)  #get the filename without directory part.basename is used for the rest of the loop
    echo "calling peaks for file with base name:$filename"
    #
    if [[ $filename == *"merged"* ]]; then
        #Rep1 is present in $fq
        #list variables for troubleshooting
        echo "$filename contains 'merged'"
            echo "cores: $((CORES))"
            echo "project path: $PROJECTPATH"
            echo "input bedgraph: $PROJECTPATH/bedgraph/${filename%R1_001.fastq.gz}bt2.mm10.fragments.manualCPM.bedgraph"
            echo "control bedgraph: $IGG_CONTROL_MERGED"
        echo "input BAM: $PROJECTPATH/mapped/${filename%R1_001.fastq.gz}bt2.mm10.mapped.bam"
        echo "control BAM: $IGG_Control_MERGED_BAM"
        #submit job for peak calling
        sbatch -t 0-5:00 -n $((CORES)) --mem=32G --gres=tmpspace:15G  --job-name cutnrun-peaks -o $PROJECTPATH/sbatch_output/peaks/%j.out -e $PROJECTPATH/sbatch_output/peaks/%j.err \
--wrap="/hpc/uu_epigenetics/davide/scripts/cutnrun/merge_peaks_script_input_bam.sh $filename $((CORES)) $PROJECTPATH  $PROJECTPATH/bedgraph/${filename%R1_001.fastq.gz}bt2.mm10.fragments.manualCPM.bedgraph $IGG_CONTROL_MERGED $PROJECTPATH/mapped/${filename%R1_001.fastq.gz}bt2.mm10.mapped.bam $IGG_Control_MERGED_BAM"    
    fi

    sleep 1     # wait 1 second between each job submission
done
