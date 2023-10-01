import os
from irods.session import iRODSSession

# Informations de connexion iRODS
irods_host = 'lbbe-irods-local.univ-lyon1.fr'
irods_port = 1247
irods_user = 'soukkal'
irods_zone = 'lbbeZone'
irods_password = 'Buduuh190398'

# Chemin du dossier iRODS
irods_path = '/lbbeZone/home/charlat/horizon/data/raw_data/2020/HN00131934'

# Chemin du fichier de sortie iRODS
irods_output_file = '/lbbeZone/home/charlat/horizon/data/raw_data/2020/HN00131934/HN00131934_summary.txt'

# Initialisation de la session iRODS
with iRODSSession(host=irods_host, port=irods_port, user=irods_user,
                  password=irods_password, zone=irods_zone) as session:
    # Liste tous les fichiers se terminant par "fastq.gz"
    files = session.collections.get(irods_path).data_objects
    with session.data_objects.open(irods_output_file, 'w') as output_file:
        for file in files:
            if file.name.endswith('.fastq.gz'):
                output_file.write(f"Nom du fichier: {file.name}\n")
                # Lire les trois premières lignes du fichier
                data = file.read(3)
                output_file.write(data.decode('utf-8'))
                output_file.write("\n------------------------------\n")

print("Les noms des fichiers et leurs trois premières lignes ont été écrits dans le fichier de sortie iRODS.")
