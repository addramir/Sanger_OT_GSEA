cust_func(){
path2csv=/mnt/disk1/data/GS_233IDs/to_magma/
path2save=/mnt/disk1/data/GS_233IDs/GSA_magma/
~/projects/GSEA/02_magma/magma \
--bfile ~/projects/GSEA/02_magma/ref/g1000_eur \
--pval $path2csv/"$1" ncol=3 \
--gene-annot ~/projects/GSEA/03_magma_124IDs/hg38_ENSG_annot.genes.annot \
--out $path2save/"$1"
}

cd /mnt/disk1/data/GS_233IDs/

export -f cust_func

cat diff.txt | parallel -j 16 cust_func {}



