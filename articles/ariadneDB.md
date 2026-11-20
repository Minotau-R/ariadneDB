# ariadneDB: a harmonised graph of biological databases and relations

## Introduction

The way that ariadne retrieves and combines relational data is informed
by its companion data package
[ariadneDB](https://github.com/Minotau-R/ariadneDB), which contains
information about the feature types and mappings available from a
handful of popular databases. From here on, we will refer to those
databases as *resources* to distinguish them from the ariadne database
itself.

The relational information of each resource is described by a graph,
where nodes and edges represent feature types and mappings between them,
respectively. In ariadneDB, these graphs are stored in the Graph
Modelling Language (GML), which is a standard format for relational
data. Currently, ariadneDB includes 12 resources that span a diverse set
of biological domains and applications.

Geistlinger et al. (2024) Franzosa et al. (2018) Hafner et al. (2024)
Vieira-Silva et al. (2016); Valles-Colomer et al. (2019) Ashburner et
al. (2000) Kanehisa and Goto (2000) Subramanian et al. (2005) Hinchliff
et al. (2015) Bansal et al. (2022) Haft et al. (2001) Bateman et al.
(2025) Zhu et al. (2019)

## Tutorial

This tutorial demonstrates how to import and explore the ariadne
resource graph. First, we set up the environment by loading the
necessary dependencies.

\
`# Load required packages`\
[`library`](https://rdrr.io/r/base/library.html)`(`[`ariadne`](https://codeberg.org/Minotau-R/ariadne)`)`\
[`library`](https://rdrr.io/r/base/library.html)`(`[`igraph`](https://r.igraph.org/)`)`\
[`library`](https://rdrr.io/r/base/library.html)`(`[`dplyr`](https://dplyr.tidyverse.org)`)`\
[`library`](https://rdrr.io/r/base/library.html)`(`[`ggplot2`](https://ggplot2.tidyverse.org)`)`\
[`library`](https://rdrr.io/r/base/library.html)`(`[`DT`](https://github.com/rstudio/DT)`)`

When
[`ariadne()`](https://minotau-r.github.io/ariadne/reference/ariadne.html)
is executed, the graph for each resource is retrieved from the database
release on [Zenodo](https://zenodo.org/records/18788725) and combined
into a single igraph object.

\
`# Import resource graph`\
`graph`` ``<-`` `[`ariadne`](https://minotau-r.github.io/ariadne/reference/ariadne.html)`(``)`\
\
`# Plot resource graph`\
[`plotPath`](https://minotau-r.github.io/ariadne/reference/plotPath.html)`(``graph``)`\
`#> Using ``"stress"`` as default layout`

![](ariadneDB_files/figure-html/fetch-1.png)

Some resources have multiple versions, which can be selected through the
argument `versions`. This defaults to the latest version found in the
database.

\
`# List available resource versions`\
`versions`` ``<-`` `[`listResourceVersions`](https://minotau-r.github.io/ariadne/reference/listResourceVersions.html)`(``)`\
\
`# View versions`\
[`datatable`](https://rdrr.io/pkg/DT/man/datatable.html)`(``versions``)`

The igraph object is made of two components: edges data and nodes (or
vertices) data, which are stored in two different data tables.

\
`# Convert igraph to data.frame pair`\
`graph_df`` ``<-`` ``igraph``::`[`as_data_frame`](https://r.igraph.org/reference/graph_from_data_frame.html)`(``graph``, what ``=`` ``"both"``)`\
\
`# Extract edges data`\
`edge_df`` ``<-`` ``graph_df``$``edges`\
`# Extract nodes data`\
`node_df`` ``<-`` ``graph_df``$``vertices`

As mentioned above, the resource graph is composed of feature types
(nodes) and mappings (edges) from several resources. We generate the
summary statistics for each resource integrated within ariadne.

\
`# Get stats for each resource`\
`df`` ``<-`` ``edge_df`` ``|>`\
`    `[`group_by`](https://dplyr.tidyverse.org/reference/group_by.html)`(``source``)`` ``|>`\
`    `[`summarise`](https://dplyr.tidyverse.org/reference/summarise.html)`(``edges ``=`` `[`n`](https://dplyr.tidyverse.org/reference/context.html)`(``)``, nodes ``=`` `[`n_distinct`](https://dplyr.tidyverse.org/reference/n_distinct.html)`(`[`c`](https://rdrr.io/r/base/c.html)`(``from``, ``to``)``)``)`\
\
`# View stats`\
[`datatable`](https://rdrr.io/pkg/DT/man/datatable.html)`(``df``)`

The number of edges and nodes represent the amount of links and feature
types provided by each resource, respectively. These two metrics largely
vary between the available resources. The size and graph for each
resource can be visualized by generating individual graphs with the
argument `res.name`.

\
`# Create resource graphs`\
`plots`` ``<-`` `[`lapply`](https://rdrr.io/r/base/lapply.html)`(`\
`    ``df``$``source``, ``function``(``x``)`` ``{`\
`        `[`plotPath`](https://minotau-r.github.io/ariadne/reference/plotPath.html)`(``graph``, res.name ``=`` ``x``, layout ``=`` ``"stress"``, focus ``=`` ``TRUE``)`` ``+`\
`            `[`ggtitle`](https://ggplot2.tidyverse.org/reference/labs.html)`(``x``)`\
`    ``}`\
`)`\
`#> Warning in matrix(c(0, rep(0, dim - 1), 1, rep(0, dim - 2)), 2, dim, byrow =`\
`#> TRUE): data length [3] is not a sub-multiple or multiple of the number of rows`\
`#> [2]`\
\
`# View resource graphs`\
`plots`\
`#> [[1]]`

![](ariadneDB_files/figure-html/plot_graphs-1.png)

    #> 
    #> [[2]]

![](ariadneDB_files/figure-html/plot_graphs-2.png)

    #> 
    #> [[3]]

![](ariadneDB_files/figure-html/plot_graphs-3.png)

    #> 
    #> [[4]]

![](ariadneDB_files/figure-html/plot_graphs-4.png)

    #> 
    #> [[5]]

![](ariadneDB_files/figure-html/plot_graphs-5.png)

    #> 
    #> [[6]]

![](ariadneDB_files/figure-html/plot_graphs-6.png)

    #> 
    #> [[7]]

![](ariadneDB_files/figure-html/plot_graphs-7.png)

    #> 
    #> [[8]]

![](ariadneDB_files/figure-html/plot_graphs-8.png)

    #> 
    #> [[9]]

![](ariadneDB_files/figure-html/plot_graphs-9.png)

    #> 
    #> [[10]]

![](ariadneDB_files/figure-html/plot_graphs-10.png)

    #> 
    #> [[11]]

![](ariadneDB_files/figure-html/plot_graphs-11.png)

    #> 
    #> [[12]]

![](ariadneDB_files/figure-html/plot_graphs-12.png)

As seen in the graphs, each resource includes unique links between
different feature types, which ariadneDB integrates into a single
organised graph to benefit from its emerging properties.

## Reproducibility

R session information:

    #> R version 4.6.1 (2026-06-24)
    #> Platform: x86_64-pc-linux-gnu
    #> Running under: Ubuntu 24.04.5 LTS
    #> 
    #> Matrix products: default
    #> BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
    #> LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0
    #> 
    #> locale:
    #>  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C               LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
    #>  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8    LC_PAPER=en_US.UTF-8       LC_NAME=C                 
    #>  [9] LC_ADDRESS=C               LC_TELEPHONE=C             LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
    #> 
    #> time zone: UTC
    #> tzcode source: system (glibc)
    #> 
    #> attached base packages:
    #> [1] stats     graphics  grDevices utils     datasets  methods   base     
    #> 
    #> other attached packages:
    #> [1] jsonlite_2.0.0    htmlwidgets_1.6.4 DT_0.34.0         dplyr_1.2.1       ariadne_0.2.13    igraph_2.3.4     
    #> [7] ggraph_2.2.2      ggplot2_4.0.3     BiocStyle_2.41.0 
    #> 
    #> loaded via a namespace (and not attached):
    #>   [1] DBI_1.3.0                   gridExtra_2.3.1             enviPathR_1.0.2             httr2_1.3.0                
    #>   [5] rlang_1.3.0                 magrittr_2.0.5              otel_0.2.0                  matrixStats_1.5.0          
    #>   [9] compiler_4.6.1              RSQLite_3.53.3              png_0.1-9                   systemfonts_1.3.2          
    #>  [13] vctrs_0.7.3                 stringr_1.6.0               pkgconfig_2.0.3             crayon_1.5.3               
    #>  [17] fastmap_1.2.0               dbplyr_2.6.0                XVector_0.53.0              labeling_0.4.3             
    #>  [21] rmarkdown_2.32              tzdb_0.5.0                  ragg_1.5.2                  purrr_1.2.2                
    #>  [25] bit_4.6.0                   xfun_0.62                   cachem_1.1.0                progress_1.2.3             
    #>  [29] blob_1.3.0                  DelayedArray_0.39.8         BiocParallel_1.47.0         tweenr_2.0.3               
    #>  [33] prettyunits_1.2.0           parallel_4.6.1              R6_2.6.1                    bslib_0.12.0               
    #>  [37] stringi_1.8.9               RColorBrewer_1.1-3          GenomicRanges_1.65.4        jquerylib_0.1.4            
    #>  [41] Rcpp_1.1.2                  Seqinfo_1.3.2               bookdown_0.48               assertthat_0.2.1           
    #>  [45] SummarizedExperiment_1.43.0 knitr_1.52                  readr_2.2.0                 IRanges_2.47.5             
    #>  [49] rentrez_1.2.4               rotl_3.1.1                  Matrix_1.7-6                tidyselect_1.2.1           
    #>  [53] abind_1.4-8                 yaml_2.3.12                 viridis_0.6.5               codetools_0.2-20           
    #>  [57] curl_8.1.0                  lattice_0.23-1              tibble_3.3.1                Biobase_2.73.2             
    #>  [61] withr_3.0.3                 KEGGREST_1.53.6             S7_0.2.2                    evaluate_1.0.5             
    #>  [65] desc_1.4.3                  polyclip_1.10-7             BiocFileCache_3.3.3         Biostrings_2.81.9          
    #>  [69] pillar_1.11.1               BiocManager_1.30.27         filelock_1.0.3              MatrixGenerics_1.25.0      
    #>  [73] stats4_4.6.1                generics_0.1.4              S4Vectors_0.51.10           hms_1.1.4                  
    #>  [77] scales_1.4.0                rncl_0.8.10                 glue_1.8.1                  tools_4.6.1                
    #>  [81] data.table_1.18.6.1         forcats_1.0.1               XML_3.99-0.25               fs_2.1.0                   
    #>  [85] graphlayouts_1.2.5          multifactor_0.1.3           tidygraph_1.3.1             grid_4.6.1                 
    #>  [89] ape_5.8-1                   tidyr_1.3.2                 crosstalk_1.2.2             nlme_3.1-171               
    #>  [93] ggforce_0.5.0               cli_3.6.6                   textshaping_1.0.5           S4Arrays_1.13.2            
    #>  [97] viridisLite_0.4.3           arrow_26.0.0                gtable_0.3.6                sass_0.4.10                
    #> [101] digest_0.6.39               BiocGenerics_0.59.13        SparseArray_1.13.5          ggrepel_0.9.8              
    #> [105] farver_2.1.2                memoise_2.0.1               htmltools_0.5.9             pkgdown_2.2.1              
    #> [109] lifecycle_1.0.5             httr_1.4.9                  bit64_4.8.6                 MASS_7.3-66

## References

Ashburner, Michael, Catherine A Ball, Judith A Blake, et al. 2000. “Gene
Ontology: Tool for the Unification of Biology.” *Nature Genetics* 25
(1): 25–29.

Bansal, Parit, Anne Morgat, Kristian B Axelsen, et al. 2022. “Rhea, the
Reaction Knowledgebase in 2022.” *Nucleic Acids Research* 50 (D1):
D693–700.

Bateman, Alex, Maria-Jesus Martin, Sandra Orchard, et al. 2025.
“UniProt: The Universal Protein Knowledgebase in 2025.” *Nucleic Acids
Research* 53 (D1).

Franzosa, Eric A, Lauren J McIver, Gholamali Rahnavard, et al. 2018.
“Species-Level Functional Profiling of Metagenomes and
Metatranscriptomes.” *Nature Methods* 15 (11): 962–68.

Geistlinger, Ludwig, Chloe Mirzayi, Fatima Zohra, et al. 2024. “BugSigDB
Captures Patterns of Differential Abundance across a Broad Range of
Host-Associated Microbial Signatures.” *Nature Biotechnology* 42 (5):
790–802.

Hafner, Jasmin, Tim Lorsbach, Sebastian Schmidt, et al. 2024.
“Advancements in Biotransformation Pathway Prediction: Enhancements,
Datasets, and Novel Functionalities in enviPath.” *Journal of
Cheminformatics* 16 (1): 93.

Haft, Daniel H, Brendan J Loftus, Delwood L Richardson, et al. 2001.
“TIGRFAMs: A Protein Family Resource for the Functional Identification
of Proteins.” *Nucleic Acids Research* 29 (1): 41–43.

Hinchliff, Cody E, Stephen A Smith, James F Allman, et al. 2015.
“Synthesis of Phylogeny and Taxonomy into a Comprehensive Tree of Life.”
*Proceedings of the National Academy of Sciences* 112 (41): 12764–69.

Kanehisa, Minoru, and Susumu Goto. 2000. “KEGG: Kyoto Encyclopedia of
Genes and Genomes.” *Nucleic Acids Research* 28 (1): 27–30.

Subramanian, Aravind, Pablo Tamayo, Vamsi K Mootha, et al. 2005. “Gene
Set Enrichment Analysis: A Knowledge-Based Approach for Interpreting
Genome-Wide Expression Profiles.” *Proceedings of the National Academy
of Sciences* 102 (43): 15545–50.

Valles-Colomer, Mireia, Gwen Falony, Youssef Darzi, et al. 2019. “The
Neuroactive Potential of the Human Gut Microbiota in Quality of Life and
Depression.” *Nature Microbiology* 4 (4): 623–32.

Vieira-Silva, Sara, Gwen Falony, Youssef Darzi, et al. 2016.
“Species–Function Relationships Shape Ecological Properties of the Human
Gut Microbiome.” *Nature Microbiology* 1 (8): 16088.

Zhu, Qiyun, Uyen Mai, Wayne Pfeiffer, et al. 2019. “Phylogenomics of
10,575 Genomes Reveals Evolutionary Proximity between Domains Bacteria
and Archaea.” *Nature Communications* 10 (1): 5477.
