#Loading the required packages
library(caret)

#Downloading the data
download.file('https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv', 'train.csv')
download.file('https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv', 'test.csv')

#Reading the data
training <- read.csv('train.csv')
test <- read.csv('test.csv')

#Splitting the data to create a validation set
trainIndex <- createDataPartition(training$classe, p = 0.75, list = FALSE)
validation <- training[-trainIndex,]
training <- training[trainIndex,]

#Removing columns with NA values
nacol <- numeric()
for(i in 1:length(training)){
  if(any(is.na(training[i]))){nacol <- append(nacol, i)}
}

training <- training[-nacol]

#Removing non-numeric columns
training <- training[-(1:7)]

#Removing columns with near zero variance
nzv <- nearZeroVar(training)
training <- training[-nzv]

#Training a model using random forests
model <- train(classe~., data = training, method = 'rf')