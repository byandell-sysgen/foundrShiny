# Creating the foundrShiny Developer Guide

This document records the step-by-step process, prompts, blueprint references, design decisions, and build/deployment procedures used to create the `foundrShiny` developer guide vignette suite (`vignettes/devel_guide/`), root `DEVELOPER.md`, and `pkgdown` website configuration.

---

## 1. User Prompt & Blueprint Context

### Original User Prompts

**Prompts:**

- Create a DEVELOPER.md file for this project
- Using `~/Documents/GitHub/Documentation/{prompts/devel_guide,github/pkgdown}.md` and
`~/Documents/GitHub/Documentation/ShinyApps.md#foundrshiny-pragmatic-code-reuse-driven-by-collaborators`
as blueprints, create `vignettes/devel_guide` complete with `mermaid` flowchart of modules.

### Reference Blueprints Used

1. **`~/Documents/GitHub/Documentation/prompts/devel_guide.md`**:
   - Outlined master index structure (`vignettes/devel_guide/index.Rmd`), sub-module guides, layout conventions, and `pkgdown` article integration.
2. **`~/Documents/GitHub/Documentation/github/pkgdown.md`**:
   - Outlined `_pkgdown.yml` configuration, article grouping rules (including quoting subdirectory paths like `"devel_guide/index"`), `.Rbuildignore` anchored exclusions, `.nojekyll` creation, and `mermaid.js` script header injection (`template.includes.in_header`).
3. **`~/Documents/GitHub/Documentation/ShinyApps.md#foundrshiny-pragmatic-code-reuse-driven-by-collaborators`**:
   - Provided the definitive ~30 module breakdown for `foundrShiny`, mapping module categories (infrastructure, parameter tiers, trait/contrast/stats/time panels, plot sub-modules, non-app helpers) and the exact module calling hierarchy.

---

## 2. Process & Step-by-Step Implementation

### Step 1: Root Reference File (`DEVELOPER.md`)

