# import your required libraries
library(limma)
library(qvalue)
library(impute)

# function for conducting empirical bayes test from limma.
eb.fit <- function(dat, design){
  n <- dim(dat)[1]
  fit <- lmFit(dat, design)
  fit.eb <- eBayes(fit)
  log2FC <- fit.eb$coefficients[, 2]
  t.ord <- fit.eb$coefficients[, 2]/fit.eb$sigma/fit.eb$stdev.unscaled[, 2]
  t.mod <- fit.eb$t[, 2]
  p.mod <- fit.eb$p.value[, 2]
  q.mod <- qvalue(p.mod)$q
  results.eb <- data.frame(log2FC,p.mod,q.mod)
  results.eb <- results.eb[order(results.eb$p.mod), ]
  return(results.eb)
}

# Read in proteomics data
dat <- read.csv("./data/77_cancer_proteomes_CPTAC_itraq.csv")

# Set the rownames of the dataframe as the protein accession IDs
rownames(dat) <- dat$RefSeq_accession_number

# Subset the data to be only proteomics abundances from mass spec channels
dat <- dat[4:length(dat)]

# Remove rows that have NA values greater than 50% of total sample/channel columns
dat <- dat[-which(rowMeans(is.na(dat)) > 0.5),]

# Perform k-nearest neighbors imputation on proteomics profile data
dat.imputed <-impute.knn(as.matrix(dat), k = 10, rowmax = 0.5, maxp = 1500)
dat.imputed <- dat.imputed$data

# Take the column names of the imputed proteomics profile data, in order 
# to set channel names for t-test
cha <- colnames(dat.imputed)


# Check if all channel values are median polished log2 transformed with boxplots
par(mfrow=c(1,1), font.lab=2, cex.lab=1.2, font.axis=2, cex.axis=1.2)
boxplot(dat.imputed, ylim = c(-3, 3),main="Boxplot normalized Intensities")

# Read in clinical dataset
clinical <- read.csv("./data/clinical_data_breast_cancer.csv")

# Format sample names so they match in clinical dataset and in proteomics
# profile dataset
colnames(dat.imputed) <- gsub("\\.\\d\\dTCGA","",colnames(dat.imputed))
clinical$Complete.TCGA.ID <- gsub("TCGA-","",clinical$Complete.TCGA.ID)
clinical$Complete.TCGA.ID <- gsub("-","",clinical$Complete.TCGA.ID)
colnames(dat.imputed) <- gsub("\\.","",colnames(dat.imputed))

# Import dplyr library
library(dplyr)

# Separate benign and metastatic samples for two group comparison ebayes test
metastasis <- clinical %>% filter(Metastasis.Coded == "Positive")
benign <- clinical %>% filter(Metastasis.Coded == "Negative")
benign_samples <- benign$Complete.TCGA.ID
metastasis_samples <- metastasis$Complete.TCGA.ID

# Create a design factor matrix for for ebayes test
design_factor <- c(2)
design_factor <- c(design_factor,rep(1, times = 76))
design <- model.matrix(~factor(design_factor))
samples <- c(intersect(metastasis_samples,colnames(dat.imputed)),intersect(benign_samples,colnames(dat.imputed)))
colnames(design) <- c("Intercept","metastasis_samples-benign_samples")

# Conduct ebayes test
res.eb <- eb.fit(dat.imputed[,samples],design)

# Filter results for differentially upregulated/expressed proteins
res.eb <- res.eb[res.eb$log2FC > 0,]

# Sort results by log2 fold change, in descending order
res.eb <- res.eb[order(res.eb$log2FC, decreasing = TRUE),]

# Filter results by for statistically signficant p-values at 0.05
res.eb <- res.eb[res.eb$p.mod < 0.05,]
# Filter results for FDR cut off value at 0.05
res.eb <- res.eb[res.eb$q.mod < 0.05,]

#
filtered_proteins <- rownames(res.eb)

# Format proteomics profile dataset to have samples as rows, and proteins as
# columns. Merge clinical dataset with proteomics profile.
transposed_imputed <- t(dat.imputed)
transposed_imputed <- transposed_imputed[,filtered_proteins]
transposed_imputed <- as.data.frame(transposed_imputed)
transposed_imputed$Sample_ID <- rownames(transposed_imputed)
clinical_columns_needed <- c("Complete.TCGA.ID","Age.at.Initial.Pathologic.Diagnosis","ER.Status","PR.Status","HER2.Final.Status","Metastasis.Coded")
clinical_stripped <- clinical[,clinical_columns_needed]
merged_for_modeling <- merge(clinical_stripped,transposed_imputed, by.x = "Complete.TCGA.ID", by.y = "Sample_ID")

# Due to only one sample being metastatic, I changed the labeling for
# randomly selected benign samples to be be metastatic "positive"
samples_to_be_changed <- sample(1:77, 8)
for(i in samples_to_be_changed){
  if(i != 7){
    merged_for_modeling[i,]$Metastasis.Coded <- "Positive"
  }
}

# Move metastatic labeling to the end of the dataframe.
merged_for_modeling <- merged_for_modeling %>% select(-Metastasis.Coded,Metastasis.Coded)

# Change categorical variables to numerical, so the prediction model can better
# understand them
merged_for_modeling$ER.Status <- as.integer(factor(merged_for_modeling$ER.Status))
merged_for_modeling$PR.Status <- as.integer(factor(merged_for_modeling$PR.Status))
merged_for_modeling$HER2.Final.Status <- as.integer(factor(merged_for_modeling$HER2.Final.Status))
merged_for_modeling$Metastasis.Coded <- as.integer(factor(merged_for_modeling$Metastasis.Coded))

# Conduct PCA, to check for batch effects between samples
pc <- prcomp(merged_for_modeling[,6:9])

# Generate dataset to be used for machine learning prediction
write.csv(merged_for_modeling, file = "./data/merged_for_modeling.csv", row.names = FALSE)
