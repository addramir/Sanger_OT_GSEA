#approbation of gsea
#just for myself

setwd("~/Projects/GSEA/")
library(data.table)
#install.packages("VGAM")

load("data/gm_gip1_minp.RData")
load("data/gene_sets_msigdb_v2022_1_15_500.RData")
source("src/00a_GSEA_util.R")

gene_length=out_l[!is.na(out)]
z=out[!is.na(out)]
z=VGAM::probit(1-z)

crp2=apply(crp,MAR=2,FUN=function(x){x[!x%in%names(z)]=NA;x})
l1=apply(crp2,MAR=1,FUN=function(x){sum(!is.na(x))})
n_min=15
n_max=500
ind=which(l1>=(n_min) & l1<=(n_max))
crp2=crp2[ind,]
l2=apply(crp2,MAR=2,FUN=function(x){sum(is.na(x))})
crp2=crp2[,l2<max(l2)]
crp=crp[ind,]

GS=crp2[1,]
out=array(NA,c(nrow(crp2),3))

i=1
for (i in (1:nrow(crp2))){
  GS=crp2[i,]
  l=MAGMA_core_no_perm(GS = GS,gene_length = gene_length,z=z)
  out[i,]=l
}

out_perm=array(NA,c(nrow(crp2),5))

i=1
for (i in (1:nrow(crp2))){
  print(i)
  GS=crp2[i,]
  l=MAGMA_core_perm(GS = GS,gene_length = gene_length,z=z,n_perm=1000)
  out_perm[i,]=l
}



#
source("src/00a_GSEA_util.R")
library(data.table)

load("data/gm_gip1_minp.RData")

l=out[which(out<=5e-8)]

l=sqrt(qchisq(l,df=1,low=F))

GSEA(gene_list=l, 
     GO_file="./data/msigdb_v2022.1.Hs_files_to_download_locally/msigdb_v2022.1.Hs_GMTs/msigdb.v2022.1.Hs.symbols.gmt", 
     pval=1)

gene_list=l 
GO_file="./data/msigdb_v2022.1.Hs_files_to_download_locally/msigdb_v2022.1.Hs_GMTs/msigdb.v2022.1.Hs.symbols.gmt"


