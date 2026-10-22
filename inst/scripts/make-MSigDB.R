
library(igraph)

# Set resource name
res.name <- "MSigDB"
# Set url for MSigDB v2024.1
url <- "https://zenodo.org/records/15377497/"
# Fetch file names from Zenodo
file_names <- fetch_zenodo_resource(basename(url))
file_url <- paste0(url, "files/", file_names[1])

tmp_file <- tempfile(fileext = "rds")
download.file(file_url, tmp_file)

linkmap <- readRDS(tmp_file)

ids <- colnames(linkmap)
ids <- grepv("name|version|source|target|description|url", ids, invert = TRUE)

edge_df <- expand.grid(
    from = ids[startsWith(ids, "db_")],
    to = ids[startsWith(ids, "gs_")],
    stringsAsFactors = FALSE
)

res_url <- "https://zenodo.org/api/records/{version}/files-archive"
edge_df$url <- res_url

node_df <- edge2node(edge_df)

msig_nodes <- c(
    msig = "gs_id", msig_col = "gs_collection", msig_subcol = "gs_subcollection"
)

node_df$name[node_df$specific %in% msig_nodes] <- names(msig_nodes)
node_df$name[node_df$specific == "gs_geoid"] <- "geo"
node_df$name[node_df$specific == "gs_pmid"] <- "pmid"

node_df$url <- ifelse(node_df$name %in% names(msig_nodes), res_url, NA)

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

