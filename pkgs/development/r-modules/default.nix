/* This file defines the composition for CRAN (R) packages. */

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

  # Templates for generating Bioconductor and CRAN packages
  # from the name, version, sha256, and optional per-package arguments above
  #
  deriveBioc = mkDerive {
    mkHomepage = name: "http://cran.r-project.org/web/packages/${name}/";
    mkUrls = {name, version}: [ "mirror://bioc/src/contrib/${name}_${version}.tar.gz" ];
  };
  deriveCran = mkDerive {
    mkHomepage = name: "http://bioconductor.org/packages/release/bioc/html/${name}.html";
    mkUrls = {name, version}: [
      "mirror://cran/src/contrib/${name}_${version}.tar.gz"
      "mirror://cran/src/contrib/00Archive/${name}/${name}_${version}.tar.gz"
    ];
  };

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
          import ./cran-packages.nix { inherit self; derive = deriveCran; };

  # tweaks for the individual packages and "in self" follow

  packagesWithRDepends = {
    FactoMineR = [ self.car ];
    pander = [ self.codetools ];
  };

  packagesWithNativeBuildInputs = {
    abn = [ pkgs.gsl ];
    adimpro = [ pkgs.imagemagick ];
    audio = [ pkgs.portaudio ];
    BayesSAE = [ pkgs.gsl ];
    BayesVarSel = [ pkgs.gsl ];
    BayesXsrc = [ pkgs.readline pkgs.ncurses ];
    bigGP = [ pkgs.openmpi ];
    BiocCheck = [ pkgs.which ];
    Biostrings = [ pkgs.zlib ];
    bnpmr = [ pkgs.gsl ];
    BNSP = [ pkgs.gsl ];
    cairoDevice = [ pkgs.gtk2 ];
    Cairo = [ pkgs.libtiff pkgs.libjpeg pkgs.cairo ];
    Cardinal = [ pkgs.which ];
    CARramps = [ pkgs.linuxPackages.nvidia_x11 pkgs.liblapack ];
    chebpol = [ pkgs.fftw ];
    ChemmineOB = [ pkgs.openbabel pkgs.pkgconfig ];
    cit = [ pkgs.gsl ];
    curl = [ pkgs.curl ];
    devEMF = [ pkgs.xorg.libXft ];
    diversitree = [ pkgs.gsl pkgs.fftw ];
    EMCluster = [ pkgs.liblapack ];
    fftw = [ pkgs.fftw ];
    fftwtools = [ pkgs.fftw ];
    Formula = [ pkgs.gmp ];
    geoCount = [ pkgs.gsl ];
    git2r = [ pkgs.zlib pkgs.openssl ];
    GLAD = [ pkgs.gsl ];
    glpkAPI = [ pkgs.gmp pkgs.glpk ];
    gmp = [ pkgs.gmp ];
    graphscan = [ pkgs.gsl ];
    gsl = [ pkgs.gsl ];
    HiCseg = [ pkgs.gsl ];
    iBMQ = [ pkgs.gsl ];
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
    R2GUESS = [ pkgs.gsl ];
    R2SWF = [ pkgs.zlib pkgs.libpng pkgs.freetype ];
    RAppArmor = [ pkgs.libapparmor ];
    rapportools = [ pkgs.which ];
    rapport = [ pkgs.which ];
    rbamtools = [ pkgs.zlib ];
    RCA = [ pkgs.gmp ];
    rcdd = [ pkgs.gmp ];
    RcppCNPy = [ pkgs.zlib ];
    RcppGSL = [ pkgs.gsl ];
    RcppOctave = [ pkgs.zlib pkgs.bzip2 pkgs.icu pkgs.lzma pkgs.pcre pkgs.octave ];
    RcppZiggurat = [ pkgs.gsl ];
    rgdal = [ pkgs.proj pkgs.gdal ];
    rgeos = [ pkgs.geos ];
    rggobi = [ pkgs.ggobi pkgs.gtk2 pkgs.libxml2 ];
    rgl = [ pkgs.mesa pkgs.xlibsWrapper ];
    Rglpk = [ pkgs.glpk ];
    RGtk2 = [ pkgs.gtk2 ];
    Rhpc = [ pkgs.zlib pkgs.bzip2 pkgs.icu pkgs.lzma pkgs.openmpi pkgs.pcre ];
    Rhtslib = [ pkgs.zlib ];
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
    stringi = [ pkgs.icu ];
    survSNP = [ pkgs.gsl ];
    sysfonts = [ pkgs.zlib pkgs.libpng pkgs.freetype ];
    TAQMNGR = [ pkgs.zlib ];
    tiff = [ pkgs.libtiff ];
    TKF = [ pkgs.gsl ];
    tkrplot = [ pkgs.xorg.libX11 ];
    topicmodels = [ pkgs.gsl ];
    udunits2 = [ pkgs.udunits pkgs.expat ];
    V8 = [ pkgs.v8 ];
    VBLPCM = [ pkgs.gsl ];
    VBmix = [ pkgs.gsl pkgs.fftw pkgs.qt4 ];
    WhopGenome = [ pkgs.zlib ];
    XBRL = [ pkgs.zlib pkgs.libxml2 ];
    xml2 = [ pkgs.libxml2 ];
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
    "loe"
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
    "a4Base" # depends on broken package annaffy-1.41.1
    "a4" # depends on broken package annaffy-1.41.1
    "a4Reporting" # depends on broken package annaffy-1.41.1
    "abd" # depends on broken package nlopt-2.4.2
    "Actigraphy" # Build Is Broken
    "adabag" # depends on broken package nlopt-2.4.2
    "ADaCGH2" # depends on broken package tilingArray-1.47.0
    "adSplit" # build is broken
    "AER" # depends on broken package nlopt-2.4.2
    "afex" # depends on broken package nlopt-2.4.2
    "affyContam" # depends on broken package affyio-1.37.0
    "affycoretools" # depends on broken package affyio-1.37.0
    "affy" # depends on broken package affyio-1.37.0
    "AffyExpress" # depends on broken package affyio-1.37.0
    "affyILM" # depends on broken package affyio-1.37.0
    "affyio" # build is broken
    "affylmGUI" # depends on broken package affyio-1.37.0
    "affyPara" # depends on broken package affyio-1.37.0
    "affypdnn" # depends on broken package affyio-1.37.0
    "affyPLM" # depends on broken package affyio-1.37.0
    "affyQCReport" # depends on broken package affyio-1.37.0
    "AffyRNADegradation" # depends on broken package affyio-1.37.0
    "AffyTiling" # depends on broken package affyio-1.37.0
    "AgiMicroRna" # depends on broken package affyio-1.37.0
    "agRee" # depends on broken package nlopt-2.4.2
    "aLFQ" # depends on broken package nlopt-2.4.2
    "AllelicImbalance" # depends on broken package Rsamtools-1.21.8
    "alr3" # depends on broken package nlopt-2.4.2
    "alr4" # depends on broken package nlopt-2.4.2
    "alsace" # depends on broken nloptr-1.0.4
    "altcdfenvs" # depends on broken package affyio-1.37.0
    "ampliQueso" # depends on broken package Rsamtools-1.21.8
    "anacor" # depends on broken package nlopt-2.4.2
    "annaffy" # build is broken
    "annmap" # depends on broken package Rsamtools-1.21.8
    "AnnotationForge" # Build Is Broken
    "AnnotationHub" # depends on broken package interactiveDisplayBase-1.7.0
    "aods3" # depends on broken package nlopt-2.4.2
    "apComplex" # build is broken
    "apt" # depends on broken package nlopt-2.4.2
    "ArfimaMLM" # depends on broken package nlopt-2.4.2
    "arm" # depends on broken package nlopt-2.4.2
    "ArrayExpress" # depends on broken package affyio-1.37.0
    "ArrayExpressHTS" # depends on broken package Rsamtools-1.21.8
    "arrayMvout" # depends on broken package affyio-1.37.0
    "arrayQualityMetrics" # depends on broken package affyio-1.37.0
    "ArrayTools" # depends on broken package affyio-1.37.0
    "ArrayTV" # depends on broken package affyio-1.37.0
    "ARRmNormalization" # Build Is Broken
    "ARTool" # depends on broken package nlopt-2.4.2
    "attract" # depends on broken package AnnotationForge-1.11.3
    "BACA" # depends on broken package Category-2.35.1
    "BAGS" # build is broken
    "ballgown" # depends on broken package Rsamtools-1.21.8
    "bamsignals" # build is broken
    "bartMachine" # depends on broken package nlopt-2.4.2
    "Basic4Cseq" # depends on broken package Rsamtools-1.21.8
    "bayesDem" # depends on broken package nlopt-2.4.2
    "bayesLife" # depends on broken package nlopt-2.4.2
    "bayesPop" # depends on broken package nlopt-2.4.2
    "Bayesthresh" # depends on broken package nlopt-2.4.2
    "BBRecapture" # depends on broken package nlopt-2.4.2
    "BCA" # depends on broken package nlopt-2.4.2
    "BEAT" # depends on broken package Rsamtools-1.21.8
    "bgmm" # depends on broken package nlopt-2.4.2
    "bgx" # depends on broken package affyio-1.37.0
    "BIFIEsurvey" # depends on broken package nlopt-2.4.2
    "bigGP" # build is broken
    "BiGGR" # depends on broken package rsbml-2.27.0
    "BiodiversityR" # depends on broken package nlopt-2.4.2
    "biomvRCNS" # depends on broken package Rsamtools-1.21.8
    "biotools" # depends on broken package rpanel-1.1-3
    "biovizBase" # depends on broken package Rsamtools-1.21.8
    "birte" # build is broken
    "BiSEp" # depends on broken package GOSemSim-1.27.3
    "BiSeq" # depends on broken package Rsamtools-1.21.8
    "BitSeq" # depends on broken package Rsamtools-1.21.8
    "BLCOP" # depends on broken package Rsymphony-0.1-20
    "blmeco" # depends on broken package nlopt-2.4.2
    "blme" # depends on broken package nlopt-2.4.2
    "bmd" # depends on broken package nlopt-2.4.2
    "bmem" # depends on broken package nlopt-2.4.2
    "bootnet" # depends on broken package nlopt-2.4.2
    "boss" # depends on broken package nlopt-2.4.2
    "BradleyTerry2" # depends on broken package nlopt-2.4.2
    "BRugs" # build is broken
    "BSgenome" # depends on broken package Rsamtools-1.21.8
    "bumphunter" # depends on broken package Rsamtools-1.21.8
    "CADFtest" # depends on broken package nlopt-2.4.2
    "CAFE" # depends on broken package affyio-1.37.0
    "CAGEr" # depends on broken package Rsamtools-1.21.8
    "cAIC4" # depends on broken package nlopt-2.4.2
    "CAMERA" # depends on broken package mzR-2.3.1
    "canceR" # depends on broken package Category-2.35.1
    "candisc" # depends on broken package nlopt-2.4.2
    "carcass" # depends on broken package nlopt-2.4.2
    "car" # depends on broken package nlopt-2.4.2
    "caret" # depends on broken package nlopt-2.4.2
    "caretEnsemble" # depends on broken package nlopt-2.4.2
    "CARrampsOcl" # depends on broken package OpenCL-0.1-3
    "casper" # depends on broken package Rsamtools-1.21.8
    "Category" # Build Is Broken
    "categoryCompare" # depends on broken package Category-2.35.1
    "CCpop" # depends on broken package nlopt-2.4.2
    "cellHTS2" # depends on broken package Category-2.35.1
    "CexoR" # depends on broken package Rsamtools-1.21.8
    "ChainLadder" # depends on broken package nlopt-2.4.2
    "ChAMP" # depends on broken package affyio-1.37.0
    "charm" # depends on broken package affyio-1.37.0
    "ChemmineR" # Build Is Broken
    "chimera" # depends on broken package Rsamtools-1.21.8
    "chipenrich" # build is broken
    "chipPCR" # depends on broken nloptr-1.0.4
    "ChIPpeakAnno" # depends on broken package Rsamtools-1.21.8
    "ChIPQC" # depends on broken package AnnotationForge-1.11.3
    "ChIPseeker" # depends on broken package Rsamtools-1.21.8
    "chipseq" # depends on broken package Rsamtools-1.21.8
    "ChIPseqR" # depends on broken package Rsamtools-1.21.8
    "ChIPsim" # depends on broken package Rsamtools-1.21.8
    "ChIPXpress" # depends on broken package affyio-1.37.0
    "ChromHeatMap" # depends on broken package Rsamtools-1.21.8
    "cleanUpdTSeq" # depends on broken package Rsamtools-1.21.8
    "climwin" # depends on broken package nlopt-2.4.2
    "clipper" # depends on broken package Rsamtools-1.21.8
    "CLME" # depends on broken package nlopt-2.4.2
    "clpAPI" # build is broken
    "clusterPower" # depends on broken package nlopt-2.4.2
    "clusterProfiler" # depends on broken package GOSemSim-1.27.3
    "clusterSEs" # depends on broken AER-1.2-4
    "ClustGeo" # depends on broken FactoMineR-1.31.3
    "CNEr" # depends on broken package Rsamtools-1.21.8
    "cn_farms" # depends on broken package affyio-1.37.0
    "cn_mops" # depends on broken package Rsamtools-1.21.8
    "CNORfuzzy" # depends on broken package nlopt-2.4.2
    "CNVPanelizer" # depends on broken cn.mops-1.15.1
    "CNVrd2" # depends on broken package Rsamtools-1.21.8
    "cobindR" # depends on broken package Rsamtools-1.21.8
    "CoCiteStats" # Build Is Broken
    "CODEX" # depends on broken package Rsamtools-1.21.8
    "COHCAP" # build is broken
    "colorscience"
    "coMET" # depends on broken package Rsamtools-1.21.8
    "compEpiTools" # depends on broken package topGO-2.21.0
    "CompGO" # depends on broken package Category-2.35.1
    "conformal" # depends on broken package nlopt-2.4.2
    "ConsensusClusterPlus" # Build Is Broken
    "conumee" # depends on broken package Rsamtools-1.21.8
    "CopyNumber450k" # depends on broken package Rsamtools-1.21.8
    "CopywriteR" # depends on broken package Rsamtools-1.21.8
    "corHMM" # depends on broken package nlopt-2.4.2
    "Cormotif" # depends on broken package affyio-1.37.0
    "coRNAi" # depends on broken package Category-2.35.1
    "cosmiq" # depends on broken package mzR-2.3.1
    "CosmoPhotoz" # depends on broken package nlopt-2.4.2
    "CoverageView" # depends on broken package Rsamtools-1.21.8
    "cplexAPI" # build is broken
    "cpvSNP" # depends on broken package Rsamtools-1.21.8
    "CRISPRseek" # depends on broken package Rsamtools-1.21.8
    "crlmm" # depends on broken package affyio-1.37.0
    "Crossover" # Build Is Broken
    "CrypticIBDcheck" # depends on broken package nlopt-2.4.2
    "csaw" # depends on broken package Rsamtools-1.21.8
    "cudaBayesreg" # build is broken
    "cummeRbund" # depends on broken package Rsamtools-1.21.8
    "customProDB" # depends on broken package Rsamtools-1.21.8
    "daff" # depends on broken package V8-0.6
    "dagbag" # build is broken
    "dagLogo" # depends on broken package Rsamtools-1.21.8
    "DAMisc" # depends on broken package nlopt-2.4.2
    "DBKGrad" # depends on broken package rpanel-1.1-3
    "Deducer" # depends on broken package nlopt-2.4.2
    "DeducerExtras" # depends on broken package nlopt-2.4.2
    "DeducerPlugInExample" # depends on broken package nlopt-2.4.2
    "DeducerPlugInScaling" # depends on broken package nlopt-2.4.2
    "DeducerSpatial" # depends on broken package nlopt-2.4.2
    "DeducerSurvival" # depends on broken package nlopt-2.4.2
    "DeducerText" # depends on broken package nlopt-2.4.2
    "deepSNV" # depends on broken package Rsamtools-1.21.8
    "DEGraph" # depends on broken package RCytoscape-1.19.0
    "demi" # depends on broken package affyio-1.37.0
    "derfinder" # depends on broken package Rsamtools-1.21.8
    "derfinderPlot" # depends on broken package Rsamtools-1.21.8
    "destiny" # depends on broken package VIM-4.3.0
    "DEXSeq" # depends on broken package Rsamtools-1.21.8
    "DiagTest3Grp" # depends on broken package nlopt-2.4.2
    "DiffBind" # depends on broken package AnnotationForge-1.11.3
    "diffHic" # depends on broken package rhdf5-2.13.1
    "difR" # depends on broken package nlopt-2.4.2
    "DirichletMultinomial" # Build Is Broken
    "discSurv" # depends on broken package nlopt-2.4.2
    "DistatisR" # depends on broken package nlopt-2.4.2
    "diveRsity" # depends on broken package nlopt-2.4.2
    "DMRcate" # depends on broken package Rsamtools-1.21.8
    "DMRforPairs" # depends on broken package Rsamtools-1.21.8
    "domainsignatures" # build is broken
    "doMPI" # build is broken
    "DOQTL" # depends on broken package Rsamtools-1.21.8
    "DOSE" # depends on broken package GOSemSim-1.27.3
    "dpa" # depends on broken package nlopt-2.4.2
    "dpcR" # depends on broken nloptr-1.0.4
    "drc" # depends on broken package nlopt-2.4.2
    "drfit" # depends on broken package nlopt-2.4.2
    "drsmooth" # depends on broken package nlopt-2.4.2
    "DrugVsDisease" # depends on broken package affyio-1.37.0
    "dualKS" # depends on broken package affyio-1.37.0
    "dynlm" # depends on broken package nlopt-2.4.2
    "easyanova" # depends on broken package nlopt-2.4.2
    "easyRNASeq" # depends on broken package Rsamtools-1.21.8
    "EDASeq" # depends on broken package Rsamtools-1.21.8
    "edge" # depends on broken package nlopt-2.4.2
    "eeptools" # depends on broken package nlopt-2.4.2
    "EffectLiteR" # depends on broken package nlopt-2.4.2
    "effects" # depends on broken package nlopt-2.4.2
    "eiR" # depends on broken package ChemmineR-2.21.7
    "eisa" # depends on broken package Category-2.35.1
    "ELMER" # depends on broken package Rsamtools-1.21.8
    "EMA" # depends on broken package nlopt-2.4.2
    "ENmix" # depends on broken package affyio-1.37.0
    "EnQuireR" # depends on broken package nlopt-2.4.2
    "EnrichmentBrowser" # depends on broken package r-EDASeq-2.3.2
    "ensembldb" # depends on broken package interactiveDisplayBase-1.7.0
    "ensemblVEP" # depends on broken package Rsamtools-1.21.8
    "epigenomix" # depends on broken package Rsamtools-1.21.8
    "episplineDensity" # depends on broken package nlopt-2.4.2
    "epivizr" # depends on broken package Rsamtools-1.21.8
    "epr" # depends on broken package nlopt-2.4.2
    "erer" # depends on broken package nlopt-2.4.2
    "erma" # depends on broken GenomicFiles-1.5.4
    "erpR" # depends on broken package rpanel-1.1-3
    "ExiMiR" # depends on broken package affyio-1.37.0
    "exomeCopy" # depends on broken package Rsamtools-1.21.8
    "ExomeDepth" # depends on broken package Rsamtools-1.21.8
    "exomePeak" # depends on broken package Rsamtools-1.21.8
    "ExpressionView" # depends on broken package Category-2.35.1
    "extRemes" # depends on broken package nlopt-2.4.2
    "ez" # depends on broken package nlopt-2.4.2
    "facopy" # depends on broken package nlopt-2.4.2
    "FactoMineR" # depends on broken package nlopt-2.4.2
    "Factoshiny" # depends on broken package nlopt-2.4.2
    "faoutlier" # depends on broken package nlopt-2.4.2
    "farms" # depends on broken package affyio-1.37.0
    "fastLiquidAssociation" # depends on broken package LiquidAssociation-1.23.0
    "fastR" # depends on broken package nlopt-2.4.2
    "FDRreg" # depends on broken package nlopt-2.4.2
    "FEM" # build is broken
    "ffpe" # depends on broken package affyio-1.37.0
    "flagme" # depends on broken package mzR-2.3.1
    "flowDensity" # depends on broken package nlopt-2.4.2
    "flowPeaks" # build is broken
    "flowQ" # build is broken
    "FlowSOM" # depends on broken package ConsensusClusterPlus-1.23.0
    "flowStats" # depends on broken package ncdfFlow-2.15.2
    "flowVS" # depends on broken package ncdfFlow-2.15.2
    "flowWorkspace" # depends on broken package ncdfFlow-2.15.2
    "fmcsR" # depends on broken package ChemmineR-2.21.7
    "FourCSeq" # depends on broken package Rsamtools-1.21.8
    "fPortfolio" # depends on broken package Rsymphony-0.1-20
    "freqweights" # depends on broken package nlopt-2.4.2
    "frma" # depends on broken package affyio-1.37.0
    "frmaTools" # depends on broken package affyio-1.37.0
    "fscaret" # depends on broken package nlopt-2.4.2
    "FunciSNP" # depends on broken package snpStats-1.19.0
    "FunctionalNetworks" # Build Is Broken
    "fxregime" # depends on broken package nlopt-2.4.2
    "gamclass" # depends on broken package nlopt-2.4.2
    "gamlss_demo" # depends on broken package rpanel-1.1-3
    "gamm4" # depends on broken package nlopt-2.4.2
    "gCMAP" # depends on broken package Category-2.35.1
    "gCMAPWeb" # depends on broken package Category-2.35.1
    "gcmr" # depends on broken package nlopt-2.4.2
    "gcrma" # depends on broken package affyio-1.37.0
    "GDAtools" # depends on broken package nlopt-2.4.2
    "GENE_E" # depends on broken package rhdf5-2.13.1
    "GeneExpressionSignature" # depends on broken package annaffy-1.41.1
    "GeneticTools" # depends on broken package snpStats-1.19.0
    "genomation" # depends on broken package Rsamtools-1.21.8
    "GenomicAlignments" # depends on broken package Rsamtools-1.21.8
    "GenomicFeatures" # depends on broken package Rsamtools-1.21.8
    "GenomicFiles" # depends on broken package Rsamtools-1.21.8
    "GenomicInteractions" # depends on broken package Rsamtools-1.21.8
    "genotypeeval" # depends on broken package r-rtracklayer-1.29.12
    "GenoView" # depends on broken package Rsamtools-1.21.8
    "genridge" # depends on broken package nlopt-2.4.2
    "geojsonio" # depends on broken package V8-0.6
    "GEOsubmission" # depends on broken package affyio-1.37.0
    "gespeR" # depends on broken package Category-2.35.1
    "GEWIST" # depends on broken package nlopt-2.4.2
    "GGBase" # depends on broken package snpStats-1.19.0
    "ggbio" # depends on broken package Rsamtools-1.21.8
    "GGtools" # depends on broken package snpStats-1.19.0
    "gimme" # depends on broken package nlopt-2.4.2
    "girafe" # depends on broken package Rsamtools-1.21.8
    "gmapR" # depends on broken package Rsamtools-1.21.8
    "gmatrix" # depends on broken package cudatoolkit-5.5.22
    "gMCP" # build is broken
    "GOFunction" # build is broken
    "GOGANPA" # depends on broken package WGCNA-1.47
    "GoogleGenomics" # depends on broken package Rsamtools-1.21.8
    "goProfiles" # build is broken
    "GOSemSim" # Build Is Broken
    "goseq" # build is broken
    "GOSim" # depends on broken package topGO-2.21.0
    "GOstats" # depends on broken package AnnotationForge-1.11.3
    "GOTHiC" # depends on broken package Rsamtools-1.21.8
    "goTools" # build is broken
    "gplm" # depends on broken package nlopt-2.4.2
    "gputools" # depends on broken package cudatoolkit-5.5.22
    "gQTLstats" # depends on broken package snpStats-1.19.0
    "granova" # depends on broken package nlopt-2.4.2
    "graphicalVAR" # depends on broken package nlopt-2.4.2
    "GraphPCA" # depends on broken package nlopt-2.4.2
    "GreyListChIP" # depends on broken package Rsamtools-1.21.8
    "groHMM" # depends on broken package Rsamtools-1.21.8
    "GSCA" # depends on broken package rhdf5-2.13.1
    "GUIDE" # depends on broken package rpanel-1.1-3
    "Gviz" # depends on broken package Rsamtools-1.21.8
    "GWAF" # depends on broken package nlopt-2.4.2
    "gwascat" # depends on broken package interactiveDisplayBase-1.7.0
    "h2o" # build is broken
    "h5" # build is broken
    "h5vc" # depends on broken package rhdf5-2.13.1
    "Harshlight" # depends on broken package affyio-1.37.0
    "hbsae" # depends on broken package nlopt-2.4.2
    "heplots" # depends on broken package nlopt-2.4.2
    "hiAnnotator" # depends on broken package Rsamtools-1.21.8
    "hierGWAS"
    "HierO" # Build Is Broken
    "highriskzone"
    "HilbertVisGUI" # Build Is Broken
    "HiPLARM" # Build Is Broken
    "hiReadsProcessor" # depends on broken package Rsamtools-1.21.8
    "HistDAWass" # depends on broken package nlopt-2.4.2
    "HiTC" # depends on broken package Rsamtools-1.21.8
    "HLMdiag" # depends on broken package nlopt-2.4.2
    "HTqPCR" # depends on broken package affyio-1.37.0
    "HTSanalyzeR" # depends on broken package Category-2.35.1
    "HTSeqGenie" # depends on broken package Rsamtools-1.21.8
    "htSeqTools" # depends on broken package Rsamtools-1.21.8
    "hysteresis" # depends on broken package nlopt-2.4.2
    "IATscores" # depends on broken package nlopt-2.4.2
    "ibd" # depends on broken package nlopt-2.4.2
    "ibh" # build is broken
    "iccbeta" # depends on broken package nlopt-2.4.2
    "IdeoViz" # depends on broken package Rsamtools-1.21.8
    "ifaTools" # depends on broken package r-OpenMx-2.2.6
    "iFes" # depends on broken package cudatoolkit-5.5.22
    "imageHTS" # depends on broken package Category-2.35.1
    "immunoClust" # build is broken
    "imputeR" # depends on broken package nlopt-2.4.2
    "in2extRemes" # depends on broken package nlopt-2.4.2
    "inferference" # depends on broken package nlopt-2.4.2
    "influence_ME" # depends on broken package nlopt-2.4.2
    "InPAS" # depends on broken package Rsamtools-1.21.8
    "inSilicoMerging" # build is broken
    "INSPEcT" # depends on broken GenomicFeatures-1.21.13
    "intansv" # depends on broken package Rsamtools-1.21.8
    "interactiveDisplayBase" # build is broken
    "interactiveDisplay" # depends on broken package Category-2.35.1
    "interplot" # depends on broken arm-1.8-5
    "IONiseR" # depends on broken rhdf5-2.13.4
    "iptools"
    "IsingFit" # depends on broken package nlopt-2.4.2
    "IsoGene" # depends on broken package affyio-1.37.0
    "IsoGeneGUI" # depends on broken package affyio-1.37.0
    "ITALICS" # depends on broken package oligo-1.33.0
    "IVAS" # depends on broken package nlopt-2.4.2
    "ivpack" # depends on broken package nlopt-2.4.2
    "JAGUAR" # depends on broken package nlopt-2.4.2
    "jetset"
    "joda" # depends on broken package nlopt-2.4.2
    "jomo" # build is broken
    "js" # depends on broken package V8-0.6
    "KANT" # depends on broken package affyio-1.37.0
    "keggorthology" # build is broken
    "KEGGprofile" # Build Is Broken
    "lawn" # depends on broken package V8-0.6
    "learnstats" # depends on broken package nlopt-2.4.2
    "lefse" # build is broken
    "lessR" # depends on broken package nlopt-2.4.2
    "lfe" # build is broken
    "lgcp" # depends on broken package rpanel-1.1-3
    "limmaGUI" # depends on broken package affyio-1.37.0
    "LinRegInteractive" # depends on broken package rpanel-1.1-3
    "LiquidAssociation" # build is broken
    "lmdme" # build is broken
    "lme4" # depends on broken package nlopt-2.4.2
    "LMERConvenienceFunctions" # depends on broken package nlopt-2.4.2
    "lmerTest" # depends on broken package nlopt-2.4.2
    "LMGene" # depends on broken package affyio-1.37.0
    "lmSupport" # depends on broken package nlopt-2.4.2
    "LogisticDx" # depends on broken package nlopt-2.4.2
    "logitT" # depends on broken package affyio-1.37.0
    "longpower" # depends on broken package nlopt-2.4.2
    "LowMACA" # depends on broken package Rsamtools-1.21.8
    "lumi" # depends on broken package affyio-1.37.0
    "LVSmiRNA" # depends on broken package affyio-1.37.0
    "M3D" # depends on broken package Rsamtools-1.21.8
    "MAIT" # depends on broken package nlopt-2.4.2
    "makecdfenv" # depends on broken package affyio-1.37.0
    "mAPKL" # build is broken
    "maPredictDSC" # depends on broken package nlopt-2.4.2
    "marked" # depends on broken package nlopt-2.4.2
    "maskBAD" # depends on broken package affyio-1.37.0
    "MatrixRider" # depends on broken package DirichletMultinomial-1.11.1
    "MaxPro" # depends on broken package nlopt-2.4.2
    "mbest" # depends on broken package nlopt-2.4.2
    "MBmca" # depends on broken nloptr-1.0.4
    "mBPCR" # depends on broken package affyio-1.37.0
    "mcaGUI" # depends on broken package Rsamtools-1.21.8
    "MCRestimate" # build is broken
    "mdgsa" # build is broken
    "meboot" # depends on broken package nlopt-2.4.2
    "mediation" # depends on broken package r-lme4-1.1-8
    "MEDIPS" # depends on broken package Rsamtools-1.21.8
    "MEDME" # depends on broken package nlopt-2.4.2
    "MEMSS" # depends on broken package nlopt-2.4.2
    "meshr" # depends on broken package Category-2.35.1
    "Metab" # depends on broken package mzR-2.3.1
    "metagear" # build is broken
    "metagene" # depends on broken package Rsamtools-1.21.8
    "metaMix" # build is broken
    "metaMS" # depends on broken package mzR-2.3.1
    "metaplus" # depends on broken package nlopt-2.4.2
    "metaSEM" # depends on broken package OpenMx-2.2.4
    "metaseqR" # depends on broken package affyio-1.37.0
    "Metatron" # depends on broken package nlopt-2.4.2
    "methyAnalysis" # depends on broken package affyio-1.37.0
    "MethylAid" # depends on broken package Rsamtools-1.21.8
    "methylPipe" # depends on broken package Rsamtools-1.21.8
    "MethylSeekR" # depends on broken package Rsamtools-1.21.8
    "methylumi" # depends on broken package Rsamtools-1.21.8
    "miceadds" # depends on broken package nlopt-2.4.2
    "micEconAids" # depends on broken package nlopt-2.4.2
    "micEconCES" # depends on broken package nlopt-2.4.2
    "micEconSNQP" # depends on broken package nlopt-2.4.2
    "mi" # depends on broken package nlopt-2.4.2
    "MigClim" # Build Is Broken
    "migui" # depends on broken package nlopt-2.4.2
    "MineICA" # depends on broken package AnnotationForge-1.11.3
    "minfi" # depends on broken package Rsamtools-1.21.8
    "minimist" # depends on broken package V8-0.6
    "MinimumDistance" # depends on broken package affyio-1.37.0
    "mirIntegrator" # build is broken
    "missDeaths"
    "missMDA" # depends on broken package nlopt-2.4.2
    "missMethyl" # depends on broken package Rsamtools-1.21.8
    "mitoODE" # build is broken
    "mixAK" # depends on broken package nlopt-2.4.2
    "mixlm" # depends on broken package nlopt-2.4.2
    "MixMAP" # depends on broken package nlopt-2.4.2
    "mlmRev" # depends on broken package nlopt-2.4.2
    "MLP" # depends on broken package affyio-1.37.0
    "MLSeq" # depends on broken package nlopt-2.4.2
    "mlVAR" # depends on broken package nlopt-2.4.2
    "MMDiff" # depends on broken package AnnotationForge-1.11.3
    "MmPalateMiRNA" # depends on broken package affyio-1.37.0
    "mongolite" # build is broken
    "monocle" # build is broken
    "mosaic" # depends on broken package nlopt-2.4.2
    "MotifDb" # depends on broken package Rsamtools-1.21.8
    "motifRG" # depends on broken package Rsamtools-1.21.8
    "motifStack" # depends on broken package Rsamtools-1.21.8
    "MotIV" # depends on broken package Rsamtools-1.21.8
    "MSeasy" # depends on broken package mzR-2.3.1
    "MSeasyTkGUI" # depends on broken package mzR-2.3.1
    "MSGFgui" # depends on broken package MSGFplus-1.3.0
    "MSGFplus" # Build Is Broken
    "msmsEDA" # depends on broken package affyio-1.37.0
    "msmsTests" # depends on broken package affyio-1.37.0
    "MSnbase" # depends on broken package affyio-1.37.0
    "MSnID" # depends on broken package affyio-1.37.0
    "MSstats" # depends on broken package nlopt-2.4.2
    "multiDimBio" # depends on broken package nlopt-2.4.2
    "MultiRR" # depends on broken package nlopt-2.4.2
    "muma" # depends on broken package nlopt-2.4.2
    "munsellinterpol"
    "mutossGUI" # build is broken
    "mvGST" # depends on broken package AnnotationForge-1.11.3
    "mvinfluence" # depends on broken package nlopt-2.4.2
    "mygene" # depends on broken package Rsamtools-1.21.8
    "mzR" # build is broken
    "NanoStringQCPro" # build is broken
    "nCal" # depends on broken package nlopt-2.4.2
    "ncdfFlow" # build is broken
    "NCIgraph" # depends on broken package RCytoscape-1.19.0
    "netbenchmark" # build is broken
    "nettools" # depends on broken package WGCNA-1.47
    "NGScopy"
    "NHPoisson" # depends on broken package nlopt-2.4.2
    "nloptr" # depends on broken package nlopt-2.4.2
    "nondetects" # depends on broken package affyio-1.37.0
    "nonrandom" # depends on broken package nlopt-2.4.2
    "NormqPCR" # depends on broken package affyio-1.37.0
    "NORRRM" # build is broken
    "npIntFactRep" # depends on broken package nlopt-2.4.2
    "nucleR" # depends on broken package Rsamtools-1.21.8
    "oligoClasses" # depends on broken package affyio-1.37.0
    "oligo" # depends on broken package affyio-1.37.0
    "OmicsMarkeR" # depends on broken package nlopt-2.4.2
    "oneChannelGUI" # depends on broken package affyio-1.37.0
    "OpenCL" # build is broken
    "openCyto" # depends on broken package ncdfFlow-2.15.2
    "OpenMx" # build is broken
    "OperaMate" # depends on broken package Category-2.35.1
    "optBiomarker" # depends on broken package rpanel-1.1-3
    "ora" # depends on broken package ROracle-1.1-12
    "ordBTL" # depends on broken package nlopt-2.4.2
    "OrganismDbi" # depends on broken package Rsamtools-1.21.8
    "OTUbase" # depends on broken package Rsamtools-1.21.8
    "OUwie" # depends on broken package nlopt-2.4.2
    "PADOG" # build is broken
    "pamm" # depends on broken package nlopt-2.4.2
    "PANDA" # build is broken
    "panelAR" # depends on broken package nlopt-2.4.2
    "panp" # depends on broken package affyio-1.37.0
    "papeR" # depends on broken package nlopt-2.4.2
    "parboost" # depends on broken package nlopt-2.4.2
    "parma" # depends on broken package nlopt-2.4.2
    "Pasha" # depends on broken package GenomicAlignments-1.5.12
    "pathClass" # depends on broken package affyio-1.37.0
    "pathRender" # build is broken
    "pathview" # build is broken
    "PatternClass" # build is broken
    "Pbase" # depends on broken package affyio-1.37.0
    "pbdBASE" # depends on broken package pbdSLAP-0.2-0
    "pbdDEMO" # depends on broken package pbdSLAP-0.2-0
    "pbdDMAT" # depends on broken package pbdSLAP-0.2-0
    "pbdSLAP" # build is broken
    "PBImisc" # depends on broken package nlopt-2.4.2
    "pbkrtest" # depends on broken package nlopt-2.4.2
    "PBSddesolve" # build is broken
    "PBSmapping" # build is broken
    "pcaBootPlot" # depends on broken FactoMineR-1.31.3
    "pcaL1" # build is broken
    "PCpheno" # depends on broken package Category-2.35.1
    "pdInfoBuilder" # depends on broken package affyio-1.37.0
    "pdmclass" # build is broken
    "PECA" # depends on broken package affyio-1.37.0
    "pedigreemm" # depends on broken package nlopt-2.4.2
    "pedometrics" # depends on broken package nlopt-2.4.2
    "pequod" # depends on broken package nlopt-2.4.2
    "permGPU" # build is broken
    "PGA" # depends on broken package Rsamtools-1.21.8
    "PGSEA" # depends on broken package annaffy-1.41.1
    "PharmacoGx"
    "phenoDist" # depends on broken package Category-2.35.1
    "phenoTest" # depends on broken package Category-2.35.1
    "PhenStat" # depends on broken package nlopt-2.4.2
    "phia" # depends on broken package nlopt-2.4.2
    "phylocurve" # depends on broken package nlopt-2.4.2
    "phyloTop" # depends on broken package nlopt-2.4.2
    "PICS" # depends on broken package Rsamtools-1.21.8
    "PING" # depends on broken package Rsamtools-1.21.8
    "plateCore" # depends on broken package ncdfFlow-2.15.2
    "plier" # depends on broken package affyio-1.37.0
    "plsRbeta" # depends on broken package nlopt-2.4.2
    "plsRcox" # depends on broken package nlopt-2.4.2
    "plsRglm" # depends on broken package nlopt-2.4.2
    "plw" # depends on broken package affyio-1.37.0
    "pmclust" # build is broken
    "pmm" # depends on broken package nlopt-2.4.2
    "podkat" # depends on broken package Rsamtools-1.21.8
    "polytomous" # depends on broken package nlopt-2.4.2
    "pomp" # depends on broken package nlopt-2.4.2
    "ppiPre" # depends on broken package GOSemSim-1.27.3
    "ppiStats" # depends on broken package Category-2.35.1
    "prebs" # depends on broken package affyio-1.37.0
    "predictmeans" # depends on broken package nlopt-2.4.2
    "prLogistic" # depends on broken package nlopt-2.4.2
    "proBAMr" # depends on broken package Rsamtools-1.21.8
    "ProCoNA" # depends on broken package AnnotationForge-1.11.3
    "pRoloc" # depends on broken package nlopt-2.4.2
    "pRolocGUI" # depends on broken package nlopt-2.4.2
    "proteoQC" # depends on broken package affyio-1.37.0
    "PSAboot" # depends on broken package nlopt-2.4.2
    "ptw" # depends on broken nloptr-1.0.4
    "puma" # depends on broken package affyio-1.37.0
    "pvac" # depends on broken package affyio-1.37.0
    "pvca" # depends on broken package nlopt-2.4.2
    "Pviz" # depends on broken package Rsamtools-1.21.8
    "pwOmics" # depends on broken package interactiveDisplayBase-1.7.0
    "PythonInR"
    "qcmetrics" # build is broken
    "QDNAseq" # depends on broken package Rsamtools-1.21.8
    "QFRM"
    "qgraph" # depends on broken package nlopt-2.4.2
    "qpcrNorm" # depends on broken package affyio-1.37.0
    "qpgraph" # depends on broken package Rsamtools-1.21.8
    "qrqc" # depends on broken package Rsamtools-1.21.8
    "qtbase" # build is broken
    "qtlnet" # depends on broken package nlopt-2.4.2
    "qtpaint" # depends on broken package qtbase-1.0.9
    "qtutils" # depends on broken package qtbase-1.0.9
    "QUALIFIER" # depends on broken package ncdfFlow-2.15.2
    "quantification" # depends on broken package nlopt-2.4.2
    "quantro" # depends on broken package Rsamtools-1.21.8
    "QuasR" # depends on broken package Rsamtools-1.21.8
    "R2STATS" # depends on broken package nlopt-2.4.2
    "R3CPET" # depends on broken package Rsamtools-1.21.8
    "r3Cseq" # depends on broken package Rsamtools-1.21.8
    "R453Plus1Toolbox" # depends on broken package Rsamtools-1.21.8
    "radiant" # depends on broken package nlopt-2.4.2
    "raincpc" # build is broken
    "rainfreq" # build is broken
    "RamiGO" # depends on broken package RCytoscape-1.19.0
    "RapidPolygonLookup" # depends on broken package PBSmapping-2.69.76
    "RAPIDR" # depends on broken package Rsamtools-1.21.8
    "RareVariantVis" # depends on broken VariantAnnotation-1.15.19
    "Rariant" # depends on broken package Rsamtools-1.21.8
    "rasclass" # depends on broken package nlopt-2.4.2
    "RBerkeley"
    "RbioRXN" # depends on broken package ChemmineR-2.21.7
    "Rcade" # depends on broken package Rsamtools-1.21.8
    "rCGH" # depends on broken package r-affy-1.47.1
    "Rchemcpp" # depends on broken package ChemmineR-2.21.7
    "Rcmdr" # depends on broken package nlopt-2.4.2
    "RcmdrMisc" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_BCA" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_coin" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_depthTools" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_DoE" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_doex" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_EACSPIR" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_EBM" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_EcoVirtual" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_epack" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_EZR" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_FactoMineR" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_HH" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_IPSUR" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_KMggplot2" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_lfstat" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_MA" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_mosaic" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_MPAStats" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_NMBU" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_orloca" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_plotByGroup" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_pointG" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_qual" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_RMTCJags" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_ROC" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_sampling" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_SCDA" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_seeg" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_SLC" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_SM" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_sos" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_steepness" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_survival" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_TeachingDemos" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_temis" # depends on broken package nlopt-2.4.2
    "RcmdrPlugin_UCA" # depends on broken package nlopt-2.4.2
    "Rcpi" # depends on broken package ChemmineR-2.21.7
    "Rcplex" # Build Is Broken
    "RcppAPT" # Build Is Broken
    "RcppOctave" # build is broken
    "RcppRedis" # build is broken
    "RCytoscape" # Build Is Broken
    "RDAVIDWebService" # depends on broken package Category-2.35.1
    "rdd" # depends on broken package nlopt-2.4.2
    "rddtools" # depends on broken package r-AER-1.2-4
    "rDEA" # build is broken
    "RDieHarder" # build is broken
    "ReactomePA" # depends on broken package GOSemSim-1.27.3
    "ReadqPCR" # depends on broken package affyio-1.37.0
    "REBayes" # depends on broken package Rmosek-1.2.5.1
    "REDseq" # depends on broken package Rsamtools-1.21.8
    "referenceIntervals" # depends on broken package nlopt-2.4.2
    "RefNet" # depends on broken package interactiveDisplayBase-1.7.0
    "RefPlus" # depends on broken package affyio-1.37.0
    "refund" # depends on broken package nlopt-2.4.2
    "regioneR" # depends on broken package Rsamtools-1.21.8
    "regionReport" # depends on broken package Rsamtools-1.21.8
    "repijson" # depends on broken package V8-0.6
    "Repitools" # depends on broken package affyio-1.37.0
    "ReportingTools" # depends on broken package Category-2.35.1
    "ReQON" # depends on broken package Rsamtools-1.21.8
    "REST" # depends on broken package nlopt-2.4.2
    "rfPred" # depends on broken package Rsamtools-1.21.8
    "rGADEM" # depends on broken package Rsamtools-1.21.8
    "rgbif" # depends on broken package V8-0.6
    "Rgnuplot"
    "rgp" # build is broken
    "rgpui" # depends on broken package rgp-0.4-1
    "rgsepd" # depends on broken package goseq-1.21.1
    "rhdf5" # build is broken
    "rHVDM" # depends on broken package affyio-1.37.0
    "Ringo" # depends on broken package affyio-1.37.0
    "RIPSeeker" # depends on broken package Rsamtools-1.21.8
    "Risa" # depends on broken package affyio-1.37.0
    "rjade" # depends on broken package V8-0.6
    "rJPSGCS" # build is broken
    "rLindo" # build is broken
    "RMassBank" # depends on broken package mzR-2.3.1
    "rMAT" # build is broken
    "rmgarch" # depends on broken package nlopt-2.4.2
    "rminer" # depends on broken package nlopt-2.4.2
    "RmiR" # Build Is Broken
    "Rmosek" # build is broken
    "RNAinteract" # depends on broken package Category-2.35.1
    "RNAither" # depends on broken package nlopt-2.4.2
    "RNAprobR" # depends on broken package Rsamtools-1.21.8
    "rnaSeqMap" # depends on broken package Rsamtools-1.21.8
    "RnaSeqSampleSize" # Build Is Broken
    "RnavGraph" # build is broken
    "RnBeads" # depends on broken package Rsamtools-1.21.8
    "Rnits" # depends on broken package affyio-1.37.0
    "roar" # depends on broken package Rsamtools-1.21.8
    "RobLoxBioC" # depends on broken package affyio-1.37.0
    "robustlmm" # depends on broken package nlopt-2.4.2
    "rockchalk" # depends on broken package nlopt-2.4.2
    "ROI_plugin_symphony" # depends on broken package Rsymphony-0.1-20
    "Rolexa" # depends on broken package Rsamtools-1.21.8
    "rols" # build is broken
    "ROracle" # Build Is Broken
    "RPA" # depends on broken package affyio-1.37.0
    "rpanel" # build is broken
    "rpubchem" # depends on broken package nlopt-2.4.2
    "Rqc" # depends on broken package Rsamtools-1.21.8
    "RQuantLib" # build is broken
    "rr" # depends on broken package nlopt-2.4.2
    "Rsamtools" # Build Is Broken
    "RSAP" # build is broken
    "rsbml" # build is broken
    "rscala" # build is broken
    "RSDA" # depends on broken package nlopt-2.4.2
    "rSFFreader" # depends on broken package Rsamtools-1.21.8
    "Rsubread" # Build Is Broken
    "RSVSim" # depends on broken package Rsamtools-1.21.8
    "Rsymphony" # build is broken
    "rTANDEM" # build is broken
    "RTN" # depends on broken package nlopt-2.4.2
    "rtracklayer" # depends on broken package Rsamtools-1.21.8
    "rTRMui" # depends on broken package Rsamtools-1.21.8
    "rugarch" # depends on broken package nlopt-2.4.2
    "RUVcorr" # build is broken
    "RUVnormalize" # Build Is Broken
    "RUVSeq" # depends on broken package Rsamtools-1.21.8
    "RVAideMemoire" # depends on broken package nlopt-2.4.2
    "RVFam" # depends on broken package nlopt-2.4.2
    "RVideoPoker" # depends on broken package rpanel-1.1-3
    "ryouready" # depends on broken package nlopt-2.4.2
    "sampleSelection" # depends on broken package nlopt-2.4.2
    "sapFinder" # depends on broken package rTANDEM-1.9.0
    "SCAN_UPC" # depends on broken package affyio-1.37.0
    "ScISI" # depends on broken package apComplex-2.35.0
    "sdcMicro" # depends on broken package nlopt-2.4.2
    "sdcMicroGUI" # depends on broken package nlopt-2.4.2
    "SDD" # depends on broken package rpanel-1.1-3
    "seeg" # depends on broken package nlopt-2.4.2
    "segmentSeq" # depends on broken package Rsamtools-1.21.8
    "sem" # depends on broken package nlopt-2.4.2
    "semdiag" # depends on broken package nlopt-2.4.2
    "SemDist" # Build Is Broken
    "semGOF" # depends on broken package nlopt-2.4.2
    "semPlot" # depends on broken package nlopt-2.4.2
    "SensoMineR" # depends on broken package nlopt-2.4.2
    "SEPA" # depends on broken package topGO-2.21.0
    "seq2pathway" # depends on broken package WGCNA-1.47
    "SeqArray" # depends on broken package Rsamtools-1.21.8
    "seqbias" # depends on broken package Rsamtools-1.21.8
    "seqCNA" # build is broken
    "SeqGrapheR" # Build Is Broken
    "seqplots" # depends on broken package Rsamtools-1.21.8
    "seqTools" # build is broken
    "SeqVarTools" # depends on broken package Rsamtools-1.21.8
    "SGSeq" # depends on broken package Rsamtools-1.21.8
    "shinyMethyl" # depends on broken package Rsamtools-1.21.8
    "shinyTANDEM" # depends on broken package rTANDEM-1.9.0
    "ShortRead" # depends on broken package Rsamtools-1.21.8
    "SIMAT" # depends on broken package mzR-2.3.1
    "SimBindProfiles" # depends on broken package affyio-1.37.0
    "similaRpeak" # depends on broken package Rsamtools-1.21.8
    "simpleaffy" # depends on broken package affyio-1.37.0
    "SimRAD" # depends on broken package Rsamtools-1.21.8
    "sirt" # depends on broken package nlopt-2.4.2
    "sjPlot" # depends on broken package nlopt-2.4.2
    "skewr" # depends on broken package affyio-1.37.0
    "SLGI" # depends on broken package apComplex-2.35.0
    "SNAGEE" # build is broken
    "snapCGH" # depends on broken package tilingArray-1.47.0
    "snm" # depends on broken package nlopt-2.4.2
    "SNPchip" # depends on broken package affyio-1.37.0
    "snpEnrichment" # depends on broken package snpStats-1.19.0
    "snpStats" # build is broken
    "snpStatsWriter" # depends on broken package snpStats-1.19.0
    "SNPtools" # depends on broken package Rsamtools-1.21.8
    "SOD" # depends on broken package cudatoolkit-5.5.22
    "soGGi" # depends on broken package Rsamtools-1.21.8
    "soilphysics" # depends on broken package rpanel-1.1-3
    "SomaticSignatures" # depends on broken package Rsamtools-1.21.8
    "SoyNAM" # depends on broken package r-lme4-1.1-8
    "spacom" # depends on broken package nlopt-2.4.2
    "specificity" # depends on broken package nlopt-2.4.2
    "spliceR" # depends on broken package Rsamtools-1.21.8
    "SplicingGraphs" # depends on broken package Rsamtools-1.21.8
    "spocc" # depends on broken package V8-0.6
    "spoccutils" # depends on broken spocc-0.3.0
    "spsann" # depends on broken package r-pedometrics-0.6-2
    "sscore" # depends on broken package affyio-1.37.0
    "ssmrob" # depends on broken package nlopt-2.4.2
    "ssviz" # depends on broken package Rsamtools-1.21.8
    "stagePop" # depends on broken package PBSddesolve-1.11.29
    "staRank" # depends on broken package Category-2.35.1
    "Starr" # depends on broken package affyio-1.37.0
    "STATegRa" # depends on broken package affyio-1.37.0
    "stcm" # depends on broken package nlopt-2.4.2
    "stepp" # depends on broken package nlopt-2.4.2
    "stringgaussnet" # build is broken
    "Surrogate" # depends on broken package nlopt-2.4.2
    "SVM2CRM" # depends on broken package Rsamtools-1.21.8
    "sybilSBML" # build is broken
    "synapter" # depends on broken package affyio-1.37.0
    "systemfit" # depends on broken package nlopt-2.4.2
    "systemPipeR" # depends on broken package AnnotationForge-1.11.3
    "TargetSearch" # depends on broken package mzR-2.3.1
    "TcGSA" # depends on broken package nlopt-2.4.2
    "TDMR" # depends on broken package nlopt-2.4.2
    "TEQC" # depends on broken package Rsamtools-1.21.8
    "TFBSTools" # depends on broken package DirichletMultinomial-1.11.1
    "tigerstats" # depends on broken package nlopt-2.4.2
    "tilingArray" # depends on broken package affyio-1.37.0
    "TIN" # depends on broken package WGCNA-1.47
    "TitanCNA" # depends on broken package Rsamtools-1.21.8
    "ToPASeq" # depends on broken package Rsamtools-1.21.8
    "topGO" # build is broken
    "topologyGSA" # depends on broken package Rsamtools-1.21.8
    "tracktables" # depends on broken package Rsamtools-1.21.8
    "trackViewer" # depends on broken package Rsamtools-1.21.8
    "translateSPSS2R" # depends on broken car-2.0-25
    "tRanslatome" # depends on broken package GOSemSim-1.27.3
    "TransView" # depends on broken package Rsamtools-1.21.8
    "traseR"
    "TriMatch" # depends on broken package nlopt-2.4.2
    "TROM" # depends on broken package topGO-2.21.0
    "TurboNorm" # depends on broken package affyio-1.37.0
    "unifiedWMWqPCR" # depends on broken package affyio-1.37.0
    "userfriendlyscience" # depends on broken package nlopt-2.4.2
    "V8" # build is broken
    "VanillaICE" # depends on broken package affyio-1.37.0
    "variancePartition" # depends on broken package lme4-1.1-8
    "VariantAnnotation" # depends on broken package Rsamtools-1.21.8
    "VariantFiltering" # depends on broken package Rsamtools-1.21.8
    "VariantTools" # depends on broken package Rsamtools-1.21.8
    "VIM" # depends on broken package nlopt-2.4.2
    "VIMGUI" # depends on broken package nlopt-2.4.2
    "vmsbase" # depends on broken package PBSmapping-2.69.76
    "vows" # depends on broken package nlopt-2.4.2
    "vsn" # depends on broken package affyio-1.37.0
    "vtpnet" # depends on broken package interactiveDisplayBase-1.7.0
    "wateRmelon" # depends on broken package affyio-1.37.0
    "wavClusteR" # depends on broken package Rsamtools-1.21.8
    "waveTiling" # depends on broken package affyio-1.37.0
    "webbioc" # depends on broken package affyio-1.37.0
    "wfe" # depends on broken package nlopt-2.4.2
    "WGCNA" # build is broken
    "wgsea" # depends on broken package snpStats-1.19.0
    "WideLM" # depends on broken package cudatoolkit-5.5.22
    "xcms" # depends on broken package mzR-2.3.1
    "xergm" # depends on broken package nlopt-2.4.2
    "xps" # build is broken
    "yaqcaffy" # depends on broken package affyio-1.37.0
    "ZeligMultilevel" # depends on broken package nlopt-2.4.2
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
      preConfigure = "export LIBXML_INCDIR=${pkgs.libxml2}/include/libxml2";
    });

    curl = old.curl.overrideDerivation (attrs: {
      preConfigure = "patchShebangs configure";
    });

    iFes = old.iFes.overrideDerivation (attrs: {
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
      CUDA_INC_PATH = "${pkgs.cudatoolkit}/include";
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

    V8 = old.V8.overrideDerivation (attrs: {
      preConfigure = "export V8_INCLUDES=${pkgs.v8}/include";
    });

  };
in
  self
