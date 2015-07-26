---
title: "Practical ML"
author: "Aaditya Bhat"
date: "July 26, 2015"
output: html_document
---

#Introduction
Using devices such as Jawbone Up, Nike FuelBand, and Fitbit it is now possible to collect a large amount of data about personal activity relatively inexpensively. These type of devices are part of the quantified self movement - a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. One thing that people regularly do is quantify how much of a particular activity they do, but they rarely quantify how well they do it. In this project, your goal will be to use data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants. They were asked to perform barbell lifts correctly and incorrectly in 5 different ways. More information is available from the website here: http://groupware.les.inf.puc-rio.br/har (see the section on the Weight Lifting Exercise Dataset).

##Cross-validation

Cross-validation is done by subsampling the training data set without replacements in two samples, 'training' & 'validation'. The model is built on training data set. The model is then tested on the validation data set. Model which performs well on validation data set.

##Model Building

We have to predict 'classe' variable, when given other variables. Various models will be built to predict 'classe' using various features. Model with maximum accuracy and minimum out of sample error will be selected as the final model. For this particular problem, 'Random Forests' with 52 features is the best model. 

##Expected out-of-sample error

The expected out-of-sample error will correspond to 1-Accuracy on the validation data set.


##Justification of choices

The outcome variable "classe" is an unordered factor variable. Hence, error is chosen as '1-accuracy'.The large sample size enables further subdiving of the training data set in to two data sets, 'training' & 'validation'. These two data sets are used for cross validation. To improve the model building, only relevant features are included. Variables with NA's & variables with near zero variablity are not included. Variables like name, datestamp, window are also excluded.


#Analysis

###Data Loading & Processing

Loading the required packages
```{r}
library(caret)
```

Downloading the data
```{r, eval = FALSE}
download.file('https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv', 'train.csv')
download.file('https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv', 'test.csv')
```

Reading the data
```{r}
training <- read.csv('train.csv')
test <- read.csv('test.csv')
```

Splitting the data to create a validation set
```{r}
trainIndex <- createDataPartition(training$classe, p = 0.75, list = FALSE)
validation <- training[-trainIndex,]
training <- training[trainIndex,]
```

Removing columns with NA values
```{r}
nacol <- numeric()
for(i in 1:length(training)){
  if(any(is.na(training[i]))){nacol <- append(nacol, i)}
}

training <- training[-nacol]
```

Removing non-numeric columns
```{r}
training <- training[-(1:7)]
```

Removing columns with near zero variance
```{r}
nzv <- nearZeroVar(training)
training <- training[-nzv]
```

##Model Fitting

Training a model using random forests
```{r, eval= FALSE}
model <- train(classe~., data = training, method = 'rf')
```

```{r, echo=FALSE}
model <- readRDS('model')
```
Summarizing the model
```{r}
model
```

In sample error is 1.02

###Testing the model on validation set
```{r}
valRes <- predict(model, newdata = validation)
confusionMatrix(valRes, validation$classe)
```

Out of Sample error is 0.57

###Testing the model on test set
```{r}
answers <- predict(model, newdata = test)
answers
```