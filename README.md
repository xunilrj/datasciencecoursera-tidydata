# Script Description

First, all need libraries are loaded. I included the splitstackshape becuase I have used the cSplit function, but later I have prefered the separate function.

    library(plyr)  
    library(tidyr)  
    library(dplyr)  
    library(splitstackshape)  
    
This function reads the dataset (test or train) and append its data to the consolidated csvs.

    AppendDataSet <- function (dataFolder, dataSet)
    {   

Here, I read all available features, separate its name and filter only the mean and std aggregators.

        features <- tbl_df(read.csv(file.path(dataFolder, "features.txt"), header = FALSE, sep = ' ')) %>%
          separate(V2, c("Feature","Aggregator","Axis")) %>%      
          filter(grepl("(std)|(mean)", Aggregator)) %>%      
          rename(FeatureId = V1)
          
Now I read the feature data. I have called each row the "Window" and appended a column describing its dataset.
        
        x <- tbl_df(read.csv(file.path(dataFolder, dataSet, paste("X_", dataSet, ".txt", sep ="")), header = FALSE, sep = "")) %>%
          select(features$FeatureId) %>%
          mutate(Window = as.integer(rownames(.)),
                 Dataset = dataSet) %>%
          melt(c("Window", "Dataset")) %>%
          rename(FeatureId = variable, Value = value) %>%
          mutate(FeatureId = as.numeric(gsub("[^\\d]+", "", FeatureId, perl=TRUE))) %>%
          join(features, type = "inner") %>%
          arrange(Dataset, Window, FeatureId) %>%
          select(Dataset, Window, Feature, Aggregator, Axis, Value)

Then I append the features in a CSV.

        writeHeaders <- !file.exists(file.path(dataFolder, 'features.csv'))
        write.table(x, file = file.path(dataFolder, "features.csv"), append = TRUE, sep = ",", col.names = writeHeaders, row.names = FALSE )
        
Now I read the activities data
    
    activities <- tbl_df(read.csv(file.path(dataFolder, "activity_labels.txt"), header = FALSE, sep = ' ')) %>%
      rename(ActivityId = V1, ActivityName = V2)    

And the subject data

    subject <- tbl_df(read.csv(file.path(dataFolder, dataSet, paste("subject_", dataSet, ".txt", sep = '')), header = FALSE)) %>%
      rename(SubjectId = V1) %>%
      mutate(SubjectId = as.integer(SubjectId)) %>%
      mutate(Dataset = dataSet)

Now I get the subject data of this dataset

    y <- tbl_df(read.csv(file.path(dataFolder, dataSet, paste("y_", dataSet, ".txt", sep ="")), header = FALSE, sep = ' ')) %>% 
      rename(ActivityId = V1) %>%
      mutate(Window = as.integer(rownames(.)))

and start with a base dataframe

    base <- cbind(y, subject) %>%
      join(activities) %>%
      select(Window, Dataset, ActivityName, SubjectId)
    names(base) <- c("Window", "Dataset", "Activity", "Subject")

This function is used to append the sensor data.

    appendData <- function (appendTo, name, melt = "before"){
      d <- tbl_df(read.csv(file.path(dataFolder, dataSet, 'Inertial Signals', paste(name, "_", dataSet, '.txt', sep = '')), header = FALSE, sep = "")) %>%
        mutate(Window = as.integer(rownames(.)))
      names(d) <- c(paste(name, "#", 1:(ncol(d)-1), sep= ""),"Window")
      
      if(melt == "before"){
        d <- melt(d,"Window")
        d <- d[3]
        names(d) <- c(name)
        appendTo <- cbind(appendTo, d)
      }else if(melt == "after"){
        names <- names(appendTo)
        appendTo <- cbind(appendTo, d)
        appendTo <- melt(appendTo, names) %>%
          separate(variable, c("Measure", "Sample"), sep="#") %>%
          mutate(Sample = as.integer(Sample))
        names(appendTo) <- c(names, "Measure", "Sample", name)
        appendTo <- appendTo[c(names,"Sample",name)]
      }
      
      appendTo
    }

Now I append all sensors to the base dataframe

    base <-  appendData(base, 'total_acc_x', 'after')  %>%
      appendData('total_acc_y')  %>%
      appendData('total_acc_z')  %>%
      appendData('body_acc_x')  %>%
      appendData('body_acc_y')  %>%
      appendData('body_acc_z')  %>%
      appendData('body_gyro_x')  %>%
      appendData('body_gyro_y')  %>%
      appendData('body_gyro_z')  %>%
      arrange(Dataset, Subject, Window, Sample) %>%
      select (Dataset, Subject, Window, Sample, Activity,	total_acc_x, total_acc_y,	total_acc_z, body_acc_x, body_acc_y, body_acc_z, body_gyro_x, body_gyro_y, body_gyro_z )
      
And append the resulting dataframe to its file.
    
    writeHeaders <- !file.exists(file.path(dataFolder, 'dataSet.csv'))
    write.table(base, file = file.path(dataFolder, "dataset.csv"), append = TRUE, sep = ",", col.names = writeHeaders, row.names = FALSE )
}

Now I call the above function only if the file does not exists. I have created this to be more easy to debug the script. I can always run it, and the slower part does not need to run again.

    dataFolder <- getwd()
    
    file <- file.path(dataFolder, "dataset.csv")
    if(!file.exists(file)){
      AppendDataSet(dataFolder, "test")
      AppendDataSet(dataFolder, "train")
    }
    
Now, I generate the last dataset, summarizing the csv generated.
    
    allmeasures <- read.csv(file, sep=",")
    means <- allmeasures %>%
      group_by(Subject, Activity) %>%
      summarize(
             total_acc_x = mean(total_acc_x),
             total_acc_y = mean(total_acc_y),
             total_acc_z = mean(total_acc_z),
             body_acc_x = mean(body_acc_x),
             body_acc_y = mean(body_acc_y),
             body_acc_z = mean(body_acc_z),
             body_gyro_x = mean(body_gyro_x),
             body_gyro_y = mean(body_gyro_y),
             body_gyro_z = mean(body_gyro_z))
    write.table(means, file = file.path(dataFolder, "means.csv"), append = TRUE, sep = ",", col.names = TRUE, row.names = FALSE )
