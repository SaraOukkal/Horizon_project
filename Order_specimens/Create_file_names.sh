#!/bin/bash

input_file="Species_specimen_correspondance.txt"

# Ouvrir le fichier de sortie en mode écriture
output_file="Species_specimen_file_names.txt"
> "$output_file"

# Lire le fichier d'entrée ligne par ligne
while IFS= read -r ligne; do
    # Diviser la ligne en deux parties en utilisant l'espace comme séparateur
    read -r nom_espece identifiant_specimen <<< "$ligne"
    
    # Extraire le nom d'espèce sans le suffixe
    nom_espece_sans_suffixe="${nom_espece%_sp*}"
    
    # Écrire le résultat dans le fichier de sortie
    echo "$nom_espece $nom_espece_sans_suffixe:$identifiant_specimen" >> "$output_file"
done < "$input_file"
