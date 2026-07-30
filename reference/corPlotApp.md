# Correlation Plot App

Correlation Plot App

## Usage

``` r
corPlotApp()

corPlotServer(id, panel_par, cors_table, customSettings = NULL)

corPlotOutput(id)
```

## Arguments

- id:

  identifier for shiny reactive

- panel_par:

  reactive inputs from calling modules

- customSettings:

  static list of settings

- input, output, session:

  standard shiny arguments

- CorTable:

  reactive data frames

## Value

reactive object
