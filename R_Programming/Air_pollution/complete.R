complete <- function(directory, id = 1:332) {
      ## 'directory' is a character vector of length 1 indicating
      ## the location of the CSV files
      
      ## 'id' is an integer vector indicating the monitor ID numbers
      ## to be used
      
      ## Return a data frame of the form:
      ## id nobs
      ## 1  117
      ## 2  1041
      ## ...
      ## where 'id' is the monitor ID number and 'nobs' is the
      ## number of complete cases
      
      ########################################################
      
      # List of the file names in directory
      file_list = list.files(directory, full.names=T)
      
      # Initializing the data frame output
      data_complete = data.frame()
      
      # Looping on the CSV files
      for (i in id) {
            # Reading the CSV file
            data = read.csv(file_list[i], header=T)
            
            # Calculating the number of complete observations
            nco = sum(complete.cases(data))
            
            # Putting the data in the outuput data frame
            data_complete = rbind(data_complete, data.frame(id=i,nobs=nco))
      }
      
      data_complete
      
}





