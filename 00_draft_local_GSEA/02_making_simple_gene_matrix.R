#Obtaning GWAS matrix

setwd("~/Projects/GSEA/")

library(data.table)

genes=fread("data/NCBI37.3/NCBI37.3.gene.loc",data.table=F)
gwas=fread("data/2021_07_06_human_ageing_gip1.tsv",data.table=F)
chr_col="chr"
pos_col="pos"

i=1
out=rep(NA,nrow(genes))
out_l=rep(0,nrow(genes))




fff=function(x){
  start=as.numeric(x[3])-window
  end=as.numeric(x[4])+window
  chr=x[2]
  ind=which(gwas$chr==chr & gwas$pos<=end & gwas$pos>=start)
  length(ind)
}

window=1e6
l1e6=apply(genes,MAR=1,FUN=fff)

window=5e5
l5e5=apply(genes,MAR=1,FUN=fff)

window=2.5e5
l25e5=apply(genes,MAR=1,FUN=fff)


for (i in 1:nrow(genes)){
  print(i)
  start=genes[i,3]-window
  end=genes[i,4]+window
  chr=genes[i,2]
  ind=which(gwas$chr==chr & gwas$pos<=end & gwas$pos>=start)
  if(length(ind)>0){
    g=gwas[ind,]
    out[i]=min(g$p)
    out_l[i]=length(ind)
  }
}
names(out)=names(out_l)=genes[,6]



save(list=c("out","out_l"),file="data/gm_gip1_minp.RData")

