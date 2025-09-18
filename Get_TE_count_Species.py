import os
import pandas as pd

# Input folder containing the *_scaffolds_TE_proportions.tsv files
input_dir = "/beegfs/project/horizon/data/TE/TE_positions/"

# Output file path
output_file = "/beegfs/data/soukkal/Thesis/Horizon/TE_count_summary_by_species.tsv"

# Initialize a list to store per-species TE counts
summary_list = []

# Iterate over all files in the directory
for filename in os.listdir(input_dir):
    if filename.endswith("_scaffolds_TE_proportions.tsv"):
        # Extract species name from the filename
        species = filename.replace("_scaffolds_TE_proportions.tsv", "")
        
        # Construct full path to the file
        file_path = os.path.join(input_dir, filename)
        
        # Load the data
        df = pd.read_csv(file_path, sep="\t")
        
        # Compute total TE count for this species
        total_te = df["TE Count"].sum()
        
        # Store the result
        summary_list.append({
            "Species": species,
            "Total_TE_Count": total_te
        })

# Create summary DataFrame
summary_df = pd.DataFrame(summary_list)

# Write the result to the specified output path
summary_df.to_csv(output_file, sep="\t", index=False)

