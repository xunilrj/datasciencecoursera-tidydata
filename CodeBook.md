#  Codebook for the Getting and cleaning data Assignment

For the features:  
1 - Merged features.txt with x_<dataset>.txt  
2 - Cleaned column names  
3 - Melt the dataset so each line is a different observation  

For the sensors:  
1 - Merged all sensor files  
2 - Merged the subject and activity files  
3 - Melt the dataset so each line is a Window+Sample+Sensor observation  
4 - Cleaned the column names  
5 - Unpivoted the sensors so each line is Window+Sample observation  

For the means:  
1 - Read the sensors file of the step above  
2 - Grouped by Subject+Activity  
3 - Calculated all means  
