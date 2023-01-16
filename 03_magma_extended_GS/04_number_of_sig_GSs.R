library(data.table)

genes=fread("~/projects/GSEA/03_magma_124IDs/ENSG_h38_gene_list.txt",data.table=F)
colnames(genes)=c("gene_id","chr","start","end","strand")
GS=fread("~/projects/GS_with_biggest_GWASid.txt",data.table=F)
SI=fread("~/projects/study_index.csv",data.table=F)

load("~/projects/GSEA/03_magma_124IDs/10677_GS_tables.RData")
gss=table(y)
gss_null=rep(0,length(gss))
names(gss_null)=names(gss)

l=list.files("/mnt/disk1/data/GS_124IDs/GSA_out/",pattern="gsa.out")


for (f in l){
	print(f)
	x=fread(paste0("/mnt/disk1/data/GS_124IDs/GSA_out/",f),data.table=F,skip=4)
	pval=x[,7]
	pval=p.adjust(pval)

	f=gsub(f,pattern=".csv.gsa.out",replacement="")

	ind=which(GS$the_biggest_GWAS_id==f)[1]
	efo=GS[ind,"trait_info.ontology"]
	
	ind=which(SI$study_id==f)[1]
	ncas=SI[ind,"n_cases"]


	ind=which(pval<=0.05)

	if ((!is.na(ncas) & ncas>=1000 & length(ind)>0)|(is.na(ncas) & length(ind)>0))
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

fwrite("~/projects/GSEA/03_magma_124IDs/genes_GSA_results_efo.txt",x=genes)
