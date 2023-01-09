cd ~/projects/GSEA/02_magma

./magma \
--annotate \
--gene-loc ~/projects/GSEA/02_magma/g37_formated.txt \
--snp-loc ~/projects/GSEA/02_magma/ref/g1000_eur.bim \
--out ~/projects/GSEA/02_magma/01_gip1/annot


./magma \
--bfile ~/projects/GSEA/02_magma/ref/g1000_eur \
--pval ~/projects/GSEA/02_magma/data/gip_to_magma_t.txt ncol=3 \
--gene-annot /home/yt4/projects/GSEA/02_magma/01_gip1/annot.genes.annot \
--out ~/projects/GSEA/02_magma/01_gip1/gip1


./magma \
--gene-results ~/projects/GSEA/02_magma/01_gip1/gip1.genes.raw \
--set-annot ~/projects/GSEA/01_L2Gscore/data/msigdb_v2022.1.Hs_files_to_download_locally/msigdb_v2022.1.Hs_GMTs/c2.all.v2022.1.Hs.symbols.gmt \
--out ~/projects/GSEA/02_magma/01_gip1/gip1