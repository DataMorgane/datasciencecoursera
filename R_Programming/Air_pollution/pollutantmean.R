pollutantmean <- function(directory, pollutant, id = 1:332) {
      ## 'directory' is a character vector of length 1 indicating
      ## the location of the CSV files
      
      ## 'pollutant' is a character vector of length 1 indicating
      ## the name of the pollutant for which we will calculate the
      ## mean; either "sulfate" or "nitrate".
      
      ## 'id' is an integer vector indicating the monitor ID numbers
      ## to be used
      
      ## Return the mean of the pollutant across all monitors list
      ## in the 'id' vector (ignoring NA values)
      ## NOTE: Do not round the result!
     
      ######################################################## 
      
      # List of the file names in directory
      file_list = list.files(directory, full.names=T)

      # Initializing the data frame which will combine
      # all the data from the different files
      whole_data <- data.frame()
      
      # Looping on the CSV files
      for (i in id) {
            # Reading the CSV file
            data = read.csv(file_list[i], header=T)
            
            # Adding the data from to file to whole_data
            whole_data = rbind(whole_data, data)
      }      
      
      # Calculating the mean
      mean(whole_data[[pollutant]], na.rm=T)
      
}

