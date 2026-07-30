# Stats App

Stats App

Shiny Module Output for Stats Plot

## Usage

``` r
statsApp()

statsServer(id, main_par, traitStats, customSettings = NULL, facet = FALSE)

statsUI(id)

statsOutput(id)
```

## Arguments

- id:

  identifier for shiny reactive

- main_par:

  reactive arguments from \`server()\`

- traitStats:

  static data frame

- customSettings:

  list of custom settings

- facet:

  facet on \`strain\` if \`TRUE\`

## Value

reactive object for \`statsOutput\`

nothing returned
