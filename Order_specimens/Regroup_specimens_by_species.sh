#!/bin/bash

# Nom du fichier d'entrée
input_file="Species_3_specimens.txt"

# Nom du fichier de sortie
output_file="Species_3_specimens_regrouped.txt"

# Déclaration du tableau associatif
declare -A species_specimens

# Lire l'entrée ligne par ligne
while read line; do
  # Séparer la ligne en deux colonnes en utilisant la tabulation comme délimiteur
  IFS=$'\t' read -r -a fields <<< "$line"
  
  # La première colonne contient le nom d'espèce, et la deuxième contient l'identifiant du spécimen
  species="${fields[0]}"
  specimen="${fields[1]}"
  
  # Ajouter l'identifiant du spécimen à un tableau associatif basé sur le nom d'espèce
  species_specimens["$species"]="${species_specimens["$species"]} $specimen"
done < "$input_file"

# Afficher le tableau résultant dans le fichier de sortie
for species in "${!species_specimens[@]}"; do
  echo -e "$species\t${species_specimens["$species"]}" >> "$output_file"
done
