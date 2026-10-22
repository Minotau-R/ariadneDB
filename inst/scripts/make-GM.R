
library(igraph)

# Set resource name
res.name <- "GM"
# Set url for Misc v1
base_url <- "https://github.com/"
rel_url <- "omixer/omixer-rpmR/raw/refs/heads/main/inst/extdata"
# Extract all links
file_urls <- paste0(base_url, rel_url) |>
    fetch_page_links() |>
    str_subset("(GBM|GMM)")
# Clean file urls
file_urls <- file_urls[!duplicated(file_urls)] |>
    str_replace("blob", "raw")
# Split edge and node urls
edge_urls <- str_subset(file_urls, "txt$")
node_urls <- str_subset(file_urls, "names$")
# Make edges data
edge_df <- data.frame(from = c("gbm", "gmm"), to = "ko", url = edge_urls)
# Replace version with placeholder
edge_df$url <- str_replace(edge_df$url, fixed(rel_url), "{version}")
# Make nodes data
node_df <- edge2node(edge_df)
# Add url paths for feature names
node_df$url <- c(node_urls, NA)
node_df$url <- str_replace(node_df$url, fixed(rel_url), "{version}")
# Combine to graph
graph <- graph_from_data_frame(edge_df, vertices = node_df, directed = TRUE)
# Create resource
write_graph(graph, paste0(res.name, ".gml"), format = "gml")
