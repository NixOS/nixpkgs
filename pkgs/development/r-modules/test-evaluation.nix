# Run
# Test expression evaluation
#
# $ nix build -f test-evaluation.nix rWrapper --dry-run
#
# Test building part of the packages set
#
# $ nix build -f test-evaluation.nix bioc_workflows --show-trace --verbose
#
# to test whether the R package set evaluates properly.

# To play with this in nix repl...

# nix-repl> pkgs = import ../../.. {}
# nix-repl> p = import ./test-evaluation.nix
# nix-repl> builtins.typeOf p
# ...
# nix-repl> builtins.attrNames p.notMarkedBroken # for example
    


let

  config = {
    allowBroken = true;
    allowUnfree = true;
    allowUnsupportedSystem = true;
  };

  inherit (import ../../.. { inherit config; }) pkgs;

  packagesList = pkgs.lib.filter pkgs.lib.isDerivation (pkgs.lib.attrValues pkgs.rPackages);

  opengl_names = [
    "rgl"
    "abcdeFBA"
    "afCEC"
    "alphashape3d"
    "animalTrack"
    "bcROCsurface"
    "BiodiversityR"
    "bios2mds"
    "BiplotGUI"
    "bpca"
    "brainR"
    "ChaosGame"
    "clippda"
    "ConsRank"
    "CoopGame"
    "corregp"
    "depth"
    "DGVM3D"
    "DiceView"
    "DirichletReg"
    "edrGraphicalTools"
    "eegkit"
    "etasFLP"
    "fCI"
    "FieldSim"
    "foodweb"
    "frontiles"
    "gdimap"
    "GENEAsphere"
    "gensphere"
    "geoelectrics"
    "geomorph"
    "GGEBiplotGUI"
    "GPoM"
    "hiPOD"
    "hyper_fit"
    "hypervolume"
    "kml3d"
    "lba"
    "longitudinalData"
    "LSAfun"
    "Maeswrap"
    "MDSGUI"
    "metadynminer3d"
    "mgcViz"
    "molaR"
    "mtk"
    "mvmesh"
    "nat"
    "nat_nblast"
    "nat_templatebrains"
    "NeatMap"
    "optBiomarker"
    "plot3Drgl"
    "qpcR"
    "qtlc"
    "QuantifQuantile"
    "R330"
    "RadOnc"
    "RcmdrPlugin_RiskDemo"
    "RcmdrPlugin_TeachingDemos"
    "Rknots"
    "ROCS"
    "Rpdb"
    "SEERaBomb"
    "snpReady"
    "sphereplot"
    "TTMap"
    "VecStatGraphs3D"
    "AFM"
    "AIG"
    "analogueExtra"
    "Anthropometry"
    "archiDART"
    "Arothron"
    "barplot3d"
    "BIGL"
    "Biocomb"
    "biplotbootGUI"
    "Blaunet"
    "brainKCCA"
    "clusterSim"
    "cncaGUI"
    "colourvision"
    "cops"
    "corr2D"
    "cowbell"
    "cpr"
    "crs"
    "cubing"
    "curvHDR"
    "DeSousa2013"
    "DiffusionRgqd"
    "DiffusionRimp"
    "DiffusionRjgqd"
    "Directional"
    "directPA"
    "drugCombo"
    "dti"
    "ecdfHT"
    "EMMIXcskew"
    "EvolutionaryGames"
    "feature"
    "fingerPro"
    "fsbrain"
    "gbp"
    "geoviz"
    "gge"
    "gMOIP"
    "GPareto"
    "GrammR"
    "graphscan"
    "HiveR"
    "hmgm"
    "homals"
    "HUM"
    "iCheck"
    "iSDM"
    "JointNets"
    "KarsTS"
    "kernhaz"
    "KernSmoothIRT"
    "lidR"
    "LMERConvenienceFunctions"
    "LOST"
    "matlib"
    "mcca"
    "MDSMap"
    "Morpho"
    "morphomap"
    "MSQC"
    "multibiplotGUI"
    "nanop"
    "neuroim"
    "NNS"
    "nonlinearTseries"
    "NPCirc"
    "OceanView"
    "OCNet"
    "OMICsPCA"
    "OpenRepGrid"
    "OptimalDesign"
    "orthoDr"
    "pca3d"
    "phylocurve"
    "predict3d"
    "prim"
    "RAINBOWR"
    "rase"
    "rayshader"
    "Rcade"
    "rcosmo"
    "RDRToolbox"
    "restlos"
    "retistruct"
    "rglwidget"
    "rLiDAR"
    "RockFab"
    "rotations"
    "RoundAndRound"
    "Rpolyhedra"
    "Rquake"
    "scpm"
    "SDD"
    "shapes"
    "shinyRGL"
    "SimEUCartelLaw"
    "smoothAPC"
    "sNPLS"
    "spherepc"
    "sppmix"
    "StatDA"
    "stpp"
    "stR"
    "Surrogate"
    "symbolicDA"
    "tensorsparse"
    "tkrgl"
    "tolerance"
    "TreeLS"
    "treespace"
    "trinROC"
    "TSCS"
    "ungroup"
    "vegan3d"
    "vennplot"
    "viewshed3d"
    "x3ptools"
  ];
   
  java_names = [
    "rJava"
    "AGread"
    "AntAngioCOOL"
    "AWR_KMS"
    "AWR_Athena"
    "arulesNBMiner"
    "bartMachine"
    "bartMachineJARs"
    "BridgeDbR"
    "causalMGM"
    "CollapsABEL"
    "collUtils"
    "corehunter"
    "deisotoper"
    "edeR"
    "ENVISIONQuery"
    "extraTrees"
    "gaggle"
    "glmulti"
    "GreedyExperimentalDesign"
    "GreedyExperimentalDesignJARs"
    "helloJavaWorld"
    "InSilicoVA"
    "iplots"
    "ISM"
    "JGR"
    "mallet"
    "MSIseq"
    "mwa"
    "Onassis"
    "paxtoolsr"
    "qCBA"
    "rCBA"
    "rcdklibs"
    "rChoiceDialogs"
    "Rdrools"
    "Rdroolsjars"
    "REPPlab"
    "rGroovy"
    "RH2"
    "RJDBC"
    "rJPSGCS"
    "RJSDMX"
    "rJython"
    "rkafka"
    "rkafkajars"
    "rmcfs"
    "RMOA"
    "RNCBIEUtilsLibs"
    "RNetLogo"
    "RSCAT"
    "rviewgraph"
    "SBRect"
    "scagnostics"
    "SELEX"
    "sjdbc"
    "spcosa"
    "streamMOA"
    "venneuler"
    "xlsxjars"
    "ArrayExpressHTS"
    "AWR"
    "AWR.Athena"
    "AWR.Kinesis"
    "AWR.KMS"
    "awsjavasdk"
    "BACA"
    "BASiNET"
    "BEACH"
    "beastier"
    "blkbox"
    "boilerpipeR"
    "CADStat"
    "CAMTHC"
    "CBSr"
    "ChoR"
    "coreNLP"
    "DatabaseConnector"
    "DatabaseConnectorJars"
    "debCAM"
    "DecorateR"
    "Deducer"
    "dialr"
    "dialrjars"
    "dsa"
    "esATAC"
    "expands"
    "fsdaR"
    "G2Sd"
    "gMCP"
    "hive"
    "jdx"
    "joinXL"
    "jsr223"
    "llama"
    "mailR"
    "matchingMarkets"
    "mdendro"
    "mleap"
    "MLMOI"
    "mutossGUI"
    "Myrrix"
    "Myrrixjars"
    "NoiseFiltersR"
    "OnassisJavaLibs"
    "openNLP"
    "openNLPdata"
    "OpenStreetMap"
    "PortfolioEffectEstim"
    "PortfolioEffectHFT"
    "prcbench"
    "Rbgs"
    "rcdk"
    "RDAVIDWebService"
    "ReQON"
    "RFreak"
    "RGMQL"
    "RJDemetra"
    "RKEA"
    "RKEAjars"
    "RKEEL"
    "rmelting"
    "RMOAjars"
    "rMouse"
    "rrepast"
    "RWeka"
    "RWekajars"
    "RxnSim"
    "SqlRender"
    "subspace"
    "tabulizer"
    "tabulizerjars"
    "textmining"
    "TSsdmx"
    "wordnet"
    "XLConnect"
    "xlsx"
  ];
  
  # R with everything. Use --dry-run options to test evaluation.
  # Otherwise "we're going to need a bigger box"
  rWrapper = pkgs.rWrapper.override {
    packages = packagesList;  
  };

  inherit (pkgs) lib;
  inherit (lib) subtractLists filterAttrs getAttrs;
  inherit (builtins) attrNames getAttr;
  isBroken = (n: v: (lib.attrByPath ["meta" "broken"] false v));
  findBroken = s : lib.filterAttrs isBroken s;
  findNotBroken = s : lib.filterAttrs (n: v: ! (isBroken n v) ) s;
  
  # broken and notbroken denotes the value of the meta.broken attribute
  
  fakeDerive = x1: x2: x2;
  fakeSelf = {};
  importPkgNames = s: import s { self = fakeSelf; derive = fakeDerive; };


  inherit (pkgs) rPackages;
  r_names = (attrNames rPackages);
  
  r_broken_names = attrNames (findBroken rPackages) ++ java_names ++ opengl_names; 
  r_notbroken_names = subtractLists r_broken_names r_names;

  bioc_names = attrNames (importPkgNames ./bioc-packages.nix);
  bioc_notbroken_names = subtractLists r_broken_names bioc_names;

  bioc_annotation_names = attrNames (importPkgNames ./bioc-annotation-packages.nix);
  bioc_annotation_notbroken_names = subtractLists r_broken_names bioc_annotation_names;

  bioc_experiment_names = attrNames (importPkgNames ./bioc-experiment-packages.nix);
  bioc_experiment_notbroken_names = subtractLists r_broken_names bioc_experiment_names;

  bioc_workflows_names = attrNames (importPkgNames ./bioc-workflows-packages.nix);
  bioc_workflows_notbroken_names = subtractLists r_broken_names bioc_workflows_names;

  cran_names = attrNames (importPkgNames ./cran-packages.nix);
  cran_notbroken_names = subtractLists r_broken_names cran_names;


  # not broken ones..
  bioc_pkgs            = getAttrs bioc_notbroken_names rPackages;
  bioc_annotation_pkgs = getAttrs bioc_annotation_notbroken_names rPackages;
  bioc_experiment_pkgs = getAttrs bioc_experiment_notbroken_names rPackages;
  bioc_workflows_pkgs  = getAttrs bioc_workflows_notbroken_names rPackages;
  cran_pkgs            = getAttrs cran_notbroken_names rPackages;

in

{ rpkgs = pkgs.rPackages;
  inherit
  # package sets
    rWrapper # BIG! ~18K packages
    rPackages # SAME 
    bioc_pkgs
    bioc_annotation_pkgs
    bioc_experiment_pkgs
    bioc_workflows_pkgs
    cran_pkgs # ~15K packages
    
    # names
    r_names  
    r_notbroken_names
    r_broken_names
    bioc_names
    bioc_notbroken_names
    bioc_annotation_names
    bioc_annotation_notbroken_names
    bioc_experiment_names
    bioc_experiment_notbroken_names
    bioc_workflows_names
    bioc_workflows_notbroken_names
    cran_names
    cran_notbroken_names

    # special names to test bug fixes
    opengl_names
    java_names
    
    # helper functions
    isBroken
    findBroken
    findNotBroken
    
  ;}

