
library(igraph)
library(utils)

# Set resource name
res.name <- "OTT"
# Define edges
ids <- c("ott", "ncbi", "gbif", "worms", "if", "irmng", "taxname")
# Make edges data
edge_df <- combn(ids, 2) |>
    t() |>
    as.data.frame()
# Add names to columns
colnames(edge_df) <- c("from", "to")
# Add links to silva ssu
edge_df <- rbind(edge_df, data.frame(from = ids, to = "silva"))
# Make nodes data
node_df <- edge2node(edge_df)
# Define ambiguous names
node_df$name[node_df$specific == "silva"] <- "silva_ssu"
# Use generic names in edges data
edge_df[] <- lapply(edge_df, function(col) node_df$name[match(col, node_df$specific)])
# Combine to graph
graph <- graph_from_data_frame(edge_df, vertices = node_df, directed = TRUE)
# Create resource
write_graph(
    graph, paste0(res.name, ".gml"), format = "gml", id = seq_along(graph)
)

