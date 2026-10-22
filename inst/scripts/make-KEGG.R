
library(igraph)
library(KEGGREST)
library(utils)

# Set resource name
res.name <- "KEGG"
# Find available KEGG databases
dbs <- listDatabases() |>
    setdiff(c("vg", "ag", "genes", "kegg")) |>
    c("network")
# List all possible database pairs
db_pairs <- combn(dbs, 2, simplify = FALSE)
# Initialise edges data
edge_df <- rbind(
    data.frame(from = "genes", to = c("ko", "ncbi-geneid", "ncbi-proteinid", "up")),
    expand.grid(from = c("compound", "glycan", "drug"), to = c("pubchem", "chebi"))
)
# For each pair of databases
for( pair in db_pairs ){
    # Try keggLink
    res <- tryCatch({
        keggLink(pair[2], pair[1])
        TRUE
        # Capture errors
        }, error = function(e) {
        FALSE
    })
    # Store pair if successful
    if( res ){
        edge_df <- rbind(edge_df, data.frame(from = pair[1], to = pair[2]))
    }
}
# Make nodes data
node_df <- edge2node(edge_df)
# Define ambiguous names
kdict <- c(
    compound = "cpd", reaction = "rxn", pathway = "path", module = "mod",
    network = "net", glycan = "glycan", drug = "drug", disease = "disease",
    genes = "genes"
)
node_df$name[match(names(kdict), node_df$specific)] <- paste0("kegg_", kdict)
node_df$name[node_df$specific == "up"] <- "uniprotkb"
# Use generic names in edges data
edge_df[] <- lapply(edge_df, function(col) node_df$name[match(col, node_df$specific)])
# Combine to graph
graph <- graph_from_data_frame(edge_df, vertices = node_df, directed = TRUE)
# Create resource
write_graph(
    graph, paste0(res.name, ".gml"), format = "gml", id = seq_along(graph)
)

