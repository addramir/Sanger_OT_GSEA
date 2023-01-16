cd ~/projects/GSEA/03_magma_124IDs


path2csv=/mnt/disk1/data/GS_124IDs/to_magma/
path2save=/mnt/disk1/data/GS_124IDs/GSA_out/
gw=$(ls $path2csv)

for g in $gw
do
echo $g
~/projects/GSEA/02_magma/magma \
--gene-results /mnt/disk1/data/GS_124IDs/GSA_magma/$g.genes.raw \
--set-annot ~/projects/GSEA/03_magma_124IDs/10667_GSs_for_magma_ENSG.txt \
--out $path2save/$g
done