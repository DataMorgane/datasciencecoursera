

# User Interface for a simple web application that plots a set of points and
# fit a linear model to it.

library(shiny)

shinyUI(fluidPage(
    
    # Title
    h2("Plot of a linear regression"),
    
    # Horizontal line
    hr(),
    
    ############
    #  Inputs  #
    ############
    fluidRow(
        # Data and buttons
        column(3,
               h4("Data"),
               textInput(inputId="x1", 
                         label = "x values, separated by commas (ex : 1,2,3)"),
               textInput(inputId="y1", 
                         label = "y values, separated by commas (ex : 1,2,3)"),
               actionButton("go", "Plot"),
               actionButton("reset", "Clear"),
               actionButton("lm", "Fit a linear model")
               ),
        
        # Graphical parameters for the points
        column(3,
               
               h4("Graphical parameters (points)"),
               
               # Choice of the color
               selectInput(inputId = "color",
                           label = "Select a color :",
                           choices = c("black", "red", "skyblue", 
                                       "salmon", "purple", "orange"),
                           selected = "black"),
               
               # Choice of the type of points
               selectInput(inputId = "point_type",
                           label = "Select the type of points :",
                           choices = c("solid circle", "empty circle", "triangle", 
                                       "square", "cross sign", "plus sign"),
                           selected = "solid circle"),
               
               # Choice of the size of points
               selectInput(inputId = "point_size",
                           label = "Select the size of the points :",
                           choices = c(1, 2, 3, 4, 5, 6, 7, 8),
                           selected = 2)
               ),

        # Graphical parameters for the linear regression line
        column(3,
               
               h4("Graphical parameters (line)"),
               
               # Choice of the color
               selectInput(inputId = "line_color",
                           label = "Select a color :",
                           choices = c("black", "red", "skyblue", 
                                       "salmon", "purple", "orange"),
                           selected = "black"),
               
               # Choice of the type of line
               selectInput(inputId = "line_type",
                           label = "Select the type of line :",
                           choices = c("solid", "dashed", "dotted", 
                                       "dotdash", "longdash", "twodash"),
                           selected = "solid"),
               
               # Choice of the size of the line
               selectInput(inputId = "line_size",
                           label = "Select the size of the line :",
                           choices = c(1, 2, 3, 4, 5, 6, 7, 8),
                           selected = 2)
               )
    ),
    
    # Horizontal line
    hr(),
    
    #############
    #  Outputs  #
    #############
    fluidRow(
        
        # Plot
        column(6,
               plotOutput(outputId = "main_plot", width = "100%")
        ),
        
        # Linear model summary and documentation
        column(3,
               
               # Summary
               h4("Linear model summary :"),
               p("R-squared :"),
               verbatimTextOutput("lm_rsquared"),
               p("Coefficients :"),
               verbatimTextOutput("lm_coef"),
               p("Correlation between the variables :"),
               verbatimTextOutput("lm_corr"),
               
               # Documentation
               h4("Documentation"),
               h5("What does this application do ?"),
               p("This Shiny web application plots a set of points into a grid, compute 
          a linear model, and then plot the linear regression line. It also
          displays a summary of the linear model."),
               h5("How to use it ?"),
               p("You should enter your set of values in the 'x' and 'y' fields, separated 
          by commas (for example : 1,2,3). Then, click the 'Plot' button. You
          can modify the color, size, and type of the points by choosing it
          in the section 'Graphical parameters (points)'. Then, click on the 
          'Fit a linear model' button to plot the regression line and display
          the summary. You can modify the color, width, and type of line
          in the section 'Graphical parameters (line)'.")
               )
    )
))





















