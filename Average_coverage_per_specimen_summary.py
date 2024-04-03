import os

# Directory containing coverage files
coverage_directory = "/beegfs/project/horizon/data/mapping/cov"
output_file_path = "/beegfs/project/horizon/data/mapping/cov/Coverage_per_specimen.txt"

# Open the output file for writing
with open(output_file_path, 'w') as output_file:
    # Write header to the output file
    output_file.write("species_name specimen_id average_coverage\n")

    # Iterate over all files in the directory
    for filename in os.listdir(coverage_directory):
        if filename.endswith(".cov"):
            # Extract species_name and specimen_id from the filename
            parts = filename.replace(".cov", "").split(":")
            species_name, specimen_id = parts[0], parts[1]

            # Formulate the full path to the coverage file
            coverage_file_path = os.path.join(coverage_directory, filename)

            # Read coverage information from the file
            total_coverage = 0
            total_size = 0

            with open(coverage_file_path, 'r') as coverage_file:
                # Skip the header line
                next(coverage_file)

                for line in coverage_file:
                    columns = line.strip().split()
                    size, coverage = int(columns[2]), float(columns[5])

                    # Update total coverage and size
                    total_coverage += size * coverage
                    total_size += size

            # Calculate the average coverage for the specimen
            if total_size > 0:
                average_coverage = total_coverage / total_size
                # Write the result to the output file
                output_file.write(f"{species_name} {specimen_id} {average_coverage:.2f}\n")
            else:
                # Write a placeholder if no data found
                output_file.write(f"{species_name} {specimen_id} No data found\n")

print(f"Results written to {output_file_path}")

