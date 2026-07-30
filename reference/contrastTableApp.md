# Contrast Table App

Contrast Table App

## Usage

``` r
contrastTableApp(id)

contrastTableServer(
  id,
  main_par,
  traitSignal,
  traitStats,
  customSettings = NULL,
  keepDatatraits = shiny::reactive(NULL)
)

contrastTableUI(id)
```

## Arguments

- id:

  identifier for shiny reactive

- main_par:

  parameters from calling modules

- traitSignal, traitStats:

  static data frames

- customSettings:

  list of custom settings

- keepDatatraits:

  keep datatraits if not \`NULL\`

## Value

reactive object
