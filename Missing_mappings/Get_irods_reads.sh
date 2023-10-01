#!/bin/bash

# Liste des dossiers possibles
dossiers=("HN00131934" "HN00131995" "HN00132113" "HN00136330" "HN00136333" "HN00136653" "HN00156681")

# Liste des noms de spécimens
specimens=("00-SRNP-2014" "01-SRNP-11427" "01-SRNP-18183" "01-SRNP-4906" "03-SRNP-12300.1" "04-SRNP-2493" "08-SRNP-102882" "08-SRNP-41960" "DHJPAR0004726" "DHJPAR0017537" "DHJPAR0048389" "DHJPAR0049127" "DHJPAR0051784")

# Dossier iRods de base
base_dir="/lbbeZone/home/charlat/horizon/data/raw_data/2020/"

# Dossier local de destination
destination_dir="/beegfs/data/soukkal/Thesis/Horizon/Reads/"

# Parcours des dossiers et des noms de spécimens
for dossier in "${dossiers[@]}"; do
    for specimen in "${specimens[@]}"; do
        # Chemin complet du fichier 1
        fichier_1="${base_dir}${dossier}/${specimen}_1.fastq.gz"
        
        # Chemin complet du fichier 2
        fichier_2="${base_dir}${dossier}/${specimen}_2.fastq.gz"

        echo "Récupération de : $fichier_1"
        echo "Récupération de : $fichier_2"
            
        # Création du dossier de destination s'il n'existe pas encore
        destination_subdir="${destination_dir}${dossier}/"
        mkdir -p "$destination_subdir"
            
        # Utilisation de iget pour récupérer les fichiers dans le dossier local
        iget "$fichier_1" "$destination_subdir"
        iget "$fichier_2" "$destination_subdir"
    done
done
