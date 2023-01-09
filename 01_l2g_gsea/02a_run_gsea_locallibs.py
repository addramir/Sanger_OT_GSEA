import numpy as np
import scipy.linalg
import pandas as pd
import os
from matplotlib import pyplot as plt
import gseapy 


p2g='/home/yt4/projects/GSEA/01_L2Gscore/data/genes-index/'
p2s='/home/yt4/projects/GSEA/01_L2Gscore/data/predictions/predictions.full.221012.long.parquet'
p2out='/home/yt4/projects/GSEA/01_L2Gscore/'

p2gsea='/home/yt4/projects/GSEA/01_L2Gscore/out_gsea/'
p2gsets='/home/yt4/projects/GSEA/01_L2Gscore/data/msigdb_v2022.1.Hs_files_to_download_locally/msigdb_v2022.1.Hs_GMTs/'


l5d_05s=pd.read_csv(p2out+'l5d_05s.csv',index_col=0)
genes=pd.read_csv(p2out+'genes_hg38.csv',index_col=0)

S=np.unique(l5d_05s["study_id"], return_counts=True)



list_of_libs=[
p2gsets+'c2.all.v2022.1.Hs.symbols.gmt',
p2gsets+'c5.go.bp.v2022.1.Hs.symbols.gmt',
p2gsets+'c5.go.cc.v2022.1.Hs.symbols.gmt',
p2gsets+'c5.go.mf.v2022.1.Hs.symbols.gmt'
]

for gs in S[0]:
    print(gs)
    l5d_gs=l5d_05s.loc[l5d_05s['study_id'].isin([gs])]
    g=genes.loc[genes["gene_id"].isin(l5d_gs["gene_id"])][["gene_name"]]
    x=gseapy.enrichr(gene_list=g,gene_sets=list_of_libs)
    x.results.to_csv(p2gsea+gs+'.csv')



#x=gseapy.enrichr(gene_list=l5d_gs[["gene_id"]],
#    gene_sets='/home/yt4/projects/GSEA/01_L2Gscore/data/msigdb_v2022.1.Hs_files_to_download_locally/msigdb_v2022.1.Hs_GMTs/c5.go.bp.v2022.1.Hs.entrez.gmt')