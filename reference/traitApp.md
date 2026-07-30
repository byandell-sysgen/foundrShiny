# Trait Panel App

Trait Panel App

## Usage

``` r
traitApp()

traitServer(
  id,
  main_par,
  traitData,
  traitSignal,
  traitStats,
  customSettings = NULL
)

traitInput(id)

traitUI(id)

traitOutput(id)
```

## Arguments

- id:

  identifier for shiny reactive

- traitData, traitSignal, traitStats:

  static data frames

- customSettings:

  list of custom settings

## Value

reactive object
