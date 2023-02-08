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
#l=FM.select('study_id').distinct().toPandas()

FM=FM.select(FM.columns[0:2])
FM=FM.toPandas()

FM.to_csv("/mnt/disks/gwas/feature_matrix.csv",index=False)