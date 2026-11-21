
library(dplyr)
library(stats)

meta <- list(
    BugSigDB = data.frame(
        SourceUrl = "https://zenodo.org/records/",
        SourceVersion = "v1",
        FullName = "Bug Signatures Database",
        DataProvider = "BugSigDB",
        WebUrl = "https://bugsigdb.org",
        License = "ODC BY 1.0",
        DOI = "10.1038/s41587-023-01872-y",
        Location_Prefix = 18788725
    ),
    ChocoPhlAn = data.frame(
        SourceUrl = "https://zenodo.org/records/",
        SourceVersion = "v201901b",
        FullName = NA,
        DataProvider = "bioBakery",
        WebUrl = "https://huttenhower.sph.harvard.edu/humann",
        License = "MIT",
        DOI = "10.1038/s41592-018-0176-y",
        Location_Prefix = 18788725
    ),
    enviPath = data.frame(
        SourceUrl = NA,
        SourceVersion = "v2026_10",
        FullName = "Environmental biotransformation pathway database",
        DataProvider = "enviPath Ltd.",
        WebUrl = "https://envipath.org",
        License = "CC BY-NC-SA 4.0",
        DOI = "10.1186/s13321-024-00881-6",
        Location_Prefix = 18788725
    ),
    GM = data.frame(
        SourceUrl = "https://github.com/",
        SourceVersion = "v1",
        FullName = "Gut Modules",
        DataProvider = "Raes Lab",
        WebUrl = "https://code.raeslab.org",
        License = NA,
        DOI = "10.1038/nmicrobiol.2016.88, 10.1038/s41564-018-0337-x",
        Location_Prefix = 18788725
    ),
    GO = data.frame(
        SourceUrl = "https://release.geneontology.org/",
        SourceVersion = "v2026-01-23",
        FullName = "Gene Ontology",
        DataProvider = "Global Biodata Coalition",
        WebUrl = "https://www.geneontology.org",
        License = "CC BY 4.0",
        DOI = "10.1038/75556",
        Location_Prefix = 18788725
    ),
    KEGG = data.frame(
        SourceUrl = NA,
        SourceVersion = "v117",
        FullName = "Kyoto Encyclopedia of Genes and Genomes",
        DataProvider = "Kanehisa Laboratories",
        WebUrl = "https://www.kegg.jp",
        License = NA,
        DOI = "10.1093/nar/28.1.27",
        Location_Prefix = 18788725
    ),
    MSigDB = data.frame(
        SourceUrl = "https://zenodo.org/records/",
        SourceVersion = "2024.1",
        FullName = "Molecular Signatures Database",
        DataProvider = "Broad Institute",
        WebUrl = "https://www.gsea-msigdb.org/gsea/msigdb",
        License = "CC BY 4.0",
        DOI = "10.1073/pnas.0506580102",
        Location_Prefix = 18788725
    ),
    OTT = data.frame(
        SourceUrl = NA,
        SourceVersion = "v3.7",
        FullName = "Open Tree of Life Taxonomy",
        DataProvider = "Open Tree of Life",
        WebUrl = "https://opentreeoflife.github.io",
        License = "CC0 1.0",
        DOI = "10.1073/pnas.1423041112",
        Location_Prefix = 18788725
    ),
    Rhea = data.frame(
        SourceUrl = NA,
        SourceVersion = "v140",
        FullName = "The reaction knowledgebase",
        DataProvider = "Swiss Institute of Bioinformatics",
        WebUrl = "https://www.rhea-db.org",
        License = "CC BY 4.0",
        DOI = "10.1093/nar/gkab1016",
        Location_Prefix = 18788725
    ),
    TIGRFAMs = data.frame(
        SourceUrl = "https://ftp.ncbi.nlm.nih.gov/",
        SourceVersion = "v15",
        FullName = NA,
        DataProvider = "NCBI",
        WebUrl = "https://www.ncbi.nlm.nih.gov/refseq/annotation_prok/tigrfams",
        License = "CC BY-SA 4.0",
        DOI = "10.1093/nar/29.1.41",
        Location_Prefix = 18788725
    ),
    UniProt = data.frame(
        SourceUrl = "https://www.uniprot.org",
        SourceVersion = "v2026_01",
        FullName = "Universal Protein Resource",
        DataProvider = "Swiss Institute of Bioinformatics",
        WebUrl = "https://www.uniprot.org",
        License = "CC BY 4.0",
        DOI = "10.1093/nar/gkae1010",
        Location_Prefix = 18788725
    ),
    WoL = data.frame(
        SourceUrl = "https://ftp.microbio.me/pub/",
        SourceVersion = "v20April2021",
        FullName = "Web of Life",
        DataProvider = "Bascompte Lab",
        WebUrl = "https://www.web-of-life.es",
        License = NA,
        DOI = "10.1038/s41467-019-13443-4",
        Location_Prefix = 18788726
    ),
    WoL = data.frame(
        SourceUrl = "https://ftp.microbio.me/pub/",
        SourceVersion = "v2",
        FullName = "Web of Life",
        DataProvider = "Bascompte Lab",
        WebUrl = "https://www.web-of-life.es",
        License = NA,
        DOI = "10.1038/s41467-019-13443-4",
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
    BiocVersion = "3.24", SourceType = "TSV",
    Maintainer = "Giulio Benedetti <giulio.benedetti@utu.fi>",
    RDataClass = "igraph", DispatchClass = "FilePath",
    RDataPath = paste0(meta$id, ".gml")
))

col.names <- c(
    "Title", "Description", "BiocVersion", "SourceType", "SourceUrl",
    "SourceVersion", "FullName", "DataProvider", "WebUrl", "License", "DOI",
    "Maintainer", "RDataClass", "DispatchClass", "Location_Prefix", "RDataPath"
)

meta <- meta[col.names]

write.csv(meta, "metadata.csv", row.names = FALSE)
