# This function takes three arguments: the 2-character abbreviated name 
# of a state (state), an outcome (outcome), and the ranking of a hospital 
# in that state for that outcome (num).
# The function reads the outcome-of-care-measures.csv file and returns 
# a character vector with the name of the hospital that has the ranking 
# specified by the num argument.

rankhospital <- function(state, outcome, num = "best") {
      ## Read outcome data
      data <- read.csv("outcome-of-care-measures.csv", 
                       colClasses="character")
      
      ## Check that state is valid
      if (!state %in% data$State) {
            stop("invalid state")
      }
      
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
      
      # Getting the data for the argument state
      outcome_state = split(data, data$State)[[state]]
      
      # Converting the data to numeric
      outcome_state[[col_num]] = suppressWarnings(as.numeric(
            outcome_state[[col_num]]))
      
      # Ordering the data by outcome and then alphabetical order
      outcome_list = order(outcome_state[[col_num]],
                           outcome_state$Hospital.Name,
                           na.last = NA)
      # Number of hospitals in the ordered list
      num_hosp = length(outcome_list)
      
      if (num == "best") {
            rank_num = outcome_list[1]
      } else if (num == "worst") {
            rank_num = outcome_list[num_hosp]
      } else if (is.numeric(num) && num > 0 && num <= num_hosp) {
            rank_num = outcome_list[num]
      } else {
            return(NA)
      }
      
      ## Return hospital name in that state with the given rank
      ## 30-day death rate
      outcome_state$Hospital.Name[rank_num]
      
}




