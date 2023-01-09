from pyspark.sql import SparkSession
import numpy as np
import scipy.linalg
import pandas as pd
import os
from matplotlib import pyplot as plt 



spark = SparkSession.builder.config("some_config", "some_value").master("local[*]").getOrCreate()

gwas = spark.read.parquet('/home/yt4/projects/GSEA/02_magma/data/FINNGEN_R6_F5_DEPRESSIO.parquet')
#gwasf=gwas.filter(gwas.eaf>=0.01)
#gwasf=gwasf.filter(gwas.eaf<=0.99)
#gwasd=gwasf.toPandas()
gwas.write.csv("/home/yt4/projects/GSEA/02_magma/data/FR6F5D")

gwas=pd.read_csv('/home/yt4/projects/GSEA/02_magma/data/FR6F5D/full.txt')

gwas=pd.read_csv('/home/yt4/projects/GSEA/02_magma/data/2021_07_06_human_ageing_gip1.tsv')

y=gwas[['rsid','p','n']]
y.to_csv("/home/yt4/projects/GSEA/02_magma/data/gip_to_magma.csv",index=False)