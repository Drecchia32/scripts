# Activate the Conda environment
source activate /hpc/local/CentOS7/uu_epigenetics/SOFT/miniconda3/envs/DR_chip

# Record the start time of the overall script
start_time=$(date +"%Y-%m-%d %H:%M:%S")




# initialize a variable with an intuitive name to store the name of the input fastq file
fq=$1

#set number of cores to be used, as definedd when script is called
CORES=$2

#set number of cores to be used, as definedd when script is called
PROJECTPATH=$3

#bedgraph file that will be used in seacr
BEDGRAPH_INPUT=$4

#bedgraph file that will be used as the control
BEDGRAPH_CONTROL=$5

#BAM file that will be used in MACS2
BAM_INPUT=$6

#BAM file that will be used as the control
BAM_CONTROL=$7

# grab base of filename for naming outputs
base=`basename $fq`
echo "Sample name is $base"

echo here are all of the variables:
echo "base filename: $fq "
echo "number of cores: $CORES"
echo "project path: $PROJECTPATH"
echo "input file: $BEDGRAPH_INPUT"
echo "control file: $BEDGRAPH_CONTROL"
echo "new file: $PROJECTPATH/peaks/seacr/${fq%R1_001.fastq.gz}seacr.bed"

echo calling peaks with Seacr
#stringent
SEACR_1.3.sh $BEDGRAPH_INPUT $BEDGRAPH_CONTROL norm stringent $PROJECTPATH/peaks/seacr/stringent/${fq%R1_001.fastq.gz}seacr

#relaxed
SEACR_1.3.sh $BEDGRAPH_INPUT $BEDGRAPH_CONTROL norm relaxed $PROJECTPATH/peaks/seacr/relaxed/${fq%R1_001.fastq.gz}seacr

#echo calling peaks with MACS
#MACS2

#q threshold of 0.1
echo "$BAM_INPUT"
echo "$BAM_CONTROL"
echo "${BAM_INPUT%bt2.mm10.mapped.bam}macs2_q0.01_broad"
 
macs2 callpeak -t $BAM_INPUT \
      -c $BAM_CONTROL \
      -g mm -f BAMPE -n ${fq%R1_001.fastq.gz}overIgG_macs2_q0.01_broad --outdir $PROJECTPATH/peaks/macs/broad -q 0.01 --keep-dup all --broad


macs2 callpeak -t $BAM_INPUT \
      -c $BAM_CONTROL \
      -g mm -f BAMPE -n ${fq%R1_001.fastq.gz}overIgG_macs2_q0.01 --outdir $PROJECTPATH/peaks/macs/narrow -q 0.01 --keep-dup all











# Record the end time of the overall script
end_time=$(date +"%Y-%m-%d %H:%M:%S")

# Calculate the total run time of the script
total_run_time=$(($(date -d "$end_time" +%s) - $(date -d "$start_time" +%s)))

# Print the total run time to a separate file
echo "Total Run Time: $total_run_time seconds"
echo "Total number of cores used per: $((CORES))"
