
library(igraph)
library(stringr)

# Set resource name
res.name <- "WoL"
# Set url for WoL v2
base_url <- "https://ftp.microbio.me/pub/"
# Set url for function dir
fun_url <- "wol2/function/"
# List key dirs
dirs <- c("uniref/idmaps/", "go/uniref/")
# Search uniref mappings
file_urls <- paste0(base_url, fun_url, dirs) |>
    fetch_page_links() |>
    str_subset("map\\.xz$")
# Derive file names from urls
file_names <- str_extract(file_urls, "(?<=\\/)[^\\/]+(?=\\.map\\.xz$)")
# Initialise edges data
edge_df <- data.frame(from = "uniref90", to = file_names, url = file_urls)
# List key dirs
dirs <- c("uniref/", "metacyc/")
# Fetch orf and metacyc directory links
file_urls <- paste0(base_url, fun_url, dirs) |>
    fetch_page_links() |>
    str_subset("\\.map(\\.xz)?$")
# Split features for metacyc bindings
file_names <- file_urls |>
    str_extract("(?<=\\/)[^\\/]+(?=\\.map.*)") |>
    str_split("-to-", simplify = TRUE)
# Combine uniref and metacyc bindings
edge_df <- rbind(
    edge_df,
    data.frame(from = file_names[ , 1], to = file_names[ , 2], url = file_urls)
)
# Set url for taxonomy dir
tax_url <- "wol2/taxonomy/"
# List key dirs
dirs <- c("ncbi/", "gg2/")
# Search wol mappings
file_urls <- paste0(base_url, tax_url, dirs) |>
    fetch_page_links() |>
    str_subset("(taxid|wol2gg)")
# Combine uniref, metacyc and wol bindings
edge_df <- rbind(
    edge_df,
    data.frame(from = "wol", to = c("taxid", "greengenes"), url = file_urls)
)
# Remove unnecessary pairs
to_remove <- c(
    "Gene_Name", "component", "function", "process", "regulation", "regulator",
    "pathway", "gene_list", "gene", "go", "left_compound", "right_compound", 
    "reaction_layout", "taxonomic_range"
)
edge_df <- edge_df[!edge_df$to %in% to_remove, ]
# Replace version with placeholder
edge_df$url <- str_replace(edge_df$url, fixed("wol2"), "{version}")
# Avoid multiple specifics for some nodes
edge_df$from[edge_df$from == "orf"] <- "wol"
edge_df$to[edge_df$to == "BioCyc"] <- "protein"
edge_df$to[edge_df$to == "reaction_list"] <- "reaction"
# Make nodes data
node_df <- edge2node(edge_df)
# Define ambiguous names
node_df$name[node_df$specific == "all"] <- "go"
node_df$name[node_df$specific == "protein"] <- "metacyc_prt"
node_df$name[node_df$specific == "reaction"] <- "metacyc_rxn"
node_df$name[node_df$specific == "pathway"] <- "metacyc_path"
node_df$name[node_df$specific == "super_pathway"] <- "metacyc_spath"
# Use generic names in edges data
edge_df[c("from", "to")] <- lapply(
    edge_df[c("from", "to")],
    function(col) node_df$name[match(col, node_df$specific)]
)
# Combine to graph
graph <- graph_from_data_frame(edge_df, vertices = node_df, directed = TRUE)
# Create resource
write_graph(graph, paste0(res.name, ".gml"), format = "gml")
