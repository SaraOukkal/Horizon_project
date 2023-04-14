#!/bin/bash

#Ouvrir une liste de noms d’espèces : 
species_list=`cat /beegfs/data/soukkal/Thesis/Horizon/species_list_236.txt`

#On se place dans le dossier qui contient les résultats 
cd /beegfs/project/horizon/data/stats/quast/species/Quast_sum/

#On crée le fichier final et on y insère un header : 
echo species Total_Length GC N50 > ../Species_genome_stats.txt

#On crée une boucle qui va parcourir la liste de noms et appliquer les commandes précédentes à chaque fichier : 
for i in $species_list
do
	echo $i > tmp_file.txt
	grep "Total length\|GC\|N50" report_$i.tsv | tail -n 3 | cut -f2 |paste -sd ' ' >> tmp_file.txt
	paste -sd ' '  tmp_file.txt >> ../Species_genome_stats.txt
done

rm tmp_file.txt

