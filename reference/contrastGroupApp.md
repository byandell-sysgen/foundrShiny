# Groups of Contrasts App

Groups of Contrasts App

## Usage

``` r
contrastGroupApp()

contrastGroupServer(
  id,
  panel_par,
  main_par,
  traitModule,
  trait_table,
  group_table,
  customSettings = NULL
)

contrastGroupInput(id)

contrastGroupUI(id)

contrastGroupOutput(id)
```

## Arguments

- id:

  identifier for shiny reactive

- panel_par, main_par:

  reactive arguments

- traitModule:

  static data frames

- trait_table, traitContast:

  reactive data frames

- customSettings:

  list of custom settings

## Value

reactive object
