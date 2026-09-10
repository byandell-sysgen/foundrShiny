if (!exists("deploy")) {
  deploy <- "liver"
}
if (!exists("deploydir")) {
  deploydir <- "deployLiverNew"
}
#deploy <- "trait"
#deploydir <- "deployNew"
if (!exists("small")) {
  small <- TRUE
}

dirpath <- file.path("../attie_alan/FounderDietStudy", deploydir)
traitData <- readRDS(file.path(dirpath, paste0(deploy, "Data.rds")))
traitSignal <- readRDS(file.path(dirpath, paste0(deploy, "Signal.rds")))
traitStats <- readRDS(file.path(dirpath, paste0(deploy, "Stats.rds")))
#traitModule <- readRDS(file.path(dirpath, "traitModule.rds"))
traitModule <- NULL
datasets <- readRDS(file.path(dirpath, "datasets.rds"))
customSettings <- list(
  help = "help.md",
  condition = "diet",
  group = "module",
#  entrykey = "Founder",
  dataset = datasets)
#Founder

# Small data
if(small) {
  datasets_sub <- unique(traitData$dataset)[1:2]
  traitData <- traitData |>
    dplyr::filter(dataset %in% datasets_sub) |>
    dplyr::group_by(dataset) |>
    dplyr::filter(trait %in% unique(trait)[1:2]) |>
    dplyr::ungroup()
  traitSignal <- traitSignal |>
    dplyr::semi_join(traitData, by = c("dataset", "trait"))
  traitStats <- traitStats |>
    dplyr::semi_join(traitData, by = c("dataset", "trait"))
}


