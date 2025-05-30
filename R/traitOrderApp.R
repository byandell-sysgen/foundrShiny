#' Trait Order App
#' 
#' @param id identifier for shiny reactive
#' @param main_par input reactive list
#' @param traitStats static data frame
#' @param customSettings custom settings list
#' @param keepDatatraits keep datatraits if not `NULL`
#' @return reactive object
#'
#' @importFrom shiny column fluidRow h3 isTruthy moduleServer NS observeEvent
#'             reactive  reactiveVal renderUI req selectInput shinyApp tagList
#'             uiOutput updateSelectInput
#' @importFrom DT dataTableOutput renderDataTable
#' @importFrom plotly plotlyOutput renderPlotly
#' @importFrom foundr summary_strainstats
#' @export
traitOrderApp <- function() {
  title <- "Test Shiny Trait Order Table"
  ui <- function() {
    shiny::fluidPage(
      shiny::titlePanel(title),
      shiny::sidebarLayout(
        shiny::sidebarPanel(
          # Key Datasets and Trait.
          mainParInput("main_par"), # dataset
          mainParUI("main_par"), # order
          # Related Datasets and Traits.
          shiny::uiOutput("reldataset")
        ),
        shiny::mainPanel(
          shiny::textOutput("key_trait"),
          traitOrderUI("stats_table")
        )
      )
    )
  }
  server <- function(input, output, session) {
    main_par <- mainParServer("main_par", traitStats)
    stats_table <- traitOrderServer("stats_table", main_par, traitStats)
    
    output$key_trait <- renderText({
      shiny::req(stats_table())
      foundr::unite_datatraits(stats_table(), key = TRUE)[1]
    })
  }
  shiny::shinyApp(ui = ui, server = server)
}
#' @rdname traitOrderApp
#' @export
traitOrderServer <- function(id, main_par,
  traitStats, customSettings = NULL, keepDatatraits = shiny::reactive(NULL)) {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Table
    output$key_stats <- DT::renderDataTable(
      {
        shiny::req(stats_table())
        
        # Summary gives nice table; use open thresholds to include all.
        foundr::summary_strainstats(stats_table(), threshold = c(deviance = 0, p = 1))
      },
      escape = FALSE,
      options = list(scrollX = TRUE, pageLength = 5))
    
    stats_table <- shiny::reactive({
      shiny::req(key_stats())
      order <- NULL
      if(shiny::isTruthy(main_par$order))
        order <- shiny::req(main_par$order)
      order_trait_stats(order, key_stats())
    })
    key_stats <- shiny::reactive({
      if(is.null(traitStats)) return(NULL)
      if(shiny::isTruthy(keepDatatraits())) {
        dplyr::select(
          dplyr::filter(
            tidyr::unite(
              traitStats,
              datatraits, dataset, trait, sep = ": ", remove = FALSE),
            datatraits %in% keepDatatraits()),
          -datatraits)
      } else {
        if(shiny::isTruthy(main_par$dataset)) {
          dplyr::filter(
            traitStats,
            .data$dataset %in% main_par$dataset)
        } else {
          NULL
        }
      }
    })
    
    ##########################################################
    # Return
    stats_table
  })
}
#' @rdname traitOrderApp
#' @export
traitOrderUI <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(  
    shiny::h3("Stats"),
    DT::dataTableOutput(ns("key_stats")))
}
