#!/bin/bash

Folder="/beegfs/project/horizon/data/trimmed_reads/"

# Liste des fichiers à compresser
files=(
    "mylon_lassia:05-SRNP-45964_1.fq"
    "mylon_lassia:05-SRNP-45964_2.fq"
    "geljanzen01_janzen180:02-SRNP-3724_1.fq"
    "geljanzen01_janzen180:02-SRNP-3724_2.fq"
    "geljanzen01_janzen180:06-SRNP-44458_1.fq"
    "geljanzen01_janzen180:06-SRNP-44458_2.fq"
    "lixophaga_wood06:DHJPAR0011714_1.fq"
    "lixophaga_wood06:DHJPAR0011714_2.fq"
    "mylon_lassia:04-SRNP-48829_1.fq"
    "mylon_lassia:04-SRNP-48829_2.fq"
    "alabagrus_combos:DHJPAR0035295_1.fq"
)

# Parcourir la liste et compresser chaque fichier
for file in "${files[@]}"; do
    # Vérifier si le fichier existe
    if [ -e "$Folder""$file" ]; then
        # Afficher un message
        echo "Compression de $file"

        # Utiliser gzip pour compresser le fichier
        gzip "$Folder""$file"
    else
        echo "Le fichier $file n'existe pas."
    fi
done
