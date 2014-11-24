# Packages which cannot be installed due to lack of dependencies or other reasons.
[
  # sort -t '#' -k 2

  "rpanel" # I could not make Tcl to recognize BWidget. HELP WANTED!
  "Actigraphy" # SDMTools.so: undefined symbol: X
  "MigClim" # SDMTools.So: Undefined Symbol: X
  "PatternClass" # SDMTools.So: Undefined Symbol: X
  "lefse" # SDMTools.so: undefined symbol: X
  "raincpc" # SDMTools.so: undefined symbol: X
  "rainfreq" # SDMTools.so: undefined symbol: X
  "CARrampsOcl" # depends on OpenCL
  "RGA" # jsonlite.so: undefined symbol: XXX
  "RSiteCatalyst" # jsonlite.so: undefined symbol: XXX
  "RSocrata" # jsonlite.so: undefined symbol: XXX
  "SGP" # jsonlite.so: undefined symbol: XXX
  "SocialMediaMineR" # jsonlite.so: undefined symbol: XXX
  "WikipediR" # jsonlite.so: undefined symbol: XXX
  "alm" # jsonlite.so: undefined symbol: XXX
  "archivist" # jsonlite.so: undefined symbol: XXX
  "bold" # jsonlite.so: undefined symbol: XXX
  "enigma" # jsonlite.so: undefined symbol: XXX
  "exCon" # jsonlite.so: undefined symbol: XXX
  "gender" # jsonlite.so: undefined symbol: XXX
  "jSonarR" # jsonlite.so: undefined symbol: XXX
  "leafletR" # jsonlite.so: undefined symbol: XXX
  "opencpu" # jsonlite.so: undefined symbol: XXX
  "pdfetch" # jsonlite.so: undefined symbol: XXX
  "polidata" # jsonlite.so: undefined symbol: XXX
  "pollstR" # jsonlite.so: undefined symbol: XXX
  "rHealthDataGov" # jsonlite.so: undefined symbol: XXX
  "rWBclimate" # jsonlite.so: undefined symbol: XXX
  "rbison" # jsonlite.so: undefined symbol: XXX
  "rinat" # jsonlite.so: undefined symbol: XXX
  "rjstat" # jsonlite.so: undefined symbol: XXX
  "rmongodb" # jsonlite.so: undefined symbol: XXX
  "rnoaa" # jsonlite.so: undefined symbol: XXX
  "rsunlight" # jsonlite.so: undefined symbol: XXX
  "slackr" # jsonlite.so: undefined symbol: XXX
  "webutils" # jsonlite.so: undefined symbol: XXX
  "msarc" # requires AnnotationDbi
  "ppiPre" # requires AnnotationDbi
  "RobLox" # requires Biobase
  "RobLoxBioC" # requires Biobase
  "compendiumdb" # requires Biobase
  "ktspair" # requires Biobase
  "permGPU" # requires Biobase
  "propOverlap" # requires Biobase
  "GExMap" # requires Biobase and multtest
  "IsoGene" # requires Biobase, and affy
  "mGSZ" # requires Biobase, and limma
  "NCmisc" # requires BiocInstaller
  "RADami" # requires Biostrings
  "RAPIDR" # requires Biostrings, Rsamtools, and GenomicRanges
  "SimRAD" # requires Biostrings, and ShortRead
  "SeqFeatR" # requires Biostrings, qvalue, and widgetTools
  "OpenCL" # requires CL/opencl.h
  "cplexAPI" # requires CPLEX
  "CHAT" # requires DNAcopy
  "PSCBS" # requires DNAcopy
  "ParDNAcopy" # requires DNAcopy
  "Rcell" # requires EBImage
  "RockFab" # requires EBImage
  "gitter" # requires EBImage
  "rggobi" # requires GGobi
  "BiSEp" # requires GOSemSim, GO.db, and org.Hs.eg.db
  "PubMedWordcloud" # requires GOsummaries
  "ExomeDepth" # requires GenomicRanges, and Rsamtools
  "HTSDiff" # requires HTSCluster
  "RAM" # requires Heatplus
  "RcppRedis" # requires Hiredis
  "MSIseq" # requires IRanges
  "SNPtools" # requires IRanges, GenomicRanges, Biostrings, and Rsamtools
  "interval" # requires Icens
  "PhViD" # requires LBE
  "rLindo" # requires LINDO API
  "magma" # requires MAGMA
  "HiPLARM" # requires MAGMA or PLASMA
  "bigGP" # requires MPI running. HELP WANTED!
  "doMPI" # requires MPI running. HELP WANTED!
  "metaMix" # requires MPI running. HELP WANTED!
  "pbdMPI" # requires MPI running. HELP WANTED!
  "pmclust" # requires MPI running. HELP WANTED!
  "MSeasyTkGUI" # requires MSeasyTkGUI
  "bigpca" # requires NCmisc
  "reader" # requires NCmisc
  "ROracle" # requires OCI
  "BRugs" # requires OpenBUGS
  "smart" # requires PMA
  "aroma_cn" # requires PSCBS
  "aroma_core" # requires PSCBS
  "RQuantLib" # requires QuantLib
  "RSeed" # requires RBGL, and graph
  "gRbase" # requires RBGL, and graph
  "ora" # requires ROracle
  "semiArtificial" # requires RSNNS
  "branchLars" # requires Rgraphviz
  "gcExplorer" # requires Rgraphviz
  "hasseDiagram" # requires Rgraphviz
  "hpoPlot" # requires Rgraphviz
  "strum" # requires Rgraphviz
  "dagbag" # requires Rlapack
  "ltsk" # requires Rlapack and Rblas
  "REBayes" # requires Rmosek
  "LinRegInteractive" # requires Rpanel
  "RVideoPoker" # requires Rpanel
  "ArrayBin" # requires SAGx
  "RSAP" # requires SAPNWRFCSDK
  "DBKGrad" # requires SDD
  "pubmed_mineR" # requires SSOAP
  "ENA" # requires WGCNA
  "GOGANPA" # requires WGCNA
  "nettools" # requires WGCNA
  "rneos" # requires XMLRPC
  "demi" # requires affy, affxparser, and oligo
  "KANT" # requires affy, and Biobase
  "pathClass" # requires affy, and Biobase
  "ACNE" # requires aroma_affymetrix
  "NSA" # requires aroma_core
  "aroma_affymetrix" # requires aroma_core
  "calmate" # requires aroma_core
  "beadarrayFilter" # requires beadarray
  "PepPrep" # requires biomaRt
  "snplist" # requires biomaRt
  "FunctionalNetworks" # requires breastCancerVDX, and Biobase
  "rJPSGCS" # requires chopsticks
  "clpAPI" # requires clp
  "pcaL1" # requires clp
  "bmrm" # requires clpAPI
  "sequenza" # requires copynumber
  "Rcplex" # requires cplexAPI
  "dcGOR" # requires dnet
  "bcool" # requires doMPI
  "GSAgm" # requires edgeR
  "HTSCluster" # requires edgeR
  "QuasiSeq" # requires edgeR
  "SimSeq" # requires edgeR
  "babel" # requires edgeR
  "edgeRun" # requires edgeR
  "BcDiag" # requires fabia
  "superbiclust" # requires fabia
  "curvHDR" # requires flowCore
  "RbioRXN" # requires fmcsR, and KEGGREST
  "LogisticDx" # requires gRbase
  "gRain" # requires gRbase
  "gRbase" # requires gRbase
  "gRc" # requires gRbase
  "gRim" # requires gRbase
  "topologyGSA" # requires gRbase
  "qdap" # requires gender
  "orQA" # requires genefilter
  "apmsWAPP" # requires genefilter, Biobase, multtest, edgeR, DESeq, and aroma.light
  "miRtest" # requires globaltest, GlobalAncova, and limma
  "PairViz" # requires graph
  "eulerian" # requires graph
  "gRapHD" # requires graph
  "msSurv" # requires graph
  "RnavGraph" # requires graph, and RBGL
  "iRefR" # requires graph, and RBGL
  "pcalg" # requires graph, and RBGL
  "protiq" # requires graph, and RBGL
  "classGraph" # requires graph, and Rgraphviz
  "epoc" # requires graph, and Rgraphviz
  "gridGraphviz" # requires graph, and Rgraphviz
  "ddepn" # requires graph, and genefilter
  "gridDebug" # requires gridGraphviz
  "DRI" # requires impute
  "FAMT" # requires impute
  "PMA" # requires impute
  "WGCNA" # requires impute
  "moduleColor" # requires impute
  "samr" # requires impute
  "swamp" # requires impute
  "MetaDE" # requires impute, and Biobase
  "FHtest" # requires interval
  "RefFreeEWAS" # requires isva
  "AntWeb" # requires leafletR
  "ecoengine" # requires leafletR
  "spocc" # requires leafletR
  "sybilSBML" # requires libSBML
  "RDieHarder" # requires libdieharder
  "CORM" # requires limma
  "DAAGbio" # requires limma
  "DCGL" # requires limma
  "SQDA" # requires limma
  "metaMA" # requires limma
  "plmDE" # requires limma
  "RPPanalyzer" # requires limma, and Biobase
  "PerfMeas" # requires limma, graph, and RBGL
  "MAMA" # requires metaMA
  "Rmosek" # requires mosek
  "PCS" # requires multtest
  "TcGSA" # requires multtest
  "hddplot" # requires multtest
  "mutoss" # requires multtest
  "structSSI" # requires multtest
  "mutossGUI" # requires mutoss
  "Biograph" # requires mvna
  "MSeasy" # requires mzR, and xcms
  "x_ent" # requires opencpu
  "pbdBASE" # requires pbdMPI
  "pbdDEMO" # requires pbdMPI
  "pbdDMAT" # requires pbdMPI
  "pbdSLAP" # requires pbdMPI
  "LOST" # requires pcaMethods
  "multiDimBio" # requires pcaMethods
  "crmn" # requires pcaMethods, and Biobase
  "imputeLCMD" # requires pcaMethods, and impute
  "MEET" # requires pcaMethods, and seqLogo
  "qtlnet" # requires pcalg
  "SigTree" # requires phyloseq
  "saps" # requires piano, and survcomp
  "surveillance" # requires polyCub
  "aLFQ" # requires protiq
  "NLPutils" # requires qdap
  "NBPSeq" # requires qvalue
  "RSNPset" # requires qvalue
  "evora" # requires qvalue
  "isva" # requires qvalue
  "pi0" # requires qvalue
  "CrypticIBDcheck" # requires rJPSGCS
  "PKgraph" # requires rggobi
  "SeqGrapheR" # requires rggobi
  "beadarrayMSV" # requires rggobi
  "clusterfly" # requires rggobi
  "HierO" # requires rneos
  "fPortfolio" # requires rneos
  "GUIDE" # requires rpanel
  "SDD" # requires rpanel
  "biotools" # requires rpanel
  "erpR" # requires rpanel
  "gamlss_demo" # requires rpanel
  "lgcp" # requires rpanel
  "optBiomarker" # requires rpanel
  "soilphysics" # requires rpanel
  "vows" # requires rpanel
  "PCGSE" # requires safe
  "DepthProc" # requires samr
  "netClass" # requires samr
  "RcmdrPlugin_seeg" # requires seeg
  "EMA" # requires siggenes, affy, multtest, gcrma, biomaRt, and AnnotationDbi
  "GeneticTools" # requires snpStats
  "snpEnrichment" # requires snpStats
  "snpStatsWriter" # requires snpStats
  "wgsea" # requires snpStats
  "rysgran" # requires soiltexture
  "DSpat" # requires spatstat
  "Digiroo2" # requires spatstat
  "ETAS" # requires spatstat
  "GriegSmith" # requires spatstat
  "RImageJROI" # requires spatstat
  "SGCS" # requires spatstat
  "SpatialVx" # requires spatstat
  "adaptsmoFMRI" # requires spatstat
  "ads" # requires spatstat
  "aoristic" # requires spatstat
  "dbmss" # requires spatstat
  "dixon" # requires spatstat
  "dpcR" # requires spatstat
  "ecespa" # requires spatstat
  "ecospat" # requires spatstat
  "intamapInteractive" # requires spatstat
  "latticeDensity" # requires spatstat
  "polyCub" # requires spatstat
  "seeg" # requires spatstat
  "siar" # requires spatstat
  "siplab" # requires spatstat
  "sparr" # requires spatstat
  "spatialsegregation" # requires spatstat
  "stpp" # requires spatstat
  "trip" # requires spatstat
  "dnet" # requires supraHex, graph, Rgraphviz, and Biobase
  "plsRcox" # requires survcomp
  "rsig" # requires survcomp
  "ttScreening" # requires sva, and limma
  "cudaBayesreg" # requres Rmath
  "taxize" # requres bold
  "rsprng" # requres sprng
  "RNeXML" # requres taxize
  "TR8" # requres taxize
  "bdvis" # requres taxize
  "evobiR" # requres taxiz
]
