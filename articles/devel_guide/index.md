# foundrShiny Developer Guide Overview & Architecture

## foundrShiny Developer Guide Overview & Architecture

### Package Purpose & Ecosystem

**foundrShiny** is an R Shiny package providing interactive web
applications for analyzing and visualizing multiparent founder study
data (such as Attie Lab founder mouse diet and calcium studies). It
serves as the modular interactive web companion to the core analytical
package [`foundr`](https://github.com/byandell/foundr) (branch
`foundrBase`).

- **Author:** Brian S Yandell (<brian.yandell@wisc.edu>)
- **License:** GPL-3
- **Minimum R Version:** ≥ 4.2.0

Related packages in the ecosystem: - **`foundr`**: Core data analysis
algorithms, statistical models, and `ggplot2` visualization functions. -
**`foundrShiny`**: Interactive Shiny module UI wrappers, tab routers,
reactive state handlers, and standalone test apps. -
**`foundrHarmony`**: Data harmonization across multi-tissue study
datasets (in development). - **`modulr`**: Standardization of WGCNA
module objects.

------------------------------------------------------------------------

### High-Level Module Architecture & Reactivity Flow

The package contains ~30 interconnected Shiny modules organized
hierarchically. Below is the complete visual reactivity calling
flowchart across the top-level application, panel routers, parameter
tiers, and analytical sub-modules.

``` mermaid
graph TD
    classDef entry fill:#1f77b4,stroke:#333,stroke-width:2px,color:#fff;
    classDef router fill:#ff7f0e,stroke:#333,stroke-width:2px,color:#fff;
    classDef param fill:#2ca02c,stroke:#333,stroke-width:2px,color:#fff;
    classDef panel fill:#d62728,stroke:#333,stroke-width:2px,color:#fff;
    classDef submod fill:#9467bd,stroke:#333,stroke-width:2px,color:#fff;
    classDef plot fill:#8c564b,stroke:#333,stroke-width:2px,color:#fff;

    foundrApp["foundrApp / foundrServer"]:::entry
    entryServer["entryServer (Auth)"]:::entry
    panelServer["panelServer (5-Tab Router)"]:::router

    mainParServer["mainParServer (Global Parameters)"]:::param
    panelParServer["panelParServer (Panel Parameters)"]:::param
    plotParServer["plotParServer (Plot Parameters)"]:::param

    traitServer["traitServer (Trait Panel)"]:::panel
    contrastServer["contrastServer (Contrast Panel)"]:::panel
    statsServer["statsServer (Stats Panel)"]:::panel
    timeServer["timeServer (Time Panel)"]:::panel
    aboutServer["aboutServer (About Panel)"]:::panel

    foundrApp --> entryServer
    foundrApp --> panelServer

    panelServer --> mainParServer
    panelServer --> traitServer
    panelServer --> contrastServer
    panelServer --> statsServer
    panelServer --> timeServer
    panelServer --> aboutServer

    %% Trait Panel Sub-modules
    traitServer --> panelParServer
    traitServer --> corPlotApp["corPlotApp"]:::submod
    traitServer --> corTableApp["corTableApp"]:::submod
    traitServer --> traitNamesApp["traitNamesApp (x2)"]:::submod
    traitServer --> traitOrderApp["traitOrderApp"]:::submod
    traitServer --> traitPairsApp["traitPairsApp"]:::submod
    traitServer --> traitSolosApp["traitSolosApp"]:::submod
    traitServer --> traitTableApp["traitTableApp"]:::submod

    %% Contrast Panel Sub-modules
    contrastServer --> panelParServer
    contrastServer --> contrastGroupApp["contrastGroupApp"]:::submod
    contrastServer --> contrastTimeApp["contrastTimeApp"]:::submod
    contrastServer --> contrastTableApp["contrastTableApp (x3)"]:::submod
    contrastServer --> contrastTraitApp["contrastTraitApp"]:::submod
    contrastServer --> timePlotApp["timePlotApp"]:::submod

    contrastGroupApp --> contrastPlotApp["contrastPlotApp"]:::submod
    contrastTableApp --> traitOrderApp
    contrastTimeApp --> timeTraitsApp["timeTraitsApp"]:::submod
    contrastTraitApp --> contrastPlotApp

    contrastPlotApp --> plotParServer
    contrastPlotApp --> biplotApp["biplotApp"]:::plot
    contrastPlotApp --> dotplotApp["dotplotApp"]:::plot
    contrastPlotApp --> volcanoApp["volcanoApp"]:::plot

    biplotApp --> mainParServer
    biplotApp --> panelParServer
    biplotApp --> plotParServer
    biplotApp --> contrastTableApp

    %% Stats Panel Sub-modules
    statsServer --> panelParServer
    statsServer --> contrastPlotApp

    %% Time Panel Sub-modules
    timeServer --> panelParServer
    timeServer --> timePlotApp
    timeServer --> timeTableApp["timeTableApp"]:::submod

    timeTableApp --> timeTraitsApp
    timeTableApp --> traitOrderApp
```

------------------------------------------------------------------------

### Developer Quick Start

#### Local Development Workflow

``` r

# Load local package sources dynamically
devtools::load_all()

# Re-generate documentation & NAMESPACE
devtools::document()

# Run R package checks
devtools::check()
```

#### Navigating the Guide

For detailed information on individual modules, parameters, and data
loading routines, explore the sub-guides:

- **[Shiny Module Index & Standard
  Conventions](https://byandell-sysgen.github.io/foundrShiny/articles/devel_guide/modules.md)**:
  Comprehensive listing of all ~30 modules and the standard 5-function
  Shiny module design pattern.
- **[Data Pipeline & Parameter
  Reactivity](https://byandell-sysgen.github.io/foundrShiny/articles/devel_guide/data_flow.md)**:
  Details on
  [`foundrSetup()`](https://byandell-sysgen.github.io/foundrShiny/reference/foundrSetup.md),
  parameter scoping (`main_par`, `panel_par`, `plot_par`), and
  standalone module test benches.
