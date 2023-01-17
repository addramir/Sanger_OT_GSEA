cd /mnt/disk1/data/GS_233IDs/

path2csv=/mnt/disk1/data/GS_233IDs/to_magma/
path2save=/mnt/disk1/data/GS_233IDs/GSA_magma/
gw=$(ls $path2csv)

gw_ex=$(ls /mnt/disk1/data/GS_124IDs/to_magma/)

ls $path2csv > /mnt/disk1/data/GS_233IDs/gw.txt
ls /mnt/disk1/data/GS_124IDs/to_magma/ > /mnt/disk1/data/GS_233IDs/gw_ex.txt
comm -3 gw.txt gw_ex.txt | tr -d ' \t' > diff.txt
dff=$(cat diff.txt)

for g in $dff
do
echo $g
~/projects/GSEA/02_magma/magma \
--bfile ~/projects/GSEA/02_magma/ref/g1000_eur \
--pval $path2csv/$g ncol=3 \
--gene-annot ~/projects/GSEA/03_magma_124IDs/hg38_ENSG_annot.genes.annot \
--out $path2save/$g
done