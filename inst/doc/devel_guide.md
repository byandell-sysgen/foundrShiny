# Creating the foundrShiny Developer Guide

This document records the step-by-step process, prompts, blueprint references, and design decisions used to create the `foundrShiny` developer guide vignette suite (`vignettes/devel_guide/`) and `pkgdown` website configuration.

---

## 1. User Prompt & Blueprint Context

### Original User Prompt
```text
Using `~/Documents/GitHub/Documentation/{prompts/devel_guide,github/pkgdown}.md` and `~/Documents/GitHub/Documentation/ShinyApps.md#foundrshiny-pragmatic-code-reuse-driven-by-collaborators` as blueprints, create `vignettes/devel_guide` complete with `mermaid` flowchart of modules.
```

### Reference Blueprints Used

1. **`~/Documents/GitHub/Documentation/prompts/devel_guide.md`**:
   - Outlined master index structure (`vignettes/DeveloperGuide.Rmd` / `vignettes/devel_guide/index.Rmd`), sub-module guides, layout conventions, and `pkgdown` article integration.
2. **`~/Documents/GitHub/Documentation/github/pkgdown.md`**:
   - Outlined `_pkgdown.yml` configuration, article grouping rules (including quoting subdirectory paths like `"devel_guide/index"`), `.Rbuildignore` anchored exclusions, and `mermaid.js` script header injection (`template.includes.in_header`).
3. **`~/Documents/GitHub/Documentation/ShinyApps.md#foundrshiny-pragmatic-code-reuse-driven-by-collaborators`**:
   - Provided the definitive ~30 module breakdown for `foundrShiny`, mapping module categories (infrastructure, parameter tiers, trait/contrast/stats/time panels, plot sub-modules, non-app helpers) and the exact module calling hierarchy.

---

## 2. Process & Step-by-Step Implementation

### Step 1: Architectural Analysis of `foundrShiny`
Inspected `R/*.R` files and `AGENTS.md` to map out function naming patterns (`*Input`, `*UI`, `*Output`, `*Server`, `*App`) and module relationships across the 5 tab panels.

### Step 2: Creation of `vignettes/devel_guide/` Suite
Created a 3-part R Markdown article suite under `vignettes/devel_guide/`:

- **[`vignettes/devel_guide/index.Rmd`](file:///Users/brianyandell/Documents/Research/byandell-sysgen/foundrShiny/vignettes/devel_guide/index.Rmd)**:
  - Master index article providing package purpose, companion package mapping (`foundr`, `foundrHarmony`, `modulr`), local developer quick start commands, and a full visual `mermaid` reactivity flowchart of all modules.
- **[`vignettes/devel_guide/modules.Rmd`](file:///Users/brianyandell/Documents/Research/byandell-sysgen/foundrShiny/vignettes/devel_guide/modules.Rmd)**:
  - 5-function Shiny module design pattern documentation and exhaustive 8-category breakdown of all ~30 package modules.
- **[`vignettes/devel_guide/data_flow.Rmd`](file:///Users/brianyandell/Documents/Research/byandell-sysgen/foundrShiny/vignettes/devel_guide/data_flow.Rmd)**:
  - Details on `foundrSetup()`, global runtime data objects (`traitData`, `traitSignal`, `traitStats`, `traitModule`, `customSettings`), three-tier reactive parameter scoping (`main_par`, `panel_par`, `plot_par`), and unit testing with `*App()` test functions.

### Step 3: `_pkgdown.yml` & Mermaid.js Integration
Created `_pkgdown.yml` in package root:
- Configured Bootstrap 5 theme.
- Added Mermaid.js CDN script injection in `template.includes.in_header` to automatically render `mermaid` diagrams on `pkgdown` website pages.
- Grouped developer articles under `"devel_guide/index"`, `"devel_guide/modules"`, and `"devel_guide/data_flow"`.

### Step 4: `.Rbuildignore` & Build Exclusion Hygiene
Updated `.Rbuildignore` with anchored regex exclusions:
```regex
^\.Rproj\.user$
^\.Rhistory$
^foundrShiny\.Rproj$
^_pkgdown\.yml$
^\.github$
^docs$
```

---

## 3. Verification Commands

The developer guide suite can be compiled and verified using standard R developer tools:

```r
# Build vignettes
devtools::build_vignettes()

# Build full pkgdown site
pkgdown::build_site_github_pages(new_process = FALSE, install = FALSE)

# Package check
devtools::check(cran = FALSE, vignettes = FALSE)
```
