# Trait Names App

Select trait names in one of two modes, depending on the fixed
\`multiples\`: \`FALSE\` = only one trait name, \`TRUE\` = multiple
names. The order of choices depends on \`traitArranged()\`.

## Usage

``` r
traitNamesApp()

traitNamesServer(id, main_par, traitArranged, multiples = FALSE)

traitNamesUI(id)
```

## Arguments

- id:

  identifier for shiny reactive

- main_par:

  reactive arguments

- traitArranged:

  reactive data frames

- multiples:

  fixed logical for multiple trait names

## Value

reactive vector of trait names
