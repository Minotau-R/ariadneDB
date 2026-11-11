# Translate feature names to the ariadne nomenclature

`edge2node` `.featureDictionary`

## Usage

``` r
.featureDictionary

edge2node(edges)
```

## Arguments

- edges:

  `Character list`. A named list of resource versions to load. Latest
  versions are used if not specified. (Default: `NULL`)

## Value

An igraph object with the ariadne resource graph.

## Examples

``` r
# Prepare example edges table
edge_df <- data.frame(
    from = c("ncbi", "GO"),
    to = c("BugSigDB", "FooDB")
)

# Derive nodes table from edges table
node_df <- edge2node(edge_df)

# View nodes table
node_df
#>     name specific
#> 1  taxid     ncbi
#> 2     go       GO
#> 3 bugsig BugSigDB
#> 4  foodb    FooDB
```
