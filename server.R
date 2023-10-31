server <- function(input,output) {
  ################################################################################
  # Example 1 - Static
  
  # Nothing to see here
  
  ################################################################################
  # Example 2 - Graphs
  # Data set up in global.R is used to build and render a graph
  # this result is assigned to the 'output' variable so that it can be accessed in the ui
  output$age_graph <- renderPlot({
    data_age %>%
      ggplot(aes(x=Age,y=Headcount)) +
      geom_col()
  })

  ################################################################################
  # Example 3 - user input
  
  # To use interactive features, code that relies on user input must be defined in a 'reactive' context
  # Code within the curly braces of render functions is one such 'reactive' context
  # it can use variables from user input, and will update whenever those values change
  output$var_graph_ex3 <- renderPlot({
    # The value of the user input can be accessed within the 'input' object using the 'inputId' given to it
    variable <- input$variable_selection_ex3

    # This can then be used to load a different data set
    data <- read.csv(paste0("https://co-analysis.github.io/acses_data_browser_2023/",variable,"/data.csv")) %>%
      filter(Status=="In post") %>%
      mutate(across(any_of(c("Headcount","FTE","Mean_salary","Median_salary")),as.numeric)) %>%
      rename(Group=variable) # note that the variable is being renamed here so that it is always called 'Group' regardless of which value was chosen
    
    # The resulting dynamic data is then used to build the graph
    data %>%
      ggplot(aes(x=Group,y=Headcount)) +
      geom_col()
  })
  
  ################################################################################
  # Example 4 - dynamic UI
  
  # Using a vector of values defined in global.R we can create a user interface element
  output$ui_variable_selection_ex4 <- renderUI({

    # be careful to note that the 'inputId' is defined here, rather than in ui.R
    # and that this is different to the 'outputId' the UI element is assigned to

    selectInput("variable_selection_ex4",label="Choose a variable",choices=cs_stats_vars)
  })
  
  
  # Code for the graph is as before  
  output$var_graph_ex4 <- renderPlot({
    # The value of the user input can be accessed within the 'input' object using the 'inputId' given to it
    variable <- input$variable_selection_ex4
    
    # This can then be used to load a different data set
    data <- read.csv(paste0("https://co-analysis.github.io/acses_data_browser_2023/",variable,"/data.csv")) %>%
      filter(Status=="In post") %>%
      mutate(across(any_of(c("Headcount","FTE","Mean_salary","Median_salary")),as.numeric)) %>%
      rename(Group=variable) # note that the variable is being renamed here so that it is always called 'Group' regardless of which value was chosen
    
    # The resulting dynamic data is then used to build the graph
    data %>%
      ggplot(aes(x=Group,y=Headcount)) +
      geom_col()
  })
  
  ################################################################################
  # Example 5 - reactive functions
  
  # The other main way to use reactivity is within a 'reactive function'
  # This is a function that can use dynamic input, and will update whenever that input changes
  # If the result is being used multiple times this can be helpful, or to simplify your code
  
  # Define a reactive function that loads the data:
  get_data <- reactive({
    # The code is the same as was previously included within the 'reactive context' of the graph output
    
    # The value of the user input can be accessed within the 'input' object using the 'inputId' given to it
    variable <- input$variable_selection_ex5
    
    # This can then be used to load a different data set
    data <- read.csv(paste0("https://co-analysis.github.io/acses_data_browser_2023/",variable,"/data.csv")) %>%
      filter(Status=="In post") %>%
      mutate(across(any_of(c("Headcount","FTE","Mean_salary","Median_salary")),as.numeric)) %>%
      rename(Group=variable) # note that the variable is being renamed here so that it is always called 'Group' regardless of which value was chosen
    
    data # return the 'data' object when called
  })

  
  # UI element code is the same
  # Using a vector of values defined in global.R we can create a user interface element
  output$ui_variable_selection_ex5 <- renderUI({
    # be careful to note that the 'inputId' is defined here, rather than in ui.R
    # and that this is different to the 'outputId' the UI element is assigned to
    selectInput("variable_selection_ex5",label="Choose a variable",choices=cs_stats_vars)
  })
  
  
  # Code for the graph can now be simplified
  output$var_graph_ex5 <- renderPlot({
    # data is called using the reactive function - when the inputs used in that function update, this graph will also update
    data <- get_data()
    
    # The resulting dynamic data is then used to build the graph
    data %>%
      ggplot(aes(x=Group,y=Headcount)) +
      geom_col()
  })
  
  
  # And we can re-use the reactive function in another output - such as a table
  output$var_table_ex5 <- renderTable({
    # Data is again called using the reactive function - when the inputs used in that function update, this table will also update
    get_data()
  })
}