
library(igraph)
library(stringr)

# Set resource name
res.name <- "TIGRFAMs"
# Set url for TIGRfams v15.0
base_url <- "https://ftp.ncbi.nlm.nih.gov/hmm/TIGRFAMs/"
rel_url <- "release_15.0"
# Extract all links
file_urls <- paste0(base_url, rel_url) |>
    fetch_page_links() |>
    str_subset(".*_LINK$")
# Clean and split file names
file_names <- file_urls |>
    basename() |>
    str_remove_all("_LINK") |>
    str_split("_", simplify = TRUE)
# Convert to data.frame
edge_df <- data.frame(
    from = file_names[ , 1], to = file_names[ , 2], url = file_urls
)
# Replace version with placeholder
edge_df$url <- str_replace(edge_df$url, fixed(rel_url), "{version}")
# Make nodes data
node_df <- edge2node(edge_df)
# Define ambiguous names
node_df$name[node_df$specific == "ROLE"] <- "tigr_role"
# Use generic names in edges data
edge_df[c("from", "to")] <- lapply(
    edge_df[c("from", "to")],
    function(col) node_df$name[match(col, node_df$specific)]
)
# Combine to graph
graph <- graph_from_data_frame(edge_df, vertices = node_df, directed = TRUE)
# Create resource
write_graph(graph, paste0(res.name, ".gml"), format = "gml")
