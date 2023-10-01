#!/bin/bash

# Spécifiez le chemin du dossier contenant vos fichiers
dossier="/beegfs/project/horizon/data/mapping/BUSCO_depth"

# Naviguer vers le dossier
cd "$dossier"

# Boucle sur les fichiers dans le dossier
for fichier in *; do
    # Vérifier si le fichier se termine par "_1.per-base.bed"
    if [[ "$fichier" == *_1.per-base.bed ]]; then
        # Extraire le nom du fichier sans "_1"
        nouveau_nom="${fichier%_1.per-base.bed}.per-base.bed"
        # Renommer le fichier
        mv "$fichier" "$nouveau_nom"
        echo "Renommé: $fichier -> $nouveau_nom"
    fi
done
