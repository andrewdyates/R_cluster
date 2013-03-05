print.eval = TRUE
argv <- commandArgs(trailingOnly = TRUE)
fname <- argv[1]

load("/fs/lustre/osu6683/gibbs.meth.all.aligned.psb.corr.feb-15-2013.pkl_gibbs.mrna.all.aligned.psb.corr.feb-15-2013.pkl.DCOR.values.sig=None.abs=F.tab.RData")
row.max <- apply(M, 1, max)
col.max <- apply(M, 2, max)
DCOR <- M[row.max>=0.2, col.max>=0.2]
print(dim(M))
print(dim(DCOR))

library("RColorBrewer")
library("gplots")

MIN<-0.1
MAX<-0.8
heatmap_breaks <- seq(MIN,MAX,0.01)
cols=brewer.pal(8,"RdYlBu")
heatmap_cols <- rev(colorRampPalette(cols)(length(heatmap_breaks)-1))

R = list()
D.DCOR.r <- as.dist(1-cor(t(DCOR), method="pearson")) + dist(DCOR)
D.DCOR.c <- as.dist(1-cor(DCOR, method="pearson")) + dist(t(DCOR))
Rowv <- rowMeans(DCOR, na.rm = TRUE)
Colv <- colMeans(DCOR, na.rm = TRUE)
R$Rhclust <- as.dendrogram(hclust(D.DCOR.r, method="average"))
R$Rhclust <- reorder(R$Rhclust, Rowv)
R$Chclust <- as.dendrogram(hclust(D.DCOR.c, method="average"))
R$Chclust <- reorder(R$Chclust, Colv)

R$rowInd <- order.dendrogram(R$Rhclust)
R$colInd <- order.dendrogram(R$Chclust)
G <- DCOR[R$rowInd, R$colInd]

save(R, DCOR, file="dcor.all.hclust.RData")

Img <- t(G)[,seq(nrow(G),1,-1)]
w <- ncol(G); h <- nrow(G)

png("all_dcor_hclust.png", width=w, height=h)
image(1:w, 1:h, Img, col=col, breaks=heatmap_breaks, axes=FALSE, xlab="", ylab="", useRaster=T)
dev.off()

