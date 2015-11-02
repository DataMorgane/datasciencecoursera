# This function takes two arguments: an outcome name (outcome) and a 
# hospital ranking (num). The function reads the outcome-of-care-measures.csv 
# file and returns a 2-column data frame containing the hospital in each 
# state that has the ranking specified in num. For example the function call
# rankall("heart attack", "best") would return a data frame containing the 
# names of the hospitals that are the best in their respective states for 
# 30-day heart attack death rates. The function should return a value for 
# every state (some may be NA). The first column in the data frame is named 
# hospital, which contains the hospital name, and the second column is named 
# state, which contains the 2-character abbreviation for the state name. 
# Hospitals that do not have data on a particular outcome should be excluded 
# from the set of hospitals when deciding the rankings.

rankall <- function(outcome, num = "best") {
      ## Read outcome data
      data <- read.csv("outcome-of-care-measures.csv", 
                       colClasses="character")
      
      # Getting the number of the column corresponding to the argument
      # outcome. Returns an error if the outcome is invalid
      if (outcome == "heart attack") {
            col_num = 11
      } else if (outcome == "heart failure") {
            col_num = 17
      } else if (outcome == "pneumonia") {
            col_num = 23
      } else {
            stop("invalid outcome")
      }
      
      # Splitting the data by state
      outcome_state_split = split(data, data$State)
      
      # Initializing the returned data frame
      rankall_data = data.frame()
      
      ## For each state, find the hospital of the given rank
      for (i in 1:length(outcome_state_split)) {
            outcome_state = as.data.frame(outcome_state_split[[i]])
            # Converting the data to numeric
            outcome_state[[col_num]] = suppressWarnings(as.numeric(
                  outcome_state[[col_num]]))
            # Ordering the data by outcome and then alphabetical order
            outcome_list = order(outcome_state[[col_num]],
                                 outcome_state[[2]],
                                 na.last = NA)
            # Number of hospitals in the ordered list
            num_hosp = length(outcome_list)
            
            if (num == "best") {
                  rank_num = outcome_list[1]
                  rank_hosp = outcome_state[[2]][rank_num]
            } else if (num == "worst") {
                  rank_num = outcome_list[num_hosp]
                  rank_hosp = outcome_state[[2]][rank_num]
            } else if (is.numeric(num) && num > 0 && num <= num_hosp) {
                  rank_num = outcome_list[num]
                  rank_hosp = outcome_state[[2]][rank_num]
            } else {
                  rank_hosp = NA
            }
            rankall_state = data.frame(hospital = rank_hosp,
                                       state = outcome_state[[7]])
            rankall_data = rbind(rankall_data, rankall_state[1,])
           
      }
      
      ## Return a data frame with the hospital names and the
      ## (abbreviated) state name
      rankall_data
}





