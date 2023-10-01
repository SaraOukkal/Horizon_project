#!/bin/bash

# Définir le chemin vers le répertoire contenant vos fichiers .fq.gz
repertoire_source="/beegfs/project/horizon/data/trimmed_reads/"

# Définir le chemin vers le fichier de correspondance
fichier_correspondance="Species_specimen_file_names.txt"

# Vérifier l'existence du fichier de correspondance
if [ ! -f "$fichier_correspondance" ]; then
  echo "Le fichier de correspondance n'existe pas : $fichier_correspondance"
  exit 1
fi

# Lire le fichier de correspondance dans un tableau associatif
declare -A correspondance

while IFS= read -r ligne; do
  clef=$(echo "$ligne" | cut -d' ' -f1)
  valeur=$(echo "$ligne" | cut -d' ' -f2)
  correspondance["$clef"]=$valeur
done < "$fichier_correspondance"

# Parcourir tous les fichiers .fq.gz dans le répertoire source
for fichier in "$repertoire_source"/*.fq.gz; do
  nom_fichier=$(basename "$fichier")
  
  # Extraire la partie du nom de fichier avant "_1.fq.gz" ou "_2.fq.gz"
  nom_espece=$(echo "$nom_fichier" | sed -E 's/(.*)_1\.fq\.gz/\1/')
  nom_espece=$(echo "$nom_espece" | sed -E 's/(.*)_2\.fq\.gz/\1/')
  
  # Vérifier si la partie extraite existe dans le tableau de correspondance
  if [[ -n ${correspondance[$nom_espece]} ]]; then
    nouveau_nom="${correspondance[$nom_espece]}_$nom_fichier"
    mv "$fichier" "$repertoire_source/$nouveau_nom"
    echo "Renommage de $nom_fichier en $nouveau_nom"
  else
    echo "Aucune correspondance trouvée pour $nom_fichier. Le fichier n'a pas été renommé."
  fi
done
