
MAGMA_core_no_perm=function(GS,gene_length,z){
  
  GS=GS[GS%in%names(z)]
  
  N=length(names(z))
  mask=rep(0,length=N)
  names(mask)=names(z)
  mask[GS]=1
  
  l=summary(lm(as.vector(z)~as.vector(mask)+as.vector(gene_length)))
  x=l$coefficients[2,c(1,2,4)]
  x
}



MAGMA_core_perm=function(GS,gene_length,z,n_perm=1000){
  
  GS=GS[GS%in%names(z)]
  
  N=length(names(z))
  mask=rep(0,length=N)
  names(mask)=names(z)
  mask[GS]=1
  
  l=summary(lm(as.vector(z)~as.vector(mask)+as.vector(gene_length)))
  x=l$coefficients[2,c(1,2,4)]
  
  out_p=NULL
  for (i in (1:n_perm)){
    ind=sample(1:N,length(GS))
    mask=rep(0,length=N)
    mask[ind]=1
    l=summary(lm(z~mask+gene_length))
    out_p=c(out_p,l$coefficients[2,1])
  }
  Fn=ecdf(out_p)
  x=c(x,sd(out_p),1-Fn(x[1]))
  x
}




#gene_list = Ranked gene list ( numeric vector, names of vector should be gene names)
#GO_file= Path to the “gmt” GO file on your system.
#pval = P-value threshold for returning results
#Run GSEA (package: fgsea)
#Collapse redundant GO terms using a permutation test
#Return GSEA plot and data.frame of results

GSEA_fgsea = function(gene_list, GO_file, pval) {
  set.seed(54321)
  library(dplyr)
  library(ggplot2)
  library(fgsea)
  
  if ( any( duplicated(names(gene_list)) )  ) {
    warning("Duplicates in gene names")
    gene_list = gene_list[!duplicated(names(gene_list))]
  }
  if  ( !all( order(gene_list, decreasing = TRUE) == 1:length(gene_list)) ){
    warning("Gene list not sorted")
    gene_list = sort(gene_list, decreasing = TRUE)
  }
  myGO = fgsea::gmtPathways(GO_file)
  
  fgRes <- fgsea::fgsea(pathways = myGO,
                        stats = gene_list,
                        minSize=15, ## minimum gene set size
                        maxSize=400, ## maximum gene set size
                        nperm=10000) %>% 
    as.data.frame() %>% 
    dplyr::filter(padj < !!pval) %>% 
    arrange(desc(NES))
  message(paste("Number of signficant gene sets =", nrow(fgRes)))
  
  message("Collapsing Pathways -----")
  concise_pathways = collapsePathways(data.table::as.data.table(fgRes),
                                      pathways = myGO,
                                      stats = gene_list)
  fgRes = fgRes[fgRes$pathway %in% concise_pathways$mainPathways, ]
  message(paste("Number of gene sets after collapsing =", nrow(fgRes)))
  
  fgRes$Enrichment = ifelse(fgRes$NES > 0, "Up-regulated", "Down-regulated")
  filtRes = rbind(head(fgRes, n = 10),
                  tail(fgRes, n = 10 ))
  
  total_up = sum(fgRes$Enrichment == "Up-regulated")
  total_down = sum(fgRes$Enrichment == "Down-regulated")
  header = paste0("Top 10 (Total pathways: Up=", total_up,", Down=",    total_down, ")")
  
  colos = setNames(c("firebrick2", "dodgerblue2"),
                   c("Up-regulated", "Down-regulated"))
  
  g1= ggplot(filtRes, aes(reorder(pathway, NES), NES)) +
    geom_point( aes(fill = Enrichment, size = size), shape=21) +
    scale_fill_manual(values = colos ) +
    scale_size_continuous(range = c(2,10)) +
    geom_hline(yintercept = 0) +
    coord_flip() +
    labs(x="Pathway", y="Normalized Enrichment Score",
         title=header)
  
  output = list("Results" = fgRes, "Plot" = g1)
  return(output)
}