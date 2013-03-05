print.eval = TRUE
argv <- commandArgs(trailingOnly = TRUE)
fname <- argv[1]

load("/fs/lustre/osu6683/gibbs.meth.fctx.aligned.psb.corr.feb-15-2013.pkl_gibbs.mrna.fctx.aligned.psb.corr.feb-15-2013.pkl.DCOR.values.sig=None.abs=F.tab.RData")
row.max <- apply(M, 1, max)
col.max <- apply(M, 2, max)
print("Max dCOR must be at least 0.45")
DCOR <- M[row.max>=0.45, col.max>=0.45]
print(dim(M))
print(dim(DCOR))

library("RColorBrewer")
library("gplots")

MIN<-0.1
MAX<-0.9
heatmap_breaks <- seq(MIN,MAX,0.01)
cols=brewer.pal(8,"RdYlBu")
heatmap_cols <- rev(colorRampPalette(cols)(length(heatmap_breaks)-1))

R = list()
D.DCOR.r <- dist(DCOR)
print("Computed Row Dist")
D.DCOR.c <- dist(t(DCOR))
print("Computed Col Dist")
Rowv <- rowMeans(DCOR, na.rm = TRUE)
Colv <- colMeans(DCOR, na.rm = TRUE)
R$Rhclust <- as.dendrogram(hclust(D.DCOR.r, method="complete"))
R$Rhclust <- reorder(R$Rhclust, Rowv)
print("Computed Row Clust")
R$Chclust <- as.dendrogram(hclust(D.DCOR.c, method="complete"))
R$Chclust <- reorder(R$Chclust, Colv)
print("Computed Col Clust")

R$rowInd <- order.dendrogram(R$Rhclust)
R$colInd <- order.dendrogram(R$Chclust)
G <- DCOR[R$rowInd, R$colInd]

save(R, DCOR, file="dcor.all.hclust.complete.fctx.RData")
print("Saved clustering")

Img <- t(G)[,seq(nrow(G),1,-1)]
w <- ncol(G); h <- nrow(G)

print("Generating image....")
png("all_dcor_hclust_complete_fctx.png", width=w, height=h)
image(1:w, 1:h, Img, col=col, breaks=heatmap_breaks, axes=FALSE, xlab="", ylab="", useRaster=T)
dev.off()

