
library(igraph)

# Set resource name
res.name <- "UniProt"
# Expand first combinations
edge_df <- expand.grid(
    from = c("uniref50", "uniref90"),
    to = c("taxname", "taxid", "uniprotkb"),
    stringsAsFactors = FALSE
)
# Set from ids
from.ids <- c("uniprotkb", "uniref50", "uniref90")
# Define additional pairs
edge_df <- rbind(
    edge_df, data.frame(from = "taxname", to = "taxid"),
    expand.grid(
        from = from.ids, to = c("enzyme", "rhea", "metacyc_prt", "ecocyc_prt")
    )
)
# Set endpoint for query
endpoint <- "https://sparql.uniprot.org/"
# Prepare SPARQL query
query <- "
    PREFIX up: <http://purl.uniprot.org/core/>
    SELECT DISTINCT ?db
    WHERE { ?db a up:Database. }
"
# Get results from SPARQL query
dbs <- fetch_sparql_output(query, endpoint)$db

queries <- paste0("
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX up: <http://purl.uniprot.org/core/>
    SELECT ?protein ?db
    WHERE {
        ?protein a up:Protein .
        ?protein rdfs:seeAlso ?db .
        ?db up:database <", dbs, "> .
    } LIMIT 10
")

res <- lapply(
    queries,
    function(q){
        tryCatch({
            fetch_sparql_output(
                query = q, endpoint = endpoint, timeout = 10, max_tries = 10
            )},
        error = function(e) {
            return(NULL)
        })
    }
)

names(res) <- sub("^.+database/", "", dbs)

res <- res[lengths(res) != 0L]
res <- res[vapply(res, nrow, numeric(1L)) != 0L]

exact_matches <- vapply(res, function(x){
    x[] <- lapply(x, function(col) sub(".+/", "", col))
    all(x$protein == x$db)
    }, logical(1L)
)

res <- res[!exact_matches]

# Remove BioCyc from databases (added earlier)
to.ids <- setdiff(names(res), "BioCyc")
# Expand second combinations
edge_df <- rbind(edge_df, expand.grid(from = from.ids, to = to.ids))
# Make nodes data
node_df <- edge2node(edge_df)
# Define ambiguous names
node_df$name[node_df$specific == "KEGG"] <- "kegg_genes"
# Use generic names in edges data
edge_df[] <- lapply(edge_df, function(col) node_df$name[match(col, node_df$specific)])
# Adjust specifics for special cases
node_df$specific[grepl("uniref", node_df$name, fixed = TRUE)] <- "uniref"
node_df$specific[node_df$name %in% c("metacyc_prt", "ecocyc_prt")] <- "BioCyc"
# Combine to graph
graph <- graph_from_data_frame(edge_df, vertices = node_df, directed = TRUE)
# Create resource
write_graph(
    graph, paste0(res.name, ".gml"), format = "gml", id = seq_along(graph)
)
