while read -r a b ; do
    echo $a
    mkdir /beegfs/project/horizon/data/assembly/species/$a
    cp /beegfs/project/horizon/data/assembly/specimens/$b/redundans/scaffolds.reduced.fa /beegfs/project/horizon/data/assembly/species/$a/gnm.fna
done < /beegfs/data/soukkal/Thesis/Horizon/Species_specimens_reference_genome.txt

