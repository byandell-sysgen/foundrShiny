# AGENTS.md — foundrShiny

## Context

- **Repository**: `foundrShiny` (v0.5.4) — Interactive R Shiny web
  applications for multi-parent founder study data analysis (companion
  to `foundr`).
- **Key Directories**:
  - `R/`: Shiny modules, router logic, and helper functions
    (`foundr_helpers.R`).
  - `man/`: Roxygen-generated documentation.
  - `inst/`: Standalone Shiny deployment apps (`inst/shinyApp/`),
    documentation, data files.
  - `data/`: Reference data (`foundrNode.csv`, `foundrEdge.csv`).
- **Core Runtime Objects**: `traitData`, `traitSignal`, `traitStats`,
  `traitModule`, `customSettings` (loaded via
  [`foundrSetup()`](https://byandell-sysgen.github.io/foundrShiny/reference/foundrSetup.md)).

## Role

Act as an expert R package developer, bioinformatician, and Shiny
systems architect.

## Action & Verification

- **Package Checks**: Run `devtools::document()`, `devtools::test()`,
  and `devtools::check()` to verify changes.
- **Shiny Reactivity**: Verify module reactivity and server logic with
  [`shiny::testServer()`](https://rdrr.io/pkg/shiny/man/testServer.html)
  or targeted test scripts.
- **Documentation**: Never edit `man/` files directly; always update
  roxygen tags in `R/`.

## Format & Conventions

- **Module Architecture**: Follow Mastering Shiny module naming in `R/`:
  - `*Input()`, `*UI()`, `*Output()`, `*Server()`, `*App()` (standalone
    test app).
- **Module Hierarchy**:
  - `foundrApp` -\> `entryServer` (auth), `panelServer` (5 tabs:
    `trait`, `contrast`, `stats`, `time`, `about`), `mainParServer`
    (global params).
- **Three-Tier Parameter System**:
  1.  `main_par`: dataset, trait order, plot/table toggle, plot height.
  2.  `panel_par`: strain/genotype, sex (B/F/M/C), faceting, table type.
  3.  `plot_par`: order name, interaction settings, volcano thresholds
      (`volsd`, `volvert`), row names.
- **Namespacing & Dependencies**: Explicit package namespacing
  (`pkg::func()`) across all modules; UI styled via `bslib`.

## Tone & Collaboration

- Concise, precise, and actionable. Provide complete drop-in replacement
  code and run local verification before concluding tasks.
