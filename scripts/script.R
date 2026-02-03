knowles <- readRDS("data/knowles_matched_TaLG_final.rds")
uromol <- readRDS("data/UROMOL_TaLG.teachingcohort.rds")

knowles_meta <- select(knowles, -exprs)
uromol_meta <- select(uromol, -exprs)
knowles_exprs <- knowles$exprs
uromol_exprs <- uromol$exprs

write.csv(knowles_meta, "data/knowles_meta.csv", quote = F, row.names = T, col.names = T)
write.csv(knowles_exprs, "data/knowles_exprs.csv", quote = F, row.names = T, col.names = T)
write.csv(uromol_meta, "data/uromol_meta.csv", quote = F, row.names = T, col.names = T)
write.csv(uromol_exprs, "data/uromol_exprs.csv", quote = F, row.names = T, col.names = T)