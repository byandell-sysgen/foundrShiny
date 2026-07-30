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
    foundrApp["foundrApp / foundrServer"]
    panelServer["panelServer (5-Tab Router)"]

    mainParServer["mainParServer (Global Parameters)"]

    subgraph Panels["Tab Panels (3-6)"]
        traitServer["3. Trait Panel (traitServer)"]
        contrastServer["4. Contrast Panel (contrastServer)"]
        statsServer["5. Stats Panel (statsServer)"]
        timeServer["6. Time Panel (timeServer)"]
        aboutServer["About Panel (aboutServer)"]
    end

    subgraph Plots["7. Plot Sub-Modules"]
        plotMods["biplotApp, dotplotApp, volcanoApp"]
    end

    foundrApp --> panelServer

    panelServer --> mainParServer
    panelServer --> traitServer
    panelServer --> contrastServer
    panelServer --> statsServer
    panelServer --> timeServer
    panelServer --> aboutServer

    contrastServer --> plotMods
    statsServer --> plotMods

    classDef entry fill:#1f77b4,stroke:#333,stroke-width:2px,color:#fff
    classDef router fill:#ff7f0e,stroke:#333,stroke-width:2px,color:#fff
    classDef param fill:#2ca02c,stroke:#333,stroke-width:2px,color:#fff
    classDef panel fill:#d62728,stroke:#333,stroke-width:2px,color:#fff
    classDef plot fill:#8c564b,stroke:#333,stroke-width:2px,color:#fff

    class foundrApp entry
    class panelServer router
    class mainParServer param
    class traitServer,contrastServer,statsServer,timeServer,aboutServer panel
    class plotMods plot
```

------------------------------------------------------------------------

#### 1. Application Infrastructure

``` mermaid
flowchart TD
    foundrApp["foundrApp / foundrServer"]
    entryServer["entryServer (Authentication)"]
    panelServer["panelServer (5-Tab Router)"]
    downloadApp["downloadApp (Export Helper)"]
    aboutServer["aboutServer (Info & Help)"]

    foundrApp --> entryServer
    foundrApp --> panelServer
    panelServer --> aboutServer
    panelServer --> downloadApp

    classDef entry fill:#1f77b4,stroke:#333,stroke-width:2px,color:#fff
    classDef router fill:#ff7f0e,stroke:#333,stroke-width:2px,color:#fff

    class foundrApp,entryServer,downloadApp,aboutServer entry
    class panelServer router
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

------------------------------------------------------------------------

#### 2. Parameter Tier Modules

