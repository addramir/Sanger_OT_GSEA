cd /mnt/disk1/data/GS_233IDs

path2csv=/mnt/disk1/data/GS_233IDs/to_magma/
path2save=/mnt/disk1/data/GS_233IDs/GSA_out/
path2gba=/mnt/disk1/data/GS_233IDs/GSA_magma/

cust_func(){

path2csv=/mnt/disk1/data/GS_233IDs/to_magma/
path2save=/mnt/disk1/data/GS_233IDs/GSA_out/
path2gba=/mnt/disk1/data/GS_233IDs/GSA_magma/

~/projects/GSEA/02_magma/magma \
--gene-results $path2gba/"$1".genes.raw \
--set-annot ~/projects/GSEA/03_magma_124IDs/10667_GSs_for_magma_ENSG.txt \
--out $path2save/"$1"

}

cd /mnt/disk1/data/GS_233IDs/

export -f cust_func

ls $path2csv > csv_list.txt

cat csv_list.txt | parallel -j 16 cust_func {}