# foundrShiny Module Index & Design Conventions

## foundrShiny Module Index & Design Conventions

### 5-Function Shiny Module Design Pattern

`foundrShiny` strictly adheres to [Mastering Shiny Module
Conventions](https://mastering-shiny.org/scaling-modules.html). Every
component file in `R/` defines up to 5 standard exported functions:

| Function Pattern | Purpose | Example |
|----|----|----|
| `*Input(id)` | Sidebar UI / input parameter inputs | `foundrInput("foundr")` |
| `*UI(id)` | Parameter control / intermediate sub-panel UI | `panelParUI("panel_par")` |
| `*Output(id)` | Main display / visualization output UI | `biplotOutput("biplot")` |
| `*Server(id, ...)` | Server logic holding reactive expressions and observers | `volcanoServer("volcano", ...)` |
| `*App(...)` | Standalone test application runner for isolated module testing | `corTableApp(traitSignal)` |

> \[!NOTE\] **Terminology Distinction: Shiny Modules vs. WGCNA Trait
> Modules** In `foundrShiny`, the term *module* is used in two distinct
> contexts: 1. **Shiny Modules**: Encapsulated UI, server logic, and
> reactive state functions constructed using Shiny’s
> [`moduleServer()`](https://rdrr.io/pkg/shiny/man/moduleServer.html)
> (e.g., `contrastGroupServer`, `traitServer`). 2. **WGCNA Trait
> Modules**: Statistical groupings of correlated phenotypic traits
> identified via weighted gene co-expression network analysis (WGCNA).
> The `contrastGroupApp.R` Shiny module specifically visualizes WGCNA
> eigentraits (`eigens()`) and individual traits (`traits()`) belonging
> to WGCNA modules.

------------------------------------------------------------------------

### Complete Module Categorization

The ~30 package modules are grouped into 8 functional categories. Below
is a high-level flowchart depicting the system-level relationships
between infrastructure, parameter management, panel routers, and
visualization sub-modules.

``` mermaid
flowchart TD
    subgraph Infrastructure["1. Infrastructure & Parameters"]
        app["foundrApp & panelServer"]
        params["Parameter Tiers (mainPar, panelPar, plotPar)"]
    end

    subgraph Panels["Tab Panels"]
        trait["3. Trait Panel"]
        contrast["4. Contrast Panel"]
        stats["5. Stats Panel"]
        time["6. Time Panel"]
        about["About Panel"]
    end

    subgraph Plots["7. Plot Sub-Modules"]
        plotMods["biplotApp, dotplotApp, volcanoApp"]
    end

    app --> params
    app --> trait
    app --> contrast
    app --> stats
    app --> time
    app --> about

    contrast --> plotMods
    stats --> plotMods

    classDef infra fill:#1f77b4,stroke:#333,stroke-width:2px,color:#fff
    classDef panel fill:#d62728,stroke:#333,stroke-width:2px,color:#fff
    classDef plot fill:#8c564b,stroke:#333,stroke-width:2px,color:#fff

    class app,params infra
    class trait,contrast,stats,time,about panel
    class plotMods plot
```

------------------------------------------------------------------------

#### 1. Application Infrastructure & 2. Parameter Tier Modules

``` mermaid
flowchart TD
    foundrApp["foundrApp / foundrServer"]
    entryServer["entryServer (Authentication)"]
    panelServer["panelServer (5-Tab Router)"]
    downloadApp["downloadApp (Export Helper)"]
    aboutServer["aboutServer (Info & Help)"]

    mainParServer["mainParServer (Global: dataset, order, height)"]
    panelParServer["panelParServer (Panel: strains, sex, facet)"]
    plotParServer["plotParServer (Plot: thresholds, interact, labels)"]

    foundrApp --> entryServer
    foundrApp --> panelServer
    panelServer --> aboutServer
    panelServer --> downloadApp

    panelServer --> mainParServer
    mainParServer --> panelParServer
    panelParServer --> plotParServer

    classDef entry fill:#1f77b4,stroke:#333,stroke-width:2px,color:#fff
    classDef router fill:#ff7f0e,stroke:#333,stroke-width:2px,color:#fff
    classDef param fill:#2ca02c,stroke:#333,stroke-width:2px,color:#fff

    class foundrApp,entryServer,downloadApp,aboutServer entry
    class panelServer router
    class mainParServer,panelParServer,plotParServer param
```

- **`foundrApp.R`**: Top-level application entry point uniting entry
  authentication and panel router.
- **`panelApp.R`**: Five-tab panel router managing navigation across
  Trait, Contrast, Stats, Time, and About panels.
- **`entryApp.R`**: Optional password authentication module supporting
  debounced key entry.
- **`aboutApp.R`**: Information panel displaying project documentation,
  version info, and help files.
- **`downloadApp.R`**: Standardized download module taking plot and
  table reactive objects and formatting PDF/CSV exports.
- **`mainParApp.R`**: Global parameter manager (`main_par`: dataset
  instance, trait order method, plot height).
- **`panelParApp.R`**: Panel-level parameter manager (`panel_par`:
  strain/genotype filters, sex `B`/`F`/`M`/`C`, faceting).
- **`plotParApp.R`**: Plot-level parameter manager (`plot_par`: volcano
  thresholds `volsd`/`volvert`, interaction toggles, row labels).

------------------------------------------------------------------------

#### 3. Trait Panel Modules

``` mermaid
flowchart TD
    traitServer["traitServer (Trait Panel Router)"]
    panelParServer["panelParServer (Panel Parameters)"]

    corPlotApp["corPlotApp (Correlation Matrix Plots)"]
    corTableApp["corTableApp (Correlation Tables)"]
    traitNamesKey["traitNamesApp (Key Trait Selection)"]
    traitNamesRel["traitNamesApp (Related Trait Selection)"]
    traitOrderApp["traitOrderApp (Trait Sorting)"]
    traitPairsApp["traitPairsApp (Pairwise Scatter Plots)"]
    traitSolosApp["traitSolosApp (Individual Trait Plots)"]
    traitTableApp["traitTableApp (Phenotype Data Table)"]

    traitServer --> panelParServer
    traitServer --> traitOrderApp
    traitServer --> traitNamesKey
    traitServer --> corTableApp
    traitServer --> traitNamesRel
    traitServer --> corPlotApp
    traitServer --> traitTableApp
    traitServer --> traitSolosApp
    traitServer --> traitPairsApp

    classDef panel fill:#d62728,stroke:#333,stroke-width:2px,color:#fff
    classDef param fill:#2ca02c,stroke:#333,stroke-width:2px,color:#fff
    classDef submod fill:#9467bd,stroke:#333,stroke-width:2px,color:#fff

    class traitServer panel
    class panelParServer param
    class corPlotApp,corTableApp,traitNamesKey,traitNamesRel,traitOrderApp,traitPairsApp,traitSolosApp,traitTableApp submod
```

- **`traitApp.R`**: Master trait visualization panel routing sub-module
  displays.
- **`corPlotApp.R`**: Correlation matrix heatmaps and interactive
  scatter plots.
- **`corTableApp.R`**: Pairwise trait correlation tables.
- **`traitNamesApp.R`**: Trait selection UI helpers and dropdown
  managers.
- **`traitOrderApp.R`**: Trait sorting by statistical significance or
  module membership.
- **`traitPairsApp.R`**: Pairwise trait scatter plots and regression
  fits across strains.
- **`traitSolosApp.R`**: Individual trait distribution boxplots and
  strain means.
- **`traitTableApp.R`**: Phenotype summary data tables.

------------------------------------------------------------------------

#### 4. Contrast Panel Modules

``` mermaid
flowchart TD
    contrastServer["contrastServer (Contrast Panel Router)"]
    panelParServer["panelParServer (Panel Parameters)"]

    contrastTableApp["contrastTableApp (Contrast Table)"]
    traitOrderApp["traitOrderApp (Trait Sorting)"]
    contrastSexApp["contrastSexApp (Sex Contrast)"]
    contrastGroupApp["contrastGroupApp (Group/Module Contrast)"]
    contrastTimeApp["contrastTimeApp (Time Contrast)"]
    contrastTraitApp["contrastTraitApp (Trait Contrast)"]

    contrastPlotApp["contrastPlotApp (Plot Dispatcher)"]
    timeTraitsApp["timeTraitsApp (Time Trait Selector)"]
    timePlotApp["timePlotApp (Time Series Plot)"]
    plotParServer["plotParServer (Plot Parameters)"]

    biplotApp["biplotApp (PCA Biplot)"]
    dotplotApp["dotplotApp (Effect Size Dotplot)"]
    volcanoApp["volcanoApp (Volcano Plot)"]

    contrastServer --> panelParServer
    contrastServer --> contrastTableApp
    contrastServer --> contrastSexApp
    contrastServer --> contrastGroupApp
    contrastServer --> contrastTimeApp
    contrastServer --> contrastTraitApp

    contrastTableApp --> traitOrderApp
    contrastSexApp --> contrastPlotApp
    contrastGroupApp --> contrastPlotApp
    contrastTraitApp --> contrastPlotApp
    contrastTimeApp --> timeTraitsApp
    contrastTimeApp --> timePlotApp

    contrastPlotApp --> plotParServer
    contrastPlotApp --> biplotApp
    contrastPlotApp --> dotplotApp
    contrastPlotApp --> volcanoApp

    classDef panel fill:#d62728,stroke:#333,stroke-width:2px,color:#fff
    classDef param fill:#2ca02c,stroke:#333,stroke-width:2px,color:#fff
    classDef submod fill:#9467bd,stroke:#333,stroke-width:2px,color:#fff
    classDef plot fill:#8c564b,stroke:#333,stroke-width:2px,color:#fff

    class contrastServer panel
    class panelParServer,plotParServer param
    class contrastTableApp,traitOrderApp,contrastSexApp,contrastGroupApp,contrastTimeApp,contrastTraitApp,contrastPlotApp,timeTraitsApp,timePlotApp submod
    class biplotApp,dotplotApp,volcanoApp plot
```

- **`contrastApp.R`**: Condition contrast analysis panel across
  experimental groups.
- **`contrastGroupApp.R`**: WGCNA module and group contrast
  visualizations.
- **`contrastPlotApp.R`**: Wrapper module delegating to `volcanoApp`,
  `biplotApp`, and `dotplotApp`.
- **`contrastTableApp.R`**: Condition contrast differential tables.
- **`contrastTimeApp.R`**: Condition contrasts over longitudinal time
  series.
- **`contrastTraitApp.R`**: Single-trait condition contrast displays.

------------------------------------------------------------------------

#### 5. Stats Panel Modules

- **`statsApp.R`**: Statistical model design-effect panel delegating to
  `contrastPlotApp`.

------------------------------------------------------------------------

#### 6. Time Panel Modules

``` mermaid
flowchart TD
    timeServer["timeServer (Time Panel Router)"]
    panelParServer["panelParServer (Panel Parameters)"]

    timePlotApp["timePlotApp (Longitudinal Trait Plots)"]
    timeTableApp["timeTableApp (Time Observations Table)"]
    timeTraitsApp["timeTraitsApp (Time Trait Selection)"]
    traitOrderApp["traitOrderApp (Trait Sorting)"]

    timeServer --> panelParServer
    timeServer --> timePlotApp
    timeServer --> timeTableApp

    timeTableApp --> timeTraitsApp
    timeTableApp --> traitOrderApp

    classDef panel fill:#d62728,stroke:#333,stroke-width:2px,color:#fff
    classDef param fill:#2ca02c,stroke:#333,stroke-width:2px,color:#fff
    classDef submod fill:#9467bd,stroke:#333,stroke-width:2px,color:#fff

    class timeServer panel
    class panelParServer param
    class timePlotApp,timeTableApp,timeTraitsApp,traitOrderApp submod
```

- **`timeApp.R`**: Time-series phenotyping panel.
- **`timePlotApp.R`**: Longitudinal trait trajectory plots.
- **`timeTableApp.R`**: Time-series trait observation data tables.
- **`timeTraitsApp.R`**: Trait selection for time-series comparisons.

------------------------------------------------------------------------

#### 7. Plot Sub-Modules

- **`volcanoApp.R`**: Interactive volcano plots with log-fold change and
  p-value cutoffs.
- **`biplotApp.R`**: Principal component biplots highlighting strain
  vectors.
- **`dotplotApp.R`**: Ordered dotplots of strain contrast effect sizes.

------------------------------------------------------------------------

#### 8. Non-App Helper Files

- **`foundrSetup.R`**: Data loading and environment initialization
  script.
- **`foundr_helpers.R`**: Core helper routines for table formatting,
  vector subsetting, and UI styling.
