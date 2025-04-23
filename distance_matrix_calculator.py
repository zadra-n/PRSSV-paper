from Bio.Phylo.TreeConstruction import DistanceCalculator
from Bio import AlignIO
import pandas as pd 



####load alignment the alignemnt should be in the folder where your run the code
alignment = AlignIO.read(open('complete_info_host_no_dup_al_no_gap_myodes_outgroup_nt.fasta'), 'fasta')


###set the value to the distance calulator matri
calculator = DistanceCalculator(model='identity')

distance_matrix = calculator.get_distance(alignment)
names = distance_matrix.names

matrix = distance_matrix.matrix
df = pd.DataFrame(matrix, index=names, columns=names)

df.to_csv('distance_matrix_hanta.csv', index=True)