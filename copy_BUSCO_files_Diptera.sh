#!/bin/bash
#SBATCH --job-name=copy-job2
#SBATCH --output=copy-job2.out
#SBATCH --error=copy-job2.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00  # ajustez selon vos besoins
#SBATCH --mem=4G       # ajustez selon vos besoins

# Charger les modules ou les variables d'environnement nécessaires
# module load ...

# Chemin vers le fichier contenant la liste des dossiers à copier
LIST_FILE="/beegfs/data/soukkal/Thesis/Tachinid_Project/Species_list_tachinid_horizon.txt"

# Dossier source
SOURCE_DIR="/beegfs/data/soukkal/Thesis/Tachinid_Project/Stats/BUSCO/"

# Dossier de destination
DEST_DIR="/beegfs/project/horizon/data/stats/busco/BUSCO_Diptera/"

# Lire la liste des dossiers depuis le fichier
while IFS= read -r folder; do
    # Utiliser rsync pour copier le dossier
    rsync -av --progress "$SOURCE_DIR$folder" "$DEST_DIR" >> rsync2.log
done < "$LIST_FILE"
