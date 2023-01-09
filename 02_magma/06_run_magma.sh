cd ~/projects/GSEA/03_magma_124IDs

~/projects/GSEA/02_magma/magma \
--annotate \
--gene-loc ENSG_h38_gene_list.txt \
--snp-loc hg38_snps_0001.bim \
--out hg38_ENSG_annot

cat hg38_ENSG_annot.genes.annot |tr "|" " "|awk '{print $1}' > ENSG_in_hg38_annot.txt



path2csv=/mnt/disk1/data/GS_124IDs/to_magma/
path2save=/mnt/disk1/data/GS_124IDs/GSA_magma/
gw=$(ls $path2csv)

for g in $gw
do
echo $g
~/projects/GSEA/02_magma/magma \
--bfile ~/projects/GSEA/02_magma/ref/g1000_eur \
--pval $path2csv/$g ncol=3 \
--gene-annot ~/projects/GSEA/03_magma_124IDs/hg38_ENSG_annot.genes.annot \
--out $path2save/$g
done