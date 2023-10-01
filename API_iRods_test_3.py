##Vérifier la connectivité réseau : 
import socket

# Informations de connexion iRODS
irods_host = 'lbbe-irods-local.univ-lyon1.fr'  # Remplacez par le nom d'hôte ou l'adresse IP du serveur iRODS
irods_port = 1247  # Remplacez par le numéro de port iRODS

# Fonction pour vérifier la connectivité réseau
def check_irods_connectivity(host, port):
    try:
        # Crée une socket et tente de se connecter au serveur iRODS
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.settimeout(5)  # Réglage d'un délai d'attente pour la connexion
            s.connect((host, port))
        return True
    except (socket.timeout, ConnectionRefusedError, OSError):
        return False

# Vérifie la connectivité iRODS
if check_irods_connectivity(irods_host, irods_port):
    print(f"La connectivité iRODS avec {irods_host}:{irods_port} fonctionne correctement.")
else:
    print(f"La connectivité iRODS avec {irods_host}:{irods_port} a échoué.")


