# Data Pipeline, Parameter Reactivity & Isolated Testing

## Data Pipeline, Parameter Reactivity & Isolated Testing

### Runtime Data Initialization (`foundrSetup`)

Before launching server modules or standalone test apps, runtime dataset
objects are initialized via
[`foundrSetup()`](https://byandell-sysgen.github.io/foundrShiny/reference/foundrSetup.md):

``` r

foundrSetup(
  data_instance = "Liver",
  data_subset   = c("Physio", "MixMod"),
  custom_settings = TRUE,
  dirpath       = "~/founder_diet_study/HarmonizedData"
)
```

#### Global Runtime Objects

[`foundrSetup()`](https://byandell-sysgen.github.io/foundrShiny/reference/foundrSetup.md)
generates five core global objects required by module servers:

| Object | Data Structure | Purpose |
|----|----|----|
| `traitData` | `tibble` / `data.frame` | Individual observation measurements |
| `traitSignal` | `tibble` / `data.frame` | Cell means and normalized trait metrics |
| `traitStats` | `list` / `tibble` | ANOVA estimates and statistical contrast results |
| `traitModule` | `list` | WGCNA module assignments |
| `customSettings` | `list` | App deployment metadata, dataset lists, and help file paths |

------------------------------------------------------------------------

### Three-Tier Parameter Reactivity

Parameters are managed as standard Shiny `reactiveValues` across three
distinct tiers:

``` r

# Server initialization pattern
main_par  <- mainParServer("main_par", traitSignal)
panel_par <- panelParServer("panel_par", main_par, traitSignal)
plot_par  <- plotParServer("plot_par", contrast_table)
```

           +--------------------------------------------------------+
           |               main_par (Global Parameters)            |
           |  (dataset, trait order, plot/table toggle, height)     |
           +---------------------------+----------------------------+
                                       |
                                       v
           +--------------------------------------------------------+
           |             panel_par (Panel Parameters)              |
           |  (strains/genotypes, sex B/F/M/C, faceting, table mode) |
           +---------------------------+----------------------------+
                                       |
                                       v
           +--------------------------------------------------------+
           |              plot_par (Plot Parameters)                |
           |   (volcano volsd/volvert, interact toggle, row names)  |
           +--------------------------------------------------------+

------------------------------------------------------------------------

### Unit Testing with Standalone Module Apps

Each file in `R/*.R` exports a standalone `*App()` function that acts as
an isolated test harness. This allows developers to test individual UI
components or plots without running the full multi-tab app.

``` r

library(foundrShiny)

# 1. Initialize data
foundrSetup(data_instance = "Liver", data_subset = "Physio")

# 2. Test correlation table module in isolation
corTableApp(traitSignal)

# 3. Test volcano plot module in isolation
volcanoApp(traitStats)

# 4. Test full trait panel in isolation
traitApp(traitData, traitSignal, customSettings)
```
