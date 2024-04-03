import os
import glob

# Dossier d'entrée contenant les résultats MMseqs2
input_folder = '/beegfs/project/horizon/data/TE/'

# Dossier de sortie pour les fichiers BED
output_folder = '/beegfs/project/horizon/data/TE/TE_positions/'

# Liste des fichiers result_mmseqs2.m8 à traiter
files_to_process = glob.glob(os.path.join(input_folder, '*', 'result_mmseqs2.m8'))

# Fonction pour filtrer les lignes et générer le fichier BED
def process_file(input_file):
    with open(input_file, 'r') as infile:
        species_name = input_file.split('/')[-2]  # Récupérer le nom de l'espèce depuis le chemin
        output_file_path = os.path.join(output_folder, f'{species_name}_TE.bed')
        
        with open(output_file_path, 'w') as outfile:
            for line in infile:
                columns = line.split('\t')
                qlen = int(columns[1])
                tcov = float(columns[13])
                
                # Filtrer les lignes avec une couverture minimale de 80%
                if tcov >= 80:
                    scaffold = columns[0]
                    qstart = int(columns[8])
                    qend = int(columns[9])
                    outfile.write(f'{scaffold}\t{qstart-1}\t{qend}\n')  # Conversion en format BED (0-based start)

# Traitement de chaque fichier result_mmseqs2.m8
for file_path in files_to_process:
    process_file(file_path)