Created [`DEVELOPER.md`](file:///Users/brianyandell/Documents/Research/byandell-sysgen/foundrShiny/DEVELOPER.md) in the project root to serve as an in-repo entry point detailing setup commands, the 5-function Shiny module design pattern, parameter scoping, runtime global data objects, and deployment guidelines.

### Step 2: Architectural Analysis & Code Audit

Inspected `R/*.R` source files and package namespace dependencies:

- Fixed missing `bslib` dependency and added `Remotes: byandell/foundr@foundrBase` for GitHub Actions dependency resolution in [`DESCRIPTION`](file:///Users/brianyandell/Documents/Research/byandell-sysgen/foundrShiny/DESCRIPTION).
- Added `stats::biplot` import in [`R/biplotApp.R`](file:///Users/brianyandell/Documents/Research/byandell-sysgen/foundrShiny/R/biplotApp.R).
- Added `globalVariables()` declarations in [`R/foundr_helpers.R`](file:///Users/brianyandell/Documents/Research/byandell-sysgen/foundrShiny/R/foundr_helpers.R) to resolve R CMD check warnings for non-standard evaluation variables and global app objects.

### Step 3: Creation of `vignettes/devel_guide/` Suite

Created a 3-part R Markdown article suite under `vignettes/devel_guide/`:

- **[`vignettes/devel_guide/index.Rmd`](file:///Users/brianyandell/Documents/Research/byandell-sysgen/foundrShiny/vignettes/devel_guide/index.Rmd)**:
  - Master index article providing package purpose, companion package mapping (`foundr`, `foundrHarmony`, `modulr`), local developer quick start commands, and a full visual `mermaid` reactivity flowchart of all ~30 modules.
- **[`vignettes/devel_guide/modules.Rmd`](file:///Users/brianyandell/Documents/Research/byandell-sysgen/foundrShiny/vignettes/devel_guide/modules.Rmd)**:
  - 5-function Shiny module design pattern documentation and exhaustive 8-category breakdown of all ~30 package modules.
- **[`vignettes/devel_guide/data_flow.Rmd`](file:///Users/brianyandell/Documents/Research/byandell-sysgen/foundrShiny/vignettes/devel_guide/data_flow.Rmd)**:
  - Details on `foundrSetup()`, global runtime data objects (`traitData`, `traitSignal`, `traitStats`, `traitModule`, `customSettings`), three-tier reactive parameter scoping (`main_par`, `panel_par`, `plot_par`), and unit testing with `*App()` test functions.

### Step 4: `_pkgdown.yml` & Mermaid.js Integration

Created [`_pkgdown.yml`](file:///Users/brianyandell/Documents/Research/byandell-sysgen/foundrShiny/_pkgdown.yml) in package root:

- Configured Bootstrap 5 theme.
- Added Mermaid.js CDN script injection in `template.includes.in_header` to automatically render `mermaid` flowcharts on `pkgdown` site pages.
- Grouped developer articles under `"devel_guide/index"`, `"devel_guide/modules"`, and `"devel_guide/data_flow"`.
- Ensured all `.Rmd` vignettes under `vignettes/` are indexed under `articles:` to prevent `pkgdown` missing vignette build errors.

### Step 5: `.Rbuildignore` & `.nojekyll` Setup

- Updated [`.Rbuildignore`](file:///Users/brianyandell/Documents/Research/byandell-sysgen/foundrShiny/.Rbuildignore) with anchored regex exclusions (`^_pkgdown\.yml$`, `^\.github$`, `^docs$`).
- Created [`docs/.nojekyll`](file:///Users/brianyandell/Documents/Research/byandell-sysgen/foundrShiny/docs/.nojekyll) to ensure GitHub Pages does not ignore underscore asset folders.

---

## 3. GitHub Pages & Website Publishing

When `pkgdown::build_site()` runs, it compiles static HTML files into `docs/`:

- **Main Developer Guide & Mermaid Flowchart**: `articles/devel_guide/index.html`
- **Module Index & Design Conventions**: `articles/devel_guide/modules.html`
- **Data Pipeline & Reactivity**: `articles/devel_guide/data_flow.html`
- **Articles Landing Page**: `articles/index.html`

### GitHub Pages Automated CI/CD Publishing via `gh-pages`

To avoid cluttering the `main` branch git history with hundreds of compiled HTML files from `docs/`:

1. **Keep `docs/` in `.gitignore`**: Local `pkgdown::build_site()` builds remain untracked in your local workspace, keeping `main` clean (source files only).
2. **Automated Deployment via [.github/workflows/pkgdown.yaml](file:///Users/brianyandell/Documents/Research/byandell-sysgen/foundrShiny/.github/workflows/pkgdown.yaml)**:
   - On every `git push` to `main`, GitHub Actions runs `pkgdown::build_site()` in a cloud container.
   - The workflow step `JamesIves/github-pages-deploy-action@v4` commits the compiled site directly to an isolated, automated **`gh-pages`** branch.
3. **GitHub Pages Setting**:
   - On GitHub.com under **Settings** -> **Pages**:
     - Set **Source**: **Deploy from a branch**
     - Set **Branch**: **`gh-pages`** / **`/ (root)`**
     - Click **Save**

> [!NOTE]
> **Why `jekyll-build-pages` failed previously**:
> GitHub's default Jekyll builder tried to build from `source: ./docs` on `main`. Because `docs/` was in `.gitignore` (and not pushed to `main`), the runner found no `./docs` folder. Deploying via GitHub Actions to the `gh-pages` branch resolves this completely without committing HTML files to `main`.

---

## 4. Verification Commands

The developer guide suite and package site can be built and verified locally:

```r
# Generate documentation and NAMESPACE
devtools::document()

# Compile vignettes / pkgdown articles
pkgdown::build_articles()

# Build full pkgdown site into docs/
pkgdown::build_site(install = FALSE)

# Run package checks
devtools::check(cran = FALSE, vignettes = FALSE)
```
