setwd("~/projects/GSEA/03_magma_124IDs")

library(data.table)

p2d="~/projects/GSEA/01_L2Gscore/data/msigdb_v2022.1.Hs_files_to_download_locally/msigdb_v2022.1.Hs_GMTs/"
#list_files=list.files(p2d,pattern = "symbols.gmt")
list_files=c('c2.all.v2022.1.Hs.symbols.gmt',
	'c5.go.bp.v2022.1.Hs.symbols.gmt',
	'c5.go.cc.v2022.1.Hs.symbols.gmt',
	'c5.go.mf.v2022.1.Hs.symbols.gmt')

i=1
ALL=array(NA,c(50000,3000))
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


save(list=c("gene_sets"),file="genesets_genenames_unfiltered.RData")

#
load("genesets_genenames_unfiltered.RData")

l1=apply(gene_sets,MAR=1,FUN=function(x){sum(!is.na(x))})
n_min=15
n_max=2000
ind=which(l1>=(n_min+3) & l1<=(n_max+3))
crp=gene_sets[ind,]

gi=fread("~/projects/gene_index.csv",sep="\t",data.table=F)
table(duplicated(gi$gene_name))
gi=gi[!duplicated(gi$gene_name),]

ggs=gi[,c("gene_id","chr","start","end","fwdstrand")]
l=ggs[,"fwdstrand"]
l[ggs[,"fwdstrand"]==0]="-"
l[ggs[,"fwdstrand"]==1]="+"
ggs[,"fwdstrand"]=l
fwrite(x=ggs,file="ENSG_h38_gene_list.txt",col.names=F,sep="\t")

#
#FALSE  TRUE 
#19591     8 


y=crp[,4:ncol(crp)]
glt=unique(as.vector(y))
length(glt)
#[1] 22316
table(glt%in%gi$gene_name)
#FALSE  TRUE 
# 3294 19022 

y[!(y%in%gi$gene_name)]=NA

GtoE=function(x){
	ind=match(x,gi$gene_name)
	l=gi$gene_id[ind]
	return(l)
}
dim(y)
table(is.na(y))
y=apply(y,MAR=2,FUN=GtoE)
dim(y)
table(is.na(y))


VAI=fread("ENSG_in_hg38_annot.txt",data.table=F,header=F)
VAI=VAI[,1]
glt=unique(as.vector(y))
table(is.na(y))
y[!(y%in%VAI)]=NA
table(is.na(y))

dim(y)
y=t(apply(y,MAR=1,FUN=function(x){sort(x,na.last=T)}))
dim(y)

l1=apply(y,MAR=1,FUN=function(x){sum(!is.na(x))})
n_min=15
n_max=1000
ind=which(l1>=(n_min) & l1<=(n_max))


y=y[ind,]
crp=crp[ind,]

save(file="10677_GS_tables.RData",list=c("y","crp"))


out=cbind(crp[,2],y)



#fwrite(x=out,file="~/projects/GSEA/03_magma_124IDs/10670_GSs_for_magma_ENSG.txt",sep="\t",quote=F,col.names=F,row.names=F,na="")
sink("~/projects/GSEA/03_magma_124IDs/10667_GSs_for_magma_ENSG.txt")
for (i in 1:nrow(out)){
	x=out[i,]
	x=x[!is.na(x)]
	x=paste(x,collapse="\t")
	#writeLines(x, fileConn)
	cat(x)
	cat("\n")
}
sink()



#ggs=gi[,c("chr","start","end")]
#ggs[,"chr"]=paste("chr",ggs[,"chr"],sep="")
#fwrite(x=ggs,file="h38.bed",col.names=F,sep="\t")



