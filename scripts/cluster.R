library(ConsensusClusterPlus)
library(matrixStats)
library(ggplot2)
library(caTools)
library(dplyr)

uro <- read.csv("data/uromol_exprs.csv", row.names = 1, check.names = F)
kno <- read.csv("data/knowles_exprs.csv", row.names = 1, check.names = F)

common <- intersect(colnames(uro), colnames(kno))
uromol_sub <- t(as.matrix(uro[, common, drop=FALSE]))
knowles_sub <- t(as.matrix(kno[, common, drop=FALSE]))

# uromol
rv <- rowVars(uromol_sub)
select_idx <- order(rv, decreasing = TRUE)

plot_data <- data.frame(
  Rank = 1:length(rv),
  Variance = rv[select_idx]
)

k = 500
ggplot(plot_data[1:5000, ], aes(x = Rank, y = Variance)) +
  geom_line(color = "navy", size = 1) +
  geom_vline(xintercept = k, linetype = "dashed", color = "red") +
  theme_minimal() +
  labs(
    title = "Variance Elbow Plot",
    x = "Gene Rank (Sorted by Variance)",
    y = "Variance",
    subtitle = paste("Red line indicates K =", k)
  )

uromol_topk <- uromol_sub[select_idx[1:k], ]

results <- ConsensusClusterPlus(d = uromol_topk, seed = 123, clusterAlg = 'pam')

clusters <- results[[2]][["consensusClass"]]
uromol <- read.csv("data/uromol_meta.csv", row.names = 1)
uromol$cluster <- factor(clusters)
uromol <- mutate(uromol, cluster = if_else(cluster == 1, "C1", "C2"))
# uromol <- dplyr::filter(uromol, cluster != 1)

surv_obj <- Surv(time = uromol$RFS_time, event = uromol$Recurrence)
fit_km <- survfit(surv_obj ~ cluster, data = uromol)

ggsurvplot(
  fit_km,
  data = uromol,
  risk.table = TRUE,
  pval = TRUE,
  conf.int = TRUE,
  xlab = "Recurrence-free survival time",
  ylab = "Recurrence-free survival probability",
  legend.title = "Cluster",
  legend.labs = levels(uromol$cluster)
  # legend.labs = c("2", "3")
)

write.csv(uromol, "data/uromol_meta_labelled.csv", row.names = F, quote = F)
write.csv(t(uromol_topk), "data/uromol_top500.csv", quote = F)
