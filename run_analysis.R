#Load packages
library("plyr")

#Create Training Dataset and select mean & standard deviation columns, add colums from other sets
train<-read.table("/Users/triston/Desktop/Data Science Work/UCI HAR Dataset/train/X_train.txt",header=F)
w.colnames<-read.table("/Users/triston/Desktop/Data Science Work/UCI HAR Dataset/features.txt")[,2]
colnames(train)<-w.colnames
train<-subset(train, select = grep("mean\\(\\)|std\\(\\)", names(train)))
activity<- read.table("/Users/triston/Desktop/Data Science Work/UCI HAR Dataset/train/y_train.txt",header=F)
subject<-  read.table("/Users/triston/Desktop/Data Science Work/UCI HAR Dataset/train/subject_train.txt",header=F)
ActivityID<-as.vector(activity[,1])
SubjectID<-as.vector(subject[,1])
train.set<-cbind(train,ActivityID,SubjectID)
train.set$set<-c("train")

#Create Test Training Dataset, selecting mean & standard dev columns, adding in additional columns
test<-read.table("/Users/triston/Desktop/Data Science Work/UCI HAR Dataset/test/X_test.txt",header=F)
colnames(test)<-w.colnames
test<-subset(test, select = grep("mean\\(\\)|std\\(\\)", names(test)))
activity<-read.table("/Users/triston/Desktop/Data Science Work/UCI HAR Dataset/test/y_test.txt",header=F)
subject<-read.table("/Users/triston/Desktop/Data Science Work/UCI HAR Dataset/test/subject_test.txt",header=F)
ActivityID<-as.vector(activity[,1])
SubjectID<-as.vector(subject[,1])
test.set<-cbind(test,ActivityID,SubjectID)
test.set$set<-c("test")

##Prep for Rbind & Rbind them
rownames(test)<-seq(nrow(train)+1,nrow(test)+nrow(train))
w.df<-rbind(train.set,test.set)

##Replace Column names
w.colnames<-colnames(w.df)
w.colnames <- gsub("\\()","",w.colnames)
w.colnames <- gsub("-std","StdDev",w.colnames)
w.colnames <- gsub("-mean","Mean",w.colnames)
w.colnames <- gsub("^(t)","Time.",w.colnames)
w.colnames <- gsub("^(f)","Freq.",w.colnames)
w.colnames <- gsub("Gravity","Gravity.",w.colnames)
w.colnames <- gsub("Body","Body.",w.colnames)
w.colnames <- gsub("Gyro","Gyro.",w.colnames)
w.colnames <- gsub("Acc","Acceleration.",w.colnames)
w.colnames <- gsub("Jerk","Jerk.",w.colnames)
w.colnames <- gsub("Mag","Magnitude.",w.colnames)
w.colnames <- gsub("Body\\.Body","Body",w.colnames)
w.colnames <- gsub("-X",".X",w.colnames)
w.colnames <- gsub("-Y",".Y",w.colnames)
w.colnames <- gsub("-Z",".Z",w.colnames)

colnames(w.df)<-w.colnames

#Average The Data Across Activity and Subject
w.tidy<-ddply(w.df[,-69],.(ActivityID,SubjectID),colMeans)

#Print final Table
write.table(w.tidy, file="WearablesTidyData", row.names=FALSE)


