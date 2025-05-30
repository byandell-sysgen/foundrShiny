#' Trait Pairs App
#'
#' @param id identifier for shiny reactive
#' @param input,output,session standard shiny arguments
#' @param panel_par,main_par reactive arguments from `foundrServer`
#' @param trait_names reactive with trait names
#' @param trait_table reactive objects from `foundrServer`
#' @return reactive object for `traitSolos`
#' 
#' @importFrom shiny isTruthy moduleServer observeEvent NS plotOutput radioButtons 
#'             reactive renderPlot renderUI req tagList uiOutput
#' @importFrom DT renderDataTable dataTableOutput
#' @importFrom foundr ggplot_traitPairs traitPairs
#' @importFrom dplyr distinct filter
#' @importFrom rlang .data
#' @export
traitPairsApp <- function(id) {
  title <- "Test Shiny Trait Pairs"
  ui <- function() {
    shiny::fluidPage(
      shiny::titlePanel(title),
      shiny::sidebarLayout(
        shiny::sidebarPanel(
          shiny::fluidRow(
            shiny::column(3, mainParInput("main_par")), # dataset
            shiny::column(3, mainParUI("main_par")), # order
            shiny::column(6, traitNamesUI("key_trait"))), # key_trait
          shiny::fluidRow(
            shiny::column(6, corTableInput("cors_table")),
            shiny::column(6, traitNamesUI("rel_traits"))),
          traitTableUI("trait_table"), # butresp
          shiny::fluidRow(
            shiny::column(6, mainParOutput1("main_par")), # plot_table
            shiny::column(6, panelParOutput("panel_par"))) # height or table
        ),
        
        shiny::mainPanel(
          panelParInput("panel_par"), # strains, facet
          traitPairsOutput("pairs_plot"),
          traitTableOutput("trait_table")
        )))
  }
  
  server <- function(input, output, session) {
    main_par <- mainParServer("main_par", traitStats)
    panel_par <- panelParServer("panel_par", main_par, traitStats)
    stats_table <- traitOrderServer("stats_table", main_par,
                                    traitStats, customSettings)
    key_trait    <- traitNamesServer("key_trait", main_par, stats_table)
    cors_table  <- corTableServer("cors_table", main_par,
                                  key_trait, traitSignal, customSettings)
    rel_traits   <- traitNamesServer("rel_traits", main_par, cors_table, TRUE)
    trait_table <- traitTableServer("trait_table", panel_par,
                                    key_trait, rel_traits, traitData, traitSignal)
    # *** not working yet
    traitPairsServer("pairs_plot", panel_par, main_par,
                     trait_names, trait_table)
    
    trait_names <- shiny::reactive({
      c(shiny::req(key_trait()), rel_traits())
    }, label = "trait_names")
  }
  
  shiny::shinyApp(ui = ui, server = server)
}
#' @rdname traitPairsApp
#' @export
traitPairsServer <- function(id, panel_par, main_par, trait_names,
                             trait_table) {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Output: Plots or Data
    output$pairs <- shiny::renderPlot({
      shiny::req(pairs_plot())
      print(pairs_plot())
    })
    output$pairs_plot <- shiny::renderUI({
      shiny::req(pairs_plot(), panel_par$height)
      shiny::plotOutput(ns("pairs"), height = paste0(panel_par$height, "in"))
    })
    
    # Plot
    pairs_plot <- shiny::reactive({
      shiny::req(trait_table(), trait_names())
      
      foundr::ggplot_traitPairs(
        foundr::traitPairs(
          trait_table(),
          trait_names(),
          pair()),
        facet_strain = shiny::isTruthy(panel_par$facet),
        parallel_lines = TRUE)
    },
    label = "pairs_plot")

    # INPUT PAIR
    pair <- shiny::reactive({
      trait_pairs(trait_names())
    },
    label = "pair")
    # Obsolete
    output$pair <- shiny::renderUI({
      shiny::req(trait_names())
      if(length(trait_names()) < 2)
        return(NULL)
      choices <- trait_pairs(trait_names(), key = FALSE)
      
      shiny::selectInput(
        "pair", "Select pairs for scatterplots",
        choices = choices, selected = choices[1],
        multiple = TRUE, width = '100%')
    })
    
    #############################################################
    
    pairs_plot
  })
}
#' @rdname traitPairsApp
#' @export
traitPairsOutput <- function(id) {
  ns <- shiny::NS(id)
  shiny::uiOutput(ns("pairs_plot"))
}
