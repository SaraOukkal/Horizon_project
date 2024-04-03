import os
import pandas as pd

# Dossier contenant les fichiers
input_folder = '/beegfs/project/horizon/data/stats/quast/specimens/Quast_sum/'

# Initialisation du DataFrame
df_result = pd.DataFrame()

# Liste pour stocker les noms de colonnes uniques
columns_set = set()

# Parcours des fichiers dans le dossier
for file_name in os.listdir(input_folder):
    if file_name.startswith('report_') and file_name.endswith('.tsv'):
        # Chemin complet du fichier
        file_path = os.path.join(input_folder, file_name)

        # Récupération du specimen_id à partir du nom du fichier
        specimen_id = file_name.split('_')[1].split('.')[0]

        print(f'Traitement du spécimen : {specimen_id}')

        # Lecture du fichier TSV avec pandas
        df = pd.read_csv(file_path, sep='\t', index_col=0, header=None, names=[specimen_id])

        # Transposition du DataFrame
        df_transposed = df.transpose()

        # Ajout du specimen_id comme colonne
        df_transposed['specimen_id'] = specimen_id

        # Ajout du DataFrame résultant au DataFrame global
        df_result = pd.concat([df_result, df_transposed], ignore_index=True)

        # Ajout des noms de colonnes dans l'ensemble
        columns_set.update(df.index.tolist())

# Sauvegarde du DataFrame résultant au format CSV
output_file = '/beegfs/project/horizon/data/stats/quast/specimens/Quast_summary_specimens.txt'
df_result.to_csv(output_file, sep='\t', index=False, columns=['specimen_id'] + sorted(columns_set))

print('Traitement terminé.')

