#!/bin/bash

# Chemin vers le dossier des fichiers
input_folder="/beegfs/project/horizon/data/trimmed_reads/"

# Tableau de correspondance entre Species et Specimen
declare -A species_specimen=(
    ["02-SRNP-3724"]="geljanzen01_janzen180"
    ["04-SRNP-14171"]="quadrus_cerialis"
    ["04-SRNP-41648"]="napaea_eucharila"
    ["04-SRNP-48829"]="mylon_lassia"
    ["05-SRNP-45964"]="mylon_lassia"
    ["06-SRNP-44458"]="geljanzen01_janzen180"
    ["DHJPAR0000201"]="parapanteles_continua"
    ["DHJPAR0002774"]="parapanteles_continua"
    ["DHJPAR0011714"]="lixophaga_wood06"
    ["DHJPAR0012865"]="meteorus_papiliovorusdhj03"
    ["DHJPAR0014099"]="hyposoter_inb-42dhj01"
    ["DHJPAR0016507"]="lixophaga_wood06"
    ["DHJPAR0035295"]="alabagrus_combos"
    ["DHJPAR0050715"]="actia_janzen06"
    ["DHJPAR0055060"]="actia_janzen06"
)

# Parcourir les fichiers dans le dossier
for file_name in "${!species_specimen[@]}"; do
    # Vérifier si le fichier R1 existe
    file_r1="$input_folder$file_name"_1.fq
    if [ -e "$file_r1" ]; then
        # Utiliser directement le nom du specimen à partir de file_name
        species="${species_specimen[$file_name]}"

        # Construire le nouveau nom de fichier R1
        new_file_name_r1="${species}:${file_name}_1.fq"

        # Afficher un message
        echo "Renommer et Gzip $file_r1 en $new_file_name_r1"

        # Renommer et Gzip le fichier R1
        mv "$file_r1" "$input_folder$new_file_name_r1"
        gzip "$input_folder$new_file_name_r1"
    fi

    # Vérifier si le fichier R2 existe
    file_r2="$input_folder$file_name"_2.fq
    if [ -e "$file_r2" ]; then
        # Utiliser directement le nom du specimen à partir de file_name
        species="${species_specimen[$file_name]}"

        # Construire le nouveau nom de fichier R2
        new_file_name_r2="${species}:${file_name}_2.fq"

        # Afficher un message
        echo "Renommer et Gzip $file_r2 en $new_file_name_r2"

        # Renommer et Gzip le fichier R2
        mv "$file_r2" "$input_folder$new_file_name_r2"
        gzip "$input_folder$new_file_name_r2"
    fi
done

