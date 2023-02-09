setwd("/mnt/disks/gwas/")
path2GBA="/mnt/disks/gwas/magma_GBA/"
path2save="/mnt/disks/gwas/"

library(data.table)

FM=fread("/mnt/disks/gwas/feature_matrix.csv",data.table=F)



l=list.files(path2GBA,pattern=".genes.out")
list_l=gsub(l,pattern=".genes.out",replacement="")
gids=unique(FM[,2])

table(gids%in%list_l)
f=gids[1]

FM[,"GBA_score"]=NA

for (f in gids){
	print(f)
	x=fread(paste0(path2GBA,f,".genes.out"),data.table=F,header=T)
	pval=x[,"P"]
	pval=-log10(pval)

	ind_f=which(FM[,"study_id"]==f)
	FMf=FM[ind_f,]
	if (nrow(FMf)>0){
		ind_g=match(FMf[,1],x[,"GENE"])
		#table(FMf[,1]==genes[ind_g,1])
		FMf[,3]=pval[ind_g]
		#table(FM[ind_f,1]==FMf[,1])
		FM[ind_f,]=FMf
	}
}


fwrite(paste0(path2save,"/20230208_GBA_Results.csv"),x=FM,sep=",")
