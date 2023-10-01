#!/bin/bash

# Spécifiez le nom du fichier d'entrée et de sortie
fichier_entree=$1
fichier_sortie=$2

# Initialisez une variable pour stocker les lignes extraites
lignes_extraites=""

# Parcourez le fichier en lisant les lignes
while read -r ligne1 && read -r ligne2 && read -r _; do
  lignes_extraites+="$ligne1\n$ligne2\n"
done < "$fichier_entree"

# Écrivez les lignes extraites dans le fichier de sortie
echo -e "$lignes_extraites" >> "$fichier_sortie"

echo "Les lignes extraites ont été écrites dans '$fichier_sortie'."
