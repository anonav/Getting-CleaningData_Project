####Downloading and unzipping: places folder"UCI HAR Dataset" in working directory####
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp,method="curl")
unzip(temp)

####Column binding subject_train, y_train and X_train (7352 obs. of  563 variables)####
Xtrain <- read.table("UCI HAR Dataset\\train\\X_train.txt",
                stringsAsFactors = FALSE,
                nrows = -1, 
                colClasses = c(rep("numeric",561)))

ytrain <- read.table("UCI HAR Dataset\\train\\y_train.txt",
                stringsAsFactors = FALSE,
                nrows = -1,
                colClasses="factor")
ytrain$V1<-factor(ytrain$V1,labels=c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS",
                                     "SITTING", "STANDING", "LAYING"))
names(ytrain)<- "activity_name"

subjecttrain <- read.table("UCI HAR Dataset\\train\\subject_train.txt",
                stringsAsFactors = FALSE,
                nrows = -1)
names(subjecttrain)<-"subjectID"

traindata<-cbind(subjecttrain,ytrain,Xtrain)

####Column binding subject_test, y_test and X_test (2947 obs. of  563 variables)####
Xtest <- read.table("UCI HAR Dataset\\test\\X_test.txt",
                stringsAsFactors = FALSE,
                nrows = -1, 
                colClasses = c(rep("numeric",561)))

ytest <- read.table("UCI HAR Dataset\\test\\y_test.txt",
                stringsAsFactors = FALSE,
                nrows = -1,
                colClasses="factor")
ytest$V1<-factor(ytest$V1,labels=c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS",
                                     "SITTING", "STANDING", "LAYING"))
names(ytest)<- "activity_name"

subjecttest <- read.table("UCI HAR Dataset\\test\\subject_test.txt",
                stringsAsFactors = FALSE,
                nrows = -1)
names(subjecttest)<-"subjectID"

testdata<-cbind(subjecttest,ytest,Xtest)

####Row binding traindata and testdata (10299 obs. of  563 variables)####
fulldata<-rbind(traindata,testdata)

####Reading 561 feature list####
features<-read.table("UCI HAR Dataset\\features.txt",
                stringsAsFactors = FALSE,colClasses = c("NULL", "character"))

####Renaming features of fulldata####
namesOFfulldata<- names(fulldata)
namesOFfulldata[3:563]<-features$V2
names(fulldata)<- namesOFfulldata

####Extracting column names with mean() and std() into smalldata (10299 obs. of  68 variables)####
feat <- grep("*-mean\\(|-std*", features$V2, value = TRUE)
smalldata<-fulldata[,c("subjectID","activity_name",feat)]

####Calculating averages for every combination of subjectID, activity_name and 66 measurement variables#### 
x<-smalldata[,feat]
mean_DF <-aggregate(x, by=list(smalldata$subjectID, smalldata$activity_name),FUN=mean, na.rm=TRUE)
tidy<- mean_DF[order(mean_DF$Group.1 , mean_DF$Group.2),]
names(tidy)[1:2]<- c("subjectID","activity_name")

####Writing tidy file (180 obs. of  68 variables) ####
write.table(tidy, file = "tidy.txt",row.names=FALSE)












