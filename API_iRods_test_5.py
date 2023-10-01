from irods.session import iRODSSession

# Informations de connexion iRODS
irods_host = 'lbbe-irods-local.univ-lyon1.fr'
irods_port = 1247
irods_user = 'soukkal'
irods_zone = 'lbbeZone'
irods_password = 'Buduuh190398'
irods_path = '/lbbeZone/home/soukkal/test.txt'

try:
    # Crée une session iRODS
    with iRODSSession(host=irods_host, port=irods_port, user=irods_user,
                      password=irods_password, zone=irods_zone) as session:
        # Ouvre le fichier en lecture
        with session.data_objects.get(irods_path).open('r') as file:
            # Lit et affiche le contenu du fichier
            content = file.read()
            print("yay")

except Exception as e:
    print(f"Erreur lors de la lecture du fichier : {str(e)}")

