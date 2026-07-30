# BiPlot App

BiPlot App

Shiny Module Output for Contrast Plots

## Usage

``` r
biplotApp()

biplotServer(id, panel_par, plot_par, plot_info, contrast_table)

biplotOutput(id)
```

## Arguments

- id:

  identifier

- panel_par, plot_par:

  input parameters

- plot_info:

  reactive values from contrastPlot

- contrast_table:

  reactive data frame

## Value

reactive object

nothing returned
