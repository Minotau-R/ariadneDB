
test_that("fetch", {
    
    expect_error(
        fetch_zenodo_resource("wrong"),
        "HTTP 404 Not Found.",
        fixed = TRUE
    )
    
    record_id <- "18788725"
    file_names <- fetch_zenodo_resource(record_id)
    
    expect_contains(file_names, c("BugSigDB.gml", "KEGG.gml"))
    
    go_url <- "https://current.geneontology.org/ontology/external2go/"
    fetch_page_links(go_url)
    
    uniprot_endpoint <- "https://sparql.uniprot.org/sparql"
    
    uniprot_query <- "
        PREFIX up: <http://purl.uniprot.org/core/>
        SELECT ?taxon
        FROM <http://sparql.uniprot.org/taxonomy>
        WHERE { ?taxon a up:Taxon . }
        LIMIT 6
    "
    
    expect_error(
        fetch_sparql_output("wrong", uniprot_endpoint),
        "HTTP 400 Bad Request.",
        fixed = TRUE
    )
    
    out <- fetch_sparql_output(
        query = uniprot_query,
        endpoint = uniprot_endpoint
    )
    
    expect_s3_class(out, "data.frame")
    expect_equal(nrow(out), 6L)
})
