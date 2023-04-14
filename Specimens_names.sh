#!/bin/bash

species_list=`cat /beegfs/data/soukkal/Thesis/Horizon/species_list_236.txt`

for i in $species_list
do
	cd /beegfs/data/sbarreto/hrz/p/as_horizon-assembly_2020-11-10/data/$i/
	cut -f3,5,7 -d ' ' reconcile.sh | awk '{print $1,$3,$2}' OFS='\t' >> /beegfs/data/soukkal/Thesis/Horizon/specimens_order.txt
done



