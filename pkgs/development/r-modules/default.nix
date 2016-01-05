/* This file defines the composition for CRAN (R) packages. */

# TODO: recommended package codetools for testing?

{ R, pkgs, overrides }:

let
  inherit (pkgs) fetchurl stdenv lib;

  buildRPackage = pkgs.callPackage ./generic-builder.nix { inherit R; };

  # Generates package templates given per-repository settings
  #
  # some packages, e.g. cncaGUI, require X running while installation,
  # so that we use xvfb-run if requireX is true.
  mkDerive = {mkHomepage, mkUrls}: lib.makeOverridable ({
        name, version, sha256,
        depends ? [],
        doCheck ? true,
        requireX ? false,
        broken ? false,
        hydraPlatforms ? R.meta.hydraPlatforms
      }: buildRPackage {
    name = "${name}-${version}";
    src = fetchurl {
      inherit sha256;
      urls = mkUrls { inherit name version; };
    };
    inherit doCheck requireX;
    propagatedBuildInputs = depends;
    nativeBuildInputs = depends;
    meta.homepage = mkHomepage name;
    meta.platforms = R.meta.platforms;
    meta.hydraPlatforms = hydraPlatforms;
    meta.broken = broken;
  });

  # Templates for generating Bioconductor, CRAN and IRkernel packages
  # from the name, version, sha256, and optional per-package arguments above
  #
  deriveBioc = mkDerive {
    mkHomepage = name: "http://www.bioconductor.org/packages/${name}.html";
    mkUrls = {name, version}: [ "mirror://bioc/bioc/src/contrib/${name}_${version}.tar.gz" ];
  };
  deriveBiocAnn = mkDerive {
    mkHomepage = name: "http://www.bioconductor.org/packages/${name}.html";
    mkUrls = {name, version}: [ "mirror://bioc/data/annotation/src/contrib/${name}_${version}.tar.gz" ];
  };
  deriveBiocExp = mkDerive {
    mkHomepage = name: "http://www.bioconductor.org/packages/${name}.html";
    mkUrls = {name, version}: [ "mirror://bioc/data/experiment/src/contrib/${name}_${version}.tar.gz" ];
  };
  deriveCran = mkDerive {
    mkHomepage = name: "http://bioconductor.org/packages/release/bioc/html/${name}.html";
    mkUrls = {name, version}: [
      "mirror://cran/src/contrib/${name}_${version}.tar.gz"
      "mirror://cran/src/contrib/00Archive/${name}/${name}_${version}.tar.gz"
    ];
  };
  deriveIRkernel = (mkDerive {
    mkHomepage = name: "http://irkernel.github.io/";
    mkUrls = {name, version}: [ "http://irkernel.github.io/src/contrib/${name}_${version}.tar.gz" ];
  }) {};

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
  _self = import ./bioc-packages.nix { inherit self; derive = deriveBioc; } //
          import ./bioc-annotation-packages.nix { inherit self; derive = deriveBiocAnn; } //
          import ./bioc-experiment-packages.nix { inherit self; derive = deriveBiocExp; } //
          import ./cran-packages.nix { inherit self; derive = deriveCran; } //
          import ./irkernel-packages.nix { inherit self; derive = deriveIRkernel; };

  # tweaks for the individual packages and "in self" follow

  packagesWithRDepends = {
    FactoMineR = [ self.car ];
    pander = [ self.codetools ];
  };

  # TODO: try to figure these out by zgrepping packages
  packagesWithNativeBuildInputs = {
    affyPLM = [ pkgs.zlib ];
    bamsignals = [ pkgs.zlib ];
    BitSeq = [ pkgs.zlib ];
    abn = [ pkgs.gsl_1 ];
    adimpro = [ pkgs.imagemagick ];
    audio = [ pkgs.portaudio ];
    BayesSAE = [ pkgs.gsl_1 ];
    BayesVarSel = [ pkgs.gsl_1 ];
    BayesXsrc = [ pkgs.readline pkgs.ncurses ];
    bigGP = [ pkgs.openmpi ];
    BiocCheck = [ pkgs.which ];
    Biostrings = [ pkgs.zlib ];
    DiffBind = [ pkgs.zlib ];
    ShortRead = [ pkgs.zlib ];
    oligo = [ pkgs.zlib ];
    gmapR = [ pkgs.zlib ];
    bnpmr = [ pkgs.gsl_1 ];
    BNSP = [ pkgs.gsl_1 ];
    cairoDevice = [ pkgs.gtk2 ];
    Cairo = [ pkgs.libtiff pkgs.libjpeg pkgs.cairo ];
    Cardinal = [ pkgs.which ];
    chebpol = [ pkgs.fftw ];
    ChemmineOB = [ pkgs.openbabel pkgs.pkgconfig ];
    cit = [ pkgs.gsl_1 ];
    curl = [ pkgs.curl ];
    devEMF = [ pkgs.xorg.libXft ];
    diversitree = [ pkgs.gsl_1 pkgs.fftw ];
    EMCluster = [ pkgs.liblapack ];
    fftw = [ pkgs.fftw ];
    fftwtools = [ pkgs.fftw ];
    Formula = [ pkgs.gmp ];
    geoCount = [ pkgs.gsl_1 ];
    git2r = [ pkgs.zlib pkgs.openssl ];
    GLAD = [ pkgs.gsl_1 ];
    glpkAPI = [ pkgs.gmp pkgs.glpk ];
    gmp = [ pkgs.gmp ];
    graphscan = [ pkgs.gsl_1 ];
    gsl = [ pkgs.gsl_1 ];
    HiCseg = [ pkgs.gsl_1 ];
    iBMQ = [ pkgs.gsl_1 ];
    igraph = [ pkgs.gmp ];
    JavaGD = [ pkgs.jdk ];
    jpeg = [ pkgs.libjpeg ];
    KFKSDS = [ pkgs.gsl_1 ];
    kza = [ pkgs.fftw ];
    libamtrack = [ pkgs.gsl_1 ];
    mixcat = [ pkgs.gsl_1 ];
    mvabund = [ pkgs.gsl_1 ];
    mwaved = [ pkgs.fftw ];
    ncdf4 = [ pkgs.netcdf ];
    ncdf = [ pkgs.netcdf ];
    nloptr = [ pkgs.nlopt ];
    openssl = [ pkgs.openssl ];
    outbreaker = [ pkgs.gsl_1 ];
    pander = [ pkgs.pandoc pkgs.which ];
    pbdMPI = [ pkgs.openmpi ];
    pbdNCDF4 = [ pkgs.netcdf ];
    pbdPROF = [ pkgs.openmpi ];
    PKI = [ pkgs.openssl ];
    png = [ pkgs.libpng ];
    PopGenome = [ pkgs.zlib ];
    proj4 = [ pkgs.proj ];
    qtbase = [ pkgs.qt4 ];
    qtpaint = [ pkgs.qt4 ];
    R2GUESS = [ pkgs.gsl_1 ];
    R2SWF = [ pkgs.zlib pkgs.libpng pkgs.freetype ];
    RAppArmor = [ pkgs.libapparmor ];
    rapportools = [ pkgs.which ];
    rapport = [ pkgs.which ];
    rbamtools = [ pkgs.zlib ];
    rcdd = [ pkgs.gmp ];
    RcppCNPy = [ pkgs.zlib ];
    RcppGSL = [ pkgs.gsl_1 ];
    RcppOctave = [ pkgs.zlib pkgs.bzip2 pkgs.icu pkgs.lzma pkgs.pcre pkgs.octave ];
    RcppZiggurat = [ pkgs.gsl_1 ];
    rgdal = [ pkgs.proj pkgs.gdal ];
    rgeos = [ pkgs.geos ];
    rggobi = [ pkgs.ggobi pkgs.gtk2 pkgs.libxml2 ];
    rgl = [ pkgs.mesa pkgs.xlibsWrapper ];
    Rglpk = [ pkgs.glpk ];
    RGtk2 = [ pkgs.gtk2 ];
    Rhpc = [ pkgs.zlib pkgs.bzip2 pkgs.icu pkgs.lzma pkgs.openmpi pkgs.pcre ];
    Rhtslib = [ pkgs.zlib ];
    RJaCGH = [ pkgs.zlib ];
    rjags = [ pkgs.jags ];
    rJava = [ pkgs.zlib pkgs.bzip2 pkgs.icu pkgs.lzma pkgs.pcre pkgs.jdk pkgs.libzip ];
    Rlibeemd = [ pkgs.gsl_1 ];
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
    rPython = [ pkgs.python ];
    RSclient = [ pkgs.openssl ];
    Rserve = [ pkgs.openssl ];
    Rssa = [ pkgs.fftw ];
    Rsubread = [ pkgs.zlib ];
    rtfbs = [ pkgs.zlib pkgs.pcre pkgs.bzip2 pkgs.gzip pkgs.readline ];
    rtiff = [ pkgs.libtiff ];
    runjags = [ pkgs.jags ];
    RVowpalWabbit = [ pkgs.zlib pkgs.boost ];
    rzmq = [ pkgs.zeromq3 ];
    SAVE = [ pkgs.zlib pkgs.bzip2 pkgs.icu pkgs.lzma pkgs.pcre ];
    sdcTable = [ pkgs.gmp pkgs.glpk ];
    seewave = [ pkgs.fftw pkgs.libsndfile ];
    SemiCompRisks = [ pkgs.gsl_1 ];
    seqinr = [ pkgs.zlib ];
    seqminer = [ pkgs.zlib pkgs.bzip2 ];
    showtext = [ pkgs.zlib pkgs.libpng pkgs.icu pkgs.freetype ];
    simplexreg = [ pkgs.gsl_1 ];
    SOD = [ pkgs.cudatoolkit ]; # requres CL/cl.h
    spate = [ pkgs.fftw ];
    sprint = [ pkgs.openmpi ];
    ssanv = [ pkgs.proj ];
    stsm = [ pkgs.gsl_1 ];
    stringi = [ pkgs.icu ];
    survSNP = [ pkgs.gsl_1 ];
    sysfonts = [ pkgs.zlib pkgs.libpng pkgs.freetype ];
    TAQMNGR = [ pkgs.zlib ];
    tiff = [ pkgs.libtiff ];
    TKF = [ pkgs.gsl_1 ];
    tkrplot = [ pkgs.xorg.libX11 ];
    topicmodels = [ pkgs.gsl_1 ];
    udunits2 = [ pkgs.udunits pkgs.expat ];
    V8 = [ pkgs.v8 ];
    VBLPCM = [ pkgs.gsl_1 ];
    VBmix = [ pkgs.gsl_1 pkgs.fftw pkgs.qt4 ];
    WhopGenome = [ pkgs.zlib ];
    XBRL = [ pkgs.zlib pkgs.libxml2 ];
    xml2 = [ pkgs.libxml2 ];
    XML = [ pkgs.libtool pkgs.libxml2 pkgs.xmlsec pkgs.libxslt ];
    XVector = [ pkgs.zlib ];
    Rsamtools = [ pkgs.zlib ];
    rtracklayer = [ pkgs.zlib ];
    affyio = [ pkgs.zlib ];
    VariantAnnotation = [ pkgs.zlib ];
    snpStats = [ pkgs.zlib ];
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
    gridGraphics = [ pkgs.which ];
    gputools = [ pkgs.which pkgs.cudatoolkit ];
    adimpro = [ pkgs.which pkgs.xorg.xdpyinfo ];
    PET = [ pkgs.which pkgs.xorg.xdpyinfo pkgs.imagemagick ];
    dti = [ pkgs.which pkgs.xorg.xdpyinfo pkgs.imagemagick ];
  };

  packagesRequireingX = [
    "accrual"
    "ade4TkGUI"
    "adehabitat"
    "analogue"
    "analogueExtra"
    "AnalyzeFMRI"
    "AnnotLists"
    "AnthropMMD"
    "aplpack"
    "aqfig"
    "arf3DS4"
    "asbio"
    "AtelieR"
    "BAT"
    "bayesDem"
    "BCA"
    "BEQI2"
    "betapart"
    "betaper"
    "BiodiversityR"
    "BioGeoBEARS"
    "bio_infer"
    "bipartite"
    "biplotbootGUI"
    "blender"
    "cairoDevice"
    "CCTpack"
    "cncaGUI"
    "cocorresp"
    "CommunityCorrelogram"
    "confidence"
    "constrainedKriging"
    "ConvergenceConcepts"
    "cpa"
    "DALY"
    "dave"
    "debug"
    "Deducer"
    "DeducerExtras"
    "DeducerPlugInExample"
    "DeducerPlugInScaling"
    "DeducerSpatial"
    "DeducerSurvival"
    "DeducerText"
    "Demerelate"
    "DescTools"
    "detrendeR"
    "dgmb"
    "DivMelt"
    "dpa"
    "DSpat"
    "dynamicGraph"
    "dynBiplotGUI"
    "EasyqpcR"
    "EcoVirtual"
    "ENiRG"
    "EnQuireR"
    "eVenn"
    "exactLoglinTest"
    "FAiR"
    "fat2Lpoly"
    "fbati"
    "FD"
    "feature"
    "FeedbackTS"
    "FFD"
    "fgui"
    "fisheyeR"
    "fit4NM"
    "forams"
    "forensim"
    "FreeSortR"
    "fscaret"
    "fSRM"
    "gcmr"
    "Geneland"
    "GeoGenetix"
    "geomorph"
    "geoR"
    "geoRglm"
    "georob"
    "GeoXp"
    "GGEBiplotGUI"
    "gnm"
    "GPCSIV"
    "GrammR"
    "GrapheR"
    "GroupSeq"
    "gsubfn"
    "GUniFrac"
    "gWidgets2RGtk2"
    "gWidgets2tcltk"
    "gWidgetsRGtk2"
    "gWidgetstcltk"
    "HH"
    "HiveR"
    "HomoPolymer"
    "iBUGS"
    "ic50"
    "iDynoR"
    "in2extRemes"
    "iplots"
    "isopam"
    "IsotopeR"
    "JGR"
    "KappaGUI"
    "likeLTD"
    "logmult"
    "LS2Wstat"
    "MAR1"
    "MareyMap"
    "memgene"
    "MergeGUI"
    "metacom"
    "Meth27QC"
    "MetSizeR"
    "MicroStrategyR"
    "migui"
    "miniGUI"
    "MissingDataGUI"
    "mixsep"
    "mlDNA"
    "MplusAutomation"
    "mpmcorrelogram"
    "mritc"
    "MTurkR"
    "multgee"
    "multibiplotGUI"
    "nodiv"
    "OligoSpecificitySystem"
    "onemap"
    "OpenRepGrid"
    "palaeoSig"
    "paleoMAS"
    "pbatR"
    "PBSadmb"
    "PBSmodelling"
    "PCPS"
    "pez"
    "phylotools"
    "picante"
    "PKgraph"
    "playwith"
    "plotSEMM"
    "plsRbeta"
    "plsRglm"
    "pmg"
    "PopGenReport"
    "poppr"
    "powerpkg"
    "PredictABEL"
    "prefmod"
    "PrevMap"
    "ProbForecastGOP"
    "QCAGUI"
    "qtbase"
    "qtpaint"
    "qtutils"
    "R2STATS"
    "r4ss"
    "RandomFields"
    "rareNMtests"
    "rAverage"
    "Rcmdr"
    "RcmdrPlugin_BCA"
    "RcmdrPlugin_coin"
    "RcmdrPlugin_depthTools"
    "RcmdrPlugin_DoE"
    "RcmdrPlugin_doex"
    "RcmdrPlugin_EACSPIR"
    "RcmdrPlugin_EBM"
    "RcmdrPlugin_EcoVirtual"
    "RcmdrPlugin_epack"
    "RcmdrPlugin_EZR"
    "RcmdrPlugin_FactoMineR"
    "RcmdrPlugin_HH"
    "RcmdrPlugin_IPSUR"
    "RcmdrPlugin_KMggplot2"
    "RcmdrPlugin_lfstat"
    "RcmdrPlugin_MA"
    "RcmdrPlugin_mosaic"
    "RcmdrPlugin_MPAStats"
    "RcmdrPlugin_orloca"
    "RcmdrPlugin_plotByGroup"
    "RcmdrPlugin_pointG"
    "RcmdrPlugin_qual"
    "RcmdrPlugin_ROC"
    "RcmdrPlugin_sampling"
    "RcmdrPlugin_SCDA"
    "RcmdrPlugin_SLC"
    "RcmdrPlugin_SM"
    "RcmdrPlugin_sos"
    "RcmdrPlugin_steepness"
    "RcmdrPlugin_survival"
    "RcmdrPlugin_TeachingDemos"
    "RcmdrPlugin_temis"
    "RcmdrPlugin_UCA"
    "recluster"
    "relax"
    "relimp"
    "RenextGUI"
    "reportRx"
    "reshapeGUI"
    "rgl"
    "RHRV"
    "rich"
    "rioja"
    "ripa"
    "rite"
    "rnbn"
    "RNCEP"
    "RQDA"
    "RSDA"
    "rsgcc"
    "RSurvey"
    "RunuranGUI"
    "sdcMicroGUI"
    "sharpshootR"
    "simba"
    "Simile"
    "SimpleTable"
    "SOLOMON"
    "soundecology"
    "SPACECAP"
    "spacodiR"
    "spatsurv"
    "sqldf"
    "SRRS"
    "SSDforR"
    "statcheck"
    "StatDA"
    "STEPCAM"
    "stosim"
    "strvalidator"
    "stylo"
    "svDialogstcltk"
    "svIDE"
    "svSocket"
    "svWidgets"
    "SYNCSA"
    "SyNet"
    "tcltk2"
    "TDMR"
    "TED"
    "TestScorer"
    "TIMP"
    "titan"
    "tkrgl"
    "tkrplot"
    "tmap"
    "tspmeta"
    "TTAinterfaceTrendAnalysis"
    "twiddler"
    "vcdExtra"
    "VecStatGraphs3D"
    "vegan"
    "vegan3d"
    "vegclust"
    "VIMGUI"
    "WMCapacity"
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
    "graphscan" # broken build
    "metaheur" # depends on broken package nloptr
    "vmsbase" # broken build
    "fds" # broken build
    "BubbleTree" # broken build
    "AER" # depends on broken package nloptr
    "ARRmNormalization" # broken build
    "ART" # depends on broken package ar-car-2.1-0
    "ARTool" # depends on broken package nlopt-2.4.2
    "Actigraphy" # Build Is Broken
    "AgiMicroRna" # depends on broken package affycoretools
    "AmpAffyExample" # broken build
    "AnnotationForge" # broken build
    "ArfimaMLM" # depends on broken package nlopt-2.4.2
    "ArrayExpressHTS" # broken build
    "AshkenazimSonChr21" # broken build
    "AssetPricing" # depends on broken package polynom
    "AtelieR" # depends on broken package polynom
    "AutoModel" # depends on broken package r-car-2.1-0
    "BACA" # depends on broken package AnnotationForge
    "BAGS" # broken build
    "BANOVA" # broken build
    "BBRecapture" # depends on broken package nlopt-2.4.2
    "BCA" # depends on broken package nloptr
    "BEST" # depends on broken package jagsUI
    "BIFIEsurvey" # depends on broken package nlopt-2.4.2
    "BLCOP" # depends on broken package fPortfolio
    "BRugs" # build is broken
    "BSgenome_Amellifera_UCSC_apiMel2_masked" # broken build
    "BSgenome_Dmelanogaster_UCSC_dm2_masked" # broken build
    "BSgenome_Dmelanogaster_UCSC_dm3_masked" # broken build
    "BSgenome_Ecoli_NCBI_20080805" # broken build
    "BSgenome_Gaculeatus_UCSC_gasAcu1_masked" # broken build
    "BTSPAS" # broken build
    "Basic4Cseq" # broken build
    "BaySIC" # broken build
    "BayesMed" # depends on broken package R2jags
    "Bayesthresh" # depends on broken package nlopt-2.4.2
    "BiGGR" # broken build
    "BiodiversityR" # depends on broken package nlopt-2.4.2
    "BradleyTerry2" # depends on broken package nlopt-2.4.2
    "BrailleR" # broken build
    "CADFtest" # depends on broken package nlopt-2.4.2
    "CAFE" # broken build
    "CALIB" # broken build
    "CAMERA" # depends on broken package xcms
    "CARrampsOcl" # broken build
    "CCTpack" # depends on broken package R2jags
    "CCpop" # depends on broken package nlopt-2.4.2
    "CLME" # depends on broken package nlopt-2.4.2
    "CNEr" # broken build
    "CNORfuzzy" # depends on broken package nlopt-2.4.2
    "CNVPanelizer" # depends on broken cn.mops-1.15.1
    "Causata" # broken build
    "ChIPComp" # depends on broken package r-Rsamtools-1.21.18
    "ChIPQC" # depends on broken package AnnotationForge
    "ChIPXpress" # broken build
    "ChIPseeker" # broken build
    "ChainLadder" # depends on broken package nlopt-2.4.2
    "ChemmineDrugs" # broken build
    "ChemmineR" # broken build
    "ClustGeo" # depends on broken FactoMineR-1.31.3
    "ClustGeo" # depends on broken package car
    "CoCiteStats" # broken build
    "CompGO" # depends on broken package AnnotationForge
    "CopulaDTA" # broken build
    "CosmoPhotoz" # depends on broken package nlopt-2.4.2
    "CrypticIBDcheck" # depends on broken package nlopt-2.4.2
    "DAMisc" # depends on broken package nlopt-2.4.2
    "DAPAR" # depends on broken package MSnbase
    "DBKGrad" # depends on broken package SDD
    "DJL" # depends on broken package car
    "DMRcate" # broken build
    "DMRcatedata" # broken build
    "DOSE" # broken build
    "Deducer" # depends on broken package car
    "DeducerExtras" # depends on broken package nlopt-2.4.2
    "DeducerPlugInExample" # depends on broken package nlopt-2.4.2
    "DeducerPlugInScaling" # depends on broken package nlopt-2.4.2
    "DeducerSpatial" # depends on broken package nlopt-2.4.2
    "DeducerSurvival" # depends on broken package nlopt-2.4.2
    "DeducerText" # depends on broken package nlopt-2.4.2
    "DiagTest3Grp" # depends on broken package nlopt-2.4.2
    "DiffBind" # depends on broken package AnnotationForge
    "DirichletMultinomial" # broken build
    "DistatisR" # depends on broken package nlopt-2.4.2
    "DmelSGI" # broken build
    "ELMER" # broken build
    "EMA" # depends on broken package nlopt-2.4.2
    "ESKNN" # depends on broken package r-caret-6.0-52
    "EffectLiteR" # depends on broken package nlopt-2.4.2
    "EnQuireR" # depends on broken package nlopt-2.4.2
    "EnrichmentBrowser" # depends on broken package r-EDASeq-2.3.2
    "FDRreg" # depends on broken package nlopt-2.4.2
    "FEM" # broken build
    "FSA" # depends on broken package car
    "FactoMineR" # depends on broken package car
    "Factoshiny" # depends on broken package nlopt-2.4.2
    "FlowSOM" # depends on broken package flowCore
    "FunciSNP_data" # broken build
    "FunctionalNetworks" # broken build
    "GDAtools" # depends on broken package nlopt-2.4.2
    "GEOsearch" # broken build
    "GEWIST" # depends on broken package nlopt-2.4.2
    "GGHumanMethCancerPanelv1_db" # depends on broken package AnnotationForge
    "GOstats" # depends on broken package AnnotationForge
    "GPC" # broken build
    "GSVAdata" # broken build
    "GUIProfiler" # broken build
    "GWAF" # depends on broken package nlopt-2.4.2
    "GraphPAC" # depends on broken package RMallow
    "GraphPCA" # depends on broken package nlopt-2.4.2
    "HLMdiag" # depends on broken package nlopt-2.4.2
    "HSMMSingleCell" # broken build
    "HiCDataLymphoblast" # broken build
    "HiPLARM" # Build Is Broken
    "HierO" # Build Is Broken
    "HilbertVisGUI" # Build Is Broken
    "HistDAWass" # depends on broken package nlopt-2.4.2
    "Hs6UG171_db" # broken build
    "HsAgilentDesign026652_db" # broken build
    "HuO22_db" # broken build
    "HydeNet" # broken build
    "IATscores" # depends on broken package nlopt-2.4.2
    "INSPEcT" # depends on broken GenomicFeatures-1.21.13
    "IONiseR" # depends on broken rhdf5-2.13.4
    "ITALICS" # broken build
    "ITEMAN" # depends on broken package car
    "IVAS" # depends on broken package nlopt-2.4.2
    "IlluminaHumanMethylation27k_db" # broken build
    "IlluminaHumanMethylation450k_db" # broken build
    "JAGUAR" # depends on broken package nlopt-2.4.2
    "JazaeriMetaData_db" # broken build
    "LANDD" # depends on broken package AnnotationForge
    "LAPOINTE_db" # broken build
    "LMERConvenienceFunctions" # depends on broken package nlopt-2.4.2
    "LOGIT" # depends on broken package car
    "LOST" # broken build
    "LiquidAssociation" # broken build
    "LogisticDx" # depends on broken package nlopt-2.4.2
    "LowMACA" # depends on broken package motifStack
    "MAIT" # depends on broken package CAMERA
    "MAQCsubsetILM" # broken build
    "MBmca" # depends on broken nloptr-1.0.4
    "MBmca" # depends on broken package chipPCR
    "MCRestimate" # depends on broken package golubEsets
    "MEAL" # depends on broken package DMRcate
    "MEDME" # depends on broken package nlopt-2.4.2
    "MEMSS" # depends on broken package nlopt-2.4.2
    "MLSeq" # depends on broken package nlopt-2.4.2
    "MMDiff" # depends on broken package AnnotationForge
    "MRIaggr" # broken build
    "MSnID" # depends on broken package MSnbase
    "MSnbase" # broken build
    "MSstats" # depends on broken package nlopt-2.4.2
    "MatrixRider" # depends on broken package CNEr
    "MaxPro" # depends on broken package nlopt-2.4.2
    "MazamaSpatialUtils" # broken build
    "MeSH_Aca_eg_db" # broken build
    "MeSH_Bsu_TUB10_eg_db" # broken build
    "MeSH_Cal_SC5314_eg_db" # broken build
    "MeSH_Cfa_eg_db" # broken build
    "MeSH_Dse_eg_db" # broken build
    "MeSH_Eco_55989_eg_db" # broken build
    "MeSH_Eco_HS_eg_db" # broken build
    "MeSH_Eco_IAI1_eg_db" # broken build
    "MeSH_Eco_O157_H7_EDL933_eg_db" # broken build
    "MeSH_Mtr_eg_db" # broken build
    "Metatron" # depends on broken package nlopt-2.4.2
    "MethylAidData" # broken build
    "MigClim" # Build Is Broken
    "MineICA" # depends on broken package AnnotationForge
    "MixMAP" # depends on broken package nlopt-2.4.2
    "MmAgilentDesign026655_db" # broken build
    "Mu15v1_db" # broken build
    "Mu22v3_db" # broken build
    "MultiRR" # depends on broken package nlopt-2.4.2
    "NGScopy"
    "NHPoisson" # depends on broken package nlopt-2.4.2
    "NORRRM" # build is broken
    "NSM3" # broken build
    "NanoStringQCPro" # broken build
    "Norway981_db" # broken build
    "OUwie" # depends on broken package nlopt-2.4.2
    "OmicsMarkeR" # depends on broken package nlopt-2.4.2
    "OperonHumanV3_db" # broken build
    "PADOG" # build is broken
    "PANDA" # broken build
    "PBD" # broken build
    "PBImisc" # depends on broken package nlopt-2.4.2
    "PCpheno" # depends on broken package apComplex
    "PFAM_db" # broken build
    "PGSEA" # depends on broken package annaffy
    "POCRCannotation_db" # broken build
    "PREDAsampledata" # depends on broken package gahgu133plus2cdf
    "PSAboot" # depends on broken package nlopt-2.4.2
    "PWMEnrich_Dmelanogaster_background" # broken build
    "PartheenMetaData_db" # broken build
    "PathNetData" # broken build
    "PatternClass" # build is broken
    "Pbase" # depends on broken package MSnbase
    "PharmacoGx"
    "PhenStat" # depends on broken package nlopt-2.4.2
    "ProCoNA" # depends on broken package AnnotationForge
    "Prostar" # depends on broken package MSnbase
    "ProteomicsAnnotationHubData" # depends on broken package r-AnnotationHub-2.1.40
    "PythonInR"
    "QFRM"
    "QUALIFIER" # depends on broken package flowCore
    "QuartPAC" # depends on broken package RMallow
    "R2STATS" # depends on broken package nlopt-2.4.2
    "R2jags" # broken build
    "R2jags" # broken build
    "RADami" # broken build
    "RBerkeley"
    "RDAVIDWebService" # depends on broken package AnnotationForge
    "RDieHarder" # build is broken
    "REST" # depends on broken package nlopt-2.4.2
    "REndo" # depends on broken package AER
    "RLRsim" # depends on broken package nloptr
    "RMallow" # broken build
    "RMallow" # broken build
    "RNAither" # depends on broken package nlopt-2.4.2
    "RQuantLib" # build is broken
    "RRreg" # depends on broken package nloptr
    "RSAP" # build is broken
    "RSDA" # depends on broken package nlopt-2.4.2
    "RStoolbox" # depends on broken package r-caret-6.0-52
    "RTCGA_mutations" # broken build
    "RTCGA_rnaseq" # broken build
    "RTN" # depends on broken package car
    "RVAideMemoire" # depends on broken package nlopt-2.4.2
    "RVFam" # depends on broken package nlopt-2.4.2
    "RWebServices" # broken build
    "RareVariantVis" # depends on broken VariantAnnotation-1.15.19
    "RbioRXN" # depends on broken package ChemmineR
    "Rblpapi" # broken build
    "Rchemcpp" # depends on broken package ChemmineR
    "Rchoice" # depends on broken package car
    "RchyOptimyx" # broken build
    "Rcmdr" # depends on broken package car
    "RcmdrMisc" # depends on broken package car
    "RcmdrPlugin_BCA" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_DoE" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_EACSPIR" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_EBM" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_EZR" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_EcoVirtual" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_Export" # depends on broken package car
    "RcmdrPlugin_FactoMineR" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_HH" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_IPSUR" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_KMggplot2" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_MA" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_MPAStats" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_NMBU" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_RMTCJags" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_ROC" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_SCDA" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_SLC" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_SM" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_TeachingDemos" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_UCA" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_coin" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_depthTools" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_doex" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_epack" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_lfstat" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_mosaic" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_orloca" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_plotByGroup" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_pointG" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_qual" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_sampling" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_seeg" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_sos" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_steepness" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_survival" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_temis" # depends on broken package nlopt-2.4.2
    "Rcplex" # Build Is Broken
    "RcppAPT" # Build Is Broken
    "RcppRedis" # build is broken
    "ReactomePA" # depends on broken package DOSE
    "ReportingTools" # depends on broken package AnnotationForge
    "Rgnuplot"
    "RmiR" # broken build
    "RnAgilentDesign028282_db" # broken build
    "RnavGraph" # build is broken
    "Roberts2005Annotation_db" # broken build
    "RockFab" # broken build
    "Rothermel" # broken build
    "Rphylopars" # broken build
    "SDD" # broken build
    "SHDZ_db" # broken build
    "SNAGEE" # broken build
    "SOD" # depends on broken package cudatoolkit-5.5.22
    "ScISI" # depends on broken package apComplex
    "SemDist" # broken build
    "SensMixed" # depends on broken package r-lme4-1.1-9
    "SensoMineR" # depends on broken package car
    "SeqFeatR" # broken build
    "SeqGrapheR" # Build Is Broken
    "SoyNAM" # depends on broken package r-lme4-1.1-8
    "Statomica" # broken build
    "Surrogate" # depends on broken package nlopt-2.4.2
    "TCGAbiolinks" # depends on broken package r-affy-1.47.1
    "TDMR" # depends on broken package nlopt-2.4.2
    "TED" # broken build
    "TFBSTools" # depends on broken package CNEr
    "TKF" # broken build
    "TLBC" # depends on broken package car
    "TSMySQL" # broken build
    "TSdist" # broken build
    "TcGSA" # depends on broken package nlopt-2.4.2
    "TextoMineR" # depends on broken package car
    "TransferEntropy" # broken build
    "TriMatch" # depends on broken package car
    "TxDb_Celegans_UCSC_ce6_ensGene" # broken build
    "TxDb_Rnorvegicus_BioMart_igis" # broken build
    "VBmix" # broken build
    "VIM" # depends on broken package car
    "VIMGUI" # depends on broken package nlopt-2.4.2
    "Zelig" # depends on broken package AER
    "a4" # depends on broken package htmltools
    "a4Base" # broken build
    "a4Reporting" # broken build
    "aLFQ" # depends on broken package nlopt-2.4.2
    "abd" # depends on broken package nloptr
    "adSplit" # broken build
    "adabag" # depends on broken package nloptr
    "adhoc" # depends on broken package htmltools
    "adme16cod_db" # broken build
    "afex" # depends on broken package nlopt-2.4.2
    "affycoretools" # depends on broken package ReportingTools
    "agRee" # depends on broken package nlopt-2.4.2
    "algstat" # depends on broken package polynom
    "alr3" # depends on broken package nlopt-2.4.2
    "alr4" # depends on broken package nlopt-2.4.2
    "alsace" # depends on broken nloptr-1.0.4
    "alsace" # depends on broken package nloptr
    "anacor" # depends on broken package nlopt-2.4.2
    "annaffy" # broken build
    "annmap" # broken build
    "aods3" # depends on broken package nlopt-2.4.2
    "apComplex" # broken build
    "apaTables" # depends on broken package r-car-2.1-0
    "apt" # depends on broken package nlopt-2.4.2
    "arm" # depends on broken package nloptr
    "arrayMvout" # depends on broken package rgl
    "arrayQualityMetrics" # broken build
    "attract" # depends on broken package AnnotationForge
    "auRoc" # broken build
    "bamdit" # broken build
    "bapred" # depends on broken package r-lme4-1.1-9
    "bartMachine" # depends on broken package nlopt-2.4.2
    "bayesDem" # depends on broken package nlopt-2.4.2
    "bayesLife" # depends on broken package nloptr
    "bayesPop" # depends on broken package bayesLife
    "bayescount" # broken build
    "bayesmix" # broken build
    "bcrypt" # broken build
    "bdynsys" # depends on broken package nloptr
    "bgmm" # depends on broken package nloptr
    "bigGP" # build is broken
    "bioassayR" # broken build
    "biotools" # broken build
    "birte" # build is broken
    "blme" # depends on broken package nlopt-2.4.2
    "blmeco" # depends on broken package nlopt-2.4.2
    "blowtorch" # broken build
    "bmd" # depends on broken package nlopt-2.4.2
    "bmem" # depends on broken package nlopt-2.4.2
    "bmeta" # depends on broken package R2jags
    "bootnet" # depends on broken package nlopt-2.4.2
    "boral" # depends on broken package R2jags
    "boss" # depends on broken package nlopt-2.4.2
    "bovine_db" # broken build
    "brainGraph" # broken build
    "brms" # depends on broken package htmltools
    "cAIC4" # depends on broken package nlopt-2.4.2
    "candisc" # depends on broken package nlopt-2.4.2
    "caninecdf" # broken build
    "car" # depends on broken package nloptr
    "carcass" # depends on broken package nlopt-2.4.2
    "caret" # depends on broken package car
    "caretEnsemble" # depends on broken package car
    "categoryCompare" # depends on broken package AnnotationForge
    "celegans_db" # broken build
    "charmData" # broken build
    "chicken_db0" # broken build
    "chipPCR" # depends on broken nloptr-1.0.4
    "chipPCR" # depends on broken package nloptr
    "chipenrich" # build is broken
    "classify" # depends on broken package R2jags
    "climwin" # depends on broken package nlopt-2.4.2
    "clpAPI" # build is broken
    "clusterPower" # depends on broken package nlopt-2.4.2
    "clusterProfiler" # broken build
    "clusterSEs" # depends on broken AER-1.2-4
    "clusterSEs" # depends on broken package AER
    "coefplot" # broken build
    "colorscience"
    "colorscience" # depends on broken package munsellinterpol
    "compEpiTools" # broken build
    "compendiumdb" # broken build
    "conformal" # depends on broken package nlopt-2.4.2
    "conumee" # broken build
    "corHMM" # depends on broken package nlopt-2.4.2
    "cosmiq" # depends on broken package xcms
    "covmat" # depends on broken package r-VIM-4.4.1
    "cpgen" # depends on broken package r-pedigreemm-0.3-3
    "cplexAPI" # build is broken
    "crmPack" # broken build
    "ctsem" # depends on broken package r-OpenMx-2.2.6
    "cudaBayesreg" # build is broken
    "curvHDR" # broken build
    "cytofkit" # broken build
    "dagLogo" # depends on broken package motifStack
    "dagbag" # build is broken
    "datafsm" # depends on broken package r-caret-6.0-52
    "dbConnect" # broken build
    "demography" # broken build
    "difR" # depends on broken package nlopt-2.4.2
    "diveRsity" # depends on broken package nlopt-2.4.2
    "doMPI" # build is broken
    "dpa" # depends on broken package nlopt-2.4.2
    "dpcR" # depends on broken nloptr-1.0.4
    "dpcR" # depends on broken package nloptr
    "drc" # depends on broken package car
    "drfit" # depends on broken package nlopt-2.4.2
    "drosgenome1_db" # broken build
    "drosophila2_db" # broken build
    "drosophila2cdf" # broken build
    "drsmooth" # depends on broken package nlopt-2.4.2
    "dupRadar" # depends on broken package r-Rsubread-1.19.5
    "dyebiasexamples" # broken build
    "dynlm" # depends on broken package car
    "easyanova" # depends on broken package nlopt-2.4.2
    "ecd" # depends on broken package polynom
    "ecoliLeucine" # broken build
    "edge" # depends on broken package nlopt-2.4.2
    "eeptools" # depends on broken package nlopt-2.4.2
    "effects" # depends on broken package nloptr
    "eiR" # depends on broken package ChemmineR
    "encoDnaseI" # broken build
    "episplineDensity" # depends on broken package nlopt-2.4.2
    "epr" # depends on broken package nlopt-2.4.2
    "erer" # depends on broken package car
    "erma" # depends on broken GenomicFiles-1.5.4
    "evobiR" # broken build
    "exomePeak" # broken build
    "extRemes" # depends on broken package car
    "ez" # depends on broken package car
    "facopy" # depends on broken package nlopt-2.4.2
    "facopy_annot" # broken build
    "faoutlier" # depends on broken package nlopt-2.4.2
    "fastLiquidAssociation" # depends on broken package LiquidAssociation
    "fastR" # depends on broken package nlopt-2.4.2
    "ffpeExampleData" # broken build
    "fishmethods" # depends on broken package nloptr
    "flagme" # depends on broken package CAMERA
    "flowBeads" # broken build
    "flowBin" # broken build
    "flowCHIC" # broken build
    "flowClean" # broken build
    "flowClust" # depends on broken package flowCore
    "flowCore" # broken build
    "flowDensity" # depends on broken package nlopt-2.4.2
    "flowDiv" # depends on broken package flowCore
    "flowFP" # depends on broken package flowCore
    "flowFit" # broken build
    "flowFitExampleData" # broken build
    "flowMatch" # broken build
    "flowMeans" # depends on broken package flowCore
    "flowMerge" # depends on broken package flowCore
    "flowPeaks" # build is broken
    "flowQ" # build is broken
    "flowQB" # broken build
    "flowStats" # depends on broken package flowCore
    "flowTrans" # broken build
    "flowType" # depends on broken package flowCore
    "flowUtils" # depends on broken package flowCore
    "flowVS" # depends on broken package flowCore
    "flowViz" # depends on broken package flowCore
    "flowWorkspace" # depends on broken package flowCore
    "fmcsR" # depends on broken package ChemmineR
    "freqweights" # depends on broken package nlopt-2.4.2
    "fscaret" # depends on broken package nlopt-2.4.2
    "funcy" # depends on broken package car
    "fxregime" # depends on broken package nlopt-2.4.2
    "gahgu133acdf" # broken build
    "gahgu133bcdf" # broken build
    "gahgu133plus2cdf" # broken build
    "gahgu95av2cdf" # broken build
    "gahgu95bcdf" # broken build
    "gahgu95ccdf" # broken build
    "gahgu95dcdf" # broken build
    "gahgu95ecdf" # broken build
    "gamclass" # depends on broken package nlopt-2.4.2
    "gamm4" # depends on broken package nloptr
    "gcmr" # depends on broken package nlopt-2.4.2
    "genridge" # depends on broken package nlopt-2.4.2
    "gimme" # depends on broken package nlopt-2.4.2
    "gmatrix" # depends on broken package cudatoolkit-5.5.22
    "goProfiles" # broken build
    "goTools" # broken build
    "golubEsets" # broken build
    "gplm" # depends on broken package nlopt-2.4.2
    "gputools" # depends on broken package cudatoolkit-5.5.22
    "granova" # depends on broken package nlopt-2.4.2
    "graphicalVAR" # depends on broken package nlopt-2.4.2
    "gridGraphics" # broken build
    "h10kcod_db" # broken build
    "h20kcod_db" # broken build
    "h5" # build is broken
    "h5vc" # broken build
    "hbsae" # depends on broken package nlopt-2.4.2
    "hcg110_db" # broken build
    "healthyFlowData" # broken build
    "heplots" # depends on broken package car
    "hgu133a2frmavecs" # broken build
    "hgu133afrmavecs" # broken build
    "hgu133b_db" # broken build
    "hgu219_db" # broken build
    "hgu95a_db" # broken build
    "hgu95aprobe" # broken build
    "hgu95av2_db" # broken build
    "hgu95b_db" # broken build
    "hgu95c_db" # broken build
    "hgu95d_db" # broken build
    "hgu95dprobe" # broken build
    "hgu95e_db" # broken build
    "hguDKFZ31_db" # broken build
    "hguatlas13k_db" # broken build
    "hgubeta7_db" # broken build
    "hgug4100a_db" # broken build
    "hgug4101a_db" # broken build
    "hgug4110b_db" # broken build
    "hgug4111a_db" # broken build
    "hgug4112a_db" # broken build
    "hgug4845a_db" # broken build
    "hguqiagenv3_db" # broken build
    "hi16cod_db" # broken build
    "hierGWAS"
    "highriskzone"
    "hs25kresogen_db" # broken build
    "hta20sttranscriptcluster_db" # broken build
    "hthgu133a_db" # broken build
    "hthgu133afrmavecs" # broken build
    "hthgu133b_db" # broken build
    "hu35ksuba_db" # broken build
    "hu35ksubb_db" # broken build
    "hu35ksubc_db" # broken build
    "hu35ksubd_db" # broken build
    "hu6800_db" # broken build
    "hugene10sttranscriptcluster_db" # broken build
    "hugene11stprobeset_db" # broken build
    "hugene11sttranscriptcluster_db" # broken build
    "hugene20stprobeset_db" # broken build
    "hugene20sttranscriptcluster_db" # broken build
    "hugene21sttranscriptcluster_db" # broken build
    "hwgcod_db" # broken build
    "hwwntest" # depends on broken package polynom
    "hysteresis" # depends on broken package nlopt-2.4.2
    "iClick" # depends on broken package nloptr
    "ibd" # depends on broken package nlopt-2.4.2
    "iccbeta" # depends on broken package nlopt-2.4.2
    "ifaTools" # depends on broken package r-OpenMx-2.2.6
    "ilc" # depends on broken package demography
    "illuminaHumanWGDASLv3_db" # broken build
    "illuminaHumanWGDASLv4_db" # broken build
    "illuminaHumanv2BeadID_db" # broken build
    "illuminaHumanv2_db" # broken build
    "illuminaHumanv3_db" # broken build
    "illuminaHumanv4_db" # broken build
    "illuminaMousev1_db" # broken build
    "illuminaMousev1p1_db" # broken build
    "illuminaMousev2_db" # broken build
    "illuminaRatv1_db" # broken build
    "imager" # broken build
    "immunoClust" # build is broken
    "in2extRemes" # depends on broken package nlopt-2.4.2
    "inSilicoMerging" # build is broken
    "indac_db" # broken build
    "inferference" # depends on broken package nlopt-2.4.2
    "influence_ME" # depends on broken package nlopt-2.4.2
    "interplot" # depends on broken arm-1.8-5
    "interplot" # depends on broken package arm
    "iptools"
    "iterpc" # depends on broken package polynom
    "ivpack" # depends on broken package nlopt-2.4.2
    "jetset"
    "jetset" # broken build
    "joda" # depends on broken package nlopt-2.4.2
    "jomo" # build is broken
    "keggorthology" # broken build
    "ldamatch" # depends on broken package polynom
    "learnstats" # depends on broken package nlopt-2.4.2
    "leeBamViews" # broken build
    "lefse" # build is broken
    "lmSupport" # depends on broken package nlopt-2.4.2
    "lme4" # depends on broken package nloptr
    "lmerTest" # depends on broken package nloptr
    "longpower" # depends on broken package nlopt-2.4.2
    "lumiBarnes" # broken build
    "lumiHumanAll_db" # broken build
    "lumiHumanIDMapping" # broken build
    "lumiMouseAll_db" # broken build
    "lumiMouseIDMapping" # broken build
    "lumiRatAll_db" # broken build
    "lumiRatIDMapping" # broken build
    "m10kcod_db" # broken build
    "m20kcod_db" # broken build
    "mAPKL" # build is broken
    "mBvs" # broken build
    "maGUI" # depends on broken package AnnotationForge
    "maPredictDSC" # depends on broken package nlopt-2.4.2
    "maizeprobe" # broken build
    "maqcExpression4plex" # broken build
    "marked" # depends on broken package nlopt-2.4.2
    "mbest" # depends on broken package nlopt-2.4.2
    "meboot" # depends on broken package nlopt-2.4.2
    "medflex" # depends on broken package r-car-2.1-0
    "mediation" # depends on broken package r-lme4-1.1-8
    "merTools" # depends on broken package r-arm-1.8-6
    "meta4diag" # broken build
    "metaMS" # depends on broken package CAMERA
    "metaMix" # build is broken
    "metaX" # depends on broken package r-CAMERA-1.25.2
    "metacom" # broken build
    "metagear" # build is broken
    "metaplus" # depends on broken package nlopt-2.4.2
    "mgu74a_db" # broken build
    "mgu74av2_db" # broken build
    "mgu74b_db" # broken build
    "mgu74bv2_db" # broken build
    "mgu74c_db" # broken build
    "mgu74cv2_db" # broken build
    "mguatlas5k_db" # broken build
    "mgug4104a_db" # broken build
    "mgug4120a_db" # broken build
    "mgug4121a_db" # broken build
    "mgug4122a_db" # broken build
    "mi" # depends on broken package arm
    "mi16cod_db" # broken build
    "miRcomp" # broken build
    "miRcompData" # broken build
    "micEconAids" # depends on broken package nlopt-2.4.2
    "micEconCES" # depends on broken package nlopt-2.4.2
    "micEconSNQP" # depends on broken package nlopt-2.4.2
    "miceadds" # depends on broken package car
    "migui" # depends on broken package nlopt-2.4.2
    "mirIntegrator" # broken build
    "missDeaths"
    "missMDA" # depends on broken package nlopt-2.4.2
    "mitoODE" # broken build
    "mixAK" # depends on broken package nlopt-2.4.2
    "mixlm" # depends on broken package car
    "mlVAR" # depends on broken package nlopt-2.4.2
    "mlmRev" # depends on broken package nlopt-2.4.2
    "mm24kresogen_db" # broken build
    "moe430a_db" # broken build
    "moe430b_db" # broken build
    "moex10sttranscriptcluster_db" # broken build
    "mogene10stprobeset_db" # broken build
    "mogene10sttranscriptcluster_db" # broken build
    "mogene11stprobeset_db" # broken build
    "mogene11sttranscriptcluster_db" # broken build
    "mogene20stprobeset_db" # broken build
    "mogene20sttranscriptcluster_db" # broken build
    "mogene21stprobeset_db" # broken build
    "mogene21sttranscriptcluster_db" # broken build
    "mongolite" # build is broken
    "monocle" # depends on broken package HSMMSingleCell
    "monogeneaGM" # broken build
    "mosaic" # depends on broken package car
    "motifStack" # broken build
    "motifStack" # broken build
    "motifbreakR" # depends on broken package r-BSgenome-1.37.5
    "mouse430a2_db" # broken build
    "mpedbarray_db" # broken build
    "mpoly" # depends on broken package polynom
    "msmsEDA" # depends on broken package MSnbase
    "msmsTests" # depends on broken package MSnbase
    "mta10sttranscriptcluster_db" # broken build
    "mu11ksuba_db" # broken build
    "mu11ksubb_db" # broken build
    "mu19ksuba_db" # broken build
    "mu19ksubb_db" # broken build
    "mu19ksubc_db" # broken build
    "multiDimBio" # depends on broken package nlopt-2.4.2
    "muma" # depends on broken package nlopt-2.4.2
    "munsellinterpol"
    "munsellinterpol" # broken build
    "munsellinterpol" # broken build
    "mutossGUI" # build is broken
    "mvGST" # depends on broken package AnnotationForge
    "mvMORPH" # broken build
    "mvinfluence" # depends on broken package nlopt-2.4.2
    "mwgcod_db" # broken build
    "nCal" # depends on broken package nlopt-2.4.2
    "ncdfFlow" # depends on broken package flowCore
    "netresponse" # broken build
    "nloptr" # broken build
    "nloptr" # broken build
    "nlts" # broken build
    "nonrandom" # depends on broken package nlopt-2.4.2
    "npIntFactRep" # depends on broken package nlopt-2.4.2
    "nugohs1a520180_db" # broken build
    "nugomm1a520177_db" # broken build
    "omics" # depends on broken package nloptr
    "openCyto" # depends on broken package flowCore
    "openssl" # broken build
    "ordBTL" # depends on broken package nlopt-2.4.2
    "ordPens" # depends on broken package r-lme4-1.1-9
    "org_Ce_eg_db" # broken build
    "org_Pt_eg_db" # broken build
    "org_Sc_sgd_db" # broken build
    "org_Ss_eg_db" # broken build
    "pRoloc" # depends on broken package car
    "pRolocGUI" # depends on broken package nlopt-2.4.2
    "pRolocdata" # broken build
    "pacman" # broken build
    "pamm" # depends on broken package nlopt-2.4.2
    "panelAR" # depends on broken package nlopt-2.4.2
    "papeR" # depends on broken package nlopt-2.4.2
    "parboost" # depends on broken package nlopt-2.4.2
    "parma" # depends on broken package nlopt-2.4.2
    "pbkrtest" # depends on broken package nloptr
    "pcaBootPlot" # depends on broken FactoMineR-1.31.3
    "pcaBootPlot" # depends on broken package car
    "pcaL1" # build is broken
    "pd_canine_2" # broken build
    "pd_celegans" # broken build
    "pd_citrus" # broken build
    "pd_hg_u133a" # broken build
    "pd_hg_u219" # broken build
    "pd_hg_u95a" # broken build
    "pd_ht_hg_u133a" # broken build
    "pd_moe430b" # broken build
    "pd_nugo_mm1a520177" # broken build
    "pd_plasmodium_anopheles" # broken build
    "pd_vitis_vinifera" # broken build
    "pd_zebrafish" # broken build
    "pedbarrayv10_db" # broken build
    "pedbarrayv9_db" # broken build
    "pedigreemm" # depends on broken package nloptr
    "pequod" # depends on broken package nlopt-2.4.2
    "pglm" # depends on broken package car
    "phia" # depends on broken package nlopt-2.4.2
    "phylocurve" # depends on broken package nlopt-2.4.2
    "piecewiseSEM" # depends on broken package nloptr
    "plateCore" # depends on broken package flowCore
    "plfMA" # broken build
    "plm" # depends on broken package car
    "plsRbeta" # depends on broken package nlopt-2.4.2
    "plsRcox" # depends on broken package nlopt-2.4.2
    "plsRglm" # depends on broken package car
    "pmclust" # build is broken
    "pmm" # depends on broken package nlopt-2.4.2
    "polynom" # broken build
    "polynom" # broken build
    "pomp" # depends on broken package nlopt-2.4.2
    "porcine_db" # broken build
    "prLogistic" # depends on broken package nlopt-2.4.2
    "predictmeans" # depends on broken package nlopt-2.4.2
    "preprocomb" # depends on broken package car
    "proteoQC" # depends on broken package MSnbase
    "ptw" # depends on broken nloptr-1.0.4
    "pvca" # depends on broken package nlopt-2.4.2
    "qtlnet" # depends on broken package nlopt-2.4.2
    "quantification" # depends on broken package nlopt-2.4.2
    "r10kcod_db" # broken build
    "rCGH" # depends on broken package r-affy-1.47.1
    "rDEA" # build is broken
    "rLindo" # build is broken
    "rMAT" # build is broken
    "rTableICC" # broken build
    "rUnemploymentData" # broken build
    "rae230a_db" # broken build
    "rae230b_db" # broken build
    "raex10sttranscriptcluster_db" # broken build
    "ragene10stprobeset_db" # broken build
    "ragene10sttranscriptcluster_db" # broken build
    "ragene11stprobeset_db" # broken build
    "ragene11sttranscriptcluster_db" # broken build
    "ragene20stprobeset_db" # broken build
    "ragene20sttranscriptcluster_db" # broken build
    "ragene21stprobeset_db" # broken build
    "ragene21sttranscriptcluster_db" # broken build
    "raincpc" # build is broken
    "rainfreq" # build is broken
    "rasclass" # depends on broken package nlopt-2.4.2
    "rat2302_db" # broken build
    "rbundler" # broken build
    "rcellminer" # broken build
    "rcrypt" # broken build
    "rdd" # depends on broken package AER
    "rddtools" # depends on broken package r-AER-1.2-4
    "recluster" # broken build
    "referenceIntervals" # depends on broken package nlopt-2.4.2
    "refund" # depends on broken package nloptr
    "refund_shiny" # depends on broken package r-refund-0.1-13
    "regRSM" # broken build
    "rgu34a_db" # broken build
    "rgu34b_db" # broken build
    "rgu34c_db" # broken build
    "rguatlas4k_db" # broken build
    "rgug4105a_db" # broken build
    "rgug4130a_db" # broken build
    "rgug4131a_db" # broken build
    "ri16cod_db" # broken build
    "rmgarch" # depends on broken package nlopt-2.4.2
    "rminer" # depends on broken package nlopt-2.4.2
    "rmumps" # broken build
    "rnu34_db" # broken build
    "robustlmm" # depends on broken package nlopt-2.4.2
    "rockchalk" # depends on broken package car
    "rols" # build is broken
    "rpubchem" # depends on broken package nlopt-2.4.2
    "rr" # depends on broken package nlopt-2.4.2
    "rtu34_db" # broken build
    "rugarch" # depends on broken package nloptr
    "rwgcod_db" # broken build
    "ryouready" # depends on broken package nlopt-2.4.2
    "sampleSelection" # depends on broken package car
    "sdcMicro" # depends on broken package car
    "sdcMicroGUI" # depends on broken package nlopt-2.4.2
    "seeg" # depends on broken package car
    "semGOF" # depends on broken package nlopt-2.4.2
    "semPlot" # depends on broken package nlopt-2.4.2
    "semdiag" # depends on broken package nlopt-2.4.2
    "seqCNA" # broken build
    "seqCNA_annot" # broken build
    "seqHMM" # depends on broken package nloptr
    "seqTools" # build is broken
    "seqc" # broken build
    "simPop" # depends on broken package r-VIM-4.4.1
    "simr" # depends on broken package nloptr
    "sjPlot" # depends on broken package nlopt-2.4.2
    "sortinghat" # broken build
    "spacom" # depends on broken package nlopt-2.4.2
    "spade" # broken build
    "specificity" # depends on broken package nlopt-2.4.2
    "specmine" # depends on broken package CAMERA
    "splm" # depends on broken package car
    "spoccutils" # depends on broken spocc-0.3.0
    "ssmrob" # depends on broken package nlopt-2.4.2
    "stcm" # depends on broken package nlopt-2.4.2
    "stepp" # depends on broken package nlopt-2.4.2
    "sybilSBML" # build is broken
    "synapter" # depends on broken package MSnbase
    "synapterdata" # broken build
    "synthpop" # depends on broken package coefplot
    "systemPipeR" # depends on broken package AnnotationForge
    "systemfit" # depends on broken package car
    "tigerstats" # depends on broken package nlopt-2.4.2
    "tmle" # broken build
    "tnam" # depends on broken package nloptr
    "translateSPSS2R" # depends on broken car-2.0-25
    "translateSPSS2R" # depends on broken package car
    "traseR"
    "tsoutliers" # depends on broken package polynom
    "u133aaofav2cdf" # broken build
    "u133x3p_db" # broken build
    "u133x3pcdf" # broken build
    "umx" # depends on broken package r-OpenMx-2.2.6
    "userfriendlyscience" # depends on broken package nlopt-2.4.2
    "varComp" # depends on broken package r-lme4-1.1-9
    "variancePartition" # depends on broken package nloptr
    "vows" # depends on broken package nlopt-2.4.2
    "webbioc" # depends on broken package annaffy
    "webp" # broken build
    "wfe" # depends on broken package nlopt-2.4.2
    "x_ent" # broken build
    "xcms" # broken build
    "xcms" # broken build
    "xergm" # depends on broken package nlopt-2.4.2
    "xps" # build is broken
    "yeast2_db" # broken build
    "yeastNagalakshmi" # broken build
    "yeast_db0" # broken build
    "ygs98_db" # broken build
    "zebrafish_db" # broken build
    "zetadiv" # depends on broken package nlopt-2.4.2
  ];

  otherOverrides = old: new: {
    stringi = old.stringi.overrideDerivation (attrs: {
      postInstall = let
        icuName = "icudt52l";
        icuSrc = pkgs.fetchzip {
          url = "http://static.rexamine.com/packages/${icuName}.zip";
          sha256 = "0hvazpizziq5ibc9017i1bb45yryfl26wzfsv05vk9mc1575r6xj";
          stripRoot = false;
        };
        in ''
          ${attrs.postInstall or ""}
          cp ${icuSrc}/${icuName}.dat $out/library/stringi/libs
        '';
    });

    xml2 = old.xml2.overrideDerivation (attrs: {
      preConfigure = ''
        export LIBXML_INCDIR=${pkgs.libxml2}/include/libxml2
        patchShebangs configure
        '';
    });

    curl = old.curl.overrideDerivation (attrs: {
      preConfigure = "patchShebangs configure";
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
      NIX_CFLAGS_LINK = "-L${pkgs.xorg.libXft}/lib -lXft";
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

    gmatrix = old.gmatrix.overrideDerivation (attrs: {
      patches = [ ./patches/gmatrix.patch ];
      CUDA_LIB_PATH = "${pkgs.cudatoolkit}/lib64";
      R_INC_PATH = "${pkgs.R}/lib/R/include";
      CUDA_INC_PATH = "${pkgs.cudatoolkit}/include";
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

    V8 = old.V8.overrideDerivation (attrs: {
      preConfigure = "export V8_INCLUDES=${pkgs.v8}/include";
    });

  };
in
  self
