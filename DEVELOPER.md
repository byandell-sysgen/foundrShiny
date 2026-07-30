# foundrShiny Developer Guide

## Overview

**foundrShiny** is an R Shiny package that provides modular interactive web application tools for analyzing and visualizing multiparent founder study data. It serves as the interactive web companion to the [`foundr`](https://github.com/byandell/foundr) analysis package (branch `foundrBase`).

- **Author:** Brian S Yandell (<brian.yandell@wisc.edu>)
- **License:** GPL-3
- **Minimum R Version:** ≥ 4.2.0

---

## 1. Development Environment Setup

### Prerequisites

Ensure you have R (≥ 4.2.0), RStudio (or VS Code with R extension), and key developer tools installed:

```r
install.packages(c("devtools", "roxygen2", "testthat", "pkgload"))
```

### Dependency Installation

`foundrShiny` relies on the `foundr` analysis package (specifically the `foundrBase` branch). This non-CRAN dependency is declared in `DESCRIPTION` via `Remotes: byandell/foundr@foundrBase` for automated CI/CD resolution.

```r
# Install core foundr dependency
devtools::install_github("byandell/foundr", ref = "foundrBase")

# Install foundrShiny from GitHub
devtools::install_github("byandell/foundrShiny")
```

### Local Development Workflow

When editing `foundrShiny` source code in RStudio or terminal:

```r
# Load local code without full package installation
devtools::load_all()

# Generate updated documentation (man/*.Rd) and NAMESPACE
devtools::document()

# Run R package check
devtools::check()
```

---

## 2. Architecture & Module Design

The package is built entirely with **Shiny Modules** following standard conventions from [Mastering Shiny](https://mastering-shiny.org/).

### Naming Conventions

Each module defined in `R/*.R` strictly adheres to a standard set of 5 exported functions:

| Function Pattern | Purpose |
|---|---|
| `*Input(id)` | Sidebar / input UI component |
| `*UI(id)` | Parameter control / sub-panel UI |
| `*Output(id)` | Main display / visualization output UI |
| `*Server(id, ...)` | Server logic handling reactive state and observers |
| `*App(...)` | Standalone test application runner for isolated module testing |

### Core Module Hierarchy

```
foundrApp (Top-level application entry point)
├── entryServer (Optional password authentication & access control)
└── panelServer (Five-tab main application router)
    ├── mainParServer   (Global application parameters)
    ├── traitServer     (Trait visualization & correlation analysis)
    │   ├── corTableApp / corPlotApp
    │   ├── traitTableApp / traitSolosApp / traitPairsApp
    │   └── traitOrderApp / traitNamesApp
    ├── contrastServer  (Condition contrast analysis)
    │   ├── contrastSexApp / contrastGroupApp / contrastTimeApp
    │   └── contrastPlotApp (volcanoApp, biplotApp, dotplotApp)
    ├── statsServer     (Design-effect model statistics)
    │   └── contrastPlotApp
    ├── timeServer      (Time-series phenotyping)
    │   ├── timeTableApp / timeTraitsApp
    │   └── timePlotApp
    └── aboutServer     (Application documentation & version metadata)
```

---

## 3. Parameter Architecture (Three-Tier `reactiveValues`)

App parameters are decoupled into three distinct reactive parameter tiers to simplify state propagation:

```r
main_par  <- mainParServer("main_par", traitSignal)
panel_par <- panelParServer("panel_par", main_par, traitSignal)
plot_par  <- plotParServer("plot_par", contrast_table)
```

### 1. Global Parameters (`main_par`)
Managed via [`R/mainParApp.R`](file:///Users/brianyandell/Documents/Research/byandell-sysgen/foundrShiny/R/mainParApp.R).
- Selected dataset instance
- Trait ordering method
- Table vs. plot output toggles
- Dynamic plot container height

### 2. Panel-Level Parameters (`panel_par`)
Managed via [`R/panelParApp.R`](file:///Users/brianyandell/Documents/Research/byandell-sysgen/foundrShiny/R/panelParApp.R).
- Strain / genotype filter selections
- Sex groupings (`B`oth, `F`emale, `M`ale, `C`ombined)
- Faceting configurations
- Table display mode

### 3. Plot-Specific Parameters (`plot_par`)
Managed via [`R/plotParApp.R`](file:///Users/brianyandell/Documents/Research/byandell-sysgen/foundrShiny/R/plotParApp.R).
- Volcano plot thresholds (`volsd` for standard deviation cutoff, `volvert` for log-p cutoff)
- Interaction terms toggles
- Strain / term row labels

---

## 4. Runtime Data Pipeline

App state and data loading are initialized prior to launching server components via `foundrSetup()`.

```r
foundrSetup(
  data_instance = "Liver",
  data_subset   = c("Physio", "MixMod"),
  dirpath       = "~/path/to/deploy/HarmonizedData"
)
```

### Global Runtime Objects

`foundrSetup()` generates five global objects required by module servers:

| Object | Data Type | Description |
|---|---|---|
| `traitData` | `data.frame` / `tibble` | Individual-level raw phenotypic measurements |
| `traitSignal` | `data.frame` / `tibble` | Cell means and normalized trait values |
| `traitStats` | `list` / `data.frame` | Model estimates, ANOVA tables, and contrast stats |
| `traitModule` | `list` | WGCNA or clustering module assignments |
| `customSettings` | `list` | Deployment metadata (app title, help paths, dataset lists) |

---

## 5. Isolated Sub-Module Testing

One of the key developer features of `foundrShiny` is that every file in `R/` includes a self-contained `*App()` function. This allows developers to test and debug individual UI elements or plots without spinning up the full multi-tab application.

### Examples

```r
library(foundrShiny)

# Initialize runtime environment
foundrSetup(data_instance = "Liver", data_subset = "Physio")

# Test only the correlation table module
corTableApp(traitSignal)

# Test only the volcano plot module
volcanoApp(traitStats)

# Test the trait visualization panel independently
traitApp(traitData, traitSignal, customSettings)
```

---

## 6. Deploying Applications

Production applications are typically deployed via a single `app.R` entry point located in [`inst/shinyApp/app.R`](file:///Users/brianyandell/Documents/Research/byandell-sysgen/foundrShiny/inst/shinyApp/app.R) or dedicated deployment directories.

### Example `app.R` Structure

```r
library(shiny)
library(foundrShiny)

# Load data and setup parameters
foundrShiny::foundrSetup(
  data_instance = "Liver",
  data_subset   = c("Physio", "MixMod"),
  custom_settings = TRUE,
  dirpath       = "~/path/to/deploy/"
)

# Launch Shiny app using foundrApp UI/Server
foundrShiny::foundrApp()
```

---

## 7. Developer Coding Guidelines

- **Explicit Package Namespacing:** Use `pkg::func()` for all imported functions (e.g., `shiny::moduleServer()`, `ggplot2::ggplot()`, `dplyr::filter()`) to prevent namespace collisions.
- **Safe Vector Subsetting in R:** When stripping or filtering R comments, ALWAYS use `grepl("^\\s*#'", lines)` with `!grepl(...)` or `grep(..., invert = TRUE)`. Avoid using `!grep(...)` which can evaluate to logical `FALSE` and unexpectedly empty atomic vectors to `character(0)`.
- **Roxygen Documentation:** Document exported functions using `#'` blocks in `R/*.R` files and maintain clear parameter descriptions.
- **Verification:** Run `devtools::check()` locally before submitting pull requests or preparing package releases.
