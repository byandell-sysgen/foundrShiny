#' Volcano Plot App
#'
#' @param id identifier
#' @param panel_par,plot_par input parameters
#' @param plot_info reactive values from contrastPlot
#' @param contrast_table reactive data frame
#' @return reactive object 
#'
#' @importFrom shiny column fluidRow moduleServer NS observeEvent
#'             radioButtons reactive reactiveVal reactiveValues renderUI
#'             req selectInput tagList uiOutput updateSelectInput
#' @importFrom DT renderDataTable
#' @importFrom foundr ggplot_conditionContrasts summary_conditionContrasts
#'             summary_strainstats
#' @export
volcanoApp <- function() {
  title <- "Shiny Volcano"
  ui <- function() {
    shiny::fluidPage(
      shiny::titlePanel(title),
      shiny::sidebarLayout(
        shiny::sidebarPanel(
          mainParInput("main_par"), # dataset
          plotParInput("plot_par") # ordername, interact
        ),
        shiny::mainPanel(
          mainParOutput("main_par"), # plot_table, height
          plotParUI("plot_par"), # volsd, volvert (sliders)
          plotParOutput("plot_par"), # rownames (strains/terms)
          panelParUI("panel_par"), # sex
          volcanoOutput("volcano")
        )
      )
    )
  }
  server <- function(input, output, session) {
    main_par <- mainParServer("main_par", traitStats)
    panel_par <- panelParServer("panel_par", main_par, traitStats)
    contrast_table <- contrastTableServer("contrast_table", main_par,
                                          traitSignal, traitStats, customSettings)
    plot_par <- plotParServer("plot_par", contrast_table)
    volcanoServer("volcano", input, plot_par, contrast_table)
  }
  shiny::shinyApp(ui, server)
}
#' @rdname volcanoApp
#' @export
volcanoServer <- function(id, panel_par, plot_par, plot_info,
  contrast_table) {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    contrastVolcano <- shiny::reactive({
      shiny::req(plot_info$rownames(), plot_par$ordername,
                 plot_info$threshold())
      # Generic plot function for `traits` and `eigens`.``
      foundr::ggplot_conditionContrasts(
        plot_info$rownames(), bysex = panel_par$sex,
        ordername = plot_par$ordername,
        plottype = "volcano", threshold = plot_info$threshold(),
        strain = panel_par$strain,
        interact = shiny::isTruthy(plot_par$interact))
    }, label = "contrastVolcano")
    output$plot <- shiny::renderUI({
      shiny::tagList(
        shiny::h4("Volcano Plot"),
        shiny::uiOutput(ns("rownames")),
        if(shiny::isTruthy(plot_par$interact)) {
          plotly::renderPlotly(shiny::req(contrastVolcano()))
        } else {
          shiny::renderPlot(print(shiny::req(contrastVolcano())))
        }
      )
    })

    ###############################################################
    contrastVolcano
  })
}
#' @rdname volcanoApp
#' @export
volcanoOutput <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::uiOutput(ns("title")),
    shiny::uiOutput(ns("plot"))
  )
}
