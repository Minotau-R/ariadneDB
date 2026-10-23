#' Programmatically fetch resource information
#'
#' @name fetch
#' 
#' @description
#' These utilities provide tools to programmatically fetch resource information
#' for three types of resources:
#' 
#' \itemize{
#'   \item \code{fetch_zenodo_resource} retrieves the list of files found in a
#'   Zenodo record (used for BugSigDB, ChocoPhlAn and MSigDB).
#'   \item \code{fetch_page_links} retrieves the list of items found in an
#'   online public file directory (used for GM, GO, TIGRFAMs and WoL).
#'   \item \code{fetch_sparql_output} sends a query to a SPARQL endpoint and
#'   returns the response as a table (used for Rhea and UniProt).
#' }
#' 
#' @param record_id \code{Character scalar}. A string specifying the Zenodo
#' record id of the resource to be fetched.
#' 
#' @param url \code{Character vector}. A string specifying the url from where
#' href links should be fetched.
#' 
#' @param query \code{Character scalar}. Multi-line string defining the SPARQL
#' query to be sent.
#' 
#' @param endpoint \code{Character scalar}. String specifying the name of the
#' endpoint to be queried.
#' 
#' @param timeout \code{Numeric scalar}. Number indicating the time limit for
#' the request to the SPARQL endpoint. (Default: \code{1e6})
#' 
#' @param max_tries \code{Numeric scalar}. Number indicating the maximum number
#' of trials for the request to the SPARQL endpoint. (Default: \code{2})
#' 
#' @returns \code{fetch_zenodo_resource} returns a character vector of item
#' names found in the Zenodo \code{record_id}. \code{fetch_page_links} returns
#' a character vector of https addresses to the links found in \code{url}.
#' \code{fetch_sparql_output} returns the \code{query} response as a data.frame.
#' 
#' @examples
#' # Set Zenodo record id
#' record_id <- "18788725"
#' 
#' # Retrieve file names from record
#' fetch_zenodo_resource(record_id)
#' 
#' # Set url to online directory
#' go_url <- "https://current.geneontology.org/ontology/external2go/"
#' 
#' # Retrieve links to items in directory
#' fetch_page_links(go_url)
#' 
#' # Set SPARQL endpoint
#' uniprot_endpoint <- "https://sparql.uniprot.org/sparql"
#' 
#' # Prepare SPARQL query
#' uniprot_query <- "
#'     PREFIX up: <http://purl.uniprot.org/core/>
#'     SELECT ?taxon
#'     FROM <http://sparql.uniprot.org/taxonomy>
#'     WHERE { ?taxon a up:Taxon. }
#'     LIMIT 6
#' "
#' 
#' # Send SPARQL query and get response
#' fetch_sparql_output(
#'     query = uniprot_query,
#'     endpoint = uniprot_endpoint
#' )
NULL

#' @export
#' @rdname fetch
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_timeout req_perform resp_check_status resp_body_string
fetch_zenodo_resource <- function(record_id) {
    # Build Zenodo URL
    url <- paste0("https://zenodo.org/api/records/", record_id)
    # Make request
    req <- request(url) |>
        req_timeout(30)
    # Get response
    resp <- req_perform(req)
    resp_check_status(resp)
    # Read json
    json_text <- resp_body_string(resp)
    data <- fromJSON(json_text, flatten = TRUE)
    # Extract file names
    files <- data$files
    file_names <- files$key
    return(file_names)
}


#' @export
#' @rdname fetch
#' @importFrom xml2 url_absolute
#' @importFrom rvest read_html html_elements html_attr
fetch_page_links <- function(url){
    # Repeat for every url
    links <- lapply(url, function(x){
        # Read html page
        page <- read_html(x)
        # Get hrefs from page
        links <- page |>
            html_elements("a") |>
            html_attr("href")
        # Construct full path
        links <- url_absolute(links, x)
    })
    # Unlist results
    links <- unlist(links, use.names = FALSE)
    return(links)
}


#' @export
#' @rdname fetch
#' @importFrom data.table fread
#' @importFrom httr2 request req_method req_body_form resp_body_string req_headers req_timeout req_retry req_perform
fetch_sparql_output <- function(query, endpoint, timeout = 1e6, max_tries = 2L){
    # Build request with Accept header for CSV format
    req <- request(endpoint) |>
        req_method("POST") |>
        req_body_form(query = query) |>
        req_headers(Accept = "text/csv") |>
        req_timeout(timeout) |>
        req_retry(max_tries = max_tries)
    # Get response
    resp <- req_perform(req)
    # Parse CSV content into data frame
    out <- fread(text = resp_body_string(resp), header = TRUE)
    return(out)
}

