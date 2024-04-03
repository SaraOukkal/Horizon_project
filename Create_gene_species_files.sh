#!/bin/bash

#Input directory : 
in_dir='/beegfs/project/horizon/data/stats/busco/specimens/'
#Output directory : 
out_dir='/beegfs/project/horizon/data/phylogeny/'


# Spécifiez le chemin du fichier de tableau à deux colonnes
mkdir -p "$out_dir"busco_nt
table_file="/beegfs/data/soukkal/Thesis/Horizon/Species_all_specimens.txt"
Genes_list=`cat "$out_dir"final_busco_ids.txt`

# Parcourez le fichier de tableau à deux colonnes
while IFS=$'\t' read -r species specimen; do
    for Gene in $Genes_list
    do
        if test -f "$in_dir$specimen/run_insecta_odb10/busco_sequences/single_copy_busco_sequences/$Gene.fna"
        then
            cp "$in_dir$specimen/run_insecta_odb10/busco_sequences/single_copy_busco_sequences/$Gene.fna" "$out_dir"busco_nt/"$species.$specimen.$Gene.fna"
            sed -i "/>/c\>$species:$specimen" "$out_dir"busco_nt/"$species.$specimen.$Gene.fna"
        fi
    done
done < "$table_file"

#Regrouper les fichier pour avoir un fichier par gène BUSCO (mettre dans un sous dossier)
mkdir -p "$out_dir"busco_nt/Genes_files/

while IFS=$'\t' read -r species specimen; do
    for Gene in $Genes_list
        do
        if test -f ""$out_dir"busco_nt/$species.$specimen.$Gene.fna"
            then
            cat "$out_dir"busco_nt/$species.$specimen.$Gene.fna >> "$out_dir"busco_nt/Genes_files/$Gene.fasta
            fi
        done
done < "$table_file"
