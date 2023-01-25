setwd("~/projects/Sanger_OT_GoldStandards/")
path2GSA="/mnt/disk1/data/GS_233IDs/GSA_out/"
path2save="~/projects/GSEA/Sanger_OT_GSEA/03_magma_extended_GS/"

library(data.table)

genes=fread("ENSG_h38_gene_list.txt",data.table=F)
colnames(genes)=c("gene_id","chr","start","end","strand")
GS=fread("./02_extended_GS/GS_with_biggest_GWASid.txt",data.table=F)
gs_ids=names(table(GS$the_biggest_GWAS_id))
gs_ids=gs_ids[gs_ids!=""]

SI=fread("./02_extended_GS/study_index.csv",data.table=F)

load("~/projects/GSEA/03_magma_124IDs/10677_GS_tables.RData")
gss=table(y)
gss_null=rep(0,length(gss))
names(gss_null)=names(gss)

l=list.files(path2GSA,pattern="gsa.out")
list_l=gsub(l,pattern=".csv.gsa.out",replacement="")
table(gs_ids%in%list_l)
l=l[list_l%in%gs_ids]
f=l[1]

for (f in l){
	print(f)
	x=fread(paste0(path2GSA,f),data.table=F,skip=4)
	pval=x[,7]
	pval=p.adjust(pval)

	f=gsub(f,pattern=".csv.gsa.out",replacement="")

	ind=which(GS$the_biggest_GWAS_id==f)[1]
	efo=GS[ind,"trait_info.ontology"]
	
	ind=which(SI$study_id==f)[1]
	ncas=SI[ind,"n_cases"]


	ind=which(pval<=0.05)

	if (length(ind)>0)
	{
		ind=which(pval<=0.05)
		ind=which(crp[,2]%in%x[ind,8])

		efo_gss=table(y[ind,])
		gss_out=gss_null
		gss_out[names(efo_gss)]=efo_gss
		gss_out=gss_out/gss

	
		ind=match(genes[,1],names(gss_out))
		
		gss_out=as.vector(gss_out)[ind]
		gss_out=gss_out/max(gss_out,na.rm=T)

		genes=cbind(genes,gss_out)
		colnames(genes)[ncol(genes)]=efo
	}
}

fwrite(paste0(path2save,"/genes_GSA_results_efo.txt"),x=genes)
