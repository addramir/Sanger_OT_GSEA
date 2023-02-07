cd /mnt/disks/gwas/

path2GBA=/mnt/disks/gwas/magma_GBA/
path2save=/mnt/disks/gwas/magma_GSA/

cust_func(){

path2GBA=/mnt/disks/gwas/magma_GBA/
path2save=/mnt/disks/gwas/magma_GSA/

/mnt/disks/gwas/magma_v110/magma \
--gene-results $path2GBA/"$1".genes.raw \
--set-annot ~/projects/Sanger_OT_GSEA/02_magma/10667_GSs_for_magma_ENSG.txt \
--out $path2save/"$1"

}

export -f cust_func

cat /mnt/disks/gwas/csv_magma_list.txt | parallel -j 16 cust_func {}