# breast-cancer-proteomics-machine-learning-project

This is a simple machine learning project that uses proteomics breast cancer data from a [CPTAC study](https://www.nature.com/articles/nature18003), 
in order to train a logistic regression model for breast cancer metastases prediction. 

## Goal
The goal of this project was to find a way to use proteomics abundances from tandem mass tag mass spectrometry data, in combination with
clinical categorical variables, and create a logistic regression model for breast cancer metastases prediction. I wanted to try and replicate the prediction models used by cancer diagnostic companies for assessing risk. For example, [MammaPrint](https://www.agendia.com/our-tests/mammaprint/) uses several clinical features and 70 highly significant breast cancer genes associated with breast cancer recurrence to assess cancer metastatic risk. The goal of this project was to incorporte protein expression over gene expression, since gene expression isn't binary, due to cellular regulations during transcription and translation stages of genes.

## Project workflow
1. Conduct data pre-processing and QC on proteomics profile data.
2. Conduct empirical bayes statistics for differential expression analysis from limma package to filter for top ranked statistically          significant proteins to be put into prediction model. Used two groups: metastatic vs non-metastatic (benign).
3. Put pre-processed dataset for mapping into logistic regression modeling algorithm from sklearn python library, for training and testing
   prediction model.

## Tools/Software required for this project
1. R statistical programming: used bioconductor package with limma, qvalue, and impute packages. 
2. Python: used numpy, matplotlib, and pandas libraries for this project.

## Data used for this project
Data for this project was used from this [study](https://www.nature.com/articles/nature18003). For the sake of convenience, I used an 
abbreviated version from [kaggle](https://www.kaggle.com/piotrgrabo/breastcancerproteomes).

# Directions
1. Create a data folder for the proteomics profile data and clinical data.
2. Run limmaTest.R
3. Run logisticRegressionModel.py

## Results
QC check for log2 ratio median normalized proteomics abundance data:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
![alt text](https://github.com/wongak626/breast-cancer-proteomics-machine-learning-project/blob/master/plots/boxplotNormalizedIntensities.png)

PCA check for batch effects. Points represent the samples from study:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
![alt text](https://github.com/wongak626/breast-cancer-proteomics-machine-learning-project/blob/master/plots/PCA.png)

Top ranked differentially expressed after calculating t-test for metatistic vs benign samples, and filtering with 0.05 p-value/q-value cutoff:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
![alt text](https://github.com/wongak626/breast-cancer-proteomics-machine-learning-project/blob/master/Screen%20Shot%202019-04-05%20at%207.10.57%20AM.png)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

Confusion matrix:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
![alt text](https://github.com/wongak626/breast-cancer-proteomics-machine-learning-project/blob/master/plots/Slide26.jpg)
      
      
ROC curve for prediction model:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
![alt text](https://github.com/wongak626/breast-cancer-proteomics-machine-learning-project/blob/master/ROC.png)


## Discussion
For this project, no standard methods of feature selection was conducted for modeling. Due to the small scope and time constraints, I instead used what was available already in the clinical data, and the top ranked protein hits after filtering from the empirical bayes statistics from limma. Final logistic regression model function for this project looks like so:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

![alt test]()

The top ranked protein hits after filtering, need to be validated and looked after to see if their functionality is related and if they are part of the same pathway.

QC and the PCA batch effect check, show that even though the data is already ITRAQ log2 median normalized, there is still a lot of variation about the median, and that the data isn't stable. The PCA plot demonstrates that all of the samples clustered together, probably signifiying that all of the samples were done in one batch, or some other confounding factor is making them batch together like so. I believe this should not be the case as mass spec instruments can only fit a low number of samples per channel, and 77 is too many samples to analyze in one batch or run.

Since the sample size was already low, and there was only 1 sample labeled as metastatic, I randomly selected 8 benign samples to be changed from negative to positive for metastases. Changing labeled data is not normally recommended, but for the purposes of this project, more metastatic samples were required for properly training the model.

As you can see from the ROC curve, this prediction model isn't very accurate as the area under the curve is 0.59. This might be due to a low number of samples (77), or that the features selected for this model aren't very accurate.

Nonetheless, this project demonstrates that you can incoporate protein signatures into a logistic regression model for metastatic breast cancer prediction.

## Future Directions

1. Leverage more proteomics data (more samples) in order to create a better prediction model. 
2. Determine out a more stringent test for filtering top ranked proteins associated with breast cancer metatastases. 




