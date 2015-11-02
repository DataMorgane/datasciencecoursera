# This function take two arguments: the 2-character abbreviated name of a state 
# and an outcome name. The function reads the outcome-of-care-measures.csv 
# file and returns a character vector with the name of the hospital that has 
# the best (i.e. lowest) 30-day mortality for the specified outcome in that 
# state. The outcomes can be one of “heart attack”, “heart failure”, or 
# “pneumonia”. 
# If there is a tie, the function returns the first hospital in the
# alphabetical order.

best <- function(state, outcome) {
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
      best_num = outcome_list[1]
      
      ## Return hospital name in that state with lowest 30-day death
      ## rate
      outcome_state$Hospital.Name[best_num]


}
