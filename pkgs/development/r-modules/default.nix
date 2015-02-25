/* This file defines the composition for CRAN (R) packages. */

{ R, pkgs, overrides }:

let
  inherit (pkgs) fetchurl stdenv lib;

  buildRPackage = pkgs.callPackage ./generic-builder.nix { inherit R; };

  # Package template
  #
  # some packages, e.g. cncaGUI, require X running while installation,
  # so that we use xvfb-run if requireX is true.
  derive = lib.makeOverridable ({
        name, version, sha256,
        depends ? [],
        doCheck ? true,
        requireX ? false,
        broken ? false,
        hydraPlatforms ? R.meta.hydraPlatforms
      }: buildRPackage {
    name = "${name}-${version}";
    src = fetchurl {
      urls = [
        "mirror://cran/src/contrib/${name}_${version}.tar.gz"
        "mirror://cran/src/contrib/00Archive/${name}/${name}_${version}.tar.gz"
      ];
      inherit sha256;
    };
    inherit doCheck requireX;
    propagatedBuildInputs = depends;
    nativeBuildInputs = depends;
    meta.homepage = "http://cran.r-project.org/web/packages/${name}/";
    meta.platforms = R.meta.platforms;
    meta.hydraPlatforms = hydraPlatforms;
    meta.broken = broken;
  });

  # Overrides package definitions with nativeBuildInputs.
  # For example,
  #
  # overrideNativeBuildInputs {
  #   foo = [ pkgs.bar ]
  # } old
  #
  # results in
  #
  # {
  #   foo = old.foo.overrideDerivation (attrs: {
  #     nativeBuildInputs = attrs.nativeBuildInputs ++ [ pkgs.bar ];
  #   });
  # }
  overrideNativeBuildInputs = overrides: old:
    lib.mapAttrs (name: value:
      (builtins.getAttr name old).overrideDerivation (attrs: {
        nativeBuildInputs = attrs.nativeBuildInputs ++ value;
      })
    ) overrides;

  # Overrides package definitions with buildInputs.
  # For example,
  #
  # overrideBuildInputs {
  #   foo = [ pkgs.bar ]
  # } old
  #
  # results in
  #
  # {
  #   foo = old.foo.overrideDerivation (attrs: {
  #     buildInputs = attrs.buildInputs ++ [ pkgs.bar ];
  #   });
  # }
  overrideBuildInputs = overrides: old:
    lib.mapAttrs (name: value:
      (builtins.getAttr name old).overrideDerivation (attrs: {
        buildInputs = attrs.buildInputs ++ value;
      })
    ) overrides;

  # Overrides package definitions with new R dependencies.
  # For example,
  #
  # overrideRDepends {
  #   foo = [ self.bar ]
  # } old
  #
  # results in
  #
  # {
  #   foo = old.foo.overrideDerivation (attrs: {
  #     nativeBuildInputs = attrs.nativeBuildInputs ++ [ self.bar ];
  #     propagatedNativeBuildInputs = attrs.propagatedNativeBuildInputs ++ [ self.bar ];
  #   });
  # }
  overrideRDepends = overrides: old:
    lib.mapAttrs (name: value:
      (builtins.getAttr name old).overrideDerivation (attrs: {
        nativeBuildInputs = attrs.nativeBuildInputs ++ value;
        propagatedNativeBuildInputs = attrs.propagatedNativeBuildInputs ++ value;
      })
    ) overrides;

  # Overrides package definition requiring X running to install.
  # For example,
  #
  # overrideRequireX [
  #   "foo"
  # ] old
  #
  # results in
  #
  # {
  #   foo = old.foo.override {
  #     requireX = true;
  #   };
  # }
  overrideRequireX = packageNames: old:
    let
      nameValuePairs = map (name: {
        inherit name;
        value = (builtins.getAttr name old).override {
          requireX = true;
        };
      }) packageNames;
    in
      builtins.listToAttrs nameValuePairs;

  # Overrides package definition to skip check.
  # For example,
  #
  # overrideSkipCheck [
  #   "foo"
  # ] old
  #
  # results in
  #
  # {
  #   foo = old.foo.override {
  #     doCheck = false;
  #   };
  # }
  overrideSkipCheck = packageNames: old:
    let
      nameValuePairs = map (name: {
        inherit name;
        value = (builtins.getAttr name old).override {
          doCheck = false;
        };
      }) packageNames;
    in
      builtins.listToAttrs nameValuePairs;

  # Overrides package definition to mark it broken.
  # For example,
  #
  # overrideBroken [
  #   "foo"
  # ] old
  #
  # results in
  #
  # {
  #   foo = old.foo.override {
  #     broken = true;
  #   };
  # }
  overrideBroken = packageNames: old:
    let
      nameValuePairs = map (name: {
        inherit name;
        value = (builtins.getAttr name old).override {
          broken = true;
        };
      }) packageNames;
    in
      builtins.listToAttrs nameValuePairs;

  defaultOverrides = old: new:
    let old0 = old; in
    let
      old1 = old0 // (overrideRequireX packagesRequireingX old0);
      old2 = old1 // (overrideSkipCheck packagesToSkipCheck old1);
      old3 = old2 // (overrideRDepends packagesWithRDepends old2);
      old4 = old3 // (overrideNativeBuildInputs packagesWithNativeBuildInputs old3);
      old5 = old4 // (overrideBuildInputs packagesWithBuildInputs old4);
      old6 = old5 // (overrideBroken brokenPackages old5);
      old = old6;
    in old // (otherOverrides old new);

  # Recursive override pattern.
  # `_self` is a collection of packages;
  # `self` is `_self` with overridden packages;
  # packages in `_self` may depends on overridden packages.
  self = (defaultOverrides _self self) // overrides;
  _self = import ./cran-packages.nix { inherit self derive; };

  # tweaks for the individual packages and "in self" follow

  packagesWithRDepends = {
    # sort -t '=' -k 2
    FactoMineR = [ self.car ];
  };

  packagesWithNativeBuildInputs = {
    # sort -t '=' -k 2
    graphscan = [ pkgs.gsl ];
    RAppArmor = [ pkgs.apparmor ];
    BNSP = [ pkgs.gsl ];
    SOD = [ pkgs.cudatoolkit ]; # requres CL/cl.h
    curl = [ pkgs.curl pkgs.openldap ];
    Rssa = [ pkgs.fftw ];
    fftw = [ pkgs.fftw ];
    fftwtools = [ pkgs.fftw ];
    kza = [ pkgs.fftw ];
    mwaved = [ pkgs.fftw ];
    spate = [ pkgs.fftw ];
    chebpol = [ pkgs.fftw ];
    seewave = [ pkgs.fftw pkgs.libsndfile ];
    rgeos = [ pkgs.geos ];
    Rglpk = [ pkgs.glpk ];
    RCA = [ pkgs.gmp ];
    gmp = [ pkgs.gmp ];
    rcdd = [ pkgs.gmp ];
    Rlibeemd = [ pkgs.gsl ];
    igraph = [ pkgs.gmp ];
    glpkAPI = [ pkgs.gmp pkgs.glpk ];
    sdcTable = [ pkgs.gmp pkgs.glpk ];
    Rmpfr = [ pkgs.gmp pkgs.mpfr ];
    Formula = [ pkgs.gmp ];
    BayesSAE = [ pkgs.gsl ];
    BayesVarSel = [ pkgs.gsl ];
    HiCseg = [ pkgs.gsl ];
    KFKSDS = [ pkgs.gsl ];
    R2GUESS = [ pkgs.gsl ];
    RcppZiggurat = [ pkgs.gsl ];
    SemiCompRisks = [ pkgs.gsl ];
    VBLPCM = [ pkgs.gsl ];
    abn = [ pkgs.gsl ];
    cit = [ pkgs.gsl ];
    libamtrack = [ pkgs.gsl ];
    mixcat = [ pkgs.gsl ];
    outbreaker = [ pkgs.gsl ];
    ridge = [ pkgs.gsl ];
    simplexreg = [ pkgs.gsl ];
    stsm = [ pkgs.gsl ];
    survSNP = [ pkgs.gsl ];
    topicmodels = [ pkgs.gsl ];
    RcppGSL = [ pkgs.gsl ];
    bnpmr = [ pkgs.gsl ];
    V8 = [ pkgs.v8 ];
    geoCount = [ pkgs.gsl ];
    devEMF = [ pkgs.xlibs.libXft ];
    gsl = [ pkgs.gsl ];
    mvabund = [ pkgs.gsl ];
    diversitree = [ pkgs.gsl pkgs.fftw ];
    TKF = [ pkgs.gsl ];
    VBmix = [ pkgs.gsl pkgs.fftw pkgs.qt4 ];
    RGtk2 = [ pkgs.gtk2 ];
    cairoDevice = [ pkgs.gtk2 ];
    adimpro = [ pkgs.imagemagick ];
    rjags = [ pkgs.jags ];
    runjags = [ pkgs.jags ];
    JavaGD = [ pkgs.jdk ];
    RODBC = [ pkgs.libiodbc ];
    RODBCext = [ pkgs.libiodbc ];
    jpeg = [ pkgs.libjpeg ];
    EMCluster = [ pkgs.liblapack ];
    png = [ pkgs.libpng ];
    pbdMPI = [ pkgs.openmpi ];
    bigGP = [ pkgs.openmpi ];
    rtiff = [ pkgs.libtiff ];
    tiff = [ pkgs.libtiff ];
    Cairo = [ pkgs.libtiff pkgs.libjpeg pkgs.cairo ];
    XML = [ pkgs.libtool pkgs.libxml2 pkgs.xmlsec pkgs.libxslt ];
    rpud = [ pkgs.linuxPackages.nvidia_x11 ];
    CARramps = [ pkgs.linuxPackages.nvidia_x11 pkgs.liblapack ];
    rgl = [ pkgs.mesa pkgs.x11 ];
    ncdf = [ pkgs.netcdf ];
    ncdf4 = [ pkgs.netcdf ];
    pbdNCDF4 = [ pkgs.netcdf ];
    RNetCDF = [ pkgs.netcdf pkgs.udunits ];
    nloptr = [ pkgs.nlopt ];
    npRmpi = [ pkgs.openmpi ];
    pbdPROF = [ pkgs.openmpi ];
    sprint = [ pkgs.openmpi ];
    Rmpi = [ pkgs.openmpi ];
    openssl = [ pkgs.openssl ];
    PKI = [ pkgs.openssl ];
    RSclient = [ pkgs.openssl ];
    Rserve = [ pkgs.openssl ];
    Rpoppler = [ pkgs.poppler ];
    audio = [ pkgs.portaudio ];
    rpg = [ pkgs.postgresql ];
    RPostgreSQL = [ pkgs.postgresql ];
    ssanv = [ pkgs.proj ];
    proj4 = [ pkgs.proj ];
    rgdal = [ pkgs.proj pkgs.gdal ];
    RProtoBuf = [ pkgs.protobuf ];
    rPython = [ pkgs.python ];
    qtpaint = [ pkgs.qt4 ];
    qtbase = [ pkgs.qt4 ];
    BayesXsrc = [ pkgs.readline pkgs.ncurses ];
    udunits2 = [ pkgs.udunits pkgs.expat ];
    tkrplot = [ pkgs.xlibs.libX11 ];
    rzmq = [ pkgs.zeromq3 ];
    PopGenome = [ pkgs.zlib ];
    RJaCGH = [ pkgs.zlib ];
    RcppCNPy = [ pkgs.zlib ];
    rbamtools = [ pkgs.zlib ];
    rmatio = [ pkgs.zlib ];
    RVowpalWabbit = [ pkgs.zlib pkgs.boost ];
    seqminer = [ pkgs.zlib pkgs.bzip2 ];
    seqinr = [ pkgs.zlib ];
    rphast = [ pkgs.pcre pkgs.zlib pkgs.bzip2 pkgs.gzip pkgs.readline ];
    rtfbs = [ pkgs.zlib pkgs.pcre pkgs.bzip2 pkgs.gzip pkgs.readline ];
    Rhpc = [ pkgs.zlib pkgs.bzip2 pkgs.icu pkgs.lzma pkgs.openmpi pkgs.pcre ];
    SAVE = [ pkgs.zlib pkgs.bzip2 pkgs.icu pkgs.lzma pkgs.pcre ];
    RcppOctave = [ pkgs.zlib pkgs.bzip2 pkgs.icu pkgs.lzma pkgs.pcre pkgs.octave ];
    rJava = [ pkgs.zlib pkgs.bzip2 pkgs.icu pkgs.lzma pkgs.pcre pkgs.jdk pkgs.libzip ];
    R2SWF = [ pkgs.zlib pkgs.libpng pkgs.freetype ];
    sysfonts = [ pkgs.zlib pkgs.libpng pkgs.freetype ];
    showtext = [ pkgs.zlib pkgs.libpng pkgs.icu pkgs.freetype ];
    XBRL = [ pkgs.zlib pkgs.libxml2 ];
    RMySQL = [ pkgs.zlib pkgs.mysql ];
  };

  packagesWithBuildInputs = {
    # sort -t '=' -k 2
    svKomodo = [ pkgs.which ];
    nat = [ pkgs.which ];
    nat_nblast = [ pkgs.which ];
    nat_templatebrains = [ pkgs.which ];
    RMark = [ pkgs.which ];
    RPushbullet = [ pkgs.which ];
    qtpaint = [ pkgs.cmake ];
    qtbase = [ pkgs.cmake pkgs.perl ];
    gmatrix = [ pkgs.cudatoolkit ];
    WideLM = [ pkgs.cudatoolkit ];
    RCurl = [ pkgs.curl ];
    R2SWF = [ pkgs.pkgconfig ];
    RGtk2 = [ pkgs.pkgconfig ];
    RProtoBuf = [ pkgs.pkgconfig ];
    Rpoppler = [ pkgs.pkgconfig ];
    VBmix = [ pkgs.pkgconfig ];
    XML = [ pkgs.pkgconfig ];
    cairoDevice = [ pkgs.pkgconfig ];
    chebpol = [ pkgs.pkgconfig ];
    fftw = [ pkgs.pkgconfig ];
    geoCount = [ pkgs.pkgconfig ];
    kza = [ pkgs.pkgconfig ];
    mwaved = [ pkgs.pkgconfig ];
    showtext = [ pkgs.pkgconfig ];
    spate = [ pkgs.pkgconfig ];
    stringi = [ pkgs.pkgconfig ];
    sysfonts = [ pkgs.pkgconfig ];
    Cairo = [ pkgs.pkgconfig ];
    Rsymphony = [ pkgs.pkgconfig pkgs.doxygen pkgs.graphviz pkgs.subversion ];
    qtutils = [ pkgs.qt4 ];
    ecoretriever = [ pkgs.which ];
    tcltk2 = [ pkgs.tcl pkgs.tk ];
    tikzDevice = [ pkgs.which pkgs.texLive ];
    rPython = [ pkgs.which ];
    CARramps = [ pkgs.which pkgs.cudatoolkit ];
    gridGraphics = [ pkgs.which ];
    gputools = [ pkgs.which pkgs.cudatoolkit ];
    rpud = [ pkgs.which pkgs.cudatoolkit ];
    adimpro = [ pkgs.which pkgs.xorg.xdpyinfo ];
    PET = [ pkgs.which pkgs.xorg.xdpyinfo pkgs.imagemagick ];
    dti = [ pkgs.which pkgs.xorg.xdpyinfo pkgs.imagemagick ];
  };

  packagesRequireingX = [
    "AnalyzeFMRI"
    "AnnotLists"
    "AnthropMMD"
    "AtelieR"
    "BAT"
    "BCA"
    "BEQI2"
    "BHMSMAfMRI"
    "BioGeoBEARS"
    "BiodiversityR"
    "CCTpack"
    "CommunityCorrelogram"
    "ConvergenceConcepts"
    "DALY"
    "DSpat"
    "Deducer"
    "DeducerExtras"
    "DeducerPlugInExample"
    "DeducerPlugInScaling"
    "DeducerSpatial"
    "DeducerSurvival"
    "HomoPolymer"
    "MetSizeR"
    "DeducerText"
    "Demerelate"
    "DescTools"
    "DivMelt"
    "ENiRG"
    "EcoVirtual"
    "EnQuireR"
    "FAiR"
    "FD"
    "FFD"
    "FeedbackTS"
    "FreeSortR"
    "GGEBiplotGUI"
    "GPCSIV"
    "GUniFrac"
    "Geneland"
    "GeoGenetix"
    "GeoXp"
    "GrammR"
    "GrapheR"
    "GroupSeq"
    "HH"
    "HiveR"
    "IsotopeR"
    "JGR"
    "KappaGUI"
    "LS2Wstat"
    "MAR1"
    "MTurkR"
    "MareyMap"
    "MergeGUI"
    "Meth27QC"
    "MicroStrategyR"
    "MissingDataGUI"
    "MplusAutomation"
    "OligoSpecificitySystem"
    "OpenRepGrid"
    "PBSadmb"
    "PBSmodelling"
    "PCPS"
    "PopGenReport"
    "PredictABEL"
    "PrevMap"
    "ProbForecastGOP"
    "QCAGUI"
    "R2STATS"
    "RHRV"
    "RNCEP"
    "RQDA"
    "RSDA"
    "RSurvey"
    "RandomFields"
    "Rcmdr"
    "RcmdrPlugin_BCA"
    "RcmdrPlugin_DoE"
    "RcmdrPlugin_EACSPIR"
    "RcmdrPlugin_EBM"
    "RcmdrPlugin_EZR"
    "RcmdrPlugin_EcoVirtual"
    "RcmdrPlugin_FactoMineR"
    "RcmdrPlugin_HH"
    "RcmdrPlugin_IPSUR"
    "RcmdrPlugin_KMggplot2"
    "RcmdrPlugin_MA"
    "RcmdrPlugin_MPAStats"
    "RcmdrPlugin_ROC"
    "RcmdrPlugin_SCDA"
    "RcmdrPlugin_SLC"
    "RcmdrPlugin_SM"
    "RcmdrPlugin_StatisticalURV"
    "RcmdrPlugin_TeachingDemos"
    "RcmdrPlugin_UCA"
    "RcmdrPlugin_coin"
    "RcmdrPlugin_depthTools"
    "RcmdrPlugin_doex"
    "RcmdrPlugin_epack"
    "RcmdrPlugin_lfstat"
    "RcmdrPlugin_mosaic"
    "RcmdrPlugin_orloca"
    "RcmdrPlugin_plotByGroup"
    "RcmdrPlugin_pointG"
    "RcmdrPlugin_qual"
    "RcmdrPlugin_sampling"
    "RcmdrPlugin_sos"
    "RcmdrPlugin_steepness"
    "RcmdrPlugin_survival"
    "RcmdrPlugin_temis"
    "RenextGUI"
    "RunuranGUI"
    "SOLOMON"
    "SPACECAP"
    "SRRS"
    "SSDforR"
    "STEPCAM"
    "SYNCSA"
    "Simile"
    "SimpleTable"
    "StatDA"
    "SyNet"
    "TDMR"
    "TED"
    "TIMP"
    "TTAinterfaceTrendAnalysis"
    "TestScorer"
    "VIMGUI"
    "VecStatGraphs3D"
    "WMCapacity"
    "accrual"
    "ade4TkGUI"
    "adehabitat"
    "analogue"
    "analogueExtra"
    "aplpack"
    "aqfig"
    "arf3DS4"
    "asbio"
    "bayesDem"
    "betapart"
    "betaper"
    "bio_infer"
    "bipartite"
    "biplotbootGUI"
    "blender"
    "cairoDevice"
    "cncaGUI"
    "cocorresp"
    "confidence"
    "constrainedKriging"
    "cpa"
    "dave"
    "debug"
    "detrendeR"
    "dgmb"
    "dpa"
    "dynBiplotGUI"
    "dynamicGraph"
    "eVenn"
    "exactLoglinTest"
    "fSRM"
    "fat2Lpoly"
    "fbati"
    "feature"
    "fgui"
    "fisheyeR"
    "fit4NM"
    "forams"
    "forensim"
    "fscaret"
    "gWidgets2RGtk2"
    "gWidgets2tcltk"
    "gWidgetsRGtk2"
    "gWidgetstcltk"
    "gcmr"
    "geoR"
    "geoRglm"
    "geomorph"
    "georob"
    "gnm"
    "gsubfn"
    "iBUGS"
    "iDynoR"
    "ic50"
    "in2extRemes"
    "iplots"
    "isopam"
    "likeLTD"
    "loe"
    "logmult"
    "memgene"
    "metacom"
    "migui"
    "miniGUI"
    "mixsep"
    "mlDNA"
    "mpmcorrelogram"
    "mritc"
    "multgee"
    "multibiplotGUI"
    "nodiv"
    "onemap"
    "palaeoSig"
    "paleoMAS"
    "pbatR"
    "pez"
    "phylotools"
    "picante"
    "playwith"
    "plotSEMM"
    "plsRbeta"
    "plsRglm"
    "pmg"
    "poppr"
    "powerpkg"
    "prefmod"
    "qtbase"
    "qtpaint"
    "qtutils"
    "r4ss"
    "rAverage"
    "rareNMtests"
    "recluster"
    "relax"
    "relimp"
    "reportRx"
    "reshapeGUI"
    "rgl"
    "rich"
    "ringscale"
    "rioja"
    "ripa"
    "rite"
    "rnbn"
    "rriskDistributions"
    "rsgcc"
    "sdcMicroGUI"
    "sharpshootR"
    "simba"
    "soundecology"
    "spacodiR"
    "spatsurv"
    "sqldf"
    "statcheck"
    "stosim"
    "strvalidator"
    "stylo"
    "svDialogstcltk"
    "svIDE"
    "svSocket"
    "svWidgets"
    "tcltk2"
    "titan"
    "tkrgl"
    "tkrplot"
    "tmap"
    "tspmeta"
    "twiddler"
    "vcdExtra"
    "vegan"
    "vegan3d"
    "vegclust"
    "x12GUI"
    "xergm"
  ];

  packagesToSkipCheck = [
    "Rmpi" # tries to run MPI processes
    "gmatrix" # requires CUDA runtime
    "npRmpi" # tries to run MPI processes
    "sprint" # tries to run MPI processes
    "pbdMPI" # tries to run MPI processes
  ];

  # Packages which cannot be installed due to lack of dependencies or other reasons.
  brokenPackages = [
    "ACNE" # requires aroma_affymetrix
    "Actigraphy" # SDMTools.so: undefined symbol: X
    "adaptsmoFMRI" # requires spatstat
    "ads" # requires spatstat
    "agridat" # requires pcaMethods
    "aLFQ" # requires protiq
    "AntWeb" # requires leafletR
    "aoristic" # requires spatstat
    "apmsWAPP" # requires genefilter, Biobase, multtest, edgeR, DESeq, and aroma.light
    "aroma_affymetrix" # requires aroma_core
    "aroma_cn" # requires PSCBS
    "aroma_core" # requires PSCBS
    "ArrayBin" # requires SAGx
    "babel" # requires edgeR
    "BACA" # requires RDAVIDWebService
    "bamboo" # depends on broken jvmr
    "BcDiag" # requires fabia
    "bdvis" # requres taxize
    "beadarrayFilter" # requires beadarray
    "beadarrayMSV" # requires rggobi
    "bigGP" # requires MPI running. HELP WANTED!
    "bigpca" # requires NCmisc
    "Biograph" # requires mvna
    "biotools" # requires rpanel
    "BiSEp" # requires GOSemSim, GO.db, and org.Hs.eg.db
    "BLCOP" # depends on broken fPortfolio
    "bmrm" # requires clpAPI
    "branchLars" # requires Rgraphviz
    "BRugs" # requires OpenBUGS
    "calmate" # requires aroma_core
    "CARrampsOcl" # depends on OpenCL
    "CHAT" # requires DNAcopy
    "ChemoSpec" # depends on broken speaq
    "classGraph" # requires graph, and Rgraphviz
    "clpAPI" # requires clp
    "clusterfly" # requires rggobi
    "compendiumdb" # requires Biobase
    "CORM" # requires limma
    "cplexAPI" # requires CPLEX
    "cqrReg" # requires Rmosek
    "crmn" # requires pcaMethods, and Biobase
    "CrypticIBDcheck" # requires rJPSGCS
    "cudaBayesreg" # requres Rmath
    "curvHDR" # requires flowCore
    "D2C" # requires gRbase
    "DAAGbio" # requires limma
    "dagbag" # requires Rlapack
    "DBKGrad" # requires SDD
    "dbmss" # requires spatstat
    "DCGL" # requires limma
    "dcGOR" # requires dnet
    "demi" # requires affy, affxparser, and oligo
    "DepthProc" # requires samr
    "Digiroo2" # requires spatstat
    "dixon" # requires spatstat
    "dnet" # requires supraHex, graph, Rgraphviz, and Biobase
    "doMPI" # requires MPI running. HELP WANTED!
    "dpcR" # requires spatstat
    "DSpat" # requires spatstat
    "ecespa" # requires spatstat
    "ecoengine" # requires leafletR
    "ecospat" # requires spatstat
    "edgeRun" # requires edgeR
    "EMA" # requires siggenes, affy, multtest, gcrma, biomaRt, and AnnotationDbi
    "EMDomics" # requires BiocParallel
    "empiricalFDR_DESeq2" # requires DESeq2, and GenomicRanges
    "epoc" # requires graph, and Rgraphviz
    "erpR" # requires rpanel
    "ETAS" # requires spatstat
    "eulerian" # requires graph
    "evobiR" # requres taxiz
    "evora" # requires qvalue
    "ExomeDepth" # requires GenomicRanges, and Rsamtools
    "FAMT" # requires impute
    "fdrDiscreteNull" # requires edgeR
    "FHtest" # requires interval
    "flexCWM" # depends on broken mixture
    "fPortfolio" # requires rneos
    "FunctionalNetworks" # requires breastCancerVDX, and Biobase
    "gamlss_demo" # requires rpanel
    "GeneticTools" # requires snpStats
    "GExMap" # requires Biobase and multtest
    "gitter" # requires EBImage
    "gmatrix" # depends on proprietary cudatoolkit
    "GOGANPA" # requires WGCNA
    "gputools" # depends on proprietary cudatoolkit
    "gRain" # requires gRbase
    "gRapHD" # requires graph
    "gRbase" # requires RBGL, and graph
    "gRc" # requires gRbase
    "gridDebug" # requires gridGraphviz
    "gridGraphviz" # requires graph, and Rgraphviz
    "GriegSmith" # requires spatstat
    "gRim" # requires gRbase
    "GSAgm" # requires edgeR
    "GUIDE" # requires rpanel
    "h2o" # tries to download some h2o.jar during its build
    "hasseDiagram" # requires Rgraphviz
    "hddplot" # requires multtest
    "HierO" # requires rneos
    "HiPLARM" # requires MAGMA or PLASMA
    "hpoPlot" # requires Rgraphviz
    "HTSCluster" # requires edgeR
    "iFes" # depends on proprietary cudatoolkit
    "imputeLCMD" # requires pcaMethods, and impute
    "intamapInteractive" # requires spatstat
    "interval" # requires Icens
    "ionflows" # requires Biostrings
    "iRefR" # requires graph, and RBGL
    "IsoGene" # requires Biobase, and affy
    "isva" # requires qvalue
    "jomo" # linking errors
    "js" # requires broken V8
    "jvmr" # tries to download files during its build
    "KANT" # requires affy, and Biobase
    "ktspair" # requires Biobase
    "latticeDensity" # requires spatstat
    "leapp" # requires sva
    "lefse" # SDMTools.so: undefined symbol: X
    "lgcp" # requires rpanel
    "LinRegInteractive" # requires Rpanel
    "LogisticDx" # requires gRbase
    "LOST" # requires pcaMethods
    "ltsk" # requires Rlapack and Rblas
    "magma" # requires MAGMA
    "MAMA" # requires metaMA
    "MEET" # requires pcaMethods, and seqLogo
    "metabolomics" # depends on broken crmn
    "MetaDE" # requires impute, and Biobase
    "MetaLandSim" # requires Biobase
    "metaMA" # requires limma
    "metaMix" # requires MPI running. HELP WANTED!
    "mGSZ" # requires Biobase, and limma
    "MigClim" # SDMTools.So: Undefined Symbol: X
    "minimist" # requires broken V8
    "miRtest" # requires globaltest, GlobalAncova, and limma
    "mixture" # mixture.so: undefined symbol: dtrmm_
    "moduleColor" # requires impute
    "msarc" # requires AnnotationDbi
    "MSeasy" # requires mzR, and xcms
    "MSeasyTkGUI" # requires MSeasyTkGUI
    "MSIseq" # requires IRanges
    "msSurv" # requires graph
    "multiDimBio" # requires pcaMethods
    "mutossGUI" # requires mutoss
    "mutoss" # requires multtest
    "MXM" # depends on broken gRbase
    "NBPSeq" # requires qvalue
    "NCmisc" # requires BiocInstaller
    "netClass" # requires samr
    "nettools" # requires WGCNA
    "netweavers" # requires BiocGenerics, Biobase, and limma
    "NLPutils" # requires qdap
    "NSA" # requires aroma_core
    "OpenCL" # FIXME: requires CL/opencl.h
    "optBiomarker" # requires rpanel
    "ora" # requires ROracle
    "orQA" # requires genefilter
    "PairViz" # requires graph
    "PANDA" # requires GO.db
    "ParDNAcopy" # requires DNAcopy
    "pathClass" # requires affy, and Biobase
    "PatternClass" # SDMTools.So: Undefined Symbol: X
    "pbdBASE" # requires pbdMPI
    "pbdDEMO" # requires pbdMPI
    "pbdDMAT" # requires pbdMPI
    "pbdSLAP" # requires pbdMPI
    "pcaL1" # requires clp
    "pcalg" # requires graph, and RBGL
    "PCGSE" # requires safe
    "PCS" # requires multtest
    "PepPrep" # requires biomaRt
    "PerfMeas" # requires limma, graph, and RBGL
    "permGPU" # requires Biobase
    "PhViD" # requires LBE
    "pi0" # requires qvalue
    "PKgraph" # requires rggobi
    "plmDE" # requires limma
    "plsRcox" # requires survcomp
    "PMA" # requires impute
    "pmcgd" # depends on broken mixture
    "pmclust" # requires MPI running. HELP WANTED!
    "polyCub" # requires spatstat
    "ppiPre" # requires AnnotationDbi, GOSemSim, GO.db
    "propOverlap" # requires Biobase
    "protiq" # requires graph, and RBGL
    "PSCBS" # requires DNAcopy
    "pubmed_mineR" # requires SSOAP
    "PubMedWordcloud" # requires GOsummaries
    "qdap" # requires gender
    "qtlnet" # requires pcalg
    "qtpaint" # can't find QtCore libraries
    "QuACN" # requires graph, RBGL
    "QuasiSeq" # requires edgeR
    "RADami" # requires Biostrings
    "raincpc" # SDMTools.so: undefined symbol: X
    "rainfreq" # SDMTools.so: undefined symbol: X
    "RAM" # requires Heatplus
    "RAPIDR" # requires Biostrings, Rsamtools, and GenomicRanges
    "RbioRXN" # requires fmcsR, and KEGGREST
    "Rcell" # requires EBImage
    "RcmdrPlugin_seeg" # requires seeg
    "Rcplex" # requires cplexAPI
    "RcppRedis" # requires Hiredis
    "rDEA" # no such file or directory
    "RDieHarder" # requires libdieharder
    "reader" # requires NCmisc
    "REBayes" # requires Rmosek
    "RefFreeEWAS" # requires isva
    "retistruct" # depends on broken RImageJROI
    "rggobi" # requires GGobi
    "RImageJROI" # requires spatstat
    "rJPSGCS" # requires chopsticks
    "rLindo" # requires LINDO API
    "Rmosek" # requires mosek
    "RnavGraph" # requires graph, and RBGL
    "rneos" # requires XMLRPC
    "RNeXML" # requres taxize
    "RobLoxBioC" # requires Biobase
    "RobLox" # requires Biobase
    "RockFab" # requires EBImage
    "ROI_plugin_symphony" # depends on broken Rsymphony
    "ROracle" # requires OCI
    "rpanel" # I could not make Tcl to recognize BWidget. HELP WANTED!
    "RQuantLib" # requires QuantLib
    "RSAP" # requires SAPNWRFCSDK
    "RSeed" # requires RBGL, and graph
    "rsig" # requires survcomp
    "RSNPset" # requires qvalue
    "rsprng" # requres sprng
    "Rsymphony" # FIXME: requires SYMPHONY
    "RVideoPoker" # requires Rpanel
    "rysgran" # requires soiltexture
    "samr" # requires impute
    "saps" # requires piano, and survcomp
    "SDD" # requires rpanel
    "seeg" # requires spatstat
    "selectspm" # depends on broken ecespa
    "semiArtificial" # requires RSNNS
    "SeqFeatR" # requires Biostrings, qvalue, and widgetTools
    "SeqGrapheR" # requires rggobi
    "sequenza" # requires copynumber
    "SGCS" # requires spatstat
    "siar" # requires spatstat
    "SimRAD" # requires Biostrings, and ShortRead
    "SimSeq" # requires edgeR
    "siplab" # requires spatstat
    "smart" # requires PMA
    "snpEnrichment" # requires snpStats
    "snplist" # requires biomaRt
    "snpStatsWriter" # requires snpStats
    "SNPtools" # requires IRanges, GenomicRanges, Biostrings, and Rsamtools
    "SOD" # depends on proprietary cudatoolkit
    "soilphysics" # requires rpanel
    "sparr" # requires spatstat
    "spatialsegregation" # requires spatstat
    "SpatialVx" # requires spatstat
    "speaq" # requires MassSpecWavelet
    "spocc" # requires leafletR
    "SQDA" # requires limma
    "Statomica" # requires Biobase, multtest
    "StochKit2R" # tarball is invalid on server
    "stpp" # requires spatstat
    "structSSI" # requires multtest
    "strum" # requires Rgraphviz
    "superbiclust" # requires fabia
    "surveillance" # requires polyCub
    "swamp" # requires impute
    "sybilSBML" # requires libSBML
    "taxize" # requres bold
    "TcGSA" # requires multtest
    "topologyGSA" # requires gRbase
    "TR8" # requres taxize
    "trip" # requires spatstat
    "ttScreening" # requires sva, and limma
    "V8" # compilation error
    "vows" # requires rpanel
    "WGCNA" # requires impute
    "wgsea" # requires snpStats
    "WideLM" # depends on proprietary cudatoolkit
    "x_ent" # requires opencpu
    "zoib" # tarball is invalid on server
  ];

  otherOverrides = old: new: {
    curl = old.curl.overrideDerivation (attrs: {
      preConfigure = "export CURL_INCLUDES=${pkgs.curl}/include/curl";
    });

    iFes = old.iFes.overrideDerivation (attrs: {
      patches = [ ./patches/iFes.patch ];
      CUDA_HOME = "${pkgs.cudatoolkit}";
    });

    RcppArmadillo = old.RcppArmadillo.overrideDerivation (attrs: {
      patchPhase = "patchShebangs configure";
    });

    rpf = old.rpf.overrideDerivation (attrs: {
      patchPhase = "patchShebangs configure";
    });

    BayesXsrc = old.BayesXsrc.overrideDerivation (attrs: {
      patches = [ ./patches/BayesXsrc.patch ];
    });

    rJava = old.rJava.overrideDerivation (attrs: {
      preConfigure = ''
        export JAVA_CPPFLAGS=-I${pkgs.jdk}/include/
        export JAVA_HOME=${pkgs.jdk}
      '';
    });

    JavaGD = old.JavaGD.overrideDerivation (attrs: {
      preConfigure = ''
        export JAVA_CPPFLAGS=-I${pkgs.jdk}/include/
        export JAVA_HOME=${pkgs.jdk}
      '';
    });

    Mposterior = old.Mposterior.overrideDerivation (attrs: {
      PKG_LIBS = "-L${pkgs.atlas}/lib -lf77blas -latlas";
    });

    qtbase = old.qtbase.overrideDerivation (attrs: {
      patches = [ ./patches/qtbase.patch ];
    });

    Rmpi = old.Rmpi.overrideDerivation (attrs: {
      configureFlags = [
        "--with-Rmpi-type=OPENMPI"
      ];
    });

    npRmpi = old.npRmpi.overrideDerivation (attrs: {
      configureFlags = [
        "--with-Rmpi-type=OPENMPI"
      ];
    });

    Rmpfr = old.Rmpfr.overrideDerivation (attrs: {
      configureFlags = [
        "--with-mpfr-include=${pkgs.mpfr}/include"
      ];
    });

    RVowpalWabbit = old.RVowpalWabbit.overrideDerivation (attrs: {
      configureFlags = [
        "--with-boost=${pkgs.boost.dev}" "--with-boost-libdir=${pkgs.boost.lib}/lib"
      ];
    });

    RAppArmor = old.RAppArmor.overrideDerivation (attrs: {
      patches = [ ./patches/RAppArmor.patch ];
      LIBAPPARMOR_HOME = "${pkgs.apparmor}";
    });

    RMySQL = old.RMySQL.overrideDerivation (attrs: {
      patches = [ ./patches/RMySQL.patch ];
      MYSQL_DIR="${pkgs.mysql}";
    });

    devEMF = old.devEMF.overrideDerivation (attrs: {
      NIX_CFLAGS_LINK = "-L${pkgs.xlibs.libXft}/lib -lXft";
    });

    slfm = old.slfm.overrideDerivation (attrs: {
      PKG_LIBS = "-L${pkgs.atlas}/lib -lf77blas -latlas";
    });

    SamplerCompare = old.SamplerCompare.overrideDerivation (attrs: {
      PKG_LIBS = "-L${pkgs.atlas}/lib -lf77blas -latlas";
    });

    gputools = old.gputools.overrideDerivation (attrs: {
      patches = [ ./patches/gputools.patch ];
      CUDA_HOME = "${pkgs.cudatoolkit}";
    });

    # It seems that we cannot override meta attributes with overrideDerivation.
    CARramps = (old.CARramps.override { hydraPlatforms = stdenv.lib.platforms.none; }).overrideDerivation (attrs: {
      patches = [ ./patches/CARramps.patch ];
      configureFlags = [
        "--with-cuda-home=${pkgs.cudatoolkit}"
      ];
    });

    gmatrix = old.gmatrix.overrideDerivation (attrs: {
      patches = [ ./patches/gmatrix.patch ];
      CUDA_LIB_PATH = "${pkgs.cudatoolkit}/lib64";
      R_INC_PATH = "${pkgs.R}/lib/R/include";
      CUDA_INC_PATH = "${pkgs.cudatoolkit}/usr_include";
    });

    # It seems that we cannot override meta attributes with overrideDerivation.
    rpud = (old.rpud.override { hydraPlatforms = stdenv.lib.platforms.none; }).overrideDerivation (attrs: {
      patches = [ ./patches/rpud.patch ];
      CUDA_HOME = "${pkgs.cudatoolkit}";
    });

    WideLM = old.WideLM.overrideDerivation (attrs: {
      patches = [ ./patches/WideLM.patch ];
      configureFlags = [
        "--with-cuda-home=${pkgs.cudatoolkit}"
      ];
    });

    EMCluster = old.EMCluster.overrideDerivation (attrs: {
      patches = [ ./patches/EMCluster.patch ];
    });

    spMC = old.spMC.overrideDerivation (attrs: {
      patches = [ ./patches/spMC.patch ];
    });

    BayesLogit = old.BayesLogit.overrideDerivation (attrs: {
      patches = [ ./patches/BayesLogit.patch ];
    });

    BayesBridge = old.BayesBridge.overrideDerivation (attrs: {
      patches = [ ./patches/BayesBridge.patch ];
    });

    openssl = old.openssl.overrideDerivation (attrs: {
      OPENSSL_INCLUDES = "${pkgs.openssl}/include";
    });

    Rserve = old.Rserve.overrideDerivation (attrs: {
      patches = [ ./patches/Rserve.patch ];
      configureFlags = [
        "--with-server" "--with-client"
      ];
    });

    nloptr = old.nloptr.overrideDerivation (attrs: {
      configureFlags = [
        "--with-nlopt-cflags=-I${pkgs.nlopt}/include"
        "--with-nlopt-libs='-L${pkgs.nlopt}/lib -lnlopt_cxx -lm'"
      ];
    });

  };
in
  self
