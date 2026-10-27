
# ariadneDB: the ariadne resource graph database <img src="https://raw.githubusercontent.com/Minotau-R/ariadne/devel/inst/man/figures/ariadne_logo.png" align="right" width="120" />

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.18788725.svg)](https://doi.org/10.5281/zenodo.18788725)

ariadneDB hosts a harmonised resource graph with feature mappings from various
biological databases, powering the R package
[ariadne](https://github.com/Minotau-R/ariadne) and its Python extension
[ariadnePy](https://github.com/Minotau-R/ariadnePy). A walkthrough on the
available resources can be found in
[this vignette](https://minotau-r.github.io/ariadne/articles/resources.html).

## Resources

Resource graphs are stored in the Graph Modelling Language (GML) format
for optimised graph representation. Each GML file corresponds to one source
database and includes a graph:

- edges link source features (`from`) with target features (`to`) and contain
  paths to mappings when available (`url`)
- nodes list the available features with their ariadne names (`name`),
  database-specific names (`specific`) and self-generated identifiers (`id`)

Each resource graph is generated with a reproducible pipeline (found
[here](inst/scripts)) and gets regularly updated based on the release cycle of
the respective source database.

## Usage

The full ariadne database can be fetched via the ariadne library.

In R:

```r
library(ariadne)

# Fetch resources
graph <- ariadne()

# Visualise resource graph
plotPath(graph)
```

In Python:

```python
import ariadnepy

# Fetch resources
graph = ariadnepy.ariadne()

# Visualise resource graph
ariadnepy.plot_path(graph)
```

Alternatively, single GML files can be imported using the igraph library.

```r
library(igraph)

# Set url
url <- "https://zenodo.org/records/18788726/files/ChocoPhlAn.gml"

# Import resource
graph <- read_graph(url, format = "gml")
```
