library(data.table)

genes=fread("~/projects/GSEA/03_magma_124IDs/ENSG_h38_gene_list.txt",data.table=F)
colnames(genes)=c("gene_id","chr","start","end","strand")
GS=fread("~/projects/GS_with_biggest_GWASid.txt",data.table=F)
SI=fread("~/projects/study_index.csv",data.table=F)

l=list.files("/mnt/disk1/data/GS_124IDs/GSA_magma/",pattern="genes.out")
for (f in l){
	print(f)
	x=fread(paste0("/mnt/disk1/data/GS_124IDs/GSA_magma/",f),data.table=F)
	f=gsub(f,pattern=".csv.genes.out",replacement="")

	ind=which(GS$the_biggest_GWAS_id==f)[1]
	efo=GS[ind,"trait_info.ontology"]
	
	ind=which(SI$study_id==f)[1]
	ncas=SI[ind,"n_cases"]

	#y=rep(NA,nrow(genes))
	ind=match(genes[,1],x[,1])
	#table(x[ind,1]==genes[,1])
	y=x[ind,"P"]
	y=-log10(y)

	if ((!is.na(ncas) & ncas>=1000)|(is.na(ncas)))
	{
		genes=cbind(genes,y)
		colnames(genes)[ncol(genes)]=efo
	}
}

fwrite("~/projects/GSEA/03_magma_124IDs/genes_GBA_results_efo.txt",x=genes)