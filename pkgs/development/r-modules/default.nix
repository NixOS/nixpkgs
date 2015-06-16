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
    FactoMineR = [ self.car ];
  };

  packagesWithNativeBuildInputs = {
    abn = [ pkgs.gsl ];
    adimpro = [ pkgs.imagemagick ];
    audio = [ pkgs.portaudio ];
    BayesSAE = [ pkgs.gsl ];
    BayesVarSel = [ pkgs.gsl ];
    BayesXsrc = [ pkgs.readline pkgs.ncurses ];
    bigGP = [ pkgs.openmpi ];
    bnpmr = [ pkgs.gsl ];
    BNSP = [ pkgs.gsl ];
    cairoDevice = [ pkgs.gtk2 ];
    Cairo = [ pkgs.libtiff pkgs.libjpeg pkgs.cairo ];
    CARramps = [ pkgs.linuxPackages.nvidia_x11 pkgs.liblapack ];
    chebpol = [ pkgs.fftw ];
    cit = [ pkgs.gsl ];
    curl = [ pkgs.curl ];
    devEMF = [ pkgs.xlibs.libXft ];
    diversitree = [ pkgs.gsl pkgs.fftw ];
    EMCluster = [ pkgs.liblapack ];
    fftw = [ pkgs.fftw ];
    fftwtools = [ pkgs.fftw ];
    Formula = [ pkgs.gmp ];
    geoCount = [ pkgs.gsl ];
    git2r = [ pkgs.zlib pkgs.openssl ];
    glpkAPI = [ pkgs.gmp pkgs.glpk ];
    gmp = [ pkgs.gmp ];
    graphscan = [ pkgs.gsl ];
    gsl = [ pkgs.gsl ];
    HiCseg = [ pkgs.gsl ];
    igraph = [ pkgs.gmp ];
    JavaGD = [ pkgs.jdk ];
    jpeg = [ pkgs.libjpeg ];
    KFKSDS = [ pkgs.gsl ];
    kza = [ pkgs.fftw ];
    libamtrack = [ pkgs.gsl ];
    mixcat = [ pkgs.gsl ];
    mvabund = [ pkgs.gsl ];
    mwaved = [ pkgs.fftw ];
    ncdf4 = [ pkgs.netcdf ];
    ncdf = [ pkgs.netcdf ];
    nloptr = [ pkgs.nlopt ];
    openssl = [ pkgs.openssl ];
    outbreaker = [ pkgs.gsl ];
    pbdMPI = [ pkgs.openmpi ];
    pbdNCDF4 = [ pkgs.netcdf ];
    pbdPROF = [ pkgs.openmpi ];
    PKI = [ pkgs.openssl ];
    png = [ pkgs.libpng ];
    PopGenome = [ pkgs.zlib ];
    proj4 = [ pkgs.proj ];
    qtbase = [ pkgs.qt4 ];
    qtpaint = [ pkgs.qt4 ];
    R2GUESS = [ pkgs.gsl ];
    R2SWF = [ pkgs.zlib pkgs.libpng pkgs.freetype ];
    RAppArmor = [ pkgs.libapparmor ];
    rbamtools = [ pkgs.zlib ];
    RCA = [ pkgs.gmp ];
    rcdd = [ pkgs.gmp ];
    RcppCNPy = [ pkgs.zlib ];
    RcppGSL = [ pkgs.gsl ];
    RcppOctave = [ pkgs.zlib pkgs.bzip2 pkgs.icu pkgs.lzma pkgs.pcre pkgs.octave ];
    RcppZiggurat = [ pkgs.gsl ];
    rgdal = [ pkgs.proj pkgs.gdal ];
    rgeos = [ pkgs.geos ];
    rgl = [ pkgs.mesa pkgs.x11 ];
    Rglpk = [ pkgs.glpk ];
    rggobi = [ pkgs.ggobi pkgs.gtk2 pkgs.libxml2 ];
    RGtk2 = [ pkgs.gtk2 ];
    Rhpc = [ pkgs.zlib pkgs.bzip2 pkgs.icu pkgs.lzma pkgs.openmpi pkgs.pcre ];
    ridge = [ pkgs.gsl ];
    RJaCGH = [ pkgs.zlib ];
    rjags = [ pkgs.jags ];
    rJava = [ pkgs.zlib pkgs.bzip2 pkgs.icu pkgs.lzma pkgs.pcre pkgs.jdk pkgs.libzip ];
    Rlibeemd = [ pkgs.gsl ];
    rmatio = [ pkgs.zlib ];
    Rmpfr = [ pkgs.gmp pkgs.mpfr ];
    Rmpi = [ pkgs.openmpi ];
    RMySQL = [ pkgs.zlib pkgs.mysql.lib ];
    RNetCDF = [ pkgs.netcdf pkgs.udunits ];
    RODBCext = [ pkgs.libiodbc ];
    RODBC = [ pkgs.libiodbc ];
    rpg = [ pkgs.postgresql ];
    rphast = [ pkgs.pcre pkgs.zlib pkgs.bzip2 pkgs.gzip pkgs.readline ];
    Rpoppler = [ pkgs.poppler ];
    RPostgreSQL = [ pkgs.postgresql ];
    RProtoBuf = [ pkgs.protobuf ];
    rpud = [ pkgs.linuxPackages.nvidia_x11 ];
    rPython = [ pkgs.python ];
    RSclient = [ pkgs.openssl ];
    Rserve = [ pkgs.openssl ];
    Rssa = [ pkgs.fftw ];
    rtfbs = [ pkgs.zlib pkgs.pcre pkgs.bzip2 pkgs.gzip pkgs.readline ];
    rtiff = [ pkgs.libtiff ];
    runjags = [ pkgs.jags ];
    RVowpalWabbit = [ pkgs.zlib pkgs.boost ];
    rzmq = [ pkgs.zeromq3 ];
    SAVE = [ pkgs.zlib pkgs.bzip2 pkgs.icu pkgs.lzma pkgs.pcre ];
    sdcTable = [ pkgs.gmp pkgs.glpk ];
    seewave = [ pkgs.fftw pkgs.libsndfile ];
    SemiCompRisks = [ pkgs.gsl ];
    seqinr = [ pkgs.zlib ];
    seqminer = [ pkgs.zlib pkgs.bzip2 ];
    showtext = [ pkgs.zlib pkgs.libpng pkgs.icu pkgs.freetype ];
    simplexreg = [ pkgs.gsl ];
    SOD = [ pkgs.cudatoolkit ]; # requres CL/cl.h
    spate = [ pkgs.fftw ];
    sprint = [ pkgs.openmpi ];
    ssanv = [ pkgs.proj ];
    stsm = [ pkgs.gsl ];
    survSNP = [ pkgs.gsl ];
    sysfonts = [ pkgs.zlib pkgs.libpng pkgs.freetype ];
    TAQMNGR = [ pkgs.zlib ];
    tiff = [ pkgs.libtiff ];
    TKF = [ pkgs.gsl ];
    tkrplot = [ pkgs.xlibs.libX11 ];
    topicmodels = [ pkgs.gsl ];
    udunits2 = [ pkgs.udunits pkgs.expat ];
    V8 = [ pkgs.v8 ];
    VBLPCM = [ pkgs.gsl ];
    VBmix = [ pkgs.gsl pkgs.fftw pkgs.qt4 ];
    WhopGenome = [ pkgs.zlib ];
    XBRL = [ pkgs.zlib pkgs.libxml2 ];
    XML = [ pkgs.libtool pkgs.libxml2 pkgs.xmlsec pkgs.libxslt ];
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
    rggobi = [ pkgs.pkgconfig ];
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
    "PKgraph"
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
    "sprint" # tries to run MPI processes
    "pbdMPI" # tries to run MPI processes
  ];

  # Packages which cannot be installed due to lack of dependencies or other reasons.
  brokenPackages = [
    "abd" # requires nlopt
    "ACNE" # requires aroma_affymetrix
    "Actigraphy" # SDMTools.so: undefined symbol: X
    "adabag" # requires nlopt
    "adaptsmoFMRI" # requires spatstat
    "ads" # requires spatstat
    "AER" # REQUIRES NLOPT
    "afex" # requires nlopt
    "agRee" # requires nlopt
    "agridat" # requires pcaMethods
    "aLFQ" # requires protiq
    "alr3" # requires nlopt
    "alr4" # requires nlopt
    "anacor" # requires nlopt
    "AntWeb" # requires leafletR
    "aods3" # requires nlopt
    "aoristic" # requires spatstat
    "apmsWAPP" # requires genefilter, Biobase, multtest, edgeR, DESeq, and aroma.light
    "apt" # requires nlopt
    "ArfimaMLM" # Requires Nlopt
    "arm" # requires nlopt
    "aroma_affymetrix" # requires aroma_core
    "aroma_cn" # requires PSCBS
    "aroma_core" # requires PSCBS
    "ArrayBin" # requires SAGx
    "ARTool" # Requires Nlopt
    "babel" # requires edgeR
    "BACA" # requires RDAVIDWebService
    "backShift" # requires pcalg to build
    "bartMachine" # requires nlopt
    "bayesDem" # requires nlopt
    "bayesLife" # requires nlopt
    "bayesPop" # requires nlopt
    "Bayesthresh" # Requires Nlopt
    "BBRecapture" # Requires Nlopt
    "BCA" # REQUIRES NLOPT
    "BcDiag" # requires fabia
    "bdvis" # requres taxize
    "beadarrayFilter" # requires beadarray
    "beadarrayMSV" # requires Biobase, geneplotter, andlimma
    "bgmm" # requires nlopt
    "BIFIEsurvey" # requires DiagrammeR to build
    "bigGP" # requires MPI running. HELP WANTED!
    "bigpca" # requires NCmisc
    "BiodiversityR" # Requires Nlopt
    "Biograph" # requires mvna
    "biotools" # requires rpanel
    "BiSEp" # requires GOSemSim, GO.db, and org.Hs.eg.db
    "BLCOP" # depends on broken fPortfolio
    "blmeco" # requires nlopt
    "blme" # requires nlopt
    "bmd" # requires nlopt
    "bmem" # requires DiagrammeR to build
    "bmrm" # requires clpAPI
    "bootnet" # requires IsingFit
    "boss" # requires nlopt
    "BradleyTerry2" # Requires Nlopt
    "branchLars" # requires Rgraphviz
    "BRugs" # requires OpenBUGS
    "CADFtest" # Requires Nlopt
    "cAIC4" # requires nlopt
    "calmate" # requires aroma_core
    "candisc" # requires nlopt
    "carcass" # requires nlopt
    "caretEnsemble" # requires nlopt
    "caret" # requires nlopt
    "CARrampsOcl" # depends on OpenCL
    "car" # requires nlopt
    "CCpop" # Requires Nlopt
    "ChainLadder" # Requires Nlopt
    "CHAT" # requires DNAcopy
    "ChemoSpec" # depends on broken speaq
    "classGraph" # requires graph, and Rgraphviz
    "climwin" # requires nlopt
    "CLME" # REQUIRES NLOPT
    "clpAPI" # requires clp
    "clusterPower" # requires nlopt
    "compendiumdb" # requires Biobase
    "conformal" # requires nlopt
    "corHMM" # requires nlopt
    "CORM" # requires limma
    "CosmoPhotoz" # Requires Nlopt
    "cp4p" # build is broken
    "cplexAPI" # requires CPLEX
    "crmn" # requires pcaMethods, and Biobase
    "Crossover" # fails self-test
    "CrypticIBDcheck" # requires rJPSGCS
    "cudaBayesreg" # requres Rmath
    "curvHDR" # requires flowCore
    "D2C" # requires gRbase
    "DAAGbio" # requires limma
    "daff" # requires V8 to build
    "dagbag" # requires Rlapack
    "DAMisc" # Requires Nlopt
    "DBKGrad" # requires SDD
    "dbmss" # requires spatstat
    "DCGL" # requires limma
    "dcGOR" # requires dnet
    "DeducerExtras" # Requires Nlopt
    "DeducerPlugInExample" # Requires Nlopt
    "DeducerPlugInScaling" # Requires Nlopt
    "Deducer" # Requires Nlopt
    "DeducerSpatial" # Requires Nlopt
    "DeducerSurvival" # Requires Nlopt
    "DeducerText" # Requires Nlopt
    "demi" # requires affy, affxparser, and oligo
    "DepthProc" # requires samr
    "DiagrammeR" # requires V8 to build
    "DiagTest3Grp" # Requires Nlopt
    "DiffCorr" # misses undeclared dependencies 'pcaMethods', 'multtest'
    "difR" # requires nlopt
    "Digiroo2" # requires spatstat
    "discSurv" # requires nlopt
    "DistatisR" # Requires Nlopt
    "diveRsity" # requires DiagrammeR to build
    "dixon" # requires spatstat
    "dnet" # requires supraHex, graph, Rgraphviz, and Biobase
    "doMPI" # requires MPI running. HELP WANTED!
    "dpa" # requires DiagrammeR to build
    "dpcR" # requires spatstat
    "drc" # requires nlopt
    "drfit" # requires nlopt
    "drsmooth" # requires nlopt
    "DSpat" # requires spatstat
    "dynlm" # requires nlopt
    "easyanova" # requires nlopt
    "ecespa" # requires spatstat
    "ecoengine" # requires leafletR
    "ecospat" # requires spatstat
    "edgeRun" # requires edgeR
    "eeptools" # requires nlopt
    "EffectLiteR" # Requires Nlopt
    "effects" # requires nlopt
    "EMA" # requires siggenes, affy, multtest, gcrma, biomaRt, and AnnotationDbi
    "empiricalFDR_DESeq2" # requires DESeq2, and GenomicRanges
    "EnQuireR" # Requires Nlopt
    "episplineDensity" # requires nlopt
    "epoc" # requires graph, and Rgraphviz
    "epr" # requires nlopt
    "erer" # requires nlopt
    "erpR" # requires rpanel
    "ETAS" # requires spatstat
    "eulerian" # requires graph
    "evobiR" # requres taxiz
    "evora" # requires qvalue
    "ExomeDepth" # requires GenomicRanges, and Rsamtools
    "extRemes" # requires nlopt
    "ez" # requires nlopt
    "FactoMineR" # Requires Nlopt
    "Factoshiny" # Requires Nlopt
    "FAMT" # requires impute
    "faoutlier" # requires DiagrammeR to build
    "fastR" # requires nlopt
    "fdrDiscreteNull" # requires edgeR
    "FDRreg" # Requires Nlopt
    "FHtest" # requires interval
    "flexCWM" # depends on broken mixture
    "fPortfolio" # requires rneos
    "freqweights" # requires nlopt
    "fscaret" # requires nlopt
    "FunctionalNetworks" # requires breastCancerVDX, and Biobase
    "fxregime" # requires nlopt
    "gamclass" # requires nlopt
    "gamlss_demo" # requires rpanel
    "gamm4" # requires nlopt
    "gcmr" # requires nlopt
    "GDAtools" # Requires Nlopt
    "GeneticTools" # requires snpStats
    "genridge" # requires nlopt
    "geojsonio" # requires V8 to build
    "GExMap" # requires Biobase and multtest
    "gimme" # requires DiagrammeR to build
    "gitter" # requires EBImage
    "glmgraph" # test suite says: "undefined symbol: dgemv_"
    "gmatrix" # depends on proprietary cudatoolkit
    "gMCP" # fails self-test
    "GOGANPA" # requires WGCNA
    "gplm" # requires nlopt
    "gputools" # depends on proprietary cudatoolkit
    "gRain" # requires gRbase
    "granova" # requires nlopt
    "gRapHD" # requires graph
    "graphicalVAR" # requires DiagrammeR to build
    "GraphPCA" # Requires Nlopt
    "gRbase" # requires RBGL, and graph
    "gRc" # requires gRbase
    "gridDebug" # requires gridGraphviz
    "gridGraphviz" # requires graph, and Rgraphviz
    "GriegSmith" # requires spatstat
    "gRim" # requires gRbase
    "GSAgm" # requires edgeR
    "GUIDE" # requires rpanel
    "GWAF" # REQUIRES NLOPT
    "h2o" # tries to download some h2o.jar during its build
    "h5" # depends on missing h5 system library
    "hasseDiagram" # requires Rgraphviz
    "hbsae" # requires nlopt
    "hddplot" # requires multtest
    "heplots" # requires nlopt
    "HH" # REQUIRES NLOPT
    "HierO" # requires rneos
    "HiPLARM" # requires MAGMA or PLASMA
    "HistDAWass" # Requires Nlopt
    "HLMdiag" # Requires Nlopt
    "hpoPlot" # requires Rgraphviz
    "hsdar" # fails to build
    "HTSCluster" # requires edgeR
    "hysteresis" # requires nlopt
    "IATscores" # requires DiagrammeR to build
    "ibd" # requires nlopt
    "iccbeta" # requires nlopt
    "iFes" # depends on proprietary cudatoolkit
    "imputeLCMD" # requires pcaMethods, and impute
    "imputeR" # requires nlopt
    "in2extRemes" # requires nlopt
    "incReg" # requires nlopt
    "inferference" # requires nlopt
    "influence_ME" # requires nlopt
    "intamapInteractive" # requires spatstat
    "interval" # requires Icens
    "ionflows" # requires Biostrings
    "iRefR" # requires graph, and RBGL
    "IsingFit" # requires DiagrammeR to build
    "IsoGene" # requires Biobase, and affy
    "isva" # requires qvalue
    "ivpack" # requires nlopt
    "JAGUAR" # REQUIRES NLOPT
    "jomo" # linking errors
    "js" # requires broken V8
    "KANT" # requires affy, and Biobase
    "ktspair" # requires Biobase
    "latticeDensity" # requires spatstat
    "lawn" # requires DiagrammeR to build
    "lawn" # requires V8 to build
    "leapp" # requires sva
    "learnstats" # requires nlopt
    "lefse" # SDMTools.so: undefined symbol: X
    "lessR" # requires nlopt
    "lfe" # fails to compile
    "lgcp" # requires rpanel
    "LinRegInteractive" # requires Rpanel
    "lme4" # requires nlopt
    "LMERConvenienceFunctions" # Requires Nlopt
    "lmerTest" # requires nlopt
    "lmSupport" # requires nlopt
    "LogisticDx" # requires gRbase
    "longpower" # requires nlopt
    "LOST" # requires pcaMethods
    "ltsk" # requires Rlapack and Rblas
    "MAMA" # requires metaMA
    "marked" # requires nlopt
    "MaxPro" # Requires Nlopt
    "mbest" # requires nlopt
    "meboot" # requires nlopt
    "MEET" # requires pcaMethods, and seqLogo
    "MEMSS" # REQUIRES NLOPT
    "metabolomics" # depends on broken crmn
    "MetaDE" # requires impute, and Biobase
    "metagear" # build is broken
    "MetaLandSim" # requires Biobase
    "metaMA" # requires limma
    "metaMix" # requires MPI running. HELP WANTED!
    "metaplus" # requires nlopt
    "metaSEM" # requires OpenMx
    "Metatron" # Requires Nlopt
    "mGSZ" # requires Biobase, and limma
    "miceadds" # requires DiagrammeR to build
    "micEconAids" # requires nlopt
    "micEconCES" # requires nlopt
    "micEconSNQP" # requires nlopt
    "MigClim" # SDMTools.So: Undefined Symbol: X
    "migui" # requires nlopt
    "minimist" # requires broken V8
    "mi" # requires nlopt
    "miRtest" # requires globaltest, GlobalAncova, and limma
    "missMDA" # requires nlopt
    "mixAK" # requires nlopt
    "MixGHD" # requires mixture to build
    "mixlm" # requires nlopt
    "MixMAP" # Requires Nlopt
    "mixture" # mixture.so: undefined symbol: dtrmm_
    "mlmRev" # requires nlopt
    "mlVAR" # requires DiagrammeR to build
    "MM2S" # BUILD IS BROKEN
    "moduleColor" # requires impute
    "mongolite" # doesn't find OpenSSL
    "mosaic" # requires nlopt
    "msarc" # requires AnnotationDbi
    "MSeasy" # requires mzR, and xcms
    "MSeasyTkGUI" # requires MSeasyTkGUI
    "MSIseq" # requires IRanges
    "msSurv" # requires graph
    "muir" # requires DiagrammeR to build
    "multiDimBio" # requires pcaMethods
    "MultiRR" # Requires Nlopt
    "muma" # requires nlopt
    "mutossGUI" # requires mutoss
    "mutoss" # requires multtest
    "mvinfluence" # requires nlopt
    "MXM" # depends on broken gRbase
    "NBPSeq" # requires qvalue
    "nCal" # requires nlopt
    "NCmisc" # requires BiocInstaller
    "netClass" # requires samr
    "nettools" # requires WGCNA
    "netweavers" # requires BiocGenerics, Biobase, and limma
    "NHPoisson" # Requires Nlopt
    "nloptr" # requires nlopt
    "NLPutils" # requires qdap
    "nonrandom" # requires nlopt
    "NORRRM" # can't load SDMTools properly
    "npIntFactRep" # requires nlopt
    "NSA" # requires aroma_core
    "OpenCL" # FIXME: requires CL/opencl.h
    "OpenMx" # Build Is Broken
    "optBiomarker" # requires rpanel
    "ora" # requires ROracle
    "ordBTL" # requires nlopt
    "orQA" # requires genefilter
    "OUwie" # Requires Nlopt
    "PairViz" # requires graph
    "pamm" # requires nlopt
    "PANDA" # requires GO.db
    "pander" # build is broken
    "panelAR" # requires nlopt
    "papeR" # requires nlopt
    "parboost" # requires nlopt
    "ParDNAcopy" # requires DNAcopy
    "parma" # requires nlopt
    "pathClass" # requires affy, and Biobase
    "PatternClass" # SDMTools.So: Undefined Symbol: X
    "pbdBASE" # requires pbdMPI
    "pbdDEMO" # requires pbdMPI
    "pbdDMAT" # requires pbdMPI
    "pbdSLAP" # requires pbdMPI
    "PBImisc" # Requires Nlopt
    "pbkrtest" # requires nlopt
    "PBSddesolve" # fails its test suite for unclear reasons
    "PBSmapping" # fails its test suite for unclear reasons
    "pcaL1" # requires clp
    "pcalg" # requires graph, and RBGL
    "PCGSE" # requires safe
    "PCS" # requires multtest
    "pedigreemm" # requires nlopt
    "pedometrics" # requires nlopt
    "PepPrep" # requires biomaRt
    "pequod" # requires nlopt
    "PerfMeas" # requires limma, graph, and RBGL
    "permGPU" # requires Biobase
    "phia" # requires nlopt
    "PhViD" # requires LBE
    "phylocurve" # requires nlopt
    "phyloTop" # requires nlopt
    "pi0" # requires qvalue
    "plmDE" # requires limma
    "plsRbeta" # requires nlopt
    "plsRcox" # requires survcomp
    "plsRglm" # requires nlopt
    "PMA" # requires impute
    "pmcgd" # depends on broken mixture
    "pmclust" # requires MPI running. HELP WANTED!
    "polyCub" # requires spatstat
    "polytomous" # requires nlopt
    "pomp" # requires nlopt
    "ppiPre" # requires AnnotationDbi, GOSemSim, GO.db
    "predictmeans" # requires nlopt
    "pRF" # requires multtest
    "prLogistic" # requires nlopt
    "propOverlap" # requires Biobase
    "protiq" # requires graph, and RBGL
    "PSAboot" # Requires Nlopt
    "PSCBS" # requires DNAcopy
    "pubmed_mineR" # requires SSOAP
    "PubMedWordcloud" # requires GOsummaries
    "qdap" # requires gender
    "qgraph" # requires DiagrammeR to build
    "qtbase" # build is broken
    "qtlnet" # requires pcalg
    "qtpaint" # can't find QtCore libraries
    "qtutils" # requires qtbase
    "QuACN" # requires graph, RBGL
    "quanteda" # fails to build
    "quantification" # requires nlopt
    "QuasiSeq" # requires edgeR
    "R2STATS" # REQUIRES NLOPT
    "RADami" # requires Biostrings
    "radiant" # requires nlopt
    "raincpc" # SDMTools.so: undefined symbol: X
    "rainfreq" # SDMTools.so: undefined symbol: X
    "RAM" # requires Heatplus
    "RapidPolygonLookup" # depends on broken PBSmapping
    "RAPIDR" # requires Biostrings, Rsamtools, and GenomicRanges
    "rasclass" # requires nlopt
    "RbioRXN" # requires fmcsR, and KEGGREST
    "RcmdrMisc" # Requires Nlopt
    "RcmdrPlugin_BCA" # Requires Nlopt
    "RcmdrPlugin_coin" # requires nlopt
    "RcmdrPlugin_depthTools" # requires nlopt
    "RcmdrPlugin_DoE" # Requires Nlopt
    "RcmdrPlugin_doex" # requires nlopt
    "RcmdrPlugin_EACSPIR" # Requires Nlopt
    "RcmdrPlugin_EBM" # Requires Nlopt
    "RcmdrPlugin_EcoVirtual" # Requires Nlopt
    "RcmdrPlugin_epack" # requires nlopt
    "RcmdrPlugin_EZR" # Requires Nlopt
    "RcmdrPlugin_FactoMineR" # Requires Nlopt
    "RcmdrPlugin_HH" # Requires Nlopt
    "RcmdrPlugin_IPSUR" # Requires Nlopt
    "RcmdrPlugin_KMggplot2" # Requires Nlopt
    "RcmdrPlugin_lfstat" # requires nlopt
    "RcmdrPlugin_MA" # Requires Nlopt
    "RcmdrPlugin_mosaic" # requires nlopt
    "RcmdrPlugin_MPAStats" # Requires Nlopt
    "RcmdrPlugin_NMBU" # Requires Nlopt
    "RcmdrPlugin_orloca" # requires nlopt
    "RcmdrPlugin_plotByGroup" # requires nlopt
    "RcmdrPlugin_pointG" # requires nlopt
    "RcmdrPlugin_qual" # requires nlopt
    "RcmdrPlugin_RMTCJags" # Requires Nlopt
    "RcmdrPlugin_ROC" # Requires Nlopt
    "RcmdrPlugin_sampling" # requires nlopt
    "RcmdrPlugin_SCDA" # Requires Nlopt
    "RcmdrPlugin_seeg" # requires seeg
    "RcmdrPlugin_SLC" # Requires Nlopt
    "RcmdrPlugin_SM" # Requires Nlopt
    "RcmdrPlugin_sos" # requires nlopt
    "RcmdrPlugin_StatisticalURV" # Requires Nlopt
    "RcmdrPlugin_steepness" # requires nlopt
    "RcmdrPlugin_survival" # requires nlopt
    "RcmdrPlugin_TeachingDemos" # Requires Nlopt
    "RcmdrPlugin_temis" # requires nlopt
    "RcmdrPlugin_UCA" # Requires Nlopt
    "Rcmdr" # Requires Nlopt
    "Rcplex" # requires cplexAPI
    "RcppAPT" # configure script depends on /bin/sh
    "RcppOctave" # Build Is Broken
    "RcppRedis" # requires Hiredis
    "rdd" # requires nlopt
    "rDEA" # no such file or directory
    "RDieHarder" # requires libdieharder
    "reader" # requires NCmisc
    "REBayes" # requires Rmosek
    "referenceIntervals" # requires nlopt
    "RefFreeEWAS" # requires isva
    "refund" # requires nlopt
    "REST" # REQUIRES NLOPT
    "retistruct" # depends on broken RImageJROI
    "rgbif" # requires V8 to build
    "rgp" # fails self-test
    "rgpui" # depends on broken rgp
    "RImageJROI" # requires spatstat
    "rjade" # requires V8 to build
    "rJPSGCS" # requires chopsticks
    "rLindo" # requires LINDO API
    "rmgarch" # requires nlopt
    "rminer" # requires nlopt
    "Rmosek" # requires mosek
    "RnavGraph" # requires graph, and RBGL
    "rneos" # requires XMLRPC
    "RNeXML" # requres taxize
    "RobLoxBioC" # requires Biobase
    "RobLox" # requires Biobase
    "robustlmm" # requires nlopt
    "rockchalk" # requires nlopt
    "RockFab" # requires EBImage
    "ROI_plugin_symphony" # depends on broken Rsymphony
    "ROracle" # requires OCI
    "rpanel" # I could not make Tcl to recognize BWidget. HELP WANTED!
    "rpubchem" # requires nlopt
    "RQuantLib" # requires QuantLib
    "rr" # requires nlopt
    "RSAP" # requires SAPNWRFCSDK
    "rscala" # build is broken
    "RSDA" # REQUIRES NLOPT
    "RSeed" # requires RBGL, and graph
    "rsig" # requires survcomp
    "RSNPset" # requires qvalue
    "Rsymphony" # FIXME: requires SYMPHONY
    "rugarch" # requires nlopt
    "RVAideMemoire" # Requires Nlopt
    "RVFam" # Requires Nlopt
    "RVideoPoker" # requires Rpanel
    "ryouready" # requires nlopt
    "rysgran" # requires soiltexture
    "sampleSelection" # requires nlopt
    "samr" # requires impute
    "sdcMicroGUI" # requires nlopt
    "sdcMicro" # requires nlopt
    "SDD" # requires rpanel
    "seeg" # requires spatstat
    "selectspm" # depends on broken ecespa
    "semdiag" # requires DiagrammeR to build
    "semGOF" # requires DiagrammeR to build
    "semiArtificial" # requires RSNNS
    "semPlot" # requires DiagrammeR to build
    "sem" # requires DiagrammeR to build
    "SensoMineR" # Requires Nlopt
    "SeqFeatR" # requires Biostrings, qvalue, and widgetTools
    "SeqGrapheR" # depends on Biostrings
    "sequenza" # requires copynumber
    "SGCS" # requires spatstat
    "siar" # requires spatstat
    "SID" # requires pcalg
    "SimRAD" # requires Biostrings, and ShortRead
    "SimSeq" # requires edgeR
    "siplab" # requires spatstat
    "sirt" # requires DiagrammeR to build
    "sjPlot" # requires nlopt
    "smart" # requires PMA
    "snpEnrichment" # requires snpStats
    "snplist" # requires biomaRt
    "snpStatsWriter" # requires snpStats
    "SNPtools" # requires IRanges, GenomicRanges, Biostrings, and Rsamtools
    "SOD" # depends on proprietary cudatoolkit
    "soilphysics" # requires rpanel
    "spacom" # requires nlopt
    "sparr" # requires spatstat
    "spatialsegregation" # requires spatstat
    "SpatialVx" # requires spatstat
    "speaq" # requires MassSpecWavelet
    "specificity" # requires nlopt
    "spocc" # requires leafletR
    "SQDA" # requires limma
    "ssizeRNA" # depends on missing 'Biobase', 'edgeR', 'limma', 'qvalue'
    "ssmrob" # requires nlopt
    "stagePop" # depends on broken PBSddesolve
    "statar" # depends on broken lfe
    "Statomica" # requires Biobase, multtest
    "stcm" # requires nlopt
    "stepp" # requires nlopt
    "stpp" # requires spatstat
    "structSSI" # requires multtest
    "strum" # requires Rgraphviz
    "superbiclust" # requires fabia
    "Surrogate" # Requires Nlopt
    "surveillance" # requires polyCub
    "survJamda" # depends on missing survcomp
    "swamp" # requires impute
    "switchr" # build is broken
    "switchrGist" # requires switchr
    "sybilSBML" # requires libSBML
    "systemfit" # requires nlopt
    "taxize" # requres bold
    "TcGSA" # requires multtest
    "TDMR" # REQUIRES NLOPT
    "tigerstats" # requires nlopt
    "timeSeq" # depends on missing edgeR
    "topologyGSA" # requires gRbase
    "TR8" # requres taxize
    "TriMatch" # Requires Nlopt
    "trip" # requires spatstat
    "TROM" # misses undeclared dependencies topGO', 'AnnotationDbi', 'GO.db'
    "ttScreening" # requires sva, and limma
    "userfriendlyscience" # requires nlopt
    "V8" # compilation error
    "VIMGUI" # REQUIRES NLOPT
    "VIM" # REQUIRES NLOPT
    "vmsbase" # depends on broken PBSmapping
    "vows" # requires rpanel
    "wfe" # requires nlopt
    "WGCNA" # requires impute
    "wgsea" # requires snpStats
    "WideLM" # depends on proprietary cudatoolkit
    "x_ent" # requires opencpu
    "xergm" # requires nlopt
    "xml2" # build is broken
    "ZeligMultilevel" # Requires Nlopt
    "zetadiv" # requires nlopt
    "zoib" # tarball is invalid on server
  ];

  otherOverrides = old: new: {
    xml2 = old.xml2.overrideDerivation (attrs: {
      preConfigure = ''
        export LIBXML_INCDIR=${pkgs.libxml2}/include/libxml2
        export LIBXML_LIBDIR=${pkgs.libxml2}/lib
      '';
    });

    curl = old.curl.overrideDerivation (attrs: {
      preConfigure = "export CURL_INCLUDES=${pkgs.curl}/include";
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
      PKG_LIBS = "-L${pkgs.openblasCompat}/lib -lopenblas";
    });

    qtbase = old.qtbase.overrideDerivation (attrs: {
      patches = [ ./patches/qtbase.patch ];
    });

    Rmpi = old.Rmpi.overrideDerivation (attrs: {
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
      LIBAPPARMOR_HOME = "${pkgs.libapparmor}";
    });

    RMySQL = old.RMySQL.overrideDerivation (attrs: {
      patches = [ ./patches/RMySQL.patch ];
      MYSQL_DIR="${pkgs.mysql.lib}";
    });

    devEMF = old.devEMF.overrideDerivation (attrs: {
      NIX_CFLAGS_LINK = "-L${pkgs.xlibs.libXft}/lib -lXft";
    });

    slfm = old.slfm.overrideDerivation (attrs: {
      PKG_LIBS = "-L${pkgs.openblasCompat}/lib -lopenblas";
    });

    SamplerCompare = old.SamplerCompare.overrideDerivation (attrs: {
      PKG_LIBS = "-L${pkgs.openblasCompat}/lib -lopenblas";
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
      buildInputs = (attrs.buildInputs or []) ++ [ pkgs.openblasCompat ];
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
