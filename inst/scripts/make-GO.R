
library(igraph)
library(stringr)

# Set resource name
res.name <- "GO"
# Set url for current GO release
url <- "https://current.geneontology.org/ontology/external2go/"
# Extract all links
file_urls <- url |>
    fetch_page_links() |>
    str_subset(".*2go$")
# Clean and split file names
file_names <- file_urls |>
    basename() |>
    str_split("2", simplify = TRUE)
# Convert to data.frame
edge_df <- data.frame(
    from = file_names[ , 1], to = file_names[ , 2], url = file_urls
)
# Replace version with placeholder
edge_df$url <- str_replace(
    edge_df$url,
    fixed("http://current.geneontology.org"),
    "https://release.geneontology.org/{version}"
)
# Make nodes data
node_df <- edge2node(edge_df)
# Define ambiguous names
node_df$name[node_df$specific == "kegg_reaction"] <- "kegg_rxn"
node_df$name[node_df$specific == "metacyc"] <- "metacyc_rxn"
# Use generic names in edges data
edge_df[c("from", "to")] <- lapply(
    edge_df[c("from", "to")],
    function(col) node_df$name[match(col, node_df$specific)]
)
# Combine to graph
graph <- graph_from_data_frame(edge_df, vertices = node_df, directed = TRUE)
# Create resource
write_graph(graph, paste0(res.name, ".gml"), format = "gml")
