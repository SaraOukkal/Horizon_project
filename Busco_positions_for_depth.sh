##For all species : 

#Generate a table with species sp1 sp2 : 
# Use reference genome info from : Species_specimens_reference_genome.txt to reorder the table specimens_order.txt that is wrong :
#Invert two columns of specimens_order.txt : 
awk '{print $1,$3,$2}' specimens_order.txt > specimens_order_2.txt
#Test the difference between sp1 column specimens_order_2.txt and Species_specimens_reference_genome.txt and change differences manually : 
cut -f1,2 -d " " specimens_order_2.txt > test.txt
awk 'NR==FNR {t[$0]++; next} !t[$0]' test.txt Species_specimens_reference_genome.txt > resultat

#Get BUSCO positions in a bed file (bash script) : 
Species_table="/beegfs/data/soukkal/Thesis/Horizon/specimens_order.txt"

while read -r a b c ; 
do
    cd /beegfs/project/horizon/data/stats/busco/specimens/$b/run_insecta_odb10
    cut -f3,4,5 full_table.tsv | tail -n +4 > /beegfs/project/horizon/data/stats/busco/species_busco_pos/Busco_positions_"$a"_sp1.bed
    cd /beegfs/project/horizon/data/stats/busco/specimens/$c/run_insecta_odb10
    cut -f3,4,5 full_table.tsv | tail -n +4 > /beegfs/project/horizon/data/stats/busco/species_busco_pos/Busco_positions_"$a"_sp2.bed
done < $Species_table


#Remove empty lines : 
Species_list="/beegfs/data/soukkal/Thesis/Horizon/species_list_236.txt"

while read -r a ; 
do
        cd /beegfs/project/horizon/data/stats/busco/species_busco_pos/
        sed -i "/^\s*$/d" Busco_positions_"$a"_sp1.bed
        sed -i "/^\s*$/d" Busco_positions_"$a"_sp2.bed
done < $Species_list

