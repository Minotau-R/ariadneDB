# ariadneDB: the ariadne resource graph database ![](https://raw.githubusercontent.com/Minotau-R/ariadne/devel/man/figures/ariadne_logo.png)

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.18788725.svg)](https://doi.org/10.5281/zenodo.18788725)
[![issues](https://img.shields.io/github/issues/Minotau-R/ariadneDB)](https://github.com/Minotau-R/ariadneDB/issues)
[![pulls](https://img.shields.io/github/issues-pr/Minotau-R/ariadneDB)](https://github.com/Minotau-R/ariadneDB/pulls)
[![R-CMD-check](https://github.com/Minotau-R/ariadneDB/workflows/build/badge.svg)](https://github.com/Minotau-R/ariadneDB/actions)
[![codecov](https://codecov.io/gh/Minotau-R/ariadneDB/graph/badge.svg?token=mGrzAP0atR)](https://codecov.io/gh/Minotau-R/ariadneDB)
[![CodeFactor](https://www.codefactor.io/repository/github/minotau-r/ariadnedb/badge)](https://www.codefactor.io/repository/github/minotau-r/ariadnedb)

ariadneDB hosts a harmonised resource graph with feature mappings from
various biological databases, powering the R package
[ariadne](https://codeberg.org/Minotau-R/ariadne) and its Python
extension [ariadnePy](https://github.com/Minotau-R/ariadnePy). A
walkthrough on the available resources can be found in [this
vignette](https://minotau-r.github.io/ariadneDB/articles/ariadneDB.html).

## Resources

Resource graphs are stored in the Graph Modelling Language (GML) format
for optimised graph representation. Each GML file corresponds to one
source database and includes a graph:

- edges link source features (`from`) with target features (`to`) and
  contain paths to mappings when available (`url`)
- nodes list the available features with their ariadne names (`name`),
  database-specific names (`specific`) and self-generated identifiers
  (`id`)

Each resource graph is generated with a reproducible pipeline (found
[here](https://minotau-r.github.io/ariadneDB/inst/scripts)) and gets
regularly updated based on the release cycle of the respective source
database.

## Usage

The full ariadne database can be fetched via the ariadne library.

In R:

\
[`library`](https://rdrr.io/r/base/library.html)`(`[`ariadne`](https://codeberg.org/Minotau-R/ariadne)`)`\
\
`# Fetch resources`\
`graph`` ``<-`` `[`ariadne`](https://rdrr.io/pkg/ariadne/man/ariadne.html)`(``)`\
\
`# Visualise resource graph`\
[`plotPath`](https://rdrr.io/pkg/ariadne/man/plotPath.html)`(``graph``)`

In Python:

``` python
import ariadnepy

# Fetch resources
graph = ariadnepy.ariadne()

# Visualise resource graph
ariadnepy.plot_path(graph)
```

Alternatively, single GML files can be imported using the igraph
library.

\
[`library`](https://rdrr.io/r/base/library.html)`(`[`igraph`](https://r.igraph.org/)`)`\
\
`# Set url`\
`url`` ``<-`` ``"https://zenodo.org/records/18788726/files/ChocoPhlAn.gml"`\
\
`# Import resource`\
`graph`` ``<-`` `[`read_graph`](https://r.igraph.org/reference/read_graph.html)`(``url``, format ``=`` ``"gml"``)`
