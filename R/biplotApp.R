#' BiPlot App
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
biplotApp <- function() {
  title <- "Shiny BiPlot"
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
          biplotOutput("biplot")
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
    biplotServer("biplot", input, plot_par, contrast_table)
  }
  shiny::shinyApp(ui, server)
}
#' @rdname biplotApp
#' @export
biplotServer <- function(id, panel_par, plot_par, plot_info,
  contrast_table) {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    contrastBiPlot <- shiny::reactive({
      shiny::req(plot_info$rownames(), plot_par$ordername,
                 plot_info$threshold())
      # Generic plot function for `traits` and `eigens`.``
      foundr::ggplot_conditionContrasts(
        plot_info$rownames(), bysex = panel_par$sex,
        ordername = plot_par$ordername,
        plottype = "biplot", threshold = plot_info$threshold(),
        strain = input$strain,
        interact = shiny::isTruthy(plot_par$interact))
    }, label = "contrastBiPlot")
    
    output$plot <- shiny::renderUI({
      shiny::tagList(
        shiny::h4("BiPlot Plot"),
        shiny::uiOutput(ns("rownames")),
        shiny::selectInput(ns("strain"), "Vector Highlight",
                           c("NONE", plot_par$rownames)),
        if(shiny::isTruthy(plot_par$interact)) {
          shiny::tagList(
            shiny::renderText("Rays disappear if interactive."),
            shiny::renderPlot(print(shiny::req(biplot()))),
            plotly::renderPlotly(shiny::req(contrastBiPlot())))
        } else {
          shiny::renderPlot(print(shiny::req(contrastBiPlot())))
        }
      )
    })
    ###############################################################
    contrastBiPlot
  })
}
#' Shiny Module Output for Contrast Plots
#' @return nothing returned
#' @rdname biplotApp
#' @export
biplotOutput <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::uiOutput(ns("title")),
    shiny::uiOutput(ns("plot"))
  )
}
