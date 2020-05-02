#Load the Library
library(shiny)
library(ggplot2)
library(viridis)
load("./Spells.RData")

ui <- fluidPage(
    
    # Application title
    titlePanel("A Spell Reference Guide"),
    
    t("This application is a reference guide and allows crosslisting information for spells from the 5th edition of the game Dungeons and Dragons"),
    # Sidebar layout
    sidebarLayout(

        #Inputs: Select which inputs from the data we want to display
        sidebarPanel(
            
            h3("Select Data:"),
            #Select variable for y-axis
            selectInput(inputId = "y", 
                        label = "Y-axis:",
                        choices = c("Save", "Level", "School", "Casting_Time"), 
                        selected = "Save"),
            #Select X-axis variables
            selectInput(inputId = "x", 
                        label = "X-axis:",
                        choices = c("Save", "Level", "School", "Casting_Time"),
                        selected = "Level"),
            #Create Slider for Scale
            sliderInput(inputId = "scale", 
                        label = "Scaling:", 
                        min = 1, max = 25, 
                        value = c(3,15)),
        ),
        
        #Output: Type of plot
        mainPanel(
            tabsetPanel(
                tabPanel("Graphs", plotOutput(outputId = "FreqTab")),
                tabPanel("Data",  DT::dataTableOutput(outputId="datasheet"))
            )
        )
    ),
    t("The NA under \"Save\" exists because not all saves require a save. For example, spells that help other teammates.")
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    output$FreqTab <- renderPlot({
        # draw the histogram with the specified number of bins
        a <- ggplot(Spells, aes_string(input$x,input$y)) + geom_count(aes(color = ..n.., size = ..n..)) + guides(color = 'legend') + scale_size_continuous(range = input$scale) + scale_fill_distiller(palette = "PuBu", direction = 1) + theme(panel.grid.major = element_line(), legend.position = "none") #+ ggtitle(input$x," by ", names(input$y)))
        a
    })
    
    output$datasheet<-DT::renderDataTable({
        DT::datatable(data=Spells,
                      options=list(pageLength= 20),
                      rownames=FALSE)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
