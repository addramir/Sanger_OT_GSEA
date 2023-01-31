cd /mnt/disks/gwas/

path2csv=/mnt/disks/gwas/magma_csvs_no_empty/
path2save=/mnt/disks/gwas/magma_GBA/


cust_func(){

path2csv=/mnt/disks/gwas/magma_csvs_no_empty/
path2save=/mnt/disks/gwas/magma_GBA/

/mnt/disks/gwas/magma_v110/magma \
--bfile /mnt/disks/gwas/magma_v110/g1000_eur \
--pval $path2csv/"$1".csv ncol=3 \
--gene-annot /mnt/disks/gwas/hg38_ENSG_annot.genes.annot \
--out $path2save/"$1"

}

export -f cust_func

cat csv_magma_list.txt | parallel -j 93 cust_func {}

#cat csv_subset.txt | parallel -j 5 cust_func {}

