#!/bin/bash

#Fichier contenant les valeurs espèce - sp1/sp2
values_file="/beegfs/project/horizon/data/mapping/BUSCO_depth/BUSCO_mean_depth.txt"

#Fichier contenant la correspondance espèce_sp1/sp2 - identifiant de spécimen
correspondence_file="/beegfs/data/soukkal/Thesis/Horizon/Order_specimens/Species_specimen_correspondance.txt"

#Fichier de sortie résultant
output_file="/beegfs/project/horizon/data/mapping/BUSCO_depth/Depth_per_specimen.txt"

#Création d'un tableau associatif pour stocker les valeurs espèce - sp1/sp2
declare -A species_values

# Lire le fichier des valeurs et stocker les données dans le tableau associatif
while IFS=' ' read -r species value1 value2; do
    species_values["${species}_sp1"]=$value1
    species_values["${species}_sp2"]=$value2
done < "$values_file"

# Parcourir le fichier de correspondance et écrire le tableau résultant
while IFS=' ' read -r species_specimen_id specimen_id; do
    # Extraire l'espèce à partir du nom espèce_sp1/sp2 
    # Le sed ici recherche le motif _sp1 ou _sp2 et avec le $ cela signifique qu'il cherche ce motif en fin de variable 
    species=$(echo "$species_specimen_id" | sed 's/_sp[12]$//')

    # Obtenir la valeur associée à l'espèce et à sp1/sp2 du tableau associatif
    value="${species_values["$species_specimen_id"]}"

    # Écrire l'espèce, l'identifiant du spécimen et la valeur associée dans le fichier de sortie
    echo "$species $specimen_id $value" >> "$output_file"
done < "$correspondence_file"
