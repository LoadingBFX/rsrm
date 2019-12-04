library(shiny)

ui <- pageWithSidebar(
  headerPanel('Restriction Sites Mapping for Known DNA Sequence'),
  sidebarPanel(
    textInput("dnaSeq", label = h4("DNA Sequence"), value = "GGCAGATTCCCCCTAACGTCGGACCCGCCCGCACCATGGTCAGGCATGCCCCTCCTCATCGCTGGGCACAGCCCAGAGGGT
    ATAAACAGTGCTGGAGGCTGGCGGGGCAGGCCAGCTGAGTCCTGAGCAGCAGCCCAGCGCAGCCACCGAGACACC
    ATGAGAGCCCTCACACTCCTCGCCCTATTGGCCCTGGCCGCACTTTGCATCGCTGGCCAGGCAGGTGAGTGCCCC"),
    textInput("dnaName", label = h4("DNA name"), value = "Example DNA"),
    textInput("targetSeq", label = h4("Target Sequence"), value = "ACGTCG"),
    textInput("targetName", label = h4("Target Name"), value = "Example Target"),
    textInput("title", label = h4("Title"), value = "Restriction map around the target sequence"),
    numericInput('num', 'Number of Restriction Sites', 6,
                 min = 1, max = 10)
  ),
  mainPanel(
    plotOutput('rsplot')
  )
)

server <- function(input, output, session) {

  observe({
    rs <- findre(input$dnaName, input$dnaSeq, input$targetName, input$targetSeq, dataset = redata, num = input$num, title = input$title)
    output$rsplot <- renderPlot(rs)
  })

}

shinyApp(ui = ui, server = server)
