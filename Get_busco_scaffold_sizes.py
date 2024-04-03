import os

# Chemin vers le dossier contenant les fichiers de scaffolds
folder_path = "/beegfs/project/horizon/data/stats/busco/species_busco_pos/"

# Chemin vers le fichier de sortie
output_file = "/beegfs/project/horizon/data/stats/scaffold_sizes_summary.txt"

# Dictionnaire pour stocker la somme des tailles de scaffolds par spécimen
scaffold_sizes = {}

# Parcourir les fichiers du dossier
for filename in os.listdir(folder_path):
    # Vérifier si le fichier est un fichier BED et ne contient pas "_modified"
    if filename.endswith(".bed") and "_modified" not in filename:
        print(filename)
        # Extraire le specimen_id du nom du fichier
        specimen_id = filename.split(":")[-1].split(".")[0]

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
            scaffold_sizes[specimen_id] = total_size

# Écrire le résultat dans un fichier de sortie
with open(output_file, "w") as output:
    output.write("specimen_id\ttotal_scaffold_size\n")
    for specimen_id, total_size in scaffold_sizes.items():
        output.write(f"{specimen_id}\t{total_size}\n")

print(f"Résultats écrits dans {output_file}")

