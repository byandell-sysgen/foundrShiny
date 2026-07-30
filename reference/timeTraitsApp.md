# Times Traits App

Times Traits App

## Usage

``` r
timeTraitsApp()

timeTraitsServer(
  id,
  panel_par,
  main_par,
  traitSignal,
  traitOrder,
  responses = c("value", "normed", "cellmean")
)

timeTraitsInput(id)

timeTraitsUI(id)

timeTraitsOutput(id)
```

## Arguments

- id:

  identifier for shiny reactive

- panel_par, main_par:

  reactive arguments

- traitSignal:

  static object

- traitOrder:

  reactive object

- responses:

  possible types of responses

## Value

nothing returned
