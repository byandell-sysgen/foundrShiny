# foundrShiny Deployment Application Directory (`inst/shinyApp/`)

This directory contains standalone deployment files, setup scripts, and Shiny application templates for running and deploying **foundrShiny** applications.

> [!NOTE]
> Detailed instructions for setting up data prerequisites and deploying applications are maintained in the published vignette:
> **[Application Deployment Guide](https://byandell-sysgen.github.io/foundrShiny/articles/devel_guide/deploy.html)**.

---

## Directory Overview

| File | Description |
| :--- | :--- |
| [`app.R`](app.R) | Primary Shiny application entry point using `foundrShiny::foundrSetup()`. |
| [`setup.R`](setup.R) | Standalone script for loading datasets into the workspace without `foundrSetup()`. |
| [`TraitData.R`](TraitData.R) | Helper script sourced by `foundrSetup()` to process and filter input RDS files. |
| [`appDetail.R`](appDetail.R) | Alternative standalone Shiny deployment script with explicit file path configurations. |
| [`intro.md`](intro.md) | Markdown overview displayed in the entry panel of the Shiny app. |
| [`help.md`](help.md) | User help documentation displayed within the interactive panels. |
| [`foundrDAG.Rmd`](foundrDAG.Rmd) | Directed Acyclic Graph (DAG) documentation file for trait module structures. |

For complete data preliminaries, setup script configuration (`setup.R` vs `foundrSetup()`), and command-line execution instructions, refer to the [Application Deployment Guide](https://byandell-sysgen.github.io/foundrShiny/articles/devel_guide/deploy.html).
