# foundrShiny — Project Memory

## Package Overview

**foundrShiny** is an R Shiny package providing interactive web applications
for analyzing multiparent founder study data.
It is a companion to the `foundr` package (core analysis functions).

- **Version:** 0.5.4
- **Author:** Brian S Yandell (brian.yandell@wisc.edu)
- **License:** GPL-3
- **Requires:** R ≥ 4.2.0

## Architecture

The package is fully modularized using Shiny modules
(Mastering Shiny conventions).
Every module in `R/` follows this naming pattern:
- `*Input()` — input UI
- `*UI()` — parameter UI
- `*Output()` — output/display UI
- `*Server()` — server logic
- `*App()` — standalone test app

### Module Hierarchy

```
foundrApp (main entry)
├── entryServer (optional password authentication)
└── panelServer (five-tab layout)
    ├── mainParServer        (global params: dataset, trait order, plot height)
    ├── traitServer          (trait panel)
    ├── contrastServer       (condition contrast panel)
    ├── statsServer          (design-effect statistics panel)
    ├── timeServer           (time-series panel)
    └── aboutServer          (help/info panel)
```

Each panel delegates to sub-modules (e.g., `corTableApp.R`, `volcanoApp.R`,
`timePlotApp.R`).

## Key R Files

| File | Role |
|------|------|
| `R/foundrApp.R` | Top-level app (UI + server) |
| `R/panelApp.R` | Five-tab panel router |
| `R/traitApp.R` | Trait visualization panel |
| `R/contrastApp.R` | Contrast analysis panel |
| `R/statsApp.R` | Statistical model panel |
| `R/timeApp.R` | Time-series panel |
| `R/mainParApp.R` | Global parameter module |
| `R/panelParApp.R` | Panel-level parameter module |
| `R/plotParApp.R` | Plot-level parameter module |
| `R/entryApp.R` | Authentication module |
| `R/downloadApp.R` | Download (PDF/CSV) module |
| `R/foundrSetup.R` | Data initialization |
| `R/foundr_helpers.R` | Core helper functions (450+ lines) |

## Parameter System (Three-Tier)

1. **`main_par`** — dataset selection, trait ordering, plot/table toggle,
plot height
2. **`panel_par`** — strain/genotype, sex (B/F/M/C), faceting, table type
3. **`plot_par`** — order name, interaction settings, volcano thresholds
(`volsd`, `volvert`), row names

## Runtime Data Objects

Loaded at app startup via `foundrSetup()`:

| Object | Description |
|--------|-------------|
| `traitData` | Raw individual-level observations |
| `traitSignal` | Processed traits (cell means, normalized) |
| `traitStats` | Statistical model results |
| `traitModule` | WGCNA module groupings (optional) |
| `customSettings` | Deployment-specific configuration |

## Reference Data Files (in `data/`)

- `foundrNode.csv` — Node definitions for DAG visualization (69 rows)
- `foundrEdge.csv` — Edge (module-to-module) relationships (47 rows)

## Deployment

Example deployment apps live in `inst/shinyApp/` and in external directories
(e.g., `FounderDietStudy/deployNew/app.R`). Typical setup:

```r
foundrSetup(
  data_instance = "Liver",
  data_subset   = c("Physio", "MixMod"),
  dirpath       = "~/path/to/deploy/"
)
```

Key `customSettings` fields: condition name, group name, dataset list,
help file path.

## Related Packages

- **foundr** — core analysis functions (branch: `foundrBase`)
- **foundrHarmony** — multi-source data harmonization (in development)
- **modulr** — WGCNA module standardization

## Known Planned Work

- Order module lists by p-values
- Add eigenvalue percentage display
- Improve condition contrast plotting
- Larger plot points on visualizations
- Refine plot guideline defaults
