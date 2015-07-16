rm(list=ls())
setwd('C:/Coursera/Getting and cleaning data')

if(!dir.exists('project')){
        dir.create('project')
}

setwd('C:/Coursera/Getting and cleaning data/project')

# load features text file

features<-read.table('./UCI HAR Dataset/features.txt')

# Extracts only the measurements on the mean and standard deviation & label descriptive variable names
featuresselect<-grep('.*mean.*|.*std.*',features[,2])
sub_featuresselect<-features[featuresselect,2]
sub_featuresselect<-gsub('[()]','',sub_featuresselect)
sub_featuresselect<-gsub('^(t)','Time-',sub_featuresselect)
sub_featuresselect<-gsub('^(f)','Freq-',sub_featuresselect)
sub_featuresselect<-gsub('JerkMag','-JerkMagnitude',sub_featuresselect)
sub_featuresselect<-gsub('GyroMag','-GyroMagnitude',sub_featuresselect)
sub_featuresselect<-gsub('AccMag','-AccMagnitude',sub_featuresselect)

# load data
x_train<-read.table('./UCI HAR Dataset/train/x_train.txt')[featuresselect]
y_train<-read.table('./UCI HAR Dataset/train/y_train.txt')
sub_train<-read.table('./UCI HAR Dataset/train/subject_train.txt')
train<-cbind(sub_train,x_train,y_train)

x_test<-read.table('./UCI HAR Dataset/test/x_test.txt')[featuresselect]
y_test<-read.table('./UCI HAR Dataset/test/y_test.txt')
sub_test<-read.table('./UCI HAR Dataset/test/subject_test.txt')
test<-cbind(sub_test,x_test,y_test)

# merage train and test data
data<-rbind(train,test)
colnames(data)<-c('subject',sub_featuresselect,'activity_label')

# add descriptive activity name 
lable<-read.table('./UCI HAR Dataset/activity_labels.txt')

if(!require(plyr)){
        install.packages('plyr')
        library(plyr)
}

data<-merge(data,lable,by.x='activity_label',by.y='V1')
colnames(data)[82]<-'activity_Name'

write.csv(data,'tidydata.csv',row.names=F)

# creates a second, independent tidy data set with the average of each variable for each activity and each subject
data_avg<-ddply(data,.(subject,activity_Name),function(x){colMeans(x[,3:81])})

write.table(data_avg,'averagedata.txt',row.names=FALSE)
