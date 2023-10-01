#!/bin/bash

input_file="Species_specimen_correspondance.txt"
input_dir="/beegfs/project/horizon/data/mapping/bed/"

# Lire le fichier "Species_specimen_file_names.txt" ligne par ligne
while IFS= read -r ligne; do
    # Diviser la ligne en deux parties en utilisant l'espace comme séparateur
    read -r ancien_nom nouveau_nom <<< "$ligne"
    
    # Construire les chemins complets vers les fichiers
    ancien_nom_complet="${input_dir}${ancien_nom}.per-base.bed.gz"
    nouveau_nom_complet="${input_dir}${nouveau_nom}.per-base.bed.gz"
    
    # Vérifier si le fichier ancien_nom_complet existe
    if [ -f "$ancien_nom_complet" ]; then
        # Renommer le fichier avec le nouveau nom
        mv "$ancien_nom_complet" "$nouveau_nom_complet"
        echo "Renommage de '$ancien_nom_complet' en '$nouveau_nom_complet'"
    else
        echo "Le fichier '$ancien_nom_complet' n'existe pas et n'a pas été renommé."
    fi
done < "Species_specimen_file_names.txt"
