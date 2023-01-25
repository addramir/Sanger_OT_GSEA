setwd("~/projects/Sanger_OT_GoldStandards/")
path2GBA="/mnt/disk1/data/GS_233IDs/GSA_magma/"
path2save="~/projects/GSEA/Sanger_OT_GSEA/03_magma_extended_GS/"

library(data.table)

genes=fread("ENSG_h38_gene_list.txt",data.table=F)
colnames(genes)=c("gene_id","chr","start","end","strand")
GS=fread("./02_extended_GS/GS_with_biggest_GWASid.txt",data.table=F)
gs_ids=names(table(GS$the_biggest_GWAS_id))
gs_ids=gs_ids[gs_ids!=""]

SI=fread("./02_extended_GS/study_index.csv",data.table=F)

l=list.files(path2GBA,pattern="genes.out")
list_l=gsub(l,pattern=".csv.genes.out",replacement="")
table(gs_ids%in%list_l)
l=l[list_l%in%gs_ids]
f=l[1]


for (f in l){
	print(f)
	x=fread(paste0(path2GBA,f),data.table=F)
	f=gsub(f,pattern=".csv.genes.out",replacement="")

	ind=which(GS$the_biggest_GWAS_id==f)[1]
	efo=GS[ind,"trait_info.ontology"]
	
	#y=rep(NA,nrow(genes))
	ind=match(genes[,1],x[,1])
	#table(x[ind,1]==genes[,1])
	y=x[ind,"P"]
	y=-log10(y)

	genes=cbind(genes,y)
	colnames(genes)[ncol(genes)]=efo
	
}

fwrite(paste0(path2save,"/genes_GBA_results_efo.txt"),x=genes)
tar('genes_GBA_results_efo.tar.gz', paste0(path2save,"/genes_GBA_results_efo.txt"), compression = 'gzip', tar="tar")