# List of required packages
packages <- c("shiny", "DT")

# Check and install missing packages
for (pkg in packages) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
  }
}


# Load necessary libraries
library(shiny)
library(DT)

# Define the UI
ui <- fluidPage(
  titlePanel("Soil Sample Generator"),
  
  sidebarLayout(
    sidebarPanel(
      textOutput("team_number_display"),
      br(), br(),
      downloadButton("downloadData", "Download CSV"),
      br(), br(),
      helpText("This study simulates soil sampling for Nitrogen, Phosphorus, and Moisture content across 20 plots. Click each plot to generate and view sample data.")
    ),
    
    mainPanel(
      fluidRow(
        lapply(1:20, function(i) {
          column(2, actionButton(paste0("plot", i), "", style="background-color:#8B4513; height:80px; width:100%; margin-bottom:10px;"))
        })
      ),
      br(),
      DTOutput("sample_table")
    )
  )
)

# Define the server logic
server <- function(input, output, session) {
  
  # Popup to get team number
  team_number <- reactiveVal(NULL)
  observe({
    showModal(modalDialog(
      title = "Enter Team Number",
      numericInput("team", "Team Number (1-6):", value = 1, min = 1, max = 6),
      footer = tagList(actionButton("ok", "OK"))
    ))
  })
  
  observeEvent(input$ok, {
    req(input$team >= 1 && input$team <= 6)
    team_number(input$team)
    set.seed(as.numeric(input$team))
    removeModal()
  })
  
  output$team_number_display <- renderText({
    paste("Team Number:", team_number())
  })
  
  samples <- reactiveVal(data.frame(
    Plot = numeric(0),
    Nitrogen = numeric(0),
    Phosphorus = numeric(0),
    Moisture = numeric(0)
  ))
  
  generate_sample <- function(plot_num) {
    data.frame(
      Plot = plot_num,
      Nitrogen = round(rnorm(1, mean = 1000, sd = 200), 2),  # mg/kg
      Phosphorus = round(rnorm(1, mean = 570, sd = 10), 2), # mg/kg
      Moisture = round(rnorm(1, mean = 25, sd = 5), 2)       # %
    )
  }
  
  # Plot buttons event
  lapply(1:20, function(i) {
    observeEvent(input[[paste0("plot", i)]], {
      current_samples <- samples()
      if (!(i %in% current_samples$Plot)) {
        new_sample <- generate_sample(i)
        samples(rbind(current_samples, new_sample))
        updateActionButton(session, paste0("plot", i), label = "✓")
      }
    })
  })
  
  # Render the table of samples
  output$sample_table <- renderDT({
    datatable(samples()[order(samples()$Plot),], 
              options = list(pageLength = 20),
              caption = 'Soil Sample Data (Nitrogen = mg/kg, Phosphorus = mg/kg, Moisture = %)')
  })
  
  # Download CSV
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("soil_samples_team", team_number(), "_", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(samples()[order(samples()$Plot),], file, row.names = FALSE)
    }
  )
}

# Run the application
shinyApp(ui = ui, server = server)
