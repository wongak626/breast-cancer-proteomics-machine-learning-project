# breast-cancer-proteomics-machine-learning-project

This is a simple machine learning project that uses proteomics breast cancer data from a [CPTAC study](https://www.nature.com/articles/nature18003), 
in order to train a logistic regression model for breast cancer metastases prediction. 

## Goal
The goal of this project was to find a way to use proteomics abundances from tandem mass tag mass spectrometry data, in combination with
clinical categorical variables, and create a logistic regression model for breast cancer metastases prediction. 

## Project workflow

## Tools/Software required for this project
1. R statistical programming: used bioconductor package with limma, qvalue, and impute packages. 
2. Python: used numpy, matplotlib, and pandas libraries for this project.

## Data used for this project
Data for this project was used from this [study](https://www.nature.com/articles/nature18003). For the sake of convenience, I used an 
abbreviated version from [kaggle](https://www.kaggle.com/piotrgrabo/breastcancerproteomes).

## Results
Confusion matrix:
      

ROC curve for prediction model:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
![alt text](https://github.com/wongak626/breast-cancer-proteomics-machine-learning-project/blob/master/ROC.png)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
As you can see this mode isn't very accurate as the area under the curve is 0.59. This might be due to a low number of samples, or that the features selected for this model aren't very accurate.


## Future Directions





