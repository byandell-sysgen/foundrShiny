# Correlation Table App

Correlation Table App

## Usage

``` r
corTableApp()

corTableServer(id, main_par, key_trait, traitSignal, customSettings = NULL)

corTableInput(id)

corTableOutput(id)
```

## Arguments

- id:

  identifier for shiny reactive

- main_par:

  reactive inputs from calling modules

- key_trait:

  reactive character string

- traitSignal:

  static data frame

- customSettings:

  list of custom settings

## Value

reactive object
