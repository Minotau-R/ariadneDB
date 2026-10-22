
feature.dictionary <- list(
    agora = "Agora",
    agr = "AGR",
    allergome = "Allergome",
    antibodypedia = "Antibodypedia",
    antifam = "AntiFam",
    arachnoserver = "ArachnoServer",
    araport = "Araport",
    beilstein = "Beilstein",
    bgee = "Bgee",
    biogrid = "BioGRID",
    biogrid_orcs = "BioGRID-ORCS",
    biomuta = "BioMuta",
    bpdb = "BPDB",
    brenda = "BRENDA",
    bugsig = c("bugsigdb", "BugSigDB"),
    cas = "CAS",
    cazy = "CAZy",
    ccds = "CCDS",
    cdcode = "CD-CODE",
    cgd = "CGD",
    chebi = c("ChEBI", "CHEBI"),
    chembl = "ChEMBL",
    chemspider = "Chemspider",
    chitars = "ChiTaRS",
    civic = "CIViC",
    clinpgx = "ClinPGx",
    collectf = "CollecTF",
    complex_portal = "ComplexPortal",
    come = "COMe",
    conoserver = "ConoServer",
    cptac = "CPTAC",
    ctd = "CTD",
    depod = "DEPOD",
    dictybase = "dictyBase",
    dip = "DIP",
    disgenet = "DisGeNET",
    disprot = "DisProt",
    dmdm = "DMDM",
    dnasu = "DNASU",
    drugbank = "DrugBank",
    drugcentral = "Drug_Central",
    ec = c("enzyme", "level4ec"),
    ecmdb = "ECMDB",
    echobase = "EchoBASE",
    eggnog = "eggNOG",
    elm = "ELM",
    embl = "EMBL",
    emdb = "EMDB",
    ensembl = c("Ensembl", "db_ensembl_gene"),
    ensembl_fungi = "EnsemblFungi",
    ensebml_metazoa = "EnsemblMetazoa",
    ensembl_plants = "EnsemblPlants",
    ensembl_protists = "EnsemblProtists",
    envipath_cpd = "UM-BBD_compID",
    envipath_enz = "um-bbd_enzymeid",
    envipath_path = "um-bbd_pathwayid",
    envipath_rxn = "um-bbd_reactionid",
    esther = "ESTHER",
    euhcvdb = "euHCVdb",
    flybase = "FlyBase",
    foodb = "FooDB",
    genecards = "GeneCards",
    geneid = c("GeneID", "ncbi-geneid", "db_ncbi_gene"),
    genereviews = "GeneReviews",
    genesym = "db_gene_symbol",
    genetree = "GeneTree",
    genewiki = "GeneWiki",
    genomernai = "GenomeRNAi",
    glyconnect = "GlyConnect",
    glygen = "GlyGen",
    glytoucan = "GlyTouCan",
    gmelin = "Gmelin",
    go = "GO",
    gramene = "Gramene",
    gtop = c("GtoP", "GuidetoPHARMACOLOGY"),
    hamap = "HAMAP",
    hgnc = "HGNC",
    hmdb = "HMDB",
    hogenom = "HOGENOM",
    hpa = "HPA",
    ideal = "IDEAL",
    imgt_gene = "IMGT_GENE-DB",
    interpro = "InterPro",
    japonicus = "JaponicusDB",
    ko = "kegg",
    knapsack = "KNApSAcK",
    legiolist = "LegioList",
    leproma = "Leproma",
    lincs = "LINCS",
    lipmaps_cls = "LIPID_MAPS_class",
    lipid_maps = "LIPID_MAPS_instance",
    maizegdb = "MaizeGDB",
    malacards = "MalaCards",
    mane_select = "MANE-Select",
    merops = "MEROPS",
    metacyc_enzrxn = "enzrxn",
    mgi = "MGI",
    mim = "MIM",
    molbase = "MolBase",
    niagads = "NIAGADS",
    oma = "OMA",
    opentargets = "OpenTargets",
    orphanet = "Orphanet",
    orthodb = "OrthoDB",
    pathcomms = "PathwayCommons",
    patric = "PATRIC",
    paxdb = "PaxDb",
    pdb = "PDB",
    pdbsum = "PDBsum",
    pdb_echem = "PDBeChem",
    peroxibase = "PeroxiBase",
    phibase = "PHI-base",
    pir = "PIR",
    pirsf = "PIRSF",
    plant_reactome = "PlantReactome",
    pmcid = "PMCID",
    pmid = "PMID",
    pombase = "PomBase",
    ppdb = "PPDB",
    pro = "PRO",
    proteinid = c("ProteinID", "ncbi-proteinid"),
    proteomicsdb = "ProteomicsDB",
    pseudocap = "PseudoCAP",
    pubchem = "Pubchem",
    reactome = "Reactome",
    reaxys = "Reaxys",
    rebase = "REBASE",
    refseq = "RefSeq",
    rep2dpage = "REPRODUCTION-2DPAGE",
    resid = "RESID",
    rgd = "RGD",
    sfld = "SFLD",
    sgd = "SGD",
    smid = "SMID",
    strenda = "STRENDA-DB",
    string = "STRING",
    swisslipids = "SwissLipids",
    tair = "TAIR",
    taxid = "ncbi",
    tcdb = "TCDB",
    tigr = c("TIGRFAMS", "TIGRFAMs", "tigrfams"),
    tdp = "TopDownProteomics",
    treefam = "TreeFam",
    tuberculist = "TubercuList",
    ucsc = "UCSC",
    unipath = "UniPathway",
    veupathdb = "VEuPathDB",
    vgnc = "VGNC",
    vsdb = "VSDB",
    xenbase = "Xenbase",
    wbparasite = "WBParaSite",
    webelements = "WebElements",
    wikipedia = "Wikipedia",
    wormbase = "WormBase",
    ymdb = "YMDB",
    zfin = "ZFIN"
)

#' @export
get_unique_features <- function(df){
    unique(c(as.matrix(df)))
}


#' @export
translate_features <- function(x, dict){
    x <- vapply(x, function(element) {
        matches <- vapply(dict, function(item) element %in% item, logical(1))
        if (any(matches)) {
            # return first matching list name
            names(dict)[which(matches)[1]]
        } else {
            # no match, keep original
            element
        }
    }, FUN.VALUE = character(1))
    
    x <- unname(x)
    return(x)
}

#' @export
edge2node <- function(edges){
    # Get unique features
    specific <- get_unique_features(edges[ , c("from", "to")])
    # Translate features
    generic <- translate_features(specific, feature.dictionary)
    # Build node
    nodes <- data.frame(name = generic, specific)
    return(nodes)
}
