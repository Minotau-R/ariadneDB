
library(enviPathR)
library(igraph)

# Set resource name
res.name <- "enviPath"
# Retrieve feature metadata
types <- epTypes()
# Extract feature linkmap
edge_df <- types$linkable
# Remove unnecessary features
edge_df <- edge_df[!edge_df$to %in% c("edge", "node"), ]
# Make nodes data
node_df <- edge2node(edge_df)
# Define ambiguous names
node_df$name[node_df$specific == "compound"] <- "envipath_cpd"
node_df$name[node_df$specific == "pathway"] <- "envipath_path"
node_df$name[node_df$specific == "reaction"] <- "envipath_rxn"
node_df$name[node_df$specific == "structure"] <- "envipath_struct"
# Use generic names in edges data
edge_df[c("from", "to")] <- lapply(
    edge_df[c("from", "to")],
    function(col) node_df$name[match(col, node_df$specific)]
)
# Combine to graph
graph <- graph_from_data_frame(edge_df, vertices = node_df, directed = TRUE)
# Create resource
write_graph(graph, paste0(res.name, ".gml"), format = "gml")
