# Contrast Trait Plots App

Contrast Trait Plots App

## Usage

``` r
contrastTraitApp()

contrastTraitServer(
  id,
  panel_par,
  main_par,
  contrastTable,
  customSettings = NULL
)

contrastTraitInput(id)

contrastTraitOutput(id)
```

## Arguments

- id:

  identifier for shiny reactive

- panel_par, main_par:

  input parameters

- contrastTable:

  reactive data frame

- customSettings:

  list of custom settings

## Value

reactive object
