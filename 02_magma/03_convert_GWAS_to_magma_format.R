#cd /mnt/disk1/data/GS_124IDs/to_magma
#R

library(data.table)

path2csv="/mnt/disk1/data/GS_124IDs/csvs/"
path2out="/mnt/disk1/data/GS_124IDs/to_magma/"

lfl=list.files(path2csv)

for (f in lfl){
	print(f)
	x=fread(paste0(path2csv,f))
	y=x[,c("rs_id","pval","n_total")]
	colnames(y)=c("SNP","p","n")
	ind=which(y[,1]!="")
	y=y[ind,]
	fwrite(x=y,file=paste0(path2out,f),sep="\t",quote=F)
}
