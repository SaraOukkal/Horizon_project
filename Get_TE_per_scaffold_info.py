import os

# Chemin vers le dossier contenant les fichiers BED des positions des éléments transposables
folder_path = "/beegfs/project/horizon/data/TE/TE_positions/"

# Chemin vers le dossier où seront enregistrés les fichiers de sortie
output_folder = "/beegfs/project/horizon/data/TE/TE_positions/"

# Dictionnaire pour stocker les informations par espèce
species_info = {}

# Parcourir les fichiers du dossier
for filename in os.listdir(folder_path):
    # Vérifier si le fichier est un fichier BED
    if filename.endswith("_no_duplicates.bed"):
        print(filename)
        # Extraire le nom d'espèce du nom du fichier
        species_name = filename.split("_TE_no_duplicates.bed")[0]

        # Dictionnaire pour stocker les informations par scaffold
        scaffold_info_dict = {}

        # Lire le fichier BED et collecter les informations pour chaque scaffold
        with open(os.path.join(folder_path, filename), "r") as bed_file:
            for line in bed_file:
                columns = line.strip().split()

                # Récupérer les informations nécessaires
                scaffold_info = columns[0].split("size")
                scaffold_name = columns[0]

                # Vérifier si la première colonne contient un ":"
                if ":" in scaffold_info[1]:
                    # Si oui, extraire l'information après "size" et avant ":"
                    scaffold_size = int(scaffold_info[1].split(":")[0])
                else:
                    # Si la première colonne ne contient pas de ":", récupérer simplement la taille après "size"
                    scaffold_size = int(scaffold_info[1])

                element_start = int(columns[1])
                element_end = int(columns[2])

                # Calculer la taille de l'élément transposable sur ce scaffold
                element_size = element_end - element_start

                # Vérifier si le scaffold existe déjà dans le dictionnaire
                if scaffold_name in scaffold_info_dict:
                    # Ajouter la taille de l'élément transposable à la taille existante
                    scaffold_info_dict[scaffold_name]["total_size"] += element_size
                    # Incrémenter le compteur d'éléments transposables
                    scaffold_info_dict[scaffold_name]["te_count"] += 1
                else:
                    # Ajouter le scaffold au dictionnaire avec la première taille
                    scaffold_info_dict[scaffold_name] = {"total_size": element_size, "te_count": 1}

        # Liste pour stocker les informations par scaffold après traitement
        scaffold_info_list = []

        # Calculer les proportions et ajouter les informations à la liste
        for scaffold_name, info in scaffold_info_dict.items():
            proportion = info["total_size"] / scaffold_size
            scaffold_info_list.append((scaffold_name, proportion, info["te_count"]))

        # Ajouter la liste d'informations par espèce au dictionnaire
        species_info[species_name] = scaffold_info_list

# Écrire les résultats dans des fichiers de sortie
for species, scaffold_info_list in species_info.items():
    # Construire le chemin du fichier de sortie
    output_file_path = os.path.join(output_folder, f"{species}_scaffolds_TE_proportions.tsv")

    # Écrire les informations dans le fichier de sortie
    with open(output_file_path, "w") as output_file:
        # En-tête du fichier de sortie
        output_file.write("Scaffold\tProportion\tTE Count\n")

        # Écrire les informations par scaffold dans le fichier de sortie
        for scaffold_info in scaffold_info_list:
            output_file.write(f"{scaffold_info[0]}\t{scaffold_info[1]:.4f}\t{scaffold_info[2]}\n")

