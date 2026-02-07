library(survival)
library(survminer)
library(broom)
library(dplyr)
library(ggplot2)

uromol <- read.csv("data/uromol_meta_labelled.csv")
uromol$cluster <- factor(uromol$cluster)
surv_obj <- Surv(time = uromol$RFS_time, event = uromol$Recurrence)
fit_km <- survfit(surv_obj ~ cluster, data = uromol)

ggsurvplot(
  fit_km,
  data = uromol,
  risk.table = TRUE,
  pval = TRUE,
  # conf.int = TRUE,
  xlab = "Recurrence-free survival time",
  ylab = "Recurrence-free survival probability",
  legend.title = "Cluster",
  legend.labs = levels(uromol$cluster),
)

fit_cox <- coxph(surv_obj ~ cluster, data = uromol)
fit_cox_clin <- coxph(surv_obj ~ cluster + Age + Sex + Smoking + 
                        Concomitant.CIS + Tumor.size + 
                        BCG + EAU.risk, data = uromol)


# Knowles analysis
knowles <- read.csv("data/knowles_meta_labelled.csv")
knowles$time <- ifelse(
  knowles$Recurrence == 1,
  knowles$RFS_time,
  knowles$FUtime_days. / 30
)
knowles$cluster <- factor(knowles$cluster)
surv_obj <- Surv(time = knowles$time, event = knowles$Recurrence)
fit_km <- survfit(surv_obj ~ cluster, data = knowles)

ggsurvplot(
  fit_km,
  data = knowles,
  risk.table = TRUE,
  pval = TRUE,
  # conf.int = TRUE,
  xlab = "Recurrence-free survival time",
  ylab = "Recurrence-free survival probability",
  legend.title = "Cluster",
  legend.labs = levels(knowles$cluster),
)

fit_cox <- coxph(surv_obj ~ cluster, data = knowles)
fit_cox_clin <- coxph(surv_obj ~ cluster + Age + Sex, data = knowles)

