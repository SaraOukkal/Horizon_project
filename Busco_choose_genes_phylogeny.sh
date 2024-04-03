#Input directory : 
in_dir='/beegfs/project/horizon/data/stats/busco/specimens/'
#Output directory : 
out_dir='/beegfs/project/horizon/data/phylogeny/'

#Récup la liste de tous les gènes BUSCO complets pour chacune des espèces
for file in $in_dir*/run_insecta_odb10/full_table.tsv
    do
    grep -v "^#" ${file} | awk '$2=="Complete" {print $1}' >> "$out_dir"complete_busco_ids.txt;
    done

#Retirer ceux qui sont présents chez moins de 75/80 espèces :
##Compter les occurences de chaque gène : 
sort "$out_dir"complete_busco_ids.txt |uniq -c > "$out_dir"complete_busco_ids_with_counts.txt
##Retirer les espaces des débuts de ligne que génère uniq -c
sed 's/^[ \t]*//' "$out_dir"complete_busco_ids_with_counts.txt > "$out_dir"complete_busco_ids_with_counts_without_spaces.txt
##J'ai 519 spécimens j'ai choisi 400 car c'est ce qui se rapproche le plus des 300 gènes que je veux au final
awk '{if($1 > 400) print $2}' "$out_dir"complete_busco_ids_with_counts_without_spaces.txt > "$out_dir"total_ok_busco_ids.txt
#Choisir 300 gènes parmi les gènes restants :
shuf -n 300 "$out_dir"total_ok_busco_ids.txt > "$out_dir"final_busco_ids.txt


#Copier les fichiers fasta des nt dans un dossier
#Renommer les headers des séquences avec le nom de l'espèce et le nom du gène
#Faire un fichier par Gène par espèce
mkdir -p "$out_dir"busco_nt
# Spécifiez le chemin du fichier de tableau à deux colonnes
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
