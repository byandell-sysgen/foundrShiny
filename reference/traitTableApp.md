# Trait Table App

Trait Table App

## Usage

``` r
traitTableApp()

traitTableServer(
  id,
  panel_par,
  key_trait,
  rel_traits,
  traitData,
  traitSignal,
  customSettings = NULL
)

traitTableUI(id)

traitTableOutput(id)
```

## Arguments

- id:

  identifier for shiny reactive

- panel_par:

  reactive arguments

- key_trait, rel_traits:

  reactives with trait names

- traitData, traitSignal:

  static objects

- input, output, session:

  standard shiny arguments

## Value

reactive object
