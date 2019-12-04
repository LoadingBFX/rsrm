library(shiny)

ui <- pageWithSidebar(
  headerPanel('Restriction Sites Mapping for Known DNA Sequence'),
  sidebarPanel(
    textInput("dnaSeq", label = h3("DNA Sequence"), value = "GGCAGATTCCCCCTAACGTCGGACCCGCCCGCACCATGGTCAGGCATGCCCCTCCTCATCGCTGGGCACAGCCCAGAGGGT
    ATAAACAGTGCTGGAGGCTGGCGGGGCAGGCCAGCTGAGTCCTGAGCAGCAGCCCAGCGCAGCCACCGAGACACC
    ATGAGAGCCCTCACACTCCTCGCCCTATTGGCCCTGGCCGCACTTTGCATCGCTGGCCAGGCAGGTGAGTGCCCC"),
    textInput("dnaName", label = h3("DNA name"), value = "Example DNA"),
    textInput("targetSeq", label = h3("Target Sequence"), value = "ACGTCG"),
    textInput("targetName", label = h3("Target Name"), value = "Example Target"),
    numericInput('num', 'Number of Restriction Sites', 6,
                 min = 1, max = 10)
  ),
  mainPanel(
    plotOutput('rsplot')
  )
)

server <- function(input, output, session) {

  observe({
    rs <- findre(input$dnaName, input$dnaSeq, input$targetName, input$targetSeq, dataset = redata, num = input$num)
    output$rsplot <- renderPlot(rs)
  })

}

shinyApp(ui = ui, server = server)
