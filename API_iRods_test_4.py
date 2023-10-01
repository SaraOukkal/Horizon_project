from irods.session import iRODSSession

# Informations de connexion iRODS
irods_host = 'lbbe-irods-local.univ-lyon1.fr'
irods_port = 1247
irods_user = 'soukkal'
irods_zone = 'lbbeZone'
irods_password = 'Buduuh190398'
irods_path = '/lbbeZone/home/charlat/horizon/data/raw_data/2020/HN00131934'

try:
    # Tente de créer une session iRODS
    with iRODSSession(host=irods_host, port=irods_port, user=irods_user,
                      password=irods_password, zone=irods_zone) as session:
        # Liste les fichiers dans le dossier iRODS
        files = session.collections.get(irods_path).data_objects

        # Parcourt les fichiers et lit les trois premières lignes
        for file in files:
            try:
                with file.open('r') as f:
                    for i, line in enumerate(f):
                        if i < 3:
                            print(line.strip())  # Affiche les trois premières lignes
                        else:
                            break
            except Exception as e:
                print(f"Erreur lors de la lecture du fichier {file.name}: {str(e)}")

except Exception as e:
    print(f"La connexion iRODS a échoué : {str(e)}")
