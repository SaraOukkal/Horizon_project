#!/bin/bash

# Spécifiez le chemin du dossier contenant vos fichiers
dossier="/beegfs/project/horizon/data/mapping/bam"

# Naviguer vers le dossier
cd "$dossier"

# Boucle sur les fichiers dans le dossier
for fichier in *; do
    # Vérifier si le fichier se termine par "_1.bam.gz"
    if [[ "$fichier" == *_1.bam.gz ]]; then
        # Extraire le nom du fichier sans "_1"
        nouveau_nom="${fichier%_1.bam.gz}.bam.gz"
        # Renommer le fichier
        mv "$fichier" "$nouveau_nom"
        echo "Renommé: $fichier -> $nouveau_nom"
    fi
done
