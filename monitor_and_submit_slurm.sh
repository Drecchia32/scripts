#!/bin/bash
#SBATCH --job-name=monitor_and_submit
#SBATCH --output=monitor_and_submit.out
#SBATCH --error=monitor_and_submit.err
#SBATCH --time=06:00:00  # adjust this depending on the expected waiting time
#SBATCH --partition=cpu

# Job ID of the currently running job
CURRENT_JOB_ID=24277213

# Names of the scripts to submit after the current job finishes
NEXT_JOB_SCRIPT1="/hpc/uu_epigenetics/davide/cutandrun/xDR119/cutnrun_analysis_2/P300_differential_binding/bin_genome/calc_coverage_1kb_bins.sh"
NEXT_JOB_SCRIPT2="/hpc/uu_epigenetics/davide/cutandrun/xDR119/cutnrun_analysis_2/P300_differential_binding/bin_genome/calc_coverage_10kb_bins.sh"

# Your username
USER=drecchia

# Check if the current job is still running
while squeue -u $USER | grep -q "$CURRENT_JOB_ID"
do
  # Sleep for a minute before checking again
  sleep 60
done

# Submit the next jobs
sbatch $NEXT_JOB_SCRIPT1
sbatch $NEXT_JOB_SCRIPT2

echo "Job $CURRENT_JOB_ID has finished. Submitted $NEXT_JOB_SCRIPT1 and $NEXT_JOB_SCRIPT2."

