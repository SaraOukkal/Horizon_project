from irods.session import iRODSSession

# Informations de connexion iRODS
irods_host = 'lbbe-irods-local.univ-lyon1.fr'
irods_port = 1247
irods_user = 'soukkal'
irods_zone = 'lbbeZone'
irods_password = 'Buduuh190398'

try:
    # Tente de créer une session iRODS
    with iRODSSession(host=irods_host, port=irods_port, user=irods_user,
                      password=irods_password, zone=irods_zone):
        print("La connexion iRODS a réussi.")
except Exception as e:
    print(f"La connexion iRODS a échoué : {str(e)}")
