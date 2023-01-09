#Checnking gene sets

setwd("~/Projects/GSEA/")

library(data.table)

p2d="./data/msigdb_v2022.1.Hs_files_to_download_locally/msigdb_v2022.1.Hs_GMTs/"
list_files=list.files(p2d,pattern = "symbols.gmt")
i=1
ALL=array(NA,c(200000,3000))
index=1
for (i in 1:length(list_files)){
  x=fread(paste0(p2d,"/",list_files[i]),data.table=F,sep=NULL)
  y=apply(x,MAR=1,FUN=function(x){strsplit(x,split ="\t")})
  j=1
  ALL[index:(index+length(y)-1),1]=list_files[i]
  for (j in 1:length(y)){
    v=as.vector(unlist(y[[j]]))
    ALL[index+j-1,2:(length(v)+1)]=v
  }
  index=index+length(y)
}

l1=apply(ALL,MAR=1,FUN=function(x){sum(is.na(x))})
ALL=ALL[l1<max(l1),]

l2=apply(ALL,MAR=2,FUN=function(x){sum(is.na(x))})
ALL=ALL[,l2<max(l2)]
gene_sets=ALL
save(list=c("gene_sets"),file="data/20221107_genesets_all.RData")

#
load("data/20221107_genesets_all.RData")
crp=gene_sets[gene_sets[,1]=="msigdb.v2022.1.Hs.symbols.gmt",]
l1=apply(crp,MAR=1,FUN=function(x){sum(!is.na(x))})
n_min=15
n_max=500
ind=which(l1>=(n_min+3) & l1<=(n_max+3))
crp=crp[ind,]
l2=apply(crp,MAR=2,FUN=function(x){sum(is.na(x))})
crp=crp[,l2<max(l2)]
save(list=c("crp"),file="data/gene_sets_msigdb_v2022_1_15_500.RData")
