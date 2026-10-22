
#' @export
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
#' @importFrom xml2 url_absolute
#' @importFrom rvest read_html html_elements html_attr
fetch_page_links <- function(x){
    
    links <- lapply(x, function(url){
        
        page <- read_html(url)
    
        links <- page |>
            html_elements("a") |>
            html_attr("href")
        
        links <- url_absolute(links, url)
    })
    
    links <- unlist(links, use.names = FALSE)
    return(links)
}


#' @export
#' @importFrom data.table fread
#' @importFrom httr2 request req_method req_body_form resp_body_string req_headers req_perform
fetch_sparql_output <- function(query, endpoint){
    # Build request with Accept header for CSV format
    req <- request(endpoint) |>
        req_method("POST") |>
        req_body_form(query = query) |>
        req_headers(Accept = "text/csv")
    # Get response
    resp <- req_perform(req)
    # Parse CSV content into data frame
    out <- fread(text = resp_body_string(resp), header = TRUE)
    return(out)
}
