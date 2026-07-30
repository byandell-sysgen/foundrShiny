# Contrasts over Time App

Contrasts over Time App

Shiny Module Input for Contrasts over Time

Shiny Module UI for Contrasts over Time

## Usage

``` r
contrastTimeApp()

contrastTimeServer(
  id,
  panel_par,
  main_par,
  traitSignal,
  traitStats,
  contrastTable,
  customSettings = NULL
)

contrastTimeInput(id)

contrastTimeUI(id)
```

## Arguments

- id:

  identifier for shiny reactive

- panel_par, main_par:

  reactive arguments

- traitSignal, traitStats:

  static data frames

- customSettings:

  list of custom settings

## Value

reactive object

nothing returned

nothing returned
