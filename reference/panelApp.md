# panel App for foundr package

panel App for foundr package

## Usage

``` r
panelApp(apptitle = "Panel App")

panelServer(
  id,
  traitData = NULL,
  traitSignal = NULL,
  traitStats = NULL,
  customSettings = NULL,
  traitModule = NULL,
  entry = shiny::reactive({
     2
 })
)

panelInput(id)

panelOutput(id)
```

## Arguments

- apptitle:

  title for panelApp

- id:

  identifier for shiny reactive

- traitData, traitSignal, traitStats, traitModule:

  static objects

- customSettings:

  list of custom settings

- entry:

  reactive entry flag (1 = no show, 2 = show)

## Value

reactive server
