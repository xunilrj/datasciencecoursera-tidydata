library(plyr)
library(tidyr)
library(dplyr)
library(splitstackshape)

AppendDataSet <- function (dataFolder, dataSet)
{   
    features <- tbl_df(read.csv(file.path(dataFolder, "features.txt"), header = FALSE, sep = ' ')) %>%
      separate(V2, c("Feature","Aggregator","Axis")) %>%      
      filter(grepl("(std)|(mean)", Aggregator)) %>%      
      rename(FeatureId = V1)
    
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
    
    writeHeaders <- !file.exists(file.path(dataFolder, 'features.csv'))
    write.table(x, file = file.path(dataFolder, "features.csv"), append = TRUE, sep = ",", col.names = writeHeaders, row.names = FALSE )
    
    activities <- tbl_df(read.csv(file.path(dataFolder, "activity_labels.txt"), header = FALSE, sep = ' ')) %>%
      rename(ActivityId = V1, ActivityName = V2)    
    
    subject <- tbl_df(read.csv(file.path(dataFolder, dataSet, paste("subject_", dataSet, ".txt", sep = '')), header = FALSE)) %>%
      rename(SubjectId = V1) %>%
      mutate(SubjectId = as.integer(SubjectId)) %>%
      mutate(Dataset = dataSet)
    
    y <- tbl_df(read.csv(file.path(dataFolder, dataSet, paste("y_", dataSet, ".txt", sep ="")), header = FALSE, sep = ' ')) %>% 
      rename(ActivityId = V1) %>%
      mutate(Window = as.integer(rownames(.)))
    
    base <- cbind(y, subject) %>%
      join(activities) %>%
      select(Window, Dataset, ActivityName, SubjectId)
    names(base) <- c("Window", "Dataset", "Activity", "Subject")
    
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
    
    writeHeaders <- !file.exists(file.path(dataFolder, 'dataSet.csv'))
    write.table(base, file = file.path(dataFolder, "dataset.csv"), append = TRUE, sep = ",", col.names = writeHeaders, row.names = FALSE )
}

dataFolder <- getwd()

file <- file.path(dataFolder, "dataset.csv")
if(!file.exists(file)){
  AppendDataSet(dataFolder, "test")
  AppendDataSet(dataFolder, "train")
}

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
