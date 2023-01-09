import numpy as np
import scipy.linalg
import pandas as pd
import os
from matplotlib import pyplot as plt
from scipy import stats
#stats.chi2.pdf(3.84 , 1)
#stats.chi2.isf(3.760e-18, 1)


p2gsea='/home/yt4/projects/GSEA/01_L2Gscore/out_gsea/'

list_of_files=os.listdir(p2gsea)
out=np.empty(shape=(len(list_of_files),3), dtype=float)

for i,f in enumerate(list_of_files):
	print(i)
	x=pd.read_csv(p2gsea+f,index_col=0)
	out[i,0]=x.shape[0]
	out[i,1]=np.sum(x['Adjusted P-value']<=0.05)
	l=stats.chi2.isf(x['Adjusted P-value'], 1)
	out[i,2]=np.median(stats.chi2.isf(x['Adjusted P-value'], 1))/stats.chi2.isf(0.5, 1)

np.sum(out[:,1]==0)
np.sum(out[:,1]>0)
np.sum(out[:,1]==1)
np.mean(out[:,1])
np.median(out[:,1])

p2gsea='/home/yt4/projects/GSEA/01_L2Gscore/out_gsea_08/'

list_of_files=os.listdir(p2gsea)
out=np.empty(shape=(len(list_of_files),3), dtype=float)

for i,f in enumerate(list_of_files):
	print(i)
	x=pd.read_csv(p2gsea+f,index_col=0)
	out[i,0]=x.shape[0]
	out[i,1]=np.sum(x['Adjusted P-value']<=0.05)
	l=stats.chi2.isf(x['Adjusted P-value'], 1)
	out[i,2]=np.median(stats.chi2.isf(x['Adjusted P-value'], 1))/stats.chi2.isf(0.5, 1)

np.sum(out[:,1]==0)
np.sum(out[:,1]>0)
np.sum(out[:,1]==1)
np.mean(out[:,1])
np.median(out[:,1])