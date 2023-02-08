setwd("/mnt/disks/gwas/")
path2GSA="/mnt/disks/gwas/magma_GSA/"
path2save="/mnt/disks/gwas/"

library(data.table)

genes=fread("~/projects/Sanger_OT_GoldStandards/ENSG_h38_gene_list.txt",data.table=F)
colnames(genes)=c("gene_id","chr","start","end","strand")

FM=fread("/mnt/disks/gwas/feature_matrix.csv",data.table=F)

load("/mnt/disks/gwas/10677_GS_tables.RData")
gss=table(y)
gss_null=rep(0,length(gss))
names(gss_null)=names(gss)

l=list.files(path2GSA,pattern="gsa.out")
list_l=gsub(l,pattern=".gsa.out",replacement="")
gids=unique(FM[,2])

table(gids%in%list_l)
f=gids[1]

FM[,"GSA_score"]=0

for (f in gids){
	print(f)
	x=fread(paste0(path2GSA,f,".gsa.out"),data.table=F,skip=3,header=T)
	pval=x[,7]
	pval=p.adjust(pval)

	#f=gsub(f,pattern=".gsa.out",replacement="")

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

		ind_f=which(FM[,"study_id"]==f)
		FMf=FM[ind_f,]
		if (nrow(FMf)>0){
			ind_g=match(FMf[,1],genes[,1])
			#table(FMf[,1]==genes[ind_g,1])
			FMf[,3]=gss_out[ind_g]
			#table(FM[ind_f,1]==FMf[,1])
			FM[ind_f,]=FMf
		}
		#genes=cbind(genes,gss_out)
		#colnames(genes)[ncol(genes)]=efo
	}
}

fwrite(paste0(path2save,"/20220207_GSA_Results.csv"),x=FM,sep=",")
