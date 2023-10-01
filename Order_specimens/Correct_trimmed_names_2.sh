
#!/bin/bash

# Définir le chemin vers le répertoire contenant vos fichiers .fq.gz
repertoire_source="/beegfs/project/horizon/data/trimmed_reads/"

# Parcourir tous les fichiers .fq.gz dans le répertoire source
for fichier in "$repertoire_source"/*.fq.gz; do
  if [ -f "$fichier" ]; then
    nom_fichier=$(basename "$fichier")
    
    # Utiliser la commande sed pour renommer les fichiers
    nouveau_nom=$(echo "$nom_fichier" | sed -E 's/^(.*?)_(.*?)_(.*?)_(.*?)$/\1_\2_\4/')
    
    # Renommer le fichier s'il a été modifié
    if [ "$nom_fichier" != "$nouveau_nom" ]; then
      mv "$fichier" "$repertoire_source/$nouveau_nom"
      echo "Renommage de $nom_fichier en $nouveau_nom"
    fi
  fi
done

