#!/bin/bash

# Répertoire contenant les fichiers d'entrée
input_dir="/beegfs/data/soukkal/Thesis/Horizon/Order_specimens/Comparisons"

# Nom du fichier de sortie
output_file="/beegfs/data/soukkal/Thesis/Horizon/Order_specimens/Species_specimen_correspondance.txt"

# Fonction de traitement pour un fichier
process_file() {
    local input_file="$1"
    local output_file="$2"

    # Créer un tableau associatif pour stocker les valeurs de la deuxième colonne
    declare -A column2_values

    # Lire le fichier d'entrée ligne par ligne
    while IFS=$'\t' read -r column1 column2; do
        if [ -n "$column2" ]; then
            # Vérifier si la valeur de la deuxième colonne est déjà dans le tableau
            if [ -z "${column2_values[$column2]}" ]; then
                column2_values["$column2"]=$column1
            else
                # Si la valeur de la deuxième colonne est déjà présente, écrire dans le fichier de sortie
                echo "${column1} ${column2_values[$column2]}" >> "$output_file"
            fi
        fi
    done < "$input_file"
}

# Parcourir tous les fichiers du répertoire dont le nom se termine par _regrouped.txt
for input_file in "$input_dir"/*_regrouped.txt; do
    if [ -f "$input_file" ]; then
        # Exécuter le traitement du fichier
        process_file "$input_file" "$output_file"
        echo "Traitement terminé pour '$input_file'."
    fi
done

echo "Comparaison de tous les fichiers terminée. Résultats écrits dans '$output_file'."
