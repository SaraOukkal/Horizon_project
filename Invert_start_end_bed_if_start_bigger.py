Species_table = "/beegfs/data/soukkal/Thesis/Horizon/Specimens_problematic.txt"

with open(Species_table, 'r') as species_file:
    for line in species_file:
        species_name, specimen_id = line.strip().split(' ')

        # Formulate the BED file path using the provided template
        bed_file_path = f"/beegfs/project/horizon/data/stats/busco/species_busco_pos/Busco_positions_{species_name}_{specimen_id}.bed"

        # Formulate the output BED file path with the "_modified" suffix
        output_file_path = f"/beegfs/project/horizon/data/stats/busco/species_busco_pos/Busco_positions_{species_name}_{specimen_id}_modified.bed"

        # Process the BED file
        with open(bed_file_path, 'r') as infile, open(output_file_path, 'w') as outfile:
            for bed_line in infile:
                parts = bed_line.strip().split('\t')
                start, end = int(parts[1]), int(parts[2])

                # Swap start and end if necessary
                if start > end:
                    start, end = end, start

                # Write the modified line to the output file
                modified_line = f"{parts[0]}\t{start}\t{end}\n"
                outfile.write(modified_line)

