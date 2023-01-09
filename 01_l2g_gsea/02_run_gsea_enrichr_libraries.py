import numpy as np
import scipy.linalg
import pandas as pd
import os
from matplotlib import pyplot as plt 


p2g='/home/yt4/projects/GSEA/01_L2Gscore/data/genes-index/'
p2s='/home/yt4/projects/GSEA/01_L2Gscore/data/predictions/predictions.full.221012.long.parquet'
p2out='/home/yt4/projects/GSEA/01_L2Gscore/'

p2gsea='/home/yt4/projects/GSEA/01_L2Gscore/out_gsea/'


l5d_05s=pd.read_csv(p2out+'l5d_05s.csv',index_col=0)
genes=pd.read_csv(p2out+'genes_hg38.csv',index_col=0)

S=np.unique(l5d_05s["study_id"], return_counts=True)

list_of_libs=[
"LINCS_L1000_Chem_Pert_up", #ConnectivityMap
"LINCS_L1000_Chem_Pert_down", #ConnectivityMap
"LINCS_L1000_Chem_Pert_Consensus_Sigs", #Library of Integrated Network-Based Cellular Signatures (LINCS)
"LINCS_L1000_CRISPR_KO_Consensus_Sigs", #Library of Integrated Network-Based Cellular Signatures (LINCS)
"DrugMatrix",
"GO_Biological_Process_2021",
"GTEx_Tissue_Expression_Down",
"GTEx_Tissue_Expression_Up",
"Reactome_2022",
"KEGG_2021_Human"
]

for gs in S[0]:
    print(gs)
	l5d_gs=l5d_05s.loc[l5d_05s['study_id'].isin([gs])]
	g=genes.loc[genes["gene_id"].isin(l5d_gs["gene_id"])][["gene_name"]]
	x=gseapy.enrichr(gene_list=g,gene_sets=list_of_libs)
    x.results.to_csv(p2gsea+gs+'.csv')