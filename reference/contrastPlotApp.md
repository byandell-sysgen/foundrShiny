# Contrast Plots App

Contrast Plots App

## Usage

``` r
contrastPlotApp()

contrastPlotServer(
  id,
  panel_par,
  main_par,
  contrast_table,
  customSettings = NULL,
  modTitle = shiny::reactive("Contrasts")
)

contrastPlotUI(id)

contrastPlotOutput(id)
```

## Arguments

- id:

  identifier

- panel_par, main_par:

  input parameters

- contrast_table:

  reactive data frame

- customSettings:

  list of custom settings

- modTitle:

  character string title for section

## Value

reactive object
