
test_that("fetch", {
    
    edge_df <- data.frame(
        from = c("ncbi", "GO"),
        to = c("BugSigDB", "FooDB")
    )
    
    unique_features <- get_unique_features(edge_df)
    expect_length(unique_features, 4L)
    
    node_df <- edge2node(edge_df)
    expect_s3_class(node_df, "data.frame")
    
    expect_in(node_df$name, names(.featureDictionary))
    expect_in(node_df$specific, unique_features)
})
