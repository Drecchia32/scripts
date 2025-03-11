#!/bin/bash

#directory to store the yml files
output_dir=/hpc/uu_epigenetics/davide/conda_envs

#maake directory if its not there
mkdir -p "/hpc/uu_epigenetics/davide/conda_envs"

#manualy list environments to export
#don't export environments from common GBE conda
environments=(
  "/hpc/local/CentOS7/uu_epigenetics/SOFT/miniconda3"
  "/hpc/local/CentOS7/uu_epigenetics/SOFT/miniconda3/envs/DR_chip"
  "/hpc/local/CentOS7/uu_epigenetics/SOFT/miniconda3/envs/DR_cnr"
  "/hpc/local/CentOS7/uu_epigenetics/SOFT/miniconda3/envs/RStudio"
  "/hpc/local/CentOS7/uu_epigenetics/SOFT/miniconda3/envs/maxquant"
  "/hpc/local/CentOS7/uu_epigenetics/SOFT/miniconda3/envs/nextflow"
)

#lop through each environment and export iit
for env in "${environments[@]}"; do
  #get the environment name
  env_name=$(basename "$env")
  
  #export environment to a yml 
  conda env export --prefix "$env" > "$output_dir/$env_name.yml"
  
  #check ifexport was successful
  if [ $? -eq 0 ]; then
    echo "Exported environment '$env_name' to '$output_dir/$env_name.yml'"
  else
    echo "Failed to export environment '$env_name' :("
  fi
done

echo "Exported all specified environments to $output_dir :)"

