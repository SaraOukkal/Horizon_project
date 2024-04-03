#Get BUSCO positions in a bed file (bash script) : 
Species_table="/beegfs/data/soukkal/Thesis/Horizon/Species_specimens_busco_depth.txt"

while read -r a b ; 
do
    cd /beegfs/project/horizon/data/stats/busco/specimens/$b/run_insecta_odb10/
    cut -f3,4,5 full_table.tsv | tail -n +4 > /beegfs/project/horizon/data/stats/busco/species_busco_pos/Busco_positions_"$a":"$b".bed
done < $Species_table


#Remove empty lines : 
while read -r a b ; 
do
        cd /beegfs/project/horizon/data/stats/busco/species_busco_pos/
        sed -i "/^\s*$/d" Busco_positions_"$a":"$b".bed
        sed -i "/^\s*$/d" Busco_positions_"$a":"$b".bed
done < $Species_table
