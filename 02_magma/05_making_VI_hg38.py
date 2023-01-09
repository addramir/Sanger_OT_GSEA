import pandas as pd
from pyspark.sql import DataFrame, SparkSession
import pyspark.sql.functions as f
from pyspark.sql.types import *
from pyspark.sql.window import Window
import numpy as np

spark = SparkSession.builder.getOrCreate()

variant_index=spark.read.parquet("/home/yt4/projects/variant-index")
vi=variant_index.filter(f.col("gnomad_nfe")>=0.001)
vi=vi.select("rs_id","chr_id","position","ref_allele","alt_allele")

vi.write.csv("./VI_filtered")