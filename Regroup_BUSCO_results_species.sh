#!/bin/bash

#Ouvrir une liste de noms d’espèces :
species_list=`cat /beegfs/data/soukkal/Thesis/Horizon/species_list_236.txt`

#On se place dans le dossier qui contient les résultats
cd /beegfs/project/horizon/data/stats/busco/species/

echo "Species C S D F M Total" > Species_BUSCO_results_summary.txt

for i in $species_list 
do
    #Ecrire le nom de l'espece
    echo $i > $i/tmp.txt
    #Recup la ligne avec les pourcentages BUSCO, retirer le tab de debut de ligne et remplacer les virgules par des espaces
    grep "C:" $i/short_summary.specific.insecta_odb10.*.txt | sed 's/\t//g' | sed 's/://g' | sed 's/[][]/,/g' | sed 's/,//g'| sed 's/[SDMFn]/ /g'| sed 's/C//g' >> $i/tmp.txt
    #Regrouper en une ligne le nom de l'espece et les resultats et separer par un espace :
    paste -sd ' '  $i/tmp.txt >> Species_BUSCO_results_summary.txt
    rm $i/tmp.txt
done
