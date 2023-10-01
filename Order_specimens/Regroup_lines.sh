
#!/bin/bash

# Répertoire contenant les fichiers d'entrée
input_dir="/beegfs/data/soukkal/Thesis/Horizon/Order_specimens/Comparisons"

# Parcourir tous les fichiers du répertoire d'entrée
for input_file in "$input_dir"/*; do
    if [ -f "$input_file" ]; then  # Vérifier si c'est un fichier
        # Nom du fichier de sortie (même nom que le fichier d'entrée)
        output_file="${input_file%.*}_regrouped.txt"

        # Supprimer les lignes contenant uniquement des tirets
        sed -i '/^--$/d' "$input_file"

        # Lire le fichier d'entrée et regrouper chaque paire de lignes consécutives
        awk 'NR%2==0 {print p "\t" $0} {p=$0}' "$input_file" > "$output_file"

        echo "Traitement terminé pour '$input_file'. Résultat écrit dans '$output_file'."
    fi
done
