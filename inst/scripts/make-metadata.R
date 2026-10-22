
library(dplyr)
library(stats)

meta <- list(
    BugSigDB = data.frame(
        SourceUrl = "https://zenodo.org/records/",
        SourceVersion = "v1",
        DataProvider = "BugSigDB",
        Location_Prefix = 18788725
    ),
    ChocoPhlAn = data.frame(
        SourceUrl = "https://zenodo.org/records/",
        SourceVersion = "v201901b",
        DataProvider = "bioBakery",
        Location_Prefix = 18788725
    ),
    GM = data.frame(
      SourceUrl = "https://github.com/",
      SourceVersion = "v1",
      DataProvider = "Raes Lab",
      Location_Prefix = 18788725
    ),
    GO = data.frame(
        SourceUrl = "https://release.geneontology.org/",
        SourceVersion = "v2026-01-23",
        DataProvider = "Gene Onthology",
        Location_Prefix = 18788725
    ),
    KEGG = data.frame(
        SourceUrl = "https://www.kegg.jp/",
        SourceVersion = "v117",
        DataProvider = "Kyoto Encyclopedia of Genes and Genomes",
        Location_Prefix = 18788725
    ),
    MSigDB = data.frame(
        SourceUrl = "https://zenodo.org/records/",
        SourceVersion = "2024.1",
        DataProvider = "Broad Institute",
        Location_Prefix = 18788725
    ),
    OTT = data.frame(
        SourceUrl = "https://opentreeoflife.github.io/",
        SourceVersion = "v3.7",
        DataProvider = "Open Tree Taxonomy",
        Location_Prefix = 18788725
    ),
    Rhea = data.frame(
        SourceUrl = "https://www.rhea-db.org",
        SourceVersion = "v140",
        DataProvider = "Swiss Institute of Bioinformatics",
        Location_Prefix = 18788725
    ),
    TIGRFAMs = data.frame(
        SourceUrl = "https://ftp.ncbi.nlm.nih.gov/",
        SourceVersion = "v15",
        DataProvider = "NCBI",
        Location_Prefix = 18788725
    ),
    UniProt = data.frame(
        SourceUrl = "https://www.uniprot.org",
        SourceVersion = "v2026_01",
        DataProvider = "UniProt",
        Location_Prefix = 18788725
    ),
    WoL = data.frame(
        SourceUrl = "https://ftp.microbio.me/pub/",
        SourceVersion = "v20April2021",
        DataProvider = "Web of Life",
        Location_Prefix = 18788726
    ),
    WoL = data.frame(
        SourceUrl = "https://ftp.microbio.me/pub/",
        SourceVersion = "v2",
        DataProvider = "Web of Life",
        Location_Prefix = 18788725
    )
)

meta <- bind_rows(meta, .id = "id")

meta$Location_Prefix <- paste0(
    "https://zenodo.org/records/", meta$Location_Prefix, "/"
)

meta <- cbind(meta, data.frame(
    Title = paste0(
        "ariadne ", meta$id, " graph v",
        ave(seq_along(meta$id), meta$id, FUN = seq_along)
    ),
    Description = paste(
        "Graph of", meta$id, "feature mappings based on", meta$SourceVersion
    ),
    BiocVersion = "3.23", Genome = NA, SourceType = "TSV", Species = NA,
    TaxonomyId = NA, Coordinate_1_based = FALSE,
    Maintainer = "Giulio Benedetti <giulio.benedetti@utu.fi>",
    RDataClass = "igraph", DispatchClass = "FilePath",
    RDataPath = paste0(meta$id, ".gml")
))

col.names <- c(
    "Title", "Description", "BiocVersion", "Genome", "SourceType", "SourceUrl",
    "SourceVersion", "Species", "TaxonomyId", "Coordinate_1_based",
    "DataProvider", "Maintainer", "RDataClass", "DispatchClass",
    "Location_Prefix", "RDataPath"
)

meta <- meta[col.names]

write.csv(meta, "metadata.csv", row.names = FALSE)
