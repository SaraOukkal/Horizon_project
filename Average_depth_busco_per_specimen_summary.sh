#!/bin/bash

# Specify the path to the folder containing BED files
bed_folder="/beegfs/project/horizon/data/mapping/BUSCO_depth"

# Specify the path to the output file
output_file="/beegfs/project/horizon/data/mapping/BUSCO_depth/Depth_per_specimen.txt"

# Create the output file or empty it if it already exists
> "$output_file"

# Iterate over the BED files in the folder
for file in "$bed_folder"/BUSCO_*.per-base.bed; do
    # Get the filename without the extension
    filename=$(basename -- "$file")
    filename_no_ext="${filename%.*}"

    # Remove the "BUSCO_" prefix from the filename
    filename_no_busco="${filename_no_ext#BUSCO_}"

    # Extract the specimen name between ":" and ".per-base"
    specimen=$(echo "$filename_no_busco" | awk -F':' '{print $2}' | awk -F'.' '{print $1}')

    # Extraction of species name from the filename
    species=$(echo "$filename_no_busco" | cut -d':' -f1)

    # Calculation of the average of column 3
    average=$(awk '{sum += $3} END {if (NR > 0) print sum / NR}' "$file")

    # Write to the output file
    echo "$species $specimen $average" >> "$output_file"
done

