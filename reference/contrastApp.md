# Contrast Panel App

Contrast Panel App

## Usage

``` r
contrastApp()

contrastServer(
  id,
  main_par,
  traitSignal,
  traitStats,
  traitModule,
  customSettings = NULL
)

contrastInput(id)

contrastUI(id)

contrastOutput(id)
```

## Arguments

- id:

  identifier for shiny reactive

- main_par:

  reactive arguments

- traitSignal, traitStats, traitModule:

  static objects

- customSettings:

  list of custom settings

## Value

reactive object
