#!/bin/bash

#Liste des dossiers à traiter
dossiers=("HN00131934" "HN00131995" "HN00132113" "HN00136330" "HN00136333" "HN00136653" "HN00156681")

#Parcourir la liste des dossiers
for d in "${dossiers[@]}"; do
  dossier="/lbbeZone/home/charlat/horizon/data/raw_data/2020/$d"

  #Fichier de sortie avec le nom du dossier
  output="/lbbeZone/home/soukkal/$d.txt"  ##à modifier si tu veux rediriger ailleurs 

  #Parcourir les fichiers .gz dans le dossier source
  for fichier in "$dossier"/*.gz; do
    #Extraire le nom du fichier (sans l'extension .fastq.gz)
    nom_fichier=$(basename "$fichier" .fastq.gz)
    #Écrire le nom du fichier dans le fichier de sortie
    echo "$nom_fichier" >> "$output"

    # Utiliser zcat pour extraire les 2 premières lignes et les ajouter au fichier de sortie
    zcat "$fichier" | head -n 2 >> "$output"
  done
done

