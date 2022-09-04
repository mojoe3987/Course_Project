#Packages
install.packages("dplyr")
library(dplyr)
install.packages("reshape2")
library(reshape2)

#Reading the data
URL_subject_train <- "https://raw.githubusercontent.com/mojoe3987/Course_Project/main/subject_train.txt"
download.file(URL_subject_train,"C:/Users/joerling/Dropbox/Sonstiges/Learning_Data_Science/Getting_and_Cleaning_Data/Course Project/UCI HAR Dataset/train/subject_train.txt")
subject_train <- read.table("C:/Users/joerling/Dropbox/Sonstiges/Learning_Data_Science/Getting_and_Cleaning_Data/Course Project/UCI HAR Dataset/train/subject_train.txt")

URL_X_train <- "https://raw.githubusercontent.com/mojoe3987/Course_Project/main/X_train.txt"
download.file(URL_X_train,"C:/Users/joerling/Dropbox/Sonstiges/Learning_Data_Science/Getting_and_Cleaning_Data/Course Project/UCI HAR Dataset/train/X_train.txt")
X_train <- read.table("C:/Users/joerling/Dropbox/Sonstiges/Learning_Data_Science/Getting_and_Cleaning_Data/Course Project/UCI HAR Dataset/train/X_train.txt")

URL_y_train <- "https://raw.githubusercontent.com/mojoe3987/Course_Project/main/y_train.txt"
download.file(URL_y_train,"C:/Users/joerling/Dropbox/Sonstiges/Learning_Data_Science/Getting_and_Cleaning_Data/Course Project/UCI HAR Dataset/train/y_train.txt")
y_train <- read.table("C:/Users/joerling/Dropbox/Sonstiges/Learning_Data_Science/Getting_and_Cleaning_Data/Course Project/UCI HAR Dataset/train/y_train.txt")

URL_subject_test <- "https://raw.githubusercontent.com/mojoe3987/Course_Project/main/subject_test.txt"
download.file(URL_subject_test,"C:/Users/joerling/Dropbox/Sonstiges/Learning_Data_Science/Getting_and_Cleaning_Data/Course Project/UCI HAR Dataset/test/subject_test.txt")
subject_test <- read.table("C:/Users/joerling/Dropbox/Sonstiges/Learning_Data_Science/Getting_and_Cleaning_Data/Course Project/UCI HAR Dataset/test/subject_test.txt")

URL_X_test <- "https://raw.githubusercontent.com/mojoe3987/Course_Project/main/X_test.txt"
download.file(URL_X_test,"C:/Users/joerling/Dropbox/Sonstiges/Learning_Data_Science/Getting_and_Cleaning_Data/Course Project/UCI HAR Dataset/test/X_test.txt")
X_test <- read.table("C:/Users/joerling/Dropbox/Sonstiges/Learning_Data_Science/Getting_and_Cleaning_Data/Course Project/UCI HAR Dataset/test/X_test.txt")

URL_y_test <- "https://raw.githubusercontent.com/mojoe3987/Course_Project/main/y_test.txt"
download.file(URL_y_test,"C:/Users/joerling/Dropbox/Sonstiges/Learning_Data_Science/Getting_and_Cleaning_Data/Course Project/UCI HAR Dataset/test/y_test.txt")
y_test <- read.table("C:/Users/joerling/Dropbox/Sonstiges/Learning_Data_Science/Getting_and_Cleaning_Data/Course Project/UCI HAR Dataset/test/y_test.txt")

URL_features <- "https://github.com/mojoe3987/Course_Project/blob/main/features.txt"
download.file(URL_features,"C:/Users/joerling/Dropbox/Sonstiges/Learning_Data_Science/Getting_and_Cleaning_Data/Course Project/UCI HAR Dataset/features.txt")
features <- read.table("C:/Users/joerling/Dropbox/Sonstiges/Learning_Data_Science/Getting_and_Cleaning_Data/Course Project/UCI HAR Dataset/features.txt")

#Name variables
names(subject_test)[names(subject_test) == 'V1'] <- 'subject'
names(subject_train)[names(subject_train) == 'V1'] <- 'subject'
names(y_test)[names(y_test) == 'V1'] <- 'activity'
names(y_train)[names(y_train) == 'V1'] <- 'activity'

features <- features[,2]
colnames(X_test) <- features
colnames(X_train) <- features

#Merge and sort data
train_merged <- cbind(subject_train,y_train,X_train)
test_merged <- cbind(subject_test,y_test,X_test)
df_merged <- rbind(train_merged,test_merged)

df_merged <- df_merged[order(df_merged$subject,df_merged$activity),]

#Extract the measurements on the mean and standard deviation for each measurement
means <- as.data.frame(colMeans(df_merged[3:563]))
colnames(means) <- "means"
SDs <- as.data.frame(sapply(df_merged[3:563], sd))
colnames(SDs) <- "SD"

#Use descriptive activity names for activities in the data set
df_merged["activity"][df_merged["activity"] == "1"] <- "walking"
df_merged["activity"][df_merged["activity"] == "2"] <- "walkingupstairs"
df_merged["activity"][df_merged["activity"] == "3"] <- "walkingdownstairs"
df_merged["activity"][df_merged["activity"] == "4"] <- "sitting"
df_merged["activity"][df_merged["activity"] == "5"] <- "standing"
df_merged["activity"][df_merged["activity"] == "6"] <- "laying"

#Creating a second, independent tidy data set with the average of each variable for each activity and each subject.
df_melt <- melt(df_merged, id = c("subject","activity"))
ds_cast <- dcast(df_melt, subject + activity ~ variable,mean)
write.table(ds_cast, file = "C:/Users/joerling/Dropbox/Sonstiges/Learning_Data_Science/Getting_and_Cleaning_Data/Course Project/Course_Project/ds_cast.txt", row.names = FALSE)