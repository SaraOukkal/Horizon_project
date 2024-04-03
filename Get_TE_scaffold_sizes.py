import os

# Chemin vers le dossier contenant les fichiers BED des positions des éléments transposables
folder_path = "/beegfs/project/horizon/data/TE/TE_positions/"

# Chemin vers le fichier de sortie
output_file = "/beegfs/project/horizon/data/TE/TE_scaffold_sizes_summary.txt"

# Dictionnaire pour stocker la somme des tailles de scaffolds par espèce
scaffold_sizes = {}

# Parcourir les fichiers du dossier
for filename in os.listdir(folder_path):
    # Vérifier si le fichier est un fichier BED
    if filename.endswith("_no_duplicates.bed"):
        print(filename)
        # Extraire le nom d'espèce du nom du fichier
        species_name = filename.split("_TE_no_duplicates.bed")[0]

        # Lire le fichier BED et calculer la somme des tailles de scaffolds
        with open(os.path.join(folder_path, filename), "r") as bed_file:
            # Créer un ensemble pour stocker les tailles uniques des scaffolds
            unique_sizes = set()

            # Parcourir chaque ligne du fichier BED
            for line in bed_file:
                # Séparer la ligne en colonnes
                columns = line.strip().split()

                # Vérifier si la première colonne contient un ":"
                if ":" in columns[0]:
                    # Si oui, extraire l'information après "size" et avant ":"
                    scaffold_info = columns[0].split("size")[1].split(":")[0]

                    # Ajouter la taille à l'ensemble des tailles uniques
                    unique_sizes.add(int(scaffold_info))
                else:
                    # Si la première colonne ne contient pas de ":", récupérer simplement la taille après "size"
                    size = int(columns[0].split("size")[1])
                    unique_sizes.add(size)

            # Calculer la somme des tailles uniques des scaffolds
            total_size = sum(unique_sizes)

            # Ajouter la somme au dictionnaire
            scaffold_sizes[species_name] = total_size

# Écrire le résultat dans un fichier de sortie
with open(output_file, "w") as output:
    # En-tête du fichier de sortie
    output.write("Species\tTotal Scaffold Size\n")

    # Parcourir le dictionnaire et écrire les résultats dans le fichier de sortie
    for species, total_size in scaffold_sizes.items():
        output.write(f"{species}\t{total_size}\n")

