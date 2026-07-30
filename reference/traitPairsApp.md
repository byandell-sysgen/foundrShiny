# Trait Pairs App

Trait Pairs App

## Usage

``` r
traitPairsApp(id)

traitPairsServer(id, panel_par, main_par, trait_names, trait_table)

traitPairsOutput(id)
```

## Arguments

- id:

  identifier for shiny reactive

- panel_par, main_par:

  reactive arguments from \`foundrServer\`

- trait_names:

  reactive with trait names

- trait_table:

  reactive objects from \`foundrServer\`

- input, output, session:

  standard shiny arguments

## Value

reactive object for \`traitSolos\`
