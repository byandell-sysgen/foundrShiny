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

``` mermaid
flowchart TD
    main_par["main_par (Global Parameters)<br/>dataset, trait order, plot/table toggle, height"]
    panel_par["panel_par (Panel Parameters)<br/>strains/genotypes, sex B/F/M/C, faceting, table mode"]
    plot_par["plot_par (Plot Parameters)<br/>volcano volsd/volvert, interact toggle, row names"]

    main_par --> panel_par
    panel_par --> plot_par

    classDef param fill:#2ca02c,stroke:#333,stroke-width:2px,color:#fff
    class main_par,panel_par,plot_par param
```

#### Parameter Persistence & Sub-Panel Reactivity

Managing input persistence across Shiny modules requires careful scoping
using [`reactiveVal()`](https://rdrr.io/pkg/shiny/man/reactiveVal.html)
and namespaced inputs:

- **Top-Level Parameter Flow**: `main_par$dataset` is passed from
  `mainParServer` to each panel module.
- **Panel Scoping**: Local selections (e.g., `keydataset` inside
  `traitOrderApp`) use
  [`reactiveVal()`](https://rdrr.io/pkg/shiny/man/reactiveVal.html) to
  maintain state while navigating sub-panels within the same tab.
- **Sub-Panel Parameter Sharing**:
  - In `contrastServer`, selection changes in the `Sex` sub-panel
    persist when switching to the `Group`/`Module` sub-panel (and
    vice-versa).
  - In `traitServer`, selecting a `key` trait updates choices available
    for `related` traits via `traitNamesApp`.
- **Cross-Tab Behavior**: Switching top-level tab panels re-evaluates
  scoped panel parameters against global defaults unless explicitly
  wired to `main_par`.

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
