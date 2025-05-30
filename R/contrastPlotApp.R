#' Contrast Plots App
#'
#' @param id identifier
#' @param panel_par,main_par input parameters
#' @param contrast_table reactive data frame
#' @param customSettings list of custom settings
#' @param modTitle character string title for section
#' @return reactive object 
#'
#' @importFrom shiny column fluidRow moduleServer NS observeEvent
#'             radioButtons reactive reactiveVal reactiveValues renderUI
#'             req selectInput tagList uiOutput updateSelectInput
#' @importFrom DT renderDataTable
#' @importFrom foundr ggplot_conditionContrasts summary_conditionContrasts
#'             summary_strainstats
#' @export
contrastPlotApp <- function() {
  title <- "Test contrastPlot Module"
  ui <- function() {
    shiny::fluidPage(
      shiny::titlePanel(title),
      shiny::sidebarLayout(
        shiny::sidebarPanel(
          mainParInput("main_par"), # dataset
          mainParUI("main_par"), # order
          border_line(),
          mainParOutput("main_par"), # plot_table, height
          downloadOutput("download")
        ),
        shiny::mainPanel(
          shiny::fluidRow(
            shiny::column(4, panelParUI("panel_par")), # sex
            shiny::column(8, contrastPlotUI("contrast_plot"))), # ordername, interact
          contrastPlotOutput("contrast_plot") # volsd, volvert, rownames
        )
      )
    )
  }
  server <- function(input, output, session) {
    main_par <- mainParServer("main_par", traitStats)
    panel_par <- panelParServer("panel_par", main_par, traitStats)
    contrast_table <- contrastTableServer("contrast_table", main_par,
                                          traitSignal, traitStats, customSettings)
    contrast_list <- contrastPlotServer("contrast_plot", panel_par, main_par,
                                        contrast_table, customSettings)
    downloadServer("download", "Contrasts", main_par, contrast_list)
  }
  shiny::shinyApp(ui = ui, server = server)
}
#' @rdname contrastPlotApp
#' @export
contrastPlotServer <- function(id, panel_par, main_par,
                              contrast_table, customSettings = NULL,
                              modTitle = shiny::reactive("Contrasts")) {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    plot_par <- plotParServer("plot_par", contrast_table)
    volcano <- volcanoServer("volcano", panel_par, plot_par, plot_info,
      contrast_table)
    biplot  <- biplotServer("biplot", panel_par, plot_par, plot_info,
      contrast_table)
    dotplot <- dotplotServer("dotplot", panel_par, plot_par, plot_info,
      contrast_table)
    
    # Plot Info
    has_contrasts <- shiny::reactive({
      inherits(shiny::req(contrast_table()), "conditionContrasts")
    })
    plot_row = shiny::reactive({
      ifelse(has_contrasts(), "strain", "term")
    })
    plot_info <- shiny::reactiveValues(
      # Threshold List.
      threshold = shiny::reactive({
        shiny::req(plot_par$volvert, plot_par$volsd, plot_par$ordername)
        out <- c(SD = plot_par$volsd, p.value = 0.01, kME = 0.8, module = 10,
                 size = 15)
        out[plot_par$ordername] <- ifelse(plot_par$ordername == "p.value",
          10 ^ -plot_par$volvert, plot_par$volvert)
        out
      }),
      # Filter to desired rownames (strains or terms).
      rownames = shiny::reactive({
        shiny::req(contrast_table(), plot_par$rownames, plot_row())
        dplyr::filter(contrast_table(),
                      .data[[plot_row()]] %in% plot_par$rownames)
      })
    )
    
    output$plot_table <- shiny::renderUI({
      shiny::tagList(
        shiny::h3(modTitle()),
        switch(shiny::req(main_par$plot_table),
          Plots  = shiny::tagList(
            shiny::uiOutput(ns("plot_choice")),
            shiny::uiOutput(ns("plot"))), 
          Tables = DT::renderDataTable(tableObject(), escape = FALSE,
            options = list(scrollX = TRUE, pageLength = 10))))
    })
    output$plot_choice <- shiny::renderUI({
      choices <- c("Volcano","BiPlot","DotPlot")
      shiny::checkboxGroupInput(ns("plot_choice"), "",
                                choices = choices, selected = choices, inline = TRUE)
    })
    output$plot <- shiny::renderUI({
      shiny::req(input$plot_choice)
      shiny::tagList(
        if("Volcano" %in% input$plot_choice) volcanoOutput(ns("volcano")),
        if("BiPlot" %in% input$plot_choice)  biplotOutput(ns("biplot")),
        if("DotPlot" %in% input$plot_choice) dotplotOutput(ns("dotplot")))
    })

    tableObject <- shiny::reactive({
      shiny::req(contrast_table())
      title <- ifelse(has_contrasts(), "Strains", "Terms")
      if(title == "Strains") {
        foundr::summary_conditionContrasts(
          dplyr::filter(contrast_table(), sex == shiny::req(panel_par$sex)),
          ntrait = 0)
      } else { # title == "Terms"
        foundr::summary_strainstats(contrast_table(),
                            stats = "log10.p", model = "terms",
                            threshold = c(p.value = 1.0, SD = 0.0))
      }
    })
    
    output$vol_sliders <- shiny::renderUI({
      if(shiny::req(main_par$plot_table) == "Plots")
        plotParUI(ns("plot_par")) # volsd, volvert (sliders)
    })
    
    ###############################################################
    shiny::reactiveValues(
      panel = shiny::reactive(NULL),
      height      = shiny::reactive(panel_par$height),
      postfix = shiny::reactive({
        shiny::req(contrast_table())
        paste(unique(contrast_table()$dataset), collapse = ",")
      }),
      plotObject = shiny::reactive({
        if("Volcano" %in% input$plot_choice)
          print(shiny::req(volcano()))
        if("BiPlot" %in% input$plot_choice)
          print(shiny::req(biplot()))
        if("DotPlot" %in% input$plot_choice)
          print(shiny::req(dotplot()))
      }),
      tableObject = tableObject)
  })
}
#' @rdname contrastPlotApp
#' @export
contrastPlotUI <- function(id) {
  ns <- shiny::NS(id)
  plotParInput(ns("plot_par")) # ordername, interact
}
#' @rdname contrastPlotApp
#' @export
contrastPlotOutput <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::uiOutput(ns("vol_sliders")), # volsd, volvert (sliders)
    plotParOutput(ns("plot_par")), # rownames (strains/terms)
    shiny::uiOutput(ns("plot_table")))
}
