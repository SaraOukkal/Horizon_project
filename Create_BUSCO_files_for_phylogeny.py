import pandas as pd 
import argparse
import os
import io 
import os.path
from os import path
from Bio import SeqIO

# Print out a message when the program is initiated.
print('-----------------------------------------------------------------------------------\n')
print('                        Process BUSCO table to create BUSCO files for phylogeny                          .\n')
print('-----------------------------------------------------------------------------------\n')

#----------------------------------- PARSE SOME ARGUMENTS ----------------------------------------
parser = argparse.ArgumentParser(description=' Process BUSCO table to create BUSCO files for phylogeny')
parser.add_argument("-l", "--sp_list", help="The comma separated list of species to analyse",action='append',nargs='+') 
parser.add_argument("-cat_list", "--cat_list", help="The comma separated list of species to analyse",action='append',nargs='+')
parser.add_argument("-out_busco_dir", "--out_busco_dir", help="The full busco desired path") 
parser.add_argument("-main_dir", "--main_dir", help="The full Genome paths") 
parser.add_argument("-n_missing", "--n_missing", help="Number of authorized missing busco species per IDs") 
args = parser.parse_args()


#Usage example 

"""
Create_BUSCO_files_for_phylogeny_sara.py -l GCA_916050605.2,campylocheta_wood03,GCF_015476425.1 \
-out_busco_dir /beegfs/data/soukkal/StageM2/BUSCO_phylogeny -main_dir /beegfs/data/soukkal/StageM2 -cat_list Control_genomes,Tachinids_genomes,Hymenoptera_genomes -n_missing 0 

"""
# paths 

list_sp=args.sp_list
list_sp=  list_sp[0][0].split(",")
cat_list=args.cat_list
list_cat= cat_list[0][0].split(",")

Main_dir=args.main_dir
Output_BUSCO_dir = args.out_busco_dir

print("List of species to analyse:")
print(list_sp)
print("\n")
n_missing=args.n_missing
n_missing=int(n_missing)
BUSCO_tab=pd.DataFrame(columns=['Species','Busco_id', 'Status', 'Sequence', 'Gene Start', 'Gene End', 'Strand', 'Score', 'Length', 'OrthoDB url', 'Description'])

for cat in list_cat:
	print("cat",cat)
# Open all BUSCO tables
for cat in list_cat:
	for sp in list_sp:
			#print(cat,sp)
			#print(Main_dir,cat,"/results/Stat_Results/",sp,"/BUSCO_results/run_diptera_odb10/full_table.tsv",sep="")
			try:
				#print(Main_dir+cat+"/results/Stat_Results/"+sp+"/BUSCO_results/run_diptera_odb10/full_table.tsv")
				subBUSCO_tab=pd.read_csv(Main_dir+cat+"/results/Stat_Results/"+sp+"/BUSCO_results/run_diptera_odb10/full_table.tsv", sep='\t', header=2, index_col=0)
				subBUSCO_tab=subBUSCO_tab.reset_index().rename({'index':'BUSCO_name'}, axis = 'columns')
				subBUSCO_tab.columns=['Busco_id', 'Status', 'Sequence', 'Gene Start', 'Gene End', 'Strand', 'Score', 'Length', 'OrthoDB url', 'Description']
				subBUSCO_tab['Species']=sp
				BUSCO_tab=BUSCO_tab.append(subBUSCO_tab)
			except:
				#print(cat,sp)
				continue 

print(BUSCO_tab)
# Keep only complete BUSCOs
BUSCO_tab=BUSCO_tab.loc[BUSCO_tab['Status']=="Complete"]

# Count number of BUSCO IDs found in each species 
BUSCO_tab[BUSCO_tab.duplicated(['Busco_id', 'Status', 'Sequence', 'Gene Start', 'Gene End', 'Strand', 'Score', 'Length', 'OrthoDB url', 'Description'])].groupby("Busco_id").size().reset_index(name='Duplicates')
BUSCO_tab_id = BUSCO_tab.groupby('Busco_id')['Species'].nunique().to_frame()

# allow n_missing taxa per BUSCO ids 
BUSCO_tab_id=BUSCO_tab_id.loc[BUSCO_tab_id['Species'].ge(len(list_sp)-n_missing)]
BUSCO_tab_id['Busco_id'] = BUSCO_tab_id.index

print("Number of BUSCO in common on ",len(list_sp)-n_missing,"/",len(list_sp) ," species from the dataset : ", len(BUSCO_tab_id),sep="")

# Create all the retained BUSCO files 
print ("Creating ",len(BUSCO_tab_id),' BUSCO files...',sep="")

# Check directory 
if path.exists(Output_BUSCO_dir) ==False:
  os.mkdir(Output_BUSCO_dir)
if path.exists(Output_BUSCO_dir+"/BUSCO_files") ==False:  
  os.mkdir(Output_BUSCO_dir+"/BUSCO_files") 
  
for busco in BUSCO_tab_id['Busco_id'].unique():
  with open(Output_BUSCO_dir+"/BUSCO_files/BUSCO_"+busco+".faa","w") as output:
    for sp in list_sp :
     for cat in list_cat:
      try:
        for seq in SeqIO.parse(Main_dir+cat+"/results/Stat_Results/"+sp+"/BUSCO_results/run_diptera_odb10/busco_sequences/single_copy_busco_sequences/"+busco+".faa","fasta"):
          print(">",sp,sep="",file=output)
          print(seq.seq,file=output)
      except:
          continue

with open(Output_BUSCO_dir+"/BUSCO_files/Control_check1.txt", 'w') as fp:
	print("Rule ok",file=fp) 

print("\n")
print("All BUSCO files written to : ",Output_BUSCO_dir+"/BUSCO_files")




