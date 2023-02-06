import pandas as pd
from pyspark.sql import DataFrame, SparkSession
import pyspark.sql.functions as f
from pyspark.sql.types import *
from pyspark.sql.window import Window
import numpy as np

global spark
spark = (
    SparkSession.builder
    .master('local[*]')
    .config('spark.driver.memory', '15g')
    .appName('spark')
    .getOrCreate()
)

FM=spark.read.parquet("/mnt/disks/gwas/features.raw.221011.parquet")



list_files=!ls /mnt/disks/gwas/magma_GBA/*.genes.out
gids=[x.replace("/mnt/disks/gwas/magma_GBA/","") for x in list_files]
gids=[x.replace(".genes.out","") for x in gids]

FM=FM.filter(FM.study_id.isin(gids))
l=FM.select('study_id').distinct().toPandas()




path=list_files[0]
#df = spark.read.option("header",'True').option('delimiter', '\s*').csv(path)
#df = spark.read.csv(path,inferSchema=True,header=True,ignoreLeadingWhiteSpace=True)
df=pd.read_csv(path,delim_whitespace=True)
df=df[["GENE","P"]]
df[["P"]]=-np.log10(df[["P"]])
path=path.replace("/mnt/disks/gwas/magma_GBA/","")
path=path.replace(".genes.out","")
df["Study_ID"]=path
sparkdf=spark.createDataFrame(df)
L=sparkdf.filter("Study_ID is null") 



for path in list_files:
    print(path)
    df=pd.read_csv(path,delim_whitespace=True)
    df=df[["GENE","P"]]
    df[["P"]]=-np.log10(df[["P"]])
    path=path.replace("/mnt/disks/gwas/magma_GBA/","")
    path=path.replace(".genes.out","")
    df["Study_ID"]=path
    sparkdf=spark.createDataFrame(df)
    L=L.union(sparkdf) 
