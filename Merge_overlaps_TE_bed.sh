#!/bin/bash

# Dossier d'entrée contenant les fichiers BED générés
input_folder='/beegfs/project/horizon/data/TE/TE_positions/'

# Boucle sur tous les fichiers BED dans le dossier d'entrée
for bed_file in ${input_folder}*_TE.bed; do
    # Extraire le nom de l'espèce du nom du fichier
    species_name=$(basename "${bed_file}" | sed 's/_TE\.bed$//')
    
    # Chemin de sortie pour le fichier sans doublons et chevauchements
    output_bed="${input_folder}${species_name}_TE_no_duplicates.bed"
    
    # Correction des positions start et end avec vérification du format
    awk -F'\t' '{if($2 > $3) {t=$2; $2=$3; $3=t} print}' "${bed_file}" | tr ' ' '\t' > "${output_bed}_temp1"
    
    # Trier le fichier BED
    bedtools sort -i "${output_bed}_temp1" > "${output_bed}_temp2"
    
    # Fusionner les chevauchements avec un fichier temporaire
    bedtools merge -i "${output_bed}_temp2" > "${output_bed}_temp3"
    
    # Déplacer le fichier temporaire vers le fichier de sortie final
    mv "${output_bed}_temp3" "${output_bed}"
    
    # Nettoyer les fichiers temporaires intermédiaires
    rm "${output_bed}_temp1" "${output_bed}_temp2"
    
    echo "Traitement terminé pour ${species_name}."
done

