#importing the libraries
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

#importing our cancer dataset
dataset = pd.read_csv('merged_for_modeling.csv')
X = dataset.iloc[:, 1:8].values
Y = dataset.iloc[:,9].values



#print(X)
# print(Y)
#print(dataset.head())



#Encoding categorical data values

# from sklearn.preprocessing import LabelEncoder
# labelencoder_Y = LabelEncoder()
# Y = labelencoder_Y.fit_transform(Y)




from sklearn.model_selection import train_test_split
X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size = 0.25, random_state = 0)

#Feature Scaling
from sklearn.preprocessing import StandardScaler
sc = StandardScaler()
X_train = sc.fit_transform(X_train)
X_test = sc.transform(X_test)



#Using Logistic Regression Algorithm to the Training Set

from sklearn.linear_model import LogisticRegression
classifier = LogisticRegression(random_state = 0)
classifier.fit(X_train, Y_train)



Y_pred = classifier.predict(X_test)

Y_prob = classifier.predict_proba(X_test)
preds = Y_prob[:,1]


# print(len(Y_pred))
print(Y_prob)
print(preds)
print(Y_test)




from sklearn.metrics import confusion_matrix
cm = confusion_matrix(Y_test, Y_pred)

print(cm)

from sklearn import metrics
from sklearn.metrics import auc

fpr, tpr, threshold = metrics.roc_curve(Y_test, preds,pos_label=2)
roc_auc = metrics.auc(fpr,tpr)

plt.title('Receiver Operating Characteristic')
plt.plot(fpr, tpr, 'b', label = 'AUC = %0.2f' % roc_auc)
plt.legend(loc = 'lower right')
plt.plot([0, 1], [0, 1],'r--')
plt.xlim([0, 1])
plt.ylim([0, 1])
plt.ylabel('True Positive Rate')
plt.xlabel('False Positive Rate')
plt.show()

print("Accuracy:",metrics.accuracy_score(Y_test, Y_pred))
print("Precision:",metrics.precision_score(Y_test, Y_pred))
print("Recall:",metrics.recall_score(Y_test, Y_pred))



