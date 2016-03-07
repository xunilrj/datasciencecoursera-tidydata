#  Codebook for the Getting and cleaning data Assignment


The dataset is based on and is a summary of the dataset used in the study  "Human Activity Recognition Using Smartphones Dataset" by Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio and Luca Oneto (for more details refer to http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

The experiments have been carried out with a group of 30 volunteers (subjects) within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually.  

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

The exact list of features available in the provided dataset is provided below.

One record in the initial dataset of Reyes-Ortiz et al. related to a certain subject, certain activity and a certain time window. We use the number of the record in the initial dataset in our dataset as well.

The variables contained in the dataset are described as follows:

1. activity: each of the six activities mentioned above (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
2. subject: an identifier (from 1 to 30) of the subject who carried out the experiment
3. obs: identifier of record in the initial dataset
4. feature:  the feature measured, it takes one of the following values:

         tBodyAcc-XYZ
         tGravityAcc-XYZ
         tBodyAccJerk-XYZ
         tBodyGyro-XYZ
         tBodyGyroJerk-XYZ
         tBodyAccMag
         tGravityAccMag
         tBodyAccJerkMag
         tBodyGyroMag
         tBodyGyroJerkMag
         fBodyAcc-XYZ
         fBodyAccJerk-XYZ
         fBodyGyro-XYZ
         fBodyAccMag
         fBodyAccJerkMag
         fBodyGyroMag
         fBodyGyroJerkMag
5. mean: mean value of the respective feature relating to the respective activity, respective subject and respective observation
6. sub: standard deviation of the respective feature relating to the respective activity, respective subject and respective observation
7. avg_mean: average (across all observations) mean value of the respective feature  relating to the respective activity and the respective subject 
8. avg_std: average (across all observations) standard deviation of the respective feature  relating to the respective activity and the respective subject 


The original dataset of Reyes-Ortiz et al. was randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. In our dataset we merged both set and do not distinguish between training and test data.


Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

