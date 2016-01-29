

# R codefor a simple web application that plots a set of points and
# fit a linear model to it.

library(shiny)

shinyServer(function(input, output) {
    
    # Initialisation of the values for controlling the buttons
    v <- reactiveValues(data = NULL)
    w <- reactiveValues(data = NULL)
    
    # If the user click on "clear", both values are set to NULL
    observeEvent(input$reset, {
        v$data <- NULL
        w$data <- NULL
    })
    
    # If the user clicks on "plot", v is set to 1
    observeEvent(input$go, {
        v$data <- 1
    })
    
    # If the user clicks on "fit a linear model", w is set to 1
    observeEvent(input$lm, {
        w$data <- 1
    })
    
    output$main_plot <- renderPlot({
        # If v is NULL : initial value, or if the user clicks on "clear".
        # A blank grid is plotted, and there are no values on the summary
        # of the linear model
        if (is.null(v$data)) {
            plot(x = -10:10,
                 y = -10:10,
                 type = "n",
                 xlab = "x",
                 ylab = "y")
            abline(h = 0,
                   col = "slategray",
                   lwd = 2)
            abline(v = 0,
                   col = "slategray",
                   lwd = 2)
            abline(h = -10:10,
                   col = "lightgrey")
            abline(v = -10:10,
                   col = "lightgrey")
            
            output$lm_rsquared <- renderPrint({invisible()})
            output$lm_coef <- renderPrint({invisible()})
            output$lm_corr <- renderPrint({invisible()})
            
        # If v = 1 : the user clicks on "plot".
        # The points are plotted on a grid of the correct scale
        } else {
            
            # Creating two vectors with the values entered in the input box
            x1_num <- as.numeric(unlist(strsplit(input$x1, ",")))
            y1_num <- as.numeric(unlist(strsplit(input$y1, ",")))
            
            # Plotting a blank grid of the correct scale (a little larger than
            # the range of the points)
            plot(x = 0,
                 y = 0,
                 type = "n",
                 xlab = "x",
                 ylab = "y",
                 xlim = c((range(x1_num)[1] - 2),(range(x1_num)[2] + 2)),
                 ylim = c((range(y1_num)[1] - 2),(range(y1_num)[2] + 2)))
            abline(h = 0,
                   col = "slategray",
                   lwd = 2)
            abline(v = 0,
                   col = "slategray",
                   lwd = 2)
            abline(h = (range(y1_num)[1] - 4):(range(y1_num)[2] + 4),
                   col = "lightgrey")
            abline(v = (range(x1_num)[1] - 4):(range(x1_num)[2] + 4),
                   col = "lightgrey")
            
            # Converting the text describing the type of point into the 
            # correct number for tho option pch
            p_text <- c("solid circle", "empty circle", "triangle", 
                        "square", "cross sign", "plus sign")
            p_vec <- c(19, 1, 17, 15, 4, 3)
            p_num <- p_vec[match(input$point_type, p_text)]
            
            # Adding the points to the grid, with the input color, point type
            # and point size
            points(x = x1_num,
                   y = y1_num,
                   col = input$color,
                   pch = p_num,
                   cex = as.numeric(input$point_size))
        }
        
        # If v = 1 and w = 1 : the user clicks on "plot" AND "fit a linear model".
        # The summary of the model is displayed and the line is added to the grid
        if (!is.null(w$data) & (!is.null(v$data))) {
            
            # Linear regression
            fit <- lm(y1_num ~ x1_num)
            
            # Displaying the summary of the model
            output$lm_rsquared <- renderPrint({summary(fit)$r.squared})
            output$lm_coef <- renderPrint({summary(fit)$coefficient})
            output$lm_corr <- renderPrint({cor(x1_num, y1_num)})
            
            # Adding the line to the plot, with the input color, line type
            # and line size
            abline(fit,
                   col = input$line_color,
                   lwd = input$line_size,
                   lty = input$line_type)
        }
        
    }, width = 800, height = 800) # Size of the figure
})
   
        






















