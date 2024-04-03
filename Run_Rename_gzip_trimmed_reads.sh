#!/bin/bash
#SBATCH -J Rename_and_Compress   # Nom de la tâche
#SBATCH -o /beegfs/data/soukkal/Thesis/Horizon/Logs/Rename_and_Compress.out  # Nom du fichier de sortie
#SBATCH -e /beegfs/data/soukkal/Thesis/Horizon/Logs/Rename_and_Compress.err  # Nom du fichier d'erreur
#SBATCH --cpus-per-task=1   # Nombre de cœurs CPU par tâche
#SBATCH --mem=2G             # Mémoire par tâche
#SBATCH --time=24:00:00      # Temps maximal d'exécution (hh:mm:ss)

# Exécutez le script Bash
bash /beegfs/data/soukkal/Thesis/Horizon/Scripts/Rename_gzip_trimmed_reads.sh

