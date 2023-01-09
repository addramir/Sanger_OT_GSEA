from pyspark.sql import SparkSession
import numpy as np
import scipy.linalg
import pandas as pd
import os
from matplotlib import pyplot as plt 

os.chdir('/home/yt4/projects/GSEA/01_L2Gscore/data/')
p2g='/home/yt4/projects/GSEA/01_L2Gscore/data/genes-index/'
p2s='/home/yt4//projects/GSEA/01_L2Gscore/data/predictions/predictions.full.221012.long.parquet'
p2out='/home/yt4//projects/GSEA/01_L2Gscore/'

spark = SparkSession.builder.config("some_config", "some_value").master("local[*]").getOrCreate()

genes = spark.read.parquet(p2g)
genes=genes.toPandas()

l2g = spark.read.parquet(p2s)
l=l2g.filter(l2g.training_ft=="full_model")
l_5=l.filter(l.y_proba>=0.5)
l5d=l_5.toPandas()

S=np.unique(l5d["study_id"], return_counts=True)
l5d_05s=l5d.loc[l5d['study_id'].isin(S[0][S[1]>=10])]

l5d_05s.to_csv(p2out+'l5d_05s.csv')
genes.to_csv(p2out+'genes_hg38.csv')

