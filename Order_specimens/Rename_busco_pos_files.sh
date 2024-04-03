#!/bin/bash

# Chemin vers le fichier Species_specimen_file_names.txt
file_names_file="/beegfs/data/soukkal/Thesis/Horizon/Order_specimens/Species_specimen_file_names.txt"

# Chemin vers le répertoire contenant les fichiers à renommer
directory="/beegfs/project/horizon/data/stats/busco/species_busco_pos/"

# Parcourir le fichier Species_specimen_file_names.txt
while IFS= read -r line; do
    # Extraire les colonnes 1 et 2
    current_species_type=$(echo "$line" | awk '{print $1}')
    current_species_id=$(echo "$line" | awk '{print $2}')

    # Ancien et nouveau noms de fichier
    old_filename="${directory}Busco_positions_${current_species_type}.bed"
    new_filename="${directory}Busco_positions_${current_species_id}.bed"

    # Renommer le fichier s'il existe
    if [ -e "$old_filename" ]; then
        mv "$old_filename" "$new_filename"
        echo "Renommé $old_filename en $new_filename"
    else
        echo "Le fichier $old_filename n'existe pas."
    fi
done < "$file_names_file"

