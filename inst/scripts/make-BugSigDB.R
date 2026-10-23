
library(igraph)
library(stringr)

# Set resource name
res.name <- "BugSigDB"
# Set url for BugSigDB v1
url <- "https://zenodo.org/records/5606166/"
# Fetch file names from Zenodo
file_names <- basename(url) |>
    fetch_zenodo_resource() |>
    str_subset("mixed") |>
    str_subset("metaphlan", negate = TRUE)
# Clean and split file names
features <- file_names |>
    str_remove_all("signatures_mixed_|\\.gmt") |>
    str_split("_", simplify = TRUE)
# Add url paths for resources
file_urls <- paste0(dirname(url), "/{version}/files/", file_names)
# Convert to data.frame
edge_df <- data.frame(
    from = features[ , 1], to = features[ , 2], url = file_urls
)
# Make nodes data
node_df <- edge2node(edge_df)
# Add node urls
node_df$url <- NA
node_df$url[node_df$name == "bugsig"] <- edge_df$url[edge_df$to == "taxid"]
# Use generic names in edges data
edge_df[c("from", "to")] <- lapply(
    edge_df[c("from", "to")],
    function(col) node_df$name[match(col, node_df$specific)]
)
# Combine to graph
graph <- graph_from_data_frame(edge_df, vertices = node_df, directed = TRUE)
# Create resource
write_graph(
    graph, paste0(res.name, ".gml"), format = "gml", id = seq_along(graph)
)
