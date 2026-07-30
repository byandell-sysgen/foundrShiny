# Trait Order App

Trait Order App

## Usage

``` r
traitOrderApp()

traitOrderServer(
  id,
  main_par,
  traitStats,
  customSettings = NULL,
  keepDatatraits = shiny::reactive(NULL)
)

traitOrderUI(id)
```

## Arguments

- id:

  identifier for shiny reactive

- main_par:

  input reactive list

- traitStats:

  static data frame

- customSettings:

  custom settings list

- keepDatatraits:

  keep datatraits if not \`NULL\`

## Value

reactive object
