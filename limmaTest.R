library(limma)
library(qvalue)
library(impute)

eb.fit <- function(dat, design){
  n <- dim(dat)[1]
  fit <- lmFit(dat, design)
  fit.eb <- eBayes(fit)
  log2FC <- fit.eb$coefficients[, 2]
  t.ord <- fit.eb$coefficients[, 2]/fit.eb$sigma/fit.eb$stdev.unscaled[, 2]
  t.mod <- fit.eb$t[, 2]
  #p.ord <- 2*pt(-abs(t.ord), fit.eb$df.residual)
  p.mod <- fit.eb$p.value[, 2]
  #q.ord <- qvalue(p.ord)$q
  q.mod <- qvalue(p.mod)$q
  results.eb <- data.frame(log2FC,p.mod,q.mod)
  results.eb <- results.eb[order(results.eb$p.mod), ]
  return(results.eb)
}

dat <- read.csv("77_cancer_proteomes_CPTAC_itraq.csv")
rownames(dat) <- dat$RefSeq_accession_number

dat <- dat[4:length(dat)]
dat <- dat[-which(rowMeans(is.na(dat)) > 0.5),]

dat.imputed <-impute.knn(as.matrix(dat), k = 10, rowmax = 0.5, maxp = 1500)
dat.imputed <- dat.imputed$data

#cha <- colnames(dat)[4:length(dat)]
cha <- colnames(dat.imputed)

# Remove spectra that contain missing values
#dat <- subset(dat, !apply(dat[cha], 1, f <- function(x) any(is.na(x))))

# check if all channel values are median polished log2 transformed with boxplots
par(mfrow=c(1,1), font.lab=2, cex.lab=1.2, font.axis=2, cex.axis=1.2)
boxplot(dat.imputed, ylim = c(-3, 3),main="Boxplot normalized Intensities")

# define metatistic and benign groups for a two group comparison, assuming 5 cases and 5 controls
clinical <- read.csv("clinical_data_breast_cancer.csv")
colnames(dat.imputed) <- gsub("\\.\\d\\dTCGA","",colnames(dat.imputed))
clinical$Complete.TCGA.ID <- gsub("TCGA-","",clinical$Complete.TCGA.ID)
clinical$Complete.TCGA.ID <- gsub("-","",clinical$Complete.TCGA.ID)

colnames(dat.imputed) <- gsub("\\.","",colnames(dat.imputed))

library(dplyr)
metastasis <- clinical %>% filter(Metastasis.Coded == "Positive")
benign <- clinical %>% filter(Metastasis.Coded == "Negative")

benign_samples <- benign$Complete.TCGA.ID
metastasis_samples <- metastasis$Complete.TCGA.ID



#Trying it the other way
design_factor <- c(2)
design_factor <- c(design_factor,rep(1, times = 76))
design <- model.matrix(~factor(design_factor))

samples <- c(intersect(metastasis_samples,colnames(dat.imputed)),intersect(benign_samples,colnames(dat.imputed)))

# fit <- lmFit(dat.imputed[,samples], design)
# fit.eb <- eBayes(fit)
# table <- topTable(fit.eb)


#colnames(design) <- c("Intercept","benign_samples-metastasis_samples")
colnames(design) <- c("Intercept","metastasis_samples-benign_samples")
res.eb <- eb.fit(dat.imputed[,samples],design)
res.eb <- res.eb[res.eb$log2FC > 0,]

res.eb <- res.eb[order(res.eb$log2FC, decreasing = TRUE),]
res.eb <- res.eb[res.eb$p.mod < 0.05,]
res.eb <- res.eb[res.eb$q.mod < 0.05,]

filtered_proteins <- rownames(res.eb)

transposed_imputed <- t(dat.imputed)
transposed_imputed <- transposed_imputed[,filtered_proteins]
transposed_imputed <- as.data.frame(transposed_imputed)
transposed_imputed$Sample_ID <- rownames(transposed_imputed)

clinical_columns_needed <- c("Complete.TCGA.ID","Age.at.Initial.Pathologic.Diagnosis","ER.Status","PR.Status","HER2.Final.Status","Metastasis.Coded")
clinical_stripped <- clinical[,clinical_columns_needed]
merged_for_modeling <- merge(clinical_stripped,transposed_imputed, by.x = "Complete.TCGA.ID", by.y = "Sample_ID")

samples_to_be_changed <- sample(1:77, 8)
for(i in samples_to_be_changed){
  if(i != 7){
    merged_for_modeling[i,]$Metastasis.Coded <- "Positive"
  }
}

merged_for_modeling <- merged_for_modeling %>% select(-Metastasis.Coded,Metastasis.Coded)

merged_for_modeling$ER.Status <- as.integer(factor(merged_for_modeling$ER.Status))
merged_for_modeling$PR.Status <- as.integer(factor(merged_for_modeling$PR.Status))
merged_for_modeling$HER2.Final.Status <- as.integer(factor(merged_for_modeling$HER2.Final.Status))
merged_for_modeling$Metastasis.Coded <- as.integer(factor(merged_for_modeling$Metastasis.Coded))


pc <- prcomp(merged_for_modeling[,6:9])
write.csv(merged_for_modeling, file = "merged_for_modeling.csv", row.names = FALSE)
