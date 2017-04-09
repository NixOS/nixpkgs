/* This file defines the composition for CRAN (R) packages. */

{ R, pkgs, overrides }:

let
  inherit (pkgs) fetchurl stdenv lib;

  buildRPackage = pkgs.callPackage ./generic-builder.nix {
    inherit R;
    inherit (pkgs.darwin.apple_sdk.frameworks) Cocoa Foundation;
    inherit (pkgs) gettext gfortran;
  };

  # Generates package templates given per-repository settings
  #
  # some packages, e.g. cncaGUI, require X running while installation,
  # so that we use xvfb-run if requireX is true.
  mkDerive = {mkHomepage, mkUrls}: args:
      lib.makeOverridable ({
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
      urls = mkUrls (args // { inherit name version; });
    };
    inherit doCheck requireX;
    propagatedBuildInputs = depends;
    nativeBuildInputs = depends;
    meta.homepage = mkHomepage (args // { inherit name; });
    meta.platforms = R.meta.platforms;
    meta.hydraPlatforms = hydraPlatforms;
    meta.broken = broken;
  });

  # Templates for generating Bioconductor and CRAN packages
  # from the name, version, sha256, and optional per-package arguments above
  #
  deriveBioc = mkDerive {
    mkHomepage = {name, rVersion}: "https://bioconductor.org/packages/${rVersion}/bioc/html/${name}.html";
    mkUrls = {name, version, rVersion}: [ "mirror://bioc/${rVersion}/bioc/src/contrib/${name}_${version}.tar.gz" ];
  };
  deriveBiocAnn = mkDerive {
    mkHomepage = {name, rVersion}: "http://www.bioconductor.org/packages/${name}.html";
    mkUrls = {name, version, rVersion}: [ "mirror://bioc/${rVersion}/data/annotation/src/contrib/${name}_${version}.tar.gz" ];
  };
  deriveBiocExp = mkDerive {
    mkHomepage = {name, rVersion}: "http://www.bioconductor.org/packages/${name}.html";
    mkUrls = {name, version, rVersion}: [ "mirror://bioc/${rVersion}/data/experiment/src/contrib/${name}_${version}.tar.gz" ];
  };
  deriveCran = mkDerive {
    mkHomepage = {name, snapshot}: "http://mran.revolutionanalytics.com/snapshot/${snapshot}/web/packages/${name}/";
    mkUrls = {name, version, snapshot}: [ "http://mran.revolutionanalytics.com/snapshot/${snapshot}/src/contrib/${name}_${version}.tar.gz" ];
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
          import ./bioc-annotation-packages.nix { inherit self; derive = deriveBiocAnn; } //
          import ./bioc-experiment-packages.nix { inherit self; derive = deriveBiocExp; } //
          import ./cran-packages.nix { inherit self; derive = deriveCran; };

  # tweaks for the individual packages and "in self" follow

  packagesWithRDepends = {
    FactoMineR = [ self.car ];
    pander = [ self.codetools ];
  };

  packagesWithNativeBuildInputs = {
    abn = [ pkgs.gsl_1 ];
    adimpro = [ pkgs.imagemagick ];
    audio = [ pkgs.portaudio ];
    BayesSAE = [ pkgs.gsl_1 ];
    BayesVarSel = [ pkgs.gsl_1 ];
    BayesXsrc = [ pkgs.readline.dev pkgs.ncurses ];
    bigGP = [ pkgs.openmpi ];
    bio3d = [ pkgs.zlib ];
    BiocCheck = [ pkgs.which ];
    Biostrings = [ pkgs.zlib ];
    bnpmr = [ pkgs.gsl_1 ];
    cairoDevice = [ pkgs.gtk2.dev ];
    Cairo = [ pkgs.libtiff pkgs.libjpeg pkgs.cairo.dev pkgs.x11 pkgs.fontconfig.lib ];
    Cardinal = [ pkgs.which ];
    chebpol = [ pkgs.fftw ];
    ChemmineOB = [ pkgs.openbabel pkgs.pkgconfig ];
    cit = [ pkgs.gsl_1 ];
    curl = [ pkgs.curl.dev ];
    devEMF = [ pkgs.xorg.libXft.dev pkgs.x11 ];
    diversitree = [ pkgs.gsl_1 pkgs.fftw ];
    EMCluster = [ pkgs.liblapack ];
    fftw = [ pkgs.fftw.dev ];
    fftwtools = [ pkgs.fftw.dev ];
    Formula = [ pkgs.gmp ];
    geoCount = [ pkgs.gsl_1 ];
    git2r = [ pkgs.zlib.dev pkgs.openssl.dev ];
    GLAD = [ pkgs.gsl_1 ];
    glpkAPI = [ pkgs.gmp pkgs.glpk ];
    gmp = [ pkgs.gmp.dev ];
    graphscan = [ pkgs.gsl_1 ];
    gsl = [ pkgs.gsl_1 ];
    h5 = [ pkgs.hdf5-cpp pkgs.which ];
    h5vc = [ pkgs.zlib.dev ];
    HiCseg = [ pkgs.gsl_1 ];
    iBMQ = [ pkgs.gsl_1 ];
    igraph = [ pkgs.gmp ];
    JavaGD = [ pkgs.jdk ];
    jpeg = [ pkgs.libjpeg.dev ];
    KFKSDS = [ pkgs.gsl_1 ];
    kza = [ pkgs.fftw.dev ];
    libamtrack = [ pkgs.gsl_1 ];
    mixcat = [ pkgs.gsl_1 ];
    mvabund = [ pkgs.gsl_1 ];
    mwaved = [ pkgs.fftw.dev ];
    ncdf4 = [ pkgs.netcdf ];
    nloptr = [ pkgs.nlopt ];
    openssl = [ pkgs.openssl.dev ];
    outbreaker = [ pkgs.gsl_1 ];
    pander = [ pkgs.pandoc pkgs.which ];
    pbdMPI = [ pkgs.openmpi ];
    pbdNCDF4 = [ pkgs.netcdf ];
    pbdPROF = [ pkgs.openmpi ];
    PKI = [ pkgs.openssl.dev ];
    png = [ pkgs.libpng.dev ];
    PopGenome = [ pkgs.zlib.dev ];
    proj4 = [ pkgs.proj ];
    qtbase = [ pkgs.qt4 ];
    qtpaint = [ pkgs.qt4 ];
    R2GUESS = [ pkgs.gsl_1 ];
    R2SWF = [ pkgs.zlib pkgs.libpng pkgs.freetype.dev ];
    RAppArmor = [ pkgs.libapparmor ];
    rapportools = [ pkgs.which ];
    rapport = [ pkgs.which ];
    rbamtools = [ pkgs.zlib.dev ];
    rcdd = [ pkgs.gmp.dev ];
    RcppCNPy = [ pkgs.zlib.dev ];
    RcppGSL = [ pkgs.gsl_1 ];
    RcppOctave = [ pkgs.zlib pkgs.bzip2.dev pkgs.icu pkgs.lzma.dev pkgs.pcre.dev pkgs.octave ];
    RcppZiggurat = [ pkgs.gsl_1 ];
    rgdal = [ pkgs.proj pkgs.gdal ];
    rgeos = [ pkgs.geos ];
    rggobi = [ pkgs.ggobi pkgs.gtk2.dev pkgs.libxml2.dev ];
    rgl = [ pkgs.mesa pkgs.xlibsWrapper ];
    Rglpk = [ pkgs.glpk ];
    RGtk2 = [ pkgs.gtk2.dev ];
    rhdf5 = [ pkgs.zlib ];
    Rhpc = [ pkgs.zlib pkgs.bzip2.dev pkgs.icu pkgs.lzma.dev pkgs.openmpi pkgs.pcre.dev ];
    Rhtslib = [ pkgs.zlib.dev ];
    RJaCGH = [ pkgs.zlib.dev ];
    rjags = [ pkgs.jags ];
    rJava = [ pkgs.zlib pkgs.bzip2.dev pkgs.icu pkgs.lzma.dev pkgs.pcre.dev pkgs.jdk pkgs.libzip ];
    Rlibeemd = [ pkgs.gsl_1 ];
    rmatio = [ pkgs.zlib.dev ];
    Rmpfr = [ pkgs.gmp pkgs.mpfr.dev ];
    Rmpi = [ pkgs.openmpi ];
    RMySQL = [ pkgs.zlib pkgs.mysql.lib ];
    RNetCDF = [ pkgs.netcdf pkgs.udunits ];
    RODBCext = [ pkgs.libiodbc ];
    RODBC = [ pkgs.libiodbc ];
    rpg = [ pkgs.postgresql ];
    rphast = [ pkgs.pcre.dev pkgs.zlib pkgs.bzip2 pkgs.gzip pkgs.readline ];
    Rpoppler = [ pkgs.poppler ];
    RPostgreSQL = [ pkgs.postgresql ];
    RProtoBuf = [ pkgs.protobuf ];
    rPython = [ pkgs.python ];
    RSclient = [ pkgs.openssl.dev ];
    Rserve = [ pkgs.openssl ];
    Rssa = [ pkgs.fftw.dev ];
    rtfbs = [ pkgs.zlib pkgs.pcre.dev pkgs.bzip2 pkgs.gzip pkgs.readline ];
    rtiff = [ pkgs.libtiff.dev ];
    runjags = [ pkgs.jags ];
    RVowpalWabbit = [ pkgs.zlib.dev pkgs.boost ];
    rzmq = [ pkgs.zeromq3 ];
    SAVE = [ pkgs.zlib pkgs.bzip2 pkgs.icu pkgs.lzma pkgs.pcre ];
    sdcTable = [ pkgs.gmp pkgs.glpk ];
    seewave = [ pkgs.fftw.dev pkgs.libsndfile.dev ];
    seqinr = [ pkgs.zlib.dev ];
    seqminer = [ pkgs.zlib.dev pkgs.bzip2 ];
    showtext = [ pkgs.zlib pkgs.libpng pkgs.icu pkgs.freetype.dev ];
    simplexreg = [ pkgs.gsl_1 ];
    SOD = [ pkgs.opencl-headers ];
    spate = [ pkgs.fftw.dev ];
    sprint = [ pkgs.openmpi ];
    ssanv = [ pkgs.proj ];
    stsm = [ pkgs.gsl_1 ];
    stringi = [ pkgs.icu.dev ];
    survSNP = [ pkgs.gsl_1 ];
    sysfonts = [ pkgs.zlib pkgs.libpng pkgs.freetype.dev ];
    TAQMNGR = [ pkgs.zlib.dev ];
    tiff = [ pkgs.libtiff.dev ];
    TKF = [ pkgs.gsl_1 ];
    tkrplot = [ pkgs.xorg.libX11 pkgs.tk.dev ];
    topicmodels = [ pkgs.gsl_1 ];
    udunits2 = [ pkgs.udunits pkgs.expat ];
    V8 = [ pkgs.v8 ];
    VBLPCM = [ pkgs.gsl_1 ];
    VBmix = [ pkgs.gsl_1 pkgs.fftw pkgs.qt4 ];
    WhopGenome = [ pkgs.zlib.dev ];
    XBRL = [ pkgs.zlib pkgs.libxml2.dev ];
    xml2 = [ pkgs.libxml2.dev ];
    XML = [ pkgs.libtool pkgs.libxml2.dev pkgs.xmlsec pkgs.libxslt ];
    affyPLM = [ pkgs.zlib.dev ];
    bamsignals = [ pkgs.zlib.dev ];
    BitSeq = [ pkgs.zlib.dev ];
    DiffBind = [ pkgs.zlib ];
    ShortRead = [ pkgs.zlib.dev ];
    oligo = [ pkgs.zlib.dev ];
    gmapR = [ pkgs.zlib.dev ];
    Rsubread = [ pkgs.zlib.dev ];
    XVector = [ pkgs.zlib.dev ];
    Rsamtools = [ pkgs.zlib.dev ];
    rtracklayer = [ pkgs.zlib.dev ];
    affyio = [ pkgs.zlib.dev ];
    VariantAnnotation = [ pkgs.zlib.dev ];
    snpStats = [ pkgs.zlib.dev ];
    gputools = [ pkgs.pcre.dev pkgs.lzma.dev pkgs.zlib.dev pkgs.bzip2.dev pkgs.icu.dev ];
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
    gmatrix = [ pkgs.cudatoolkit pkgs.which ];
    RCurl = [ pkgs.curl.dev ];
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
    tikzDevice = [ pkgs.which pkgs.texlive.combined.scheme-medium ];
    rPython = [ pkgs.which ];
    gridGraphics = [ pkgs.which ];
    gputools = [ pkgs.which pkgs.cudatoolkit ];
    adimpro = [ pkgs.which pkgs.xorg.xdpyinfo ];
    PET = [ pkgs.which pkgs.xorg.xdpyinfo pkgs.imagemagick ];
    dti = [ pkgs.which pkgs.xorg.xdpyinfo pkgs.imagemagick ];
    mzR = [ pkgs.netcdf ];
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
    "gputools" # requires CUDA runtime
    "sprint" # tries to run MPI processes
    "pbdMPI" # tries to run MPI processes
  ];

  # Packages which cannot be installed due to lack of dependencies or other reasons.
  brokenPackages = [
    "acs"                             # build is broken
    "AffyTiling"                      # build is broken
    "agRee"                           # depends on broken package BRugs-0.8-6
    "aLFQ"                            # depends on broken package bio3d-2.3-1
    "animation"                       # build is broken
    "anim_plots"                      # depends on broken package animation-2.4
    "annmap"                          # depends on broken package RMySQL-0.10.9
    "apaStyle"                        # depends on broken package gdtools-0.1.3
    "apaTables"                       # depends on broken package OpenMx-2.7.4
    "ArrayExpressHTS"                 # build is broken
    "arrayQualityMetrics"             # build is broken
    "auRoc"                           # depends on broken package OpenMx-2.7.4
    "BatchQC"                         # build is broken
    "bayou"                           # depends on broken package animation-2.4
    "bedr"                            # build is broken
    "BETS"                            # build is broken
    "BiGGR"                           # depends on broken package rsbml-2.30.0
    "bio3d"                           # build is broken
    "bioassayR"                       # depends on broken package ChemmineR-2.24.2
    "biomformat"                      # depends on broken package r-rhdf5-2.16.0
    "biotools"                        # depends on broken package rpanel-1.1-3
    "birte"                           # build is broken
    "BiSEp"                           # build is broken
    "BLCOP"                           # depends on broken package Rsymphony-0.1-26
    "BMhyd"                           # depends on broken package animation-2.4
    "BNSP"                            # build is broken
    "BPEC"                            # depends on broken package animation-2.4
    "BrailleR"                        # depends on broken package gridGraphics-0.1-5
    "brainGraph"                      # build is broken
    "brranching"                      # depends on broken package animation-2.4
    "brr"                             # build is broken
    "BRugs"                           # build is broken
    "CADStat"                         # build is broken
    "CampaR1"                         # depends on broken package r-bio3d-2.3-1
    "canceR"                          # build is broken
    "CardinalWorkflows"               # build is broken
    "CARrampsOcl"                     # depends on broken package OpenCL-0.1-3
    "categoryCompare"                 # depends on broken package RCytoscape-1.21.1
    "Causata"                         # depends on broken package RMySQL-0.10.9
    "cdcfluview"                      # depends on broken package V8-1.2
    "ChemmineDrugs"                   # depends on broken package ChemmineR-2.24.2
    "ChemmineR"                       # build is broken
    "chinese_misc"                    # build is broken
    "ChIPQC"                          # depends on broken package r-DiffBind-2.0.9
    "ChIPXpress"                      # build is broken
    "ChIPXpressData"                  # build is broken
    "choroplethr"                     # depends on broken package acs-2.0
    "CHRONOS"                         # build is broken
    "cleanEHR"                        # build is broken
    "clickR"                          # depends on broken package gdtools-0.1.3
    "clpAPI"                          # build is broken
    "CNEr"                            # build is broken
    "colormap"                        # depends on broken package V8-1.2
    "colorscience"                    # build is broken
    "compendiumdb"                    # depends on broken package RMySQL-0.10.9
    "CONFESS"                         # depends on broken package r-flowCore-1.38.2
    "CONS"                            # build is broken
    "convevol"                        # depends on broken package animation-2.4
    "CountClust"                      # build is broken
    "CountsEPPM"                      # build is broken
    "COUSCOus"                        # depends on broken package r-bio3d-2.3-1
    "covr"                            # build is broken
    "cplexAPI"                        # build is broken
    "Crossover"                       # build is broken
    "CrypticIBDcheck"                 # build is broken
    "csaw"                            # build is broken
    "ctsem"                           # depends on broken package OpenMx-2.7.4
    "cudaBayesreg"                    # build is broken
    "curlconverter"                   # depends on broken package V8-1.2
    "cytofkit"                        # depends on broken package flowCore-1.38.2
    "daff"                            # depends on broken package V8-1.2
    "dagbag"                          # build is broken
    "dagitty"                         # depends on broken package V8-1.2
    "dagLogo"                         # depends on broken package MotIV-1.28.0
    "DAISIE"                          # depends on broken package animation-2.4
    "dataMaid"                        # build is broken
    "dataone"                         # build is broken
    "datapack"                        # build is broken
    "dbConnect"                       # depends on broken package RMySQL-0.10.9
    "DBKGrad"                         # depends on broken package rpanel-1.1-3
    "DCM"                             # build is broken
    "DDD"                             # depends on broken package animation-2.4
    "deBInfer"                        # depends on broken package PBSddesolve-1.12.2
    "DecisionCurve"                   # build is broken
    "deepSNV"                         # build is broken
    "DEGraph"                         # depends on broken package RCytoscape-1.21.1
    "DEploid"                         # build is broken
    "DiagrammeRsvg"                   # depends on broken package V8-1.2
    "DiffBind"                        # build is broken
    "diffHic"                         # depends on broken package r-csaw-1.6.1
    "DirichletMultinomial"            # build is broken
    "diveRsity"                       # build is broken
    "DmelSGI"                         # depends on broken package r-rhdf5-2.16.0
    "DNAprofiles"                     # build is broken
    "docxtools"                       # build is broken
    "DOQTL"                           # depends on broken package r-rhdf5-2.16.0
    "DOT"                             # depends on broken package V8-1.2
    "dynr"                            # build is broken
    "ecospat"                         # depends on broken package MigClim-1.6
    "EGAD"                            # depends on broken package arrayQualityMetrics-3.28.2
    "eiR"                             # depends on broken package ChemmineR-2.24.2
    "emg"                             # build is broken
    "envlpaster"                      # build is broken
    "erpR"                            # depends on broken package rpanel-1.1-3
    "euroMix"                         # build is broken
    "evobiR"                          # depends on broken package animation-2.4
    "exifr"                           # build is broken
    "exprso"                          # build is broken
    "fastR"                           # build is broken
    "fdq"                             # depends on broken package gdtools-0.1.3
    "Fgmutils"                        # depends on broken package gdtools-0.1.3
    "flan"                            # build is broken
    "flowAI"                          # depends on broken package r-flowCore-1.38.2
    "flowBeads"                       # depends on broken package r-flowCore-1.38.2
    "flowBin"                         # depends on broken package r-flowCore-1.38.2
    "flowCHIC"                        # depends on broken package r-flowCore-1.38.2
    "flowClean"                       # depends on broken package r-flowCore-1.38.2
    "flowClust"                       # depends on broken package r-flowCore-1.38.2
    "flowCore"                        # build is broken
    "flowDensity"                     # depends on broken package flowCore-1.38.2
    "flowDiv"                         # depends on broken package r-flowCore-1.38.2
    "flowFit"                         # depends on broken package r-flowCore-1.38.2
    "flowFitExampleData"              # depends on broken package r-flowCore-1.38.2
    "flowFP"                          # depends on broken package r-flowCore-1.38.2
    "flowMatch"                       # depends on broken package r-flowCore-1.38.2
    "flowMeans"                       # depends on broken package r-flowCore-1.38.2
    "flowMerge"                       # depends on broken package r-flowCore-1.38.2
    "flowPeaks"                       # build is broken
    "flowQB"                          # depends on broken package r-flowCore-1.38.2
    "flowQ"                           # depends on broken package flowCore-1.38.2
    "FlowSOM"                         # depends on broken package r-flowCore-1.38.2
    "flowStats"                       # depends on broken package r-flowCore-1.38.2
    "flowTrans"                       # depends on broken package r-flowCore-1.38.2
    "flowType"                        # depends on broken package r-flowCore-1.38.2
    "flowUtils"                       # depends on broken package r-flowCore-1.38.2
    "flowViz"                         # depends on broken package r-flowCore-1.38.2
    "flowVS"                          # depends on broken package r-flowCore-1.38.2
    "flowWorkspace"                   # depends on broken package r-flowCore-1.38.2
    "fmcsR"                           # depends on broken package ChemmineR-2.24.2
    "ForestTools"                     # depends on broken package imager-0.31
    "fPortfolio"                      # depends on broken package Rsymphony-0.1-26
    "fracprolif"                      # build is broken
    "funModeling"                     # build is broken
    "gahgu133acdf"                    # build is broken
    "gahgu133bcdf"                    # build is broken
    "gahgu133plus2cdf"                # build is broken
    "gahgu95av2cdf"                   # build is broken
    "gahgu95bcdf"                     # build is broken
    "gahgu95ccdf"                     # build is broken
    "gahgu95dcdf"                     # build is broken
    "gahgu95ecdf"                     # build is broken
    "gamlss_demo"                     # depends on broken package rpanel-1.1-3
    "gazepath"                        # build is broken
    "gdtools"                         # build is broken
    "GENE_E"                          # depends on broken package r-rhdf5-2.16.0
    "geojson"                         # depends on broken package r-protolite-1.5
    "geojsonio"                       # depends on broken package V8-1.2
    "geojsonlint"                     # depends on broken package V8-1.2
    "gfcanalysis"                     # depends on broken package animation-2.4
    "gfer"                            # depends on broken package V8-1.2
    "ggcyto"                          # depends on broken package r-flowCore-1.38.2
    "ggghost"                         # depends on broken package animation-2.4
    "ggiraph"                         # depends on broken package gdtools-0.1.3
    "ggiraphExtra"                    # depends on broken package gdtools-0.1.3
    "ggseas"                          # build is broken
    "gmatrix"                         # depends on broken package cudatoolkit-8.0.61
    "gMCP"                            # build is broken
    "gmDatabase"                      # depends on broken package RMySQL-0.10.9
    "gmum_r"                          # build is broken
    "goldi"                           # build is broken
    "googleformr"                     # build is broken
    "gpg"                             # build is broken
    "gpuR"                            # build is broken
    "gputools"                        # depends on broken package cudatoolkit-8.0.61
    "GraphPAC"                        # build is broken
    "gridGraphics"                    # build is broken
    "GSCA"                            # depends on broken package r-rhdf5-2.16.0
    "GUIDE"                           # depends on broken package rpanel-1.1-3
    "gunsales"                        # build is broken
    "h2o"                             # build is broken
    "h5vc"                            # depends on broken package r-rhdf5-2.16.0
    "harrietr"                        # build is broken
    "HDF5Array"                       # depends on broken package r-rhdf5-2.16.0
    "healthyFlowData"                 # depends on broken package r-flowCore-1.38.2
    "HierO"                           # build is broken
    "HilbertVisGUI"                   # build is broken
    "HiPLARM"                         # build is broken
    "hisse"                           # depends on broken package animation-2.4
    "homomorpheR"                     # depends on broken package sodium-0.4
    "HTSSIP"                          # depends on broken package r-rhdf5-2.16.0
    "idm"                             # depends on broken package animation-2.4
    "ifaTools"                        # depends on broken package OpenMx-2.7.4
    "IHW"                             # depends on broken package r-lpsymphony-1.0.2
    "IHWpaper"                        # depends on broken package r-lpsymphony-1.0.2
    "IlluminaHumanMethylation450k_db" # build is broken
    "imager"                          # build is broken
    "immunoClust"                     # depends on broken package r-flowCore-1.38.2
    "inSilicoMerging"                 # build is broken
    "intansv"                         # build is broken
    "interactiveDisplay"              # build is broken
    "ionicons"                        # depends on broken package rsvg-1.0
    "IONiseR"                         # depends on broken package r-rhdf5-2.16.0
    "ITGM"                            # depends on broken package gdtools-0.1.3
    "jpmesh"                          # depends on broken package V8-1.2
    "js"                              # depends on broken package V8-1.2
    "jsonld"                          # depends on broken package V8-1.2
    "jsonvalidate"                    # depends on broken package V8-1.2
    "KoNLP"                           # build is broken
    "largeList"                       # build is broken
    "largeVis"                        # build is broken
    "lawn"                            # depends on broken package V8-1.2
    "LCMCR"                           # build is broken
    "lefse"                           # build is broken
    "lfe"                             # build is broken
    "lgcp"                            # depends on broken package rpanel-1.1-3
    "Libra"                           # build is broken
    "libsoc"                          # build is broken
    "link2GI"                         # depends on broken package r-sf-0.3-4
    "LinRegInteractive"               # depends on broken package rpanel-1.1-3
    "liquidSVM"                       # build is broken
    "littler"                         # build is broken
    "LowMACA"                         # depends on broken package MotIV-1.28.0
    "lpsymphony"                      # build is broken
    "lvnet"                           # depends on broken package OpenMx-2.7.4
    "MafDb_1Kgenomes_phase3_hs37d5"   # build is broken
    "mafs"                            # build is broken
    "magick"                          # build is broken
    "maGUI"                           # build is broken
    "mapr"                            # depends on broken package V8-1.2
    "mar1s"                           # build is broken
    "MatrixRider"                     # depends on broken package CNEr-1.8.3
    "MBESS"                           # depends on broken package OpenMx-2.7.4
    "mBvs"                            # build is broken
    "mcaGUI"                          # build is broken
    "mdsr"                            # depends on broken package RMySQL-0.10.9
    "Mediana"                         # depends on broken package gdtools-0.1.3
    "melviewr"                        # build is broken
    "MeSH_Hsa_eg_db"                  # build is broken
    "MeSH_Mmu_eg_db"                  # build is broken
    "meshr"                           # depends on broken package r-MeSH.Hsa.eg.db-1.6.0
    "Metab"                           # build is broken
    "metagear"                        # build is broken
    "MetaIntegrator"                  # depends on broken package RMySQL-0.10.9
    "metaSEM"                         # depends on broken package OpenMx-2.7.4
    "MigClim"                         # build is broken
    "minimist"                        # depends on broken package V8-1.2
    "miscF"                           # depends on broken package BRugs-0.8-6
    "mixlink"                         # build is broken
    "MLSeq"                           # build is broken
    "MMDiff"                          # depends on broken package r-DiffBind-2.0.9
    "mmnet"                           # build is broken
    "MonetDBLite"                     # build is broken
    "mongolite"                       # build is broken
    "monogeneaGM"                     # depends on broken package animation-2.4
    "MonoPhy"                         # depends on broken package animation-2.4
    "motifbreakR"                     # depends on broken package MotIV-1.28.0
    "motifStack"                      # depends on broken package MotIV-1.28.0
    "MotIV"                           # build is broken
    "mptools"                         # depends on broken package animation-2.4
    "mrMLM"                           # build is broken
    "mRMRe"                           # build is broken
    "mscstexta4r"                     # build is broken
    "mscsweblm4r"                     # build is broken
    "MSeasyTkGUI"                     # build is broken
    "MSGFgui"                         # depends on broken package MSGFplus-1.6.2
    "MSGFplus"                        # build is broken
    "multiDimBio"                     # depends on broken package gridGraphics-0.1-5
    "multipanelfigure"                # depends on broken package gridGraphics-0.1-5
    "munsellinterpol"                 # build is broken
    "mutossGUI"                       # build is broken
    "mvMORPH"                         # depends on broken package animation-2.4
    "mvst"                            # build is broken
    "ncdfFlow"                        # depends on broken package r-flowCore-1.38.2
    "NCIgraph"                        # depends on broken package RCytoscape-1.21.1
    "ndjson"                          # build is broken
    "ndtv"                            # depends on broken package animation-2.4
    "NetRep"                          # depends on broken package r-RhpcBLASctl-0.15-148
    "nlts"                            # build is broken
    "NORRRM"                          # build is broken
    "odbc"                            # build is broken
    "officer"                         # depends on broken package gdtools-0.1.3
    "OpenCL"                          # build is broken
    "opencpu"                         # depends on broken package r-protolite-1.5
    "openCyto"                        # depends on broken package r-flowCore-1.38.2
    "OpenMx"                          # build is broken
    "optbdmaeAT"                      # build is broken
    "optBiomarker"                    # depends on broken package rpanel-1.1-3
    "ora"                             # depends on broken package ROracle-1.3-1
    "OUwie"                           # depends on broken package animation-2.4
    "PAA"                             # build is broken
    "paleotree"                       # depends on broken package animation-2.4
    "PathSelectMP"                    # build is broken
    "PatternClass"                    # build is broken
    "PBD"                             # depends on broken package animation-2.4
    "PBSddesolve"                     # build is broken
    "PBSmapping"                      # build is broken
    "pcadapt"                         # depends on broken package vcfR-1.4.0
    "pcaL1"                           # build is broken
    "pcaPA"                           # build is broken
    "pcrsim"                          # build is broken
    "pdfsearch"                       # build is broken
    "pdftools"                        # build is broken
    "pd_genomewidesnp_6"              # build is broken
    "permGPU"                         # build is broken
    "PGA"                             # build is broken
    "PGPC"                            # depends on broken package ChemmineR-2.24.2
    "ph2bye"                          # depends on broken package animation-2.4
    "PhyInformR"                      # depends on broken package animation-2.4
    "phylocurve"                      # depends on broken package animation-2.4
    "phyloseq"                        # depends on broken package r-rhdf5-2.16.0
    "PhySortR"                        # depends on broken package animation-2.4
    "phytools"                        # depends on broken package animation-2.4
    "PICS"                            # build is broken
    "PING"                            # depends on broken package PICS-2.16.0
    "plateCore"                       # depends on broken package r-flowCore-1.38.2
    "plfMA"                           # build is broken
    "podkat"                          # build is broken
    "PottsUtils"                      # depends on broken package BRugs-0.8-6
    "powell"                          # build is broken
    "pqsfinder"                       # depends on broken package r-flowCore-1.38.2
    "prebs"                           # depends on broken package r-rhdf5-2.16.0
    "PREDAsampledata"                 # depends on broken package gahgu133plus2cdf-2.2.1
    "predictionInterval"              # depends on broken package OpenMx-2.7.4
    "pRoloc"                          # build is broken
    "pRolocGUI"                       # build is broken
    "proteoQC"                        # build is broken
    "protolite"                       # build is broken
    "prototest"                       # build is broken
    "PSAboot"                         # build is broken
    "psbcGroup"                       # build is broken
    "PythonInR"                       # build is broken
    "qcmetrics"                       # build is broken
    "QFRM"                            # build is broken
    "qrqc"                            # build is broken
    "qtbase"                          # build is broken
    "qtpaint"                         # build is broken
    "qtutils"                         # build is broken
    "QUALIFIER"                       # depends on broken package r-flowCore-1.38.2
    "QuartPAC"                        # build is broken
    "QuasR"                           # build is broken
    "QUBIC"                           # build is broken
    "QVM"                             # build is broken
    "raincpc"                         # build is broken
    "rainfreq"                        # build is broken
    "RAM"                             # depends on broken package animation-2.4
    "RamiGO"                          # depends on broken package RCytoscape-1.21.1
    "randomcoloR"                     # depends on broken package V8-1.2
    "randstr"                         # build is broken
    "RapidPolygonLookup"              # depends on broken package PBSmapping-2.69.76
    "RAppArmor"                       # build is broken
    "raptr"                           # depends on broken package PBSmapping-2.69.76
    "RBerkeley"                       # build is broken
    "RbioRXN"                         # depends on broken package ChemmineR-2.24.2
    "Rblpapi"                         # build is broken
    "Rchemcpp"                        # depends on broken package ChemmineR-2.24.2
    "rchess"                          # depends on broken package V8-1.2
    "RchyOptimyx"                     # depends on broken package r-flowCore-1.38.2
    "RcmdrPlugin_FuzzyClust"          # build is broken
    "RcmdrPlugin_PcaRobust"           # build is broken
    "Rcpi"                            # depends on broken package ChemmineR-2.24.2
    "Rcplex"                          # build is broken
    "RcppAPT"                         # build is broken
    "RcppGetconf"                     # build is broken
    "RcppOctave"                      # build is broken
    "RcppRedis"                       # build is broken
    "rcqp"                            # build is broken
    "rcrypt"                          # build is broken
    "RCytoscape"                      # build is broken
    "rDEA"                            # build is broken
    "RDieHarder"                      # build is broken
    "REBayes"                         # depends on broken package Rmosek-1.2.5.1
    "recluster"                       # depends on broken package animation-2.4
    "redland"                         # build is broken
    "remoter"                         # build is broken
    "repijson"                        # depends on broken package V8-1.2
    "replicationInterval"             # depends on broken package OpenMx-2.7.4
    "ReporteRs"                       # depends on broken package gdtools-0.1.3
    "ReQON"                           # depends on broken package seqbias-1.20.0
    "RforProteomics"                  # depends on broken package interactiveDisplay-1.10.2
    "rgbif"                           # depends on broken package V8-1.2
    "Rgnuplot"                        # build is broken
    "rgp"                             # build is broken
    "rgpui"                           # depends on broken package rgp-0.4-1
    "rhdf5"                           # build is broken
    "RhpcBLASctl"                     # build is broken
    "ridge"                           # build is broken
    "rjade"                           # depends on broken package V8-1.2
    "rJPSGCS"                         # build is broken
    "RKEEL"                           # depends on broken package RKEELjars-1.0.15
    "RKEELjars"                       # build is broken
    "Rknots"                          # depends on broken package r-bio3d-2.3-1
    "rLindo"                          # build is broken
    "rlo"                             # depends on broken package PythonInR-0.1-3
    "RMallow"                         # build is broken
    "rmapshaper"                      # depends on broken package V8-1.2
    "rMAT"                            # build is broken
    "Rmosek"                          # build is broken
    "RMySQL"                          # build is broken
    "RnavGraph"                       # build is broken
    "rnetcarto"                       # build is broken
    "ROI_plugin_cplex"                # depends on broken package Rcplex-0.3-3
    "ROI_plugin_symphony"             # depends on broken package Rsymphony-0.1-26
    "Rolexa"                          # build is broken
    "ROracle"                         # build is broken
    "RPA"                             # depends on broken package r-rhdf5-2.16.0
    "RPANDA"                          # depends on broken package animation-2.4
    "rpanel"                          # build is broken
    "rpg"                             # build is broken
    "Rphylopars"                      # depends on broken package animation-2.4
    "Rpoppler"                        # build is broken
    "RQuantLib"                       # build is broken
    "RSAP"                            # build is broken
    "rsbml"                           # build is broken
    "RSCABS"                          # build is broken
    "rscala"                          # build is broken
    "Rsomoclu"                        # build is broken
    "rsparkling"                      # depends on broken package h2o-3.10.3.6
    "rsvg"                            # build is broken
    "Rsymphony"                       # build is broken
    "rtable"                          # depends on broken package gdtools-0.1.3
    "rTANDEM"                         # build is broken
    "Rtextrankr"                      # build is broken
    "rUnemploymentData"               # depends on broken package acs-2.0
    "rvg"                             # depends on broken package gdtools-0.1.3
    "RVideoPoker"                     # depends on broken package rpanel-1.1-3
    "rzmq"                            # build is broken
    "s2"                              # build is broken
    "Sabermetrics"                    # build is broken
    "sapFinder"                       # build is broken
    "sbrl"                            # build is broken
    "scater"                          # depends on broken package r-rhdf5-2.16.0
    "scran"                           # depends on broken package r-rhdf5-2.16.0
    "SDD"                             # depends on broken package rpanel-1.1-3
    "seasonal"                        # build is broken
    "seasonalview"                    # build is broken
    "Sejong"                          # build is broken
    "SemiCompRisks"                   # build is broken
    "semtree"                         # depends on broken package OpenMx-2.7.4
    "seqbias"                         # build is broken
    "SeqGrapheR"                      # build is broken
    "seqTools"                        # build is broken
    "sf"                              # build is broken
    "shazam"                          # build is broken
    "shinyTANDEM"                     # build is broken
    "SICtools"                        # build is broken
    "SigTree"                         # depends on broken package r-rhdf5-2.16.0
    "SimInf"                          # build is broken
    "simsalapar"                      # build is broken
    "smapr"                           # depends on broken package r-rhdf5-2.16.0
    "SnakeCharmR"                     # build is broken
    "sodium"                          # build is broken
    "soilphysics"                     # depends on broken package rpanel-1.1-3
    "sortinghat"                      # build is broken
    "spade"                           # depends on broken package r-flowCore-1.38.2
    "spdynmod"                        # depends on broken package animation-2.4
    "spocc"                           # depends on broken package V8-1.2
    "spongecake"                      # build is broken
    "srd"                             # depends on broken package animation-2.4
    "SSDM"                            # build is broken
    "stagePop"                        # depends on broken package PBSddesolve-1.12.2
    "Starr"                           # build is broken
    "stream"                          # depends on broken package animation-2.4
    "streamMOA"                       # depends on broken package animation-2.4
    "stremr"                          # build is broken
    "subspaceMOA"                     # depends on broken package animation-2.4
    "svglite"                         # depends on broken package gdtools-0.1.3
    "sybilSBML"                       # build is broken
    "synthACS"                        # depends on broken package acs-2.0
    "tcpl"                            # depends on broken package RMySQL-0.10.9
    "TDA"                             # build is broken
    "TED"                             # depends on broken package animation-2.4
    "tesseract"                       # build is broken
    "textreadr"                       # build is broken
    "textTinyR"                       # build is broken
    "TFBSTools"                       # depends on broken package CNEr-1.8.3
    "TKF"                             # depends on broken package animation-2.4
    "tmap"                            # depends on broken package V8-1.2
    "tmaptools"                       # depends on broken package V8-1.2
    "tofsims"                         # build is broken
    "toxboot"                         # depends on broken package RMySQL-0.10.9
    "TransView"                       # build is broken
    "treeplyr"                        # depends on broken package animation-2.4
    "TSMySQL"                         # depends on broken package RMySQL-0.10.9
    "uaparserjs"                      # depends on broken package V8-1.2
    "UBCRM"                           # build is broken
    "uHMM"                            # build is broken
    "umx"                             # depends on broken package OpenMx-2.7.4
    "userfriendlyscience"             # depends on broken package OpenMx-2.7.4
    "V8"                              # build is broken
    "VBmix"                           # build is broken
    "vcfR"                            # build is broken
    "vdiffr"                          # depends on broken package gdtools-0.1.3
    "vmsbase"                         # depends on broken package PBSmapping-2.69.76
    "wallace"                         # depends on broken package V8-1.2
    "wand"                            # build is broken
    "webp"                            # build is broken
    "wordbankr"                       # depends on broken package RMySQL-0.10.9
    "x13binary"                       # build is broken
    "x_ent"                           # depends on broken package r-protolite-1.5
    "xps"                             # build is broken
    "xslt"                            # build is broken
    "zoon"                            # build is broken
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
        export LIBXML_INCDIR=${pkgs.libxml2.dev}/include/libxml2
        patchShebangs configure
        '';
    });

    Cairo = old.Cairo.overrideDerivation (attrs: {
      NIX_LDFLAGS = "-lfontconfig";
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
        "--with-mpfr-include=${pkgs.mpfr.dev}/include"
      ];
    });

    RVowpalWabbit = old.RVowpalWabbit.overrideDerivation (attrs: {
      configureFlags = [
        "--with-boost=${pkgs.boost.dev}" "--with-boost-libdir=${pkgs.boost.out}/lib"
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
      NIX_CFLAGS_LINK = "-L${pkgs.xorg.libXft.out}/lib -lXft";
      NIX_LDFLAGS = "-lX11";
    });

    slfm = old.slfm.overrideDerivation (attrs: {
      PKG_LIBS = "-L${pkgs.openblasCompat}/lib -lopenblas";
    });

    SamplerCompare = old.SamplerCompare.overrideDerivation (attrs: {
      PKG_LIBS = "-L${pkgs.openblasCompat}/lib -lopenblas";
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
      OPENSSL_INCLUDES = "${pkgs.openssl.dev}/include";
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
