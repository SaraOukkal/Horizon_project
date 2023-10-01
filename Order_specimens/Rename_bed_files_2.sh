#!/bin/bash

# Spécifiez le chemin du dossier contenant vos fichiers
dossier="/beegfs/project/horizon/data/mapping/bed"

# Naviguer vers le dossier
cd "$dossier"

# Boucle sur les fichiers dans le dossier
for fichier in *; do
    # Vérifier si le fichier se termine par "_1.per-base.bed.gz"
    if [[ "$fichier" == *_1.per-base.bed.gz ]]; then
        # Extraire le nom du fichier sans "_1"
        nouveau_nom="${fichier%_1.per-base.bed.gz}.per-base.bed.gz"
        # Renommer le fichier
        mv "$fichier" "$nouveau_nom"
        echo "Renommé: $fichier -> $nouveau_nom"
    fi
done