``` mermaid
flowchart TD
    mainParServer["mainParServer (Global: dataset, order, height)"]
    panelParServer["panelParServer (Panel: strains, sex, facet)"]
    plotParServer["plotParServer (Plot: thresholds, interact, labels)"]

    mainParServer --> panelParServer
    panelParServer --> plotParServer

    classDef param fill:#2ca02c,stroke:#333,stroke-width:2px,color:#fff
    class mainParServer,panelParServer,plotParServer param
```

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

    subgraph Inputs["Parameter & Data Inputs"]
        main_par["mainParServer (main_par)"]
        panel_par["panelParServer (panel_par)"]
        traitStats["traitStats"]
        traitSignal["traitSignal"]
        traitData["traitData"]
    end

    subgraph OrderingKey["1. Ordering & Key Trait Selection"]
        traitOrderApp["traitOrderApp (Order Traits by Stats)"]
        keyTrait["traitNamesApp (Key Trait Selector)"]
    end

    subgraph Correlations["2. Correlation Analysis"]
        corTableApp["corTableApp (Correlation Table)"]
        relTraits["traitNamesApp (Related Traits Selector)"]
        corPlotApp["corPlotApp (Correlation Matrix Plot)"]
    end

    subgraph PhenotypeDisplay["3. Phenotype Data & Plotting"]
        trait_names["trait_names (Combined Key + Related Traits)"]
        traitTableApp["traitTableApp (Phenotype Data Table)"]
        traitSolosApp["traitSolosApp (Individual Trait Plots)"]
        traitPairsApp["traitPairsApp (Pairwise Scatter Plots)"]
    end

    traitServer --> main_par
    traitServer --> panel_par

    traitStats --> traitOrderApp
    main_par --> traitOrderApp

    traitOrderApp -->|"stats_table"| keyTrait
    main_par --> keyTrait

    keyTrait -->|"key_trait"| corTableApp
    traitSignal --> corTableApp

    corTableApp -->|"cors_table"| relTraits
    corTableApp -->|"cors_table"| corPlotApp

    keyTrait -->|"key_trait"| trait_names
    relTraits -->|"rel_traits"| trait_names

    keyTrait -->|"key_trait"| traitTableApp
    relTraits -->|"rel_traits"| traitTableApp
    traitData --> traitTableApp
    traitSignal --> traitTableApp
    panel_par --> traitTableApp

    traitTableApp -->|"trait_table"| traitSolosApp
    panel_par --> traitSolosApp

    traitTableApp -->|"trait_table"| traitPairsApp
    trait_names -->|"trait_names"| traitPairsApp
    panel_par --> traitPairsApp

    classDef panel fill:#d62728,stroke:#333,stroke-width:2px,color:#fff
    classDef input fill:#1f77b4,stroke:#333,stroke-width:2px,color:#fff
    classDef submod fill:#9467bd,stroke:#333,stroke-width:2px,color:#fff

    class traitServer panel
    class main_par,panel_par,traitStats,traitSignal,traitData input
    class traitOrderApp,keyTrait,corTableApp,relTraits,corPlotApp,trait_names,traitTableApp,traitSolosApp,traitPairsApp submod
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

    subgraph Inputs["Parameter & Data Inputs"]
        main_par["mainParServer (main_par)"]
        panel_par["panelParServer (panel_par)"]
        traitSignal["traitSignal"]
        traitStats["traitStats"]
        traitModule["traitModule"]
        customSettings["customSettings"]
    end

    subgraph Tables["1. Contrast Tables (contrastTableServer)"]
        trait_table["trait_table (Trait Contrast Table)"]
        group_table["group_table (Group Contrast Table)"]
        stats_time_table["stats_time_table (Time Subsets)"]
        time_table["time_table (Time Contrast Table)"]
    end

    subgraph DisplayModules["2. Contrast View Modules"]
        contrastTraitApp["contrastTraitServer (Trait View)"]
        contrastGroupApp["contrastGroupServer (Group/Module View)"]
        contrastTimeApp["contrastTimeServer (Time View)"]
        timePlotApp["timePlotServer (Longitudinal Plot)"]
    end

    subgraph PlotDispatcher["3. Plot Dispatcher & Rendering"]
        contrastPlotApp["contrastPlotServer (Plot Dispatcher)"]
        plot_par["plotParServer (plot_par)"]
        biplotApp["biplotServer (PCA Biplot)"]
        dotplotApp["dotplotServer (Effect Size Dotplot)"]
        volcanoApp["volcanoServer (Volcano Plot)"]
    end

    contrastServer --> main_par
    contrastServer --> panel_par

    traitSignal & traitStats & main_par --> trait_table
    traitSignal & traitStats & traitModule & main_par --> group_table
    traitSignal & traitStats --> stats_time_table --> time_table

    trait_table --> contrastTraitApp
    trait_table & group_table & traitModule --> contrastGroupApp

    time_table & stats_time_table --> contrastTimeApp
    contrastTimeApp -->|"contrast_time"| timePlotApp

    contrastTraitApp --> contrastPlotApp
    contrastGroupApp --> contrastPlotApp

    contrastPlotApp --> plot_par
    contrastPlotApp --> biplotApp
    contrastPlotApp --> dotplotApp
    contrastPlotApp --> volcanoApp

    classDef panel fill:#d62728,stroke:#333,stroke-width:2px,color:#fff
    classDef input fill:#1f77b4,stroke:#333,stroke-width:2px,color:#fff
    classDef submod fill:#9467bd,stroke:#333,stroke-width:2px,color:#fff
    classDef plot fill:#8c564b,stroke:#333,stroke-width:2px,color:#fff

    class contrastServer panel
    class main_par,panel_par,traitSignal,traitStats,traitModule,customSettings input
    class trait_table,group_table,stats_time_table,time_table,contrastTraitApp,contrastGroupApp,contrastTimeApp,timePlotApp,contrastPlotApp,plot_par submod
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
