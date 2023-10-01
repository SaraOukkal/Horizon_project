#!/bin/bash

# Fichier d'entrée contenant les informations sur les espèces et les spécimens
species_file="/beegfs/data/soukkal/Thesis/Horizon/Order_specimens/Species_3_specimens_regrouped_2.txt"

# Fichiers contenant les lignes à extraire
trimmed_reads_file="/beegfs/data/soukkal/Thesis/Horizon/Order_specimens/First_line_trimmed_reads.txt"
raw_reads_file="/beegfs/data/soukkal/Thesis/Horizon/Order_specimens/First_line_raw_reads.txt"

# Parcourir le fichier "Species_specimens.txt" ligne par ligne
while IFS=' ' read -r species specimen1 specimen2 rest; do
    # Créer le nom du fichier de sortie
    output_file="/beegfs/data/soukkal/Thesis/Horizon/Order_specimens/Comparisons/${species}.txt"

    # Rechercher et extraire les lignes correspondantes dans "First_line_trimmed_reads.txt"
    if grep -q "${species}_sp1" -A 1 "$trimmed_reads_file"; then
        grep "${species}_sp1" -A 1 "$trimmed_reads_file" >> "$output_file"
    else
        echo "Aucune correspondance trouvée pour ${species}_sp1 dans $trimmed_reads_file" >&2
    fi

    if grep -q "${species}_sp2" -A 1 "$trimmed_reads_file"; then
        grep "${species}_sp2" -A 1 "$trimmed_reads_file" >> "$output_file"
    else
        echo "Aucune correspondance trouvée pour ${species}_sp2 dans $trimmed_reads_file" >&2
    fi

    # Rechercher et extraire les lignes correspondantes dans "First_line_raw_reads.txt"
    if grep -q "${specimen1}_1" -A 1 "$raw_reads_file"; then
        grep "${specimen1}_1" -A 1 "$raw_reads_file" >> "$output_file"
    else
        echo "Aucune correspondance trouvée pour $specimen1 dans $raw_reads_file" >&2
    fi

    if grep -q "${specimen2}_1" -A 1 "$raw_reads_file"; then
        grep "${specimen2}_1" -A 1 "$raw_reads_file" >> "$output_file"
    else
        echo "Aucune correspondance trouvée pour $specimen2 dans $raw_reads_file" >&2
    fi
    # Vérifier si une quatrième colonne (spécimen 3) existe
    if [ -n "$rest" ]; then
        if grep -q "${rest}_1" -A 1 "$raw_reads_file"; then
            grep "${rest}_1" -A 1 "$raw_reads_file" >> "$output_file"
        else
            echo "Aucune correspondance trouvée pour $rest dans $raw_reads_file" >&2
        fi
    fi

done < "$species_file"
