# Programmatically fetch resource information

These utilities provide tools to programmatically fetch resource
information for three types of resources:

- `fetch_zenodo_resource` retrieves the list of files found in a Zenodo
  record (used for BugSigDB, ChocoPhlAn and MSigDB).

- `fetch_page_links` retrieves the list of items found in an online
  public file directory (used for GM, GO, TIGRFAMs and WoL).

- `fetch_sparql_output` sends a query to a SPARQL endpoint and returns
  the response as a table (used for Rhea and UniProt).

## Usage

``` r
fetch_zenodo_resource(record_id)

fetch_page_links(url)

fetch_sparql_output(query, endpoint, timeout = 1e+06, max_tries = 2L)
```

## Arguments

- record_id:

  `Character scalar`. A string specifying the Zenodo record id of the
  resource to be fetched.

- url:

  `Character vector`. A string specifying the url from where href links
  should be fetched.

- query:

  `Character scalar`. Multi-line string defining the SPARQL query to be
  sent.

- endpoint:

  `Character scalar`. String specifying the name of the endpoint to be
  queried.

- timeout:

  `Numeric scalar`. Number indicating the time limit for the request to
  the SPARQL endpoint. (Default: `1e6`)

- max_tries:

  `Numeric scalar`. Number indicating the maximum number of trials for
  the request to the SPARQL endpoint. (Default: `2`)

## Value

`fetch_zenodo_resource` returns a character vector of item names found
in the Zenodo `record_id`. `fetch_page_links` returns a character vector
of https addresses to the links found in `url`. `fetch_sparql_output`
returns the `query` response as a data.frame.

## Examples

``` r
# Set Zenodo record id
record_id <- "18788725"

# Retrieve file names from record
fetch_zenodo_resource(record_id)
#>  [1] "ChocoPhlAn.gml" "BugSigDB.gml"   "UniProt.gml"    "WoL.gml"       
#>  [5] "Rhea.gml"       "KEGG.gml"       "TIGRFAMs.gml"   "GO.gml"        
#>  [9] "enviPath.gml"   "OTT.gml"        "GM.gml"         "MSigDB.gml"    

# Set url to online directory
go_url <- "https://current.geneontology.org/ontology/external2go/"

# Retrieve links to items in directory
fetch_page_links(go_url)
#>  [1] "http://current.geneontology.org/ontology/index.html"                      
#>  [2] "http://current.geneontology.org/ontology/external2go/ec2go"               
#>  [3] "http://current.geneontology.org/ontology/external2go/hamap2go"            
#>  [4] "http://current.geneontology.org/ontology/external2go/interpro2go"         
#>  [5] "http://current.geneontology.org/ontology/external2go/kegg_reaction2go"    
#>  [6] "http://current.geneontology.org/ontology/external2go/metacyc2go"          
#>  [7] "http://current.geneontology.org/ontology/external2go/pfam2go"             
#>  [8] "http://current.geneontology.org/ontology/external2go/pirsf2go"            
#>  [9] "http://current.geneontology.org/ontology/external2go/prints2go"           
#> [10] "http://current.geneontology.org/ontology/external2go/prosite2go"          
#> [11] "http://current.geneontology.org/ontology/external2go/reactome2go"         
#> [12] "http://current.geneontology.org/ontology/external2go/resid2go"            
#> [13] "http://current.geneontology.org/ontology/external2go/rfam2go"             
#> [14] "http://current.geneontology.org/ontology/external2go/rhea2go"             
#> [15] "http://current.geneontology.org/ontology/external2go/smart2go"            
#> [16] "http://current.geneontology.org/ontology/external2go/um-bbd_enzymeid2go"  
#> [17] "http://current.geneontology.org/ontology/external2go/um-bbd_pathwayid2go" 
#> [18] "http://current.geneontology.org/ontology/external2go/um-bbd_reactionid2go"
#> [19] "http://current.geneontology.org/ontology/external2go/uniprotkb_kw2go"     
#> [20] "http://current.geneontology.org/ontology/external2go/uniprotkb_sl2go"     
#> [21] "http://current.geneontology.org/ontology/external2go/unirule2go"          

# Set SPARQL endpoint
uniprot_endpoint <- "https://sparql.uniprot.org/sparql"

# Prepare SPARQL query
uniprot_query <- "
    PREFIX up: <http://purl.uniprot.org/core/>
    SELECT ?taxon
    FROM <http://sparql.uniprot.org/taxonomy>
    WHERE { ?taxon a up:Taxon. }
    LIMIT 6
"

# Send SPARQL query and get response
fetch_sparql_output(
    query = uniprot_query,
    endpoint = uniprot_endpoint
)
#>                                       taxon
#>                                      <char>
#> 1:      http://purl.uniprot.org/taxonomy/10
#> 2:     http://purl.uniprot.org/taxonomy/100
#> 3:    http://purl.uniprot.org/taxonomy/1000
#> 4:   http://purl.uniprot.org/taxonomy/10000
#> 5:  http://purl.uniprot.org/taxonomy/100000
#> 6: http://purl.uniprot.org/taxonomy/1000000
```
