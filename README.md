# breast-cancer-proteomics-machine-learning-project

This is a simple machine learning project that uses proteomics breast cancer data from a [CPTAC study](https://www.nature.com/articles/nature18003), 
in order to train a logistic regression model for breast cancer metastases prediction. 

## Goal
The goal of this project was to find a way to use proteomics abundances from tandem mass tag mass spectrometry data, in combination with
clinical categorical variables, and create a logistic regression model for breast cancer metastases prediction. 

## Project workflow
1. Conduct data pre-processing and QC on proteomics profile data.
2. Conduct empirical bayes statistics for differential expression analysis limma to filter for top ranked statistically significant       proteins to be put into prediction model.
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

PCA check for batch effects. Points represent the samples from study.:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
![alt text](https://github.com/wongak626/breast-cancer-proteomics-machine-learning-project/blob/master/plots/PCA.png)

Confusion matrix:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
![alt text](https://github.com/wongak626/breast-cancer-proteomics-machine-learning-project/blob/master/plots/Slide26.jpg)
      
      
ROC curve for prediction model:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
![alt text](https://github.com/wongak626/breast-cancer-proteomics-machine-learning-project/blob/master/ROC.png)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
As you can see this mode isn't very accurate as the area under the curve is 0.59. This might be due to a low number of samples, or that the features selected for this model aren't very accurate.


## Discussion






