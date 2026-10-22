
library(igraph)

# Set resource name
res.name <- "Rhea"
# List from ids
from.ids <- c("rhea", "chebi")
# List kegg ids
kegg.ids <- c("kegg_rxn", "kegg_cpd", "kegg_drug", "kegg_glycan")
# List to ids
to.ids <- c(
    "chebi", "ECOCYC", "enzyme", kegg.ids[1L],
    "GO_", "macie", "METACYC", "reactome"
)
# Expand first combinations
edge_df <- rbind(
    expand.grid(from = "rhea", to = to.ids),
    expand.grid(
        from = from.ids,
        to = c("inchi", "inchikey", "smiles")
    )
)
# Set endpoint for query
endpoint <- "https://sparql.rhea-db.org/"
# Prepare SPARQL query
query <- "
    PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>
    SELECT ?db
    WHERE {
        ?chebi oboInOwl:hasDbXref ?ext.
        FILTER(CONTAINS(?ext, ':'))
        BIND(STRBEFORE(?ext, ':') AS ?db)
    }
    GROUP BY ?db
    HAVING (COUNT(*) >= 10) 
"
# Get results from SPARQL query
to.ids <- fetch_sparql_output(query, endpoint)$db
# Remove KEGG from databases (added earlier)
# metacyc link is different from one before (need to find a way to keep both)
to.ids <- to.ids |>
    c(kegg.ids[-1L]) |>
    setdiff(c("KEGG", "Patent", "Pesticides", "CBA", "ChemIDplus"))
# Add chebi cross-references
edge_df <- rbind(edge_df, expand.grid(from = "chebi", to = to.ids))
# Make nodes data
node_df <- edge2node(edge_df)
# Define ambiguous names
node_df$name[node_df$specific == "GO_"] <- "go"
node_df$name[node_df$specific == "METACYC"] <- "metacyc_rxn"
node_df$name[node_df$specific == "ECOCYC"] <- "ecocyc_rxn"
node_df$name[node_df$specific == "MetaCyc"] <- "metacyc_cpd"
# Use generic names in edges data
edge_df[] <- lapply(edge_df, function(col) node_df$name[match(col, node_df$specific)])
# Define ambiguous specifics
node_df$specific[node_df$name %in% kegg.ids] <- "KEGG"
# Combine to graph
graph <- graph_from_data_frame(edge_df, vertices = node_df, directed = TRUE)
# Create resource
write_graph(
    graph, paste0(res.name, ".gml"), format = "gml", id = seq_along(graph)
)
