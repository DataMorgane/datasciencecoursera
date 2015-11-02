corr <- function(directory, threshold = 0) {
      ## 'directory' is a character vector of length 1 indicating
      ## the location of the CSV files
      
      ## 'threshold' is a numeric vector of length 1 indicating the
      ## number of completely observed observations (on all
      ## variables) required to compute the correlation between
      ## nitrate and sulfate; the default is 0
      
      ## Return a numeric vector of correlations
      ## NOTE: Do not round the result!
      
      #####################################################
      
      # List of the file names in directory
      file_list = list.files(directory, full.names=T)
      
      # Getting the number of complete observations for each file
      data_complete = complete(directory, id=1:length(file_list))
      
      # Initializing the correlation vector
      corr_vec = vector()
      
      # Looping on the CSV files
      for (i in 1:length(file_list)) {
            # Testing if the number of complete observations
            # is superior to the threshold
            if (data_complete[i,]$nobs > threshold) {
                  # Getting and cleaning the data
                  data = read.csv(file_list[i], header=T)
                  data_clean = data[complete.cases(data),]
                  
                  # Computing correlation and adding it to the
                  # correlation vector corr_vec
                  cor_val = cor(data_clean$sulfate, data_clean$nitrate)
                  corr_vec = c(corr_vec, cor_val)
            }
      }
      
      corr_vec
      
}