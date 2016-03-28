/* This file defines the composition for CRAN (R) packages. */

{ R, pkgs, overrides }:

let
  inherit (pkgs) fetchurl stdenv lib;

  buildRPackage = pkgs.callPackage ./generic-builder.nix {
    inherit R;
    inherit (pkgs.darwin.apple_sdk.frameworks) Cocoa Foundation;
  };

  # Generates package templates given per-repository settings
  #
  # some packages, e.g. cncaGUI, require X running while installation,
  # so that we use xvfb-run if requireX is true.
  mkDerive = {mkHomepage, mkUrls}: args:
      # XXX: not ideal ("2.2" would match "2.22") but sufficient
      assert (!(args ? rVersion) || lib.hasPrefix args.rVersion (lib.getVersion R));
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

  # Templates for generating Bioconductor, CRAN and IRkernel packages
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
  deriveIRkernel = mkDerive {
    mkHomepage = {name}: "https://irkernel.github.io/";
    mkUrls = {name, version}: [ "http://irkernel.github.io/src/contrib/${name}_${version}.tar.gz" ];
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
          import ./cran-packages.nix { inherit self; derive = deriveCran; } //
          import ./irkernel-packages.nix { inherit self; derive = deriveIRkernel; };

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
    BayesXsrc = [ pkgs.readline pkgs.ncurses ];
    bigGP = [ pkgs.openmpi ];
    BiocCheck = [ pkgs.which ];
    Biostrings = [ pkgs.zlib ];
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
    rtfbs = [ pkgs.zlib pkgs.pcre pkgs.bzip2 pkgs.gzip pkgs.readline ];
    rtiff = [ pkgs.libtiff ];
    runjags = [ pkgs.jags ];
    RVowpalWabbit = [ pkgs.zlib pkgs.boost ];
    rzmq = [ pkgs.zeromq3 ];
    SAVE = [ pkgs.zlib pkgs.bzip2 pkgs.icu pkgs.lzma pkgs.pcre ];
    sdcTable = [ pkgs.gmp pkgs.glpk ];
    seewave = [ pkgs.fftw pkgs.libsndfile ];
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
    affyPLM = [ pkgs.zlib ];
    bamsignals = [ pkgs.zlib ];
    BitSeq = [ pkgs.zlib ];
    DiffBind = [ pkgs.zlib ];
    ShortRead = [ pkgs.zlib ];
    oligo = [ pkgs.zlib ];
    gmapR = [ pkgs.zlib ];
    ncdf = [ pkgs.netcdf ];
    Rsubread = [ pkgs.zlib ];
    SemiCompRisks = [ pkgs.gsl_1 ];
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
    "rsvg" # broken build
    "Rothermel" # broken build
    "rfPermute" # broken build
    "redland" # broken build
    "RAppArmor" # broken build
    "permGPU" # broken build
    "pdftools" # broken build
    "OceanView" # broken build
    "MSeasyTkGUI" # broken build
    "mrMLM" # broken build
    "MonetDBLite" # broken build
    "MixGHD" # broken build
    "LCMCR" # broken build
    "hunspell" # broken build
    "googleformr" # broken build
    "ggseas" # depends on broken package x13binary
    "seasonal" # depends on broken package x13binary
    "gunsales" # depends on broken package x13binary
    "x13binary" # broken build
    "fds" # broken build
    "exifr" # broken build
    "TTAinterfaceTrendAnalysis" # depends on broken package euroMix
    "stylo" # depends on broken package euroMix
    "stosim" # depends on broken package euroMix
    "SRRS" # depends on broken package euroMix
    "rite" # depends on broken package euroMix
    "MBCB" # depends on broken package euroMix
    "forensim" # depends on broken package euroMix
    "dynBiplotGUI" # depends on broken package euroMix
    "cncaGUI" # depends on broken package euroMix
    "biplotbootGUI" # depends on broken package euroMix
    "AnthropMMD" # depends on broken package euroMix
    "ilc" # depends on broken package demography
    "demography" # broken build
    "webbioc" # depends on broken package limma
    "davidTiling" # depends on broken package limma
    "tilingArray" # depends on broken package limma
    "NAPPA" # depends on broken package limma
    "NanoStringNorm" # depends on broken package limma
    "synapterdata" # depends on broken package limma
    "synapter" # depends on broken package limma
    "RforProteomics" # depends on broken package limma
    "pRolocdata" # depends on broken package limma
    "ProCoNA" # depends on broken package limma
    "Pbase" # depends on broken package limma
    "MSnID" # depends on broken package limma
    "msmsEDA" # depends on broken package limma
    "MSnbase" # depends on broken package limma
    "staRank" # depends on broken package limma
    "phenoDist" # depends on broken package limma
    "imageHTS" # depends on broken package limma
    "Mulder2012" # depends on broken package limma
    "HTSanalyzeR" # depends on broken package limma
    "gespeR" # depends on broken package limma
    "cellHTS2" # depends on broken package limma
    "affyPara" # depends on broken package limma
    "vsn" # depends on broken package limma
    "ttScreening" # depends on broken package limma
    "metaX" # depends on broken package limma
    "SSPA" # depends on broken package limma
    "SQDA" # depends on broken package limma
    "ADaCGH2" # depends on broken package limma
    "snapCGH" # depends on broken package limma
    "Shrinkage" # depends on broken package limma
    "SafeQuant" # depends on broken package limma
    "RTopper" # depends on broken package limma
    "RTCGAToolbox" # depends on broken package limma
    "RPPanalyzer" # depends on broken package limma
    "Rnits" # depends on broken package limma
    "RNAinteractMAPK" # depends on broken package limma
    "RNAinteract" # depends on broken package limma
    "SimBindProfiles" # depends on broken package limma
    "ccTutorial" # depends on broken package limma
    "Ringo" # depends on broken package limma
    "rCGH" # depends on broken package limma
    "qusage" # depends on broken package limma
    "qpcrNorm" # depends on broken package limma
    "prot2D" # depends on broken package limma
    "polyester" # depends on broken package limma
    "plmDE" # depends on broken package limma
    "phenoTest" # depends on broken package limma
    "RANKS" # depends on broken package limma
    "PerfMeas" # depends on broken package limma
    "pepStat" # depends on broken package limma
    "PECA" # depends on broken package limma
    "PADOG" # depends on broken package limma
    "OGSA" # depends on broken package limma
    "nethet" # depends on broken package limma
    "lpNet" # depends on broken package limma
    "nem" # depends on broken package limma
    "monocle" # depends on broken package limma
    "MmPalateMiRNA" # depends on broken package limma
    "miRtest" # depends on broken package limma
    "miRLAB" # depends on broken package limma
    "mGSZ" # depends on broken package limma
    "MAMA" # depends on broken package limma
    "metaMA" # depends on broken package limma
    "msd16s" # depends on broken package limma
    "metagenomeSeq" # depends on broken package limma
    "metabolomics" # depends on broken package limma
    "maSigPro" # depends on broken package limma
    "timecourse" # depends on broken package limma
    "stepNorm" # depends on broken package limma
    "RBM" # depends on broken package limma
    "saps" # depends on broken package limma
    "PharmacoGx" # depends on broken package limma
    "piano" # depends on broken package limma
    "OLINgui" # depends on broken package limma
    "OLIN" # depends on broken package limma
    "nnNorm" # depends on broken package limma
    "ListerEtAlBSseq" # depends on broken package limma
    "compEpiTools" # depends on broken package limma
    "methylPipe" # depends on broken package limma
    "dyebiasexamples" # depends on broken package limma
    "dyebias" # depends on broken package limma
    "CluMix" # depends on broken package limma
    "HCsnip" # depends on broken package limma
    "sigaR" # depends on broken package limma
    "plrs" # depends on broken package limma
    "CGHregions" # depends on broken package limma
    "QDNAseq_mm10" # depends on broken package limma
    "QDNAseq_hg19" # depends on broken package limma
    "QDNAseq" # depends on broken package limma
    "GeneBreak" # depends on broken package limma
    "focalCall" # depends on broken package limma
    "CGHnormaliter" # depends on broken package limma
    "CGHcall" # depends on broken package limma
    "CGHbase" # depends on broken package limma
    "beta7" # depends on broken package limma
    "marray" # depends on broken package limma
    "LVSmiRNA" # depends on broken package limma
    "lmdme" # depends on broken package limma
    "limmaGUI" # depends on broken package limma
    "InPAS" # depends on broken package limma
    "iChip" # depends on broken package limma
    "unifiedWMWqPCR" # depends on broken package limma
    "nondetects" # depends on broken package limma
    "HTqPCR" # depends on broken package limma
    "HD2013SGI" # depends on broken package limma
    "vtpnet" # depends on broken package limma
    "gwascat" # depends on broken package limma
    "gQTLstats" # depends on broken package limma
    "GOsummaries" # depends on broken package limma
    "yri1kgv" # depends on broken package limma
    "hmyriB36" # depends on broken package limma
    "cheung2010" # depends on broken package limma
    "GGtools" # depends on broken package limma
    "GGdata" # depends on broken package limma
    "encoDnaseI" # depends on broken package limma
    "dsQTL" # depends on broken package limma
    "ceuhm3" # depends on broken package limma
    "ceu1kgv" # depends on broken package limma
    "ceu1kg" # depends on broken package limma
    "GGBase" # depends on broken package limma
    "GeneSelector" # depends on broken package limma
    "GeneSelectMMD" # depends on broken package limma
    "gCMAPWeb" # depends on broken package limma
    "gCMAP" # depends on broken package limma
    "flowBin" # depends on broken package limma
    "Fletcher2013a" # depends on broken package limma
    "FEM" # depends on broken package limma
    "explorase" # depends on broken package limma
    "ExiMiR" # depends on broken package limma
    "tweeDEseq" # depends on broken package limma
    "tRanslatome" # depends on broken package limma
    "ToPASeq" # depends on broken package limma
    "timeSeq" # depends on broken package limma
    "TCGAbiolinks" # depends on broken package limma
    "TCC" # depends on broken package limma
    "systemPipeR" # depends on broken package limma
    "STATegRa" # depends on broken package limma
    "ssizeRNA" # depends on broken package limma
    "RUVSeq" # depends on broken package limma
    "RnaSeqSampleSizeData" # depends on broken package limma
    "RnaSeqSampleSize" # depends on broken package limma
    "rnaSeqMap" # depends on broken package limma
    "ReportingTools" # depends on broken package limma
    "QuasiSeq" # depends on broken package limma
    "PROPER" # depends on broken package limma
    "myTAI" # depends on broken package limma
    "msmsTests" # depends on broken package limma
    "methylMnM" # depends on broken package limma
    "metaseqR" # depends on broken package limma
    "MEDIPS" # depends on broken package limma
    "manta" # depends on broken package limma
    "HTSFilter" # depends on broken package limma
    "HTSCluster" # depends on broken package limma
    "GSAgm" # depends on broken package limma
    "fdrDiscreteNull" # depends on broken package limma
    "erccdashboard" # depends on broken package limma
    "EnrichmentBrowser" # depends on broken package limma
    "edgeRun" # depends on broken package limma
    "EDDA" # depends on broken package limma
    "RnaSeqTutorial" # depends on broken package limma
    "easyRNASeq" # depends on broken package limma
    "DEGreport" # depends on broken package limma
    "Imetagene" # depends on broken package limma
    "metagene" # depends on broken package limma
    "DBChIP" # depends on broken package limma
    "babel" # depends on broken package limma
    "apmsWAPP" # depends on broken package limma
    "ampliQueso" # depends on broken package limma
    "edgeR" # depends on broken package limma
    "MMDiff" # depends on broken package limma
    "ChIPQC" # depends on broken package limma
    "DiffBind" # depends on broken package limma
    "DCGL" # depends on broken package limma
    "Prostar" # depends on broken package limma
    "DAPAR" # depends on broken package limma
    "DAAGbio" # depends on broken package limma
    "csaw" # depends on broken package limma
    "cp4p" # depends on broken package limma
    "coRNAi" # depends on broken package limma
    "Cormotif" # depends on broken package limma
    "CORM" # depends on broken package limma
    "TurboNorm" # depends on broken package limma
    "maigesPack" # depends on broken package limma
    "convert" # depends on broken package limma
    "compcodeR" # depends on broken package limma
    "codelink" # depends on broken package limma
    "clippda" # depends on broken package limma
    "REDseq" # depends on broken package limma
    "GUIDEseq" # depends on broken package limma
    "ggtut" # depends on broken package limma
    "FunciSNP" # depends on broken package limma
    "ChIPpeakAnno" # depends on broken package limma
    "ChIPComp" # depends on broken package limma
    "ChimpHumanBrainData" # depends on broken package limma
    "charmData" # depends on broken package limma
    "charm" # depends on broken package limma
    "cghMCR" # depends on broken package limma
    "CCl4" # depends on broken package limma
    "casper" # depends on broken package limma
    "CancerMutationAnalysis" # depends on broken package limma
    "CALIB" # depends on broken package limma
    "quantro" # depends on broken package limma
    "RnBeads" # depends on broken package limma
    "mvoutData" # depends on broken package limma
    "MineICA" # depends on broken package limma
    "methyAnalysis" # depends on broken package limma
    "MAQCsubsetILM" # depends on broken package limma
    "MAQCsubset" # depends on broken package limma
    "lumiRatIDMapping" # depends on broken package limma
    "lumiMouseIDMapping" # depends on broken package limma
    "lumiHumanIDMapping" # depends on broken package limma
    "lumiBarnes" # depends on broken package limma
    "iCheck" # depends on broken package limma
    "ffpeExampleData" # depends on broken package limma
    "arrayMvout" # depends on broken package limma
    "lumi" # depends on broken package limma
    "ffpe" # depends on broken package limma
    "methylumi" # depends on broken package limma
    "shinyMethyl" # depends on broken package limma
    "MethylAidData" # depends on broken package limma
    "MethylAid" # depends on broken package limma
    "IlluminaHumanMethylation450kmanifest" # depends on broken package limma
    "skewr" # depends on broken package limma
    "wateRmelon" # depends on broken package limma
    "missMethyl" # depends on broken package limma
    "minfiData" # depends on broken package limma
    "IlluminaHumanMethylation450kanno_ilmn12_hg19" # depends on broken package limma
    "IlluminaHumanMethylation27kmanifest" # depends on broken package limma
    "FlowSorted_DLPFC_450k" # depends on broken package limma
    "FlowSorted_Blood_450k" # depends on broken package limma
    "ENmix" # depends on broken package limma
    "ELMER" # depends on broken package limma
    "MEAL" # depends on broken package limma
    "DMRcate" # depends on broken package limma
    "CopyNumber450kData" # depends on broken package limma
    "CopyNumber450k" # depends on broken package limma
    "conumee" # depends on broken package limma
    "ChAMP" # depends on broken package limma
    "minfi" # depends on broken package limma
    "regionReport" # depends on broken package limma
    "derfinderPlot" # depends on broken package limma
    "derfinder" # depends on broken package limma
    "bumphunter" # depends on broken package limma
    "birta" # depends on broken package limma
    "betr" # depends on broken package limma
    "beadarrayMSV" # depends on broken package limma
    "RobLoxBioC" # depends on broken package limma
    "maGUI" # depends on broken package limma
    "epigenomix" # depends on broken package limma
    "blima" # depends on broken package limma
    "BeadArrayUseCases" # depends on broken package limma
    "beadarrayFilter" # depends on broken package limma
    "beadarrayExampleData" # depends on broken package limma
    "beadarray" # depends on broken package limma
    "ballgown" # depends on broken package limma
    "attract" # depends on broken package limma
    "ArrayTools" # depends on broken package limma
    "arrayQuality" # depends on broken package limma
    "DrugVsDisease" # depends on broken package limma
    "ArrayExpress" # depends on broken package limma
    "oneChannelGUI" # depends on broken package limma
    "affylmGUI" # depends on broken package limma
    "AffyExpress" # depends on broken package limma
    "AgiMicroRna" # depends on broken package limma
    "affycoretools" # depends on broken package limma
    "ABSSeq" # depends on broken package limma
    "a4" # depends on broken package limma
    "a4Base" # depends on broken package limma
    "limma" # broken build
    "TransView" # broken build
    "Starr" # broken build
    "SICtools" # broken build
    "ReQON" # depends on broken package seqbias
    "seqbias" # broken build
    "Repitools" # broken build
    "QuasR" # broken build
    "qrqc" # broken build
    "ProteomicsAnnotationHubData" # broken build
    "podkat" # broken build
    "PING" # depends on broken package PICS
    "PICS" # broken build
    "mcaGUI" # broken build
    "deepSNV" # broken build
    "motifbreakR" # depends on broken package MotIV
    "LowMACA" # depends on broken package MotIV
    "dagLogo" # depends on broken package MotIV
    "motifStack" # depends on broken package MotIV
    "MotIV" # broken build
    "CNEr" # broken build
    "canceR" # broken build
    "BubbleTree" # broken build
    "arrayQualityMetrics" # broken build
    "ArrayExpressHTS" # broken build
    "TargetSearchData" # depends on broken package TargetSearch
    "TargetSearch" # broken build
    "ptw" # depends on broken package nloptr
    "gpuR" # broken build
    "erma" # broken build
    "MBmca" # depends on broken package chipPCR
    "dpcR" # depends on broken package chipPCR
    "chipPCR" # broken build
    "alsace" # broken build
    "rrlda" # depends on broken package VIM
    "qrfactor" # depends on broken package VIM
    "MVN" # depends on broken package VIM
    "mvoutlier" # depends on broken package VIM
    "robCompositions" # depends on broken package VIM
    "DiagrammeRsvg" # depends on broken package V8
    "dagitty" # depends on broken package V8
    "remoter" # depends on broken package sodium
    "Fletcher2013b" # depends on broken package RTN
    "apaStyle" # depends on broken package ReporteRs
    "categoryCompare" # depends on broken package RCytoscape
    "preseqR" # depends on broken package polynom
    "permutations" # depends on broken package partitions
    "GLMMRR" # depends on broken package lme4
    "replicationInterval" # depends on broken package lme4
    "GWASdata" # depends on broken package GWASTools
    "EnsemblePCReg" # depends on broken package EnsembleBase
    "EnsembleCV" # depends on broken package EnsembleBase
    "cpgen" # depends on broken package pedigreemm
    "mitml" # depends on broken package jomo
    "IlluminaHumanMethylation450k_db" # broken build
    "gahgu95ecdf" # broken build
    "gahgu95dcdf" # broken build
    "gahgu95ccdf" # broken build
    "gahgu95bcdf" # broken build
    "gahgu95av2cdf" # broken build
    "PREDAsampledata" # depends on broken package gahgu133plus2cdf
    "gahgu133plus2cdf" # broken build
    "gahgu133bcdf" # broken build
    "gahgu133acdf" # broken build
    "annmap" # depends on broken package RMySQL
    "choroplethr" # depends on broken package acs
    "acs" # broken build
    "spray" # depends on broken package partitions
    "simmr" # depends on broken package rjags
    "morse" # depends on broken package rjags
    "gemtc" # depends on broken package rjags
    "EasyMARK" # depends on broken package rjags
    "PVAClone" # depends on broken package rjags
    "sharx" # depends on broken package rjags
    "dcmle" # depends on broken package rjags
    "dclone" # depends on broken package rjags
    "CNVrd2" # depends on broken package rjags
    "bayescount" # depends on broken package rjags
    "BANOVA" # depends on broken package rjags
    "rjags" # broken build
    "proteoQC" # depends on broken package rTANDEM
    "PGA" # depends on broken package rTANDEM
    "cudatoolkit" # broken build
    "MBESS" # depends on broken package OpenMx
    "IONiseR" # depends on broken package rhdf5
    "DOQTL" # depends on broken package rhdf5
    "DmelSGI" # depends on broken package rhdf5
    "flowDiv" # depends on broken package ncdfFlow
    "ChemmineDrugs" # depends on broken package ChemmineR
    "nlopt" # broken build
    "stpm" # depends on broken package nloptr
    "sjmisc" # depends on broken package nloptr
    "rstanarm" # depends on broken package nloptr
    "glmmsr" # depends on broken package nloptr
    "FDboost" # depends on broken package nloptr
    "faraway" # depends on broken package nloptr
    "interplot" # depends on broken package nloptr
    "VSE" # depends on broken package car
    "VARSEDIG" # depends on broken package car
    "translateSPSS2R" # depends on broken package car
    "tadaatoolbox" # depends on broken package car
    "lavaan_shiny" # depends on broken package car
    "RcmdrPlugin_GWRM" # depends on broken package car
    "TextoMineR" # depends on broken package car
    "pcaBootPlot" # depends on broken package car
    "ClustGeo" # depends on broken package car
    "preproviz" # depends on broken package car
    "hsdar" # depends on broken package car
    "DecisionCurve" # depends on broken package car
    "CONDOP" # depends on broken package car
    "EnsemblePenReg" # depends on broken package car
    "EnsembleBase" # depends on broken package car
    "fullfact" # depends on broken package car
    "clusterSEs" # depends on broken package car
    "ggiraph" # depends on broken package gdtools
    "rvg" # depends on broken package gdtools
    "ggpmisc" # depends on broken package polynom
    "mlt_docreg" # depends on broken package polynom
    "mlt" # depends on broken package polynom
    "basefun" # depends on broken package polynom
    "rtable" # depends on broken package ReporteRs
    "Mediana" # depends on broken package ReporteRs
    "ReporteRs" # broken build
    "abd" # depends on broken package nlopt
    "adabag" # depends on broken package nlopt
    "adhoc" # broken build
    "AER" # depends on broken package nlopt
    "afex" # depends on broken package nlopt
    "agRee" # depends on broken package nlopt
    "aLFQ" # depends on broken package nlopt
    "algstat" # broken build
    "alr3" # depends on broken package nlopt
    "alr4" # depends on broken package nlopt
    "alsace" # depends on broken nloptr
    "anacor" # depends on broken package nlopt
    "aods3" # depends on broken package nlopt
    "apaTables" # depends on broken package car
    "apt" # depends on broken package nlopt
    "ArfimaMLM" # depends on broken package nlopt
    "arm" # depends on broken package nlopt
    "ART" # depends on broken package car
    "ARTool" # depends on broken package nlopt
    "AssetPricing" # broken build
    "AtelieR" # broken build
    "auRoc" # depends on broken package rjags
    "AutoModel" # depends on broken package car
    "bamdit" # broken build
    "BANOVA" # broken build
    "bapred" # depends on broken package lme4
    "bartMachine" # depends on broken package nlopt
    "bayescount" # broken build
    "bayesDem" # depends on broken package nlopt
    "bayesLife" # depends on broken package nlopt
    "BayesMed" # broken build
    "bayesmix" # broken build
    "bayesPop" # depends on broken package nlopt
    "Bayesthresh" # depends on broken package nlopt
    "BaySIC" # broken build
    "BBRecapture" # depends on broken package nlopt
    "BCA" # depends on broken package nlopt
    "bdynsys" # depends on broken package car
    "BEST" # broken build
    "bgmm" # depends on broken package nlopt
    "BIFIEsurvey" # depends on broken package nlopt
    "BiGGR" # depends on broken package rsbml
    "bioassayR" # broken build
    "BiodiversityR" # depends on broken package nlopt
    "biotools" # depends on broken package rpanel
    "birte" # build is broken
    "BLCOP" # depends on broken package Rsymphony
    "blmeco" # depends on broken package nlopt
    "blme" # depends on broken package nlopt
    "bmd" # depends on broken package nlopt
    "bmem" # depends on broken package nlopt
    "bmeta" # depends on broken package R2jags
    "bootnet" # depends on broken package nlopt
    "boral" # broken build
    "BradleyTerry2" # depends on broken package nlopt
    "BrailleR" # broken build
    "brainGraph" # build is broken
    "brms" # build is broken
    "BRugs" # build is broken
    "BTSPAS" # broken build
    "CADFtest" # depends on broken package nlopt
    "cAIC4" # depends on broken package nlopt
    "candisc" # depends on broken package nlopt
    "carcass" # depends on broken package nlopt
    "car" # depends on broken package nlopt
    "caret" # depends on broken package nlopt
    "caretEnsemble" # depends on broken package nlopt
    "CARrampsOcl" # depends on broken package OpenCL
    "Causata" # broken build
    "CCpop" # depends on broken package nlopt
    "CCTpack" # broken build
    "ChainLadder" # depends on broken package nlopt
    "ChemmineR" # Build Is Broken
    "chipenrich" # build is broken
    "chipPCR" # depends on broken nloptr
    "classify" # broken build
    "climwin" # depends on broken package nlopt
    "CLME" # depends on broken package nlopt
    "clpAPI" # build is broken
    "clusterPower" # depends on broken package nlopt
    "clusterSEs" # depends on broken AER
    "ClustGeo" # depends on broken FactoMineR
    "CNORfuzzy" # depends on broken package nlopt
    "CNVPanelizer" # depends on broken cn.mops
    "COHCAP" # build is broken
    "colorscience" # broken build
    "compendiumdb" # broken build
    "conformal" # depends on broken package nlopt
    "corHMM" # depends on broken package nlopt
    "CosmoPhotoz" # depends on broken package nlopt
    "covmat" # depends on broken package VIM
    "cplexAPI" # build is broken
    "cquad" # depends on broken package car
    "crmPack" # depends on broken package rjags
    "CrypticIBDcheck" # depends on broken package nlopt
    "ctsem" # depends on broken package OpenMx
    "cudaBayesreg" # build is broken
    "daff" # depends on broken package V8
    "dagbag" # build is broken
    "DAMisc" # depends on broken package nlopt
    "datafsm" # depends on broken package caret
    "dbConnect" # broken build
    "DBKGrad" # depends on broken package rpanel
    "dcmle" # broken build
    "ddst" # broken build
    "Deducer" # depends on broken package nlopt
    "DeducerExtras" # depends on broken package nlopt
    "DeducerPlugInExample" # depends on broken package nlopt
    "DeducerPlugInScaling" # depends on broken package nlopt
    "DeducerSpatial" # depends on broken package nlopt
    "DeducerSurvival" # depends on broken package nlopt
    "DeducerText" # depends on broken package nlopt
    "DEGraph" # depends on broken package RCytoscape
    "destiny" # depends on broken package VIM
    "DiagTest3Grp" # depends on broken package nlopt
    "diffHic" # depends on broken package rhdf5
    "difR" # depends on broken package nlopt
    "DirichletMultinomial" # Build Is Broken
    "DistatisR" # depends on broken package nlopt
    "diveRsity" # depends on broken package nlopt
    "DJL" # depends on broken package car
    "dpa" # depends on broken package nlopt
    "dpcR" # depends on broken nloptr
    "drc" # depends on broken package nlopt
    "drfit" # depends on broken package nlopt
    "drsmooth" # depends on broken package nlopt
    "dynlm" # depends on broken package nlopt
    "easyanova" # depends on broken package nlopt
    "EasyMARK" # broken build
    "ecd" # depends on broken package polynom
    "edge" # depends on broken package nlopt
    "eeptools" # depends on broken package nlopt
    "EffectLiteR" # depends on broken package nlopt
    "effects" # depends on broken package nlopt
    "eiR" # depends on broken package ChemmineR
    "EMA" # depends on broken package nlopt
    "embryogrowth" # broken build
    "emg" # broken build
    "EnQuireR" # depends on broken package nlopt
    "episplineDensity" # depends on broken package nlopt
    "epr" # depends on broken package nlopt
    "erer" # depends on broken package nlopt
    "erma" # depends on broken GenomicFiles
    "erpR" # depends on broken package rpanel
    "ESKNN" # depends on broken package caret
    "euroMix" # build is broken
    "extRemes" # depends on broken package nlopt
    "ez" # depends on broken package nlopt
    "ezec" # depends on broken package drc
    "facopy" # depends on broken package nlopt
    "FactoMineR" # depends on broken package nlopt
    "Factoshiny" # depends on broken package nlopt
    "faoutlier" # depends on broken package nlopt
    "fastR" # depends on broken package nlopt
    "FDRreg" # depends on broken package nlopt
    "fishmethods" # depends on broken package lme4
    "flipflop" # broken build
    "flowDensity" # depends on broken package nlopt
    "flowPeaks" # build is broken
    "flowQ" # build is broken
    "flowStats" # depends on broken package ncdfFlow
    "flowVS" # depends on broken package ncdfFlow
    "flowWorkspace" # depends on broken package ncdfFlow
    "fmcsR" # depends on broken package ChemmineR
    "fPortfolio" # depends on broken package Rsymphony
    "fracprolif" # broken build
    "FreeSortR" # broken build
    "freqweights" # depends on broken package nlopt
    "frmqa" # broken build
    "FSA" # depends on broken package car
    "fscaret" # depends on broken package nlopt
    "funcy" # depends on broken package car
    "fxregime" # depends on broken package nlopt
    "gamclass" # depends on broken package nlopt
    "gamlss_demo" # depends on broken package rpanel
    "gamm4" # depends on broken package nlopt
    "gaussquad" # broken build
    "gcmr" # depends on broken package nlopt
    "GDAtools" # depends on broken package nlopt
    "gdtools" # broken build
    "gemtc" # broken build
    "GENE_E" # depends on broken package rhdf5
    "GENESIS" # broken build
    "genridge" # depends on broken package nlopt
    "geojsonio" # depends on broken package V8
    "GEWIST" # depends on broken package nlopt
    "ggtree" # broken build
    "gimme" # depends on broken package nlopt
    "gmatrix" # depends on broken package cudatoolkit
    "gMCP" # build is broken
    "gmum_r" # broken build
    "Goslate" # depends on broken package PythonInR
    "GPC" # broken build
    "gplm" # depends on broken package nlopt
    "gpuR" # depends on GPU-specific header files
    "gputools" # depends on broken package cudatoolkit
    "granova" # depends on broken package nlopt
    "graphicalVAR" # depends on broken package nlopt
    "GraphPAC" # broken build
    "gridGraphics" # build is broken
    "GSCA" # depends on broken package rhdf5
    "GUIDE" # depends on broken package rpanel
    "GWAF" # depends on broken package nlopt
    "GWASTools" # broken build
    "h5" # build is broken
    "h5vc" # depends on broken package rhdf5
    "hbsae" # depends on broken package nlopt
    "heplots" # depends on broken package nlopt
    "HiDimMaxStable" # broken build
    "HierO" # Build Is Broken
    "HilbertVisGUI" # Build Is Broken
    "HiPLARM" # Build Is Broken
    "HistDAWass" # depends on broken package nlopt
    "HLMdiag" # depends on broken package nlopt
    "homomorpheR" # broken build
    "hpcwld" # broken build
    "hwwntest" # broken build
    "HydeNet" # broken build
    "hysteresis" # depends on broken package nlopt
    "IATscores" # depends on broken package nlopt
    "ibd" # depends on broken package nlopt
    "iccbeta" # depends on broken package nlopt
    "iClick" # depends on broken package rugarch
    "ifaTools" # depends on broken package OpenMx
    "imager" # broken build
    "immunoClust" # build is broken
    "in2extRemes" # depends on broken package nlopt
    "inferference" # depends on broken package nlopt
    "influence_ME" # depends on broken package nlopt
    "inSilicoMerging" # build is broken
    "INSPEcT" # depends on broken GenomicFeatures
    "interplot" # depends on broken arm
    "IONiseR" # depends on broken rhdf5
    "IsingFit" # depends on broken package nlopt
    "ITEMAN" # depends on broken package car
    "iteRates" # broken build
    "iterpc" # broken build
    "IUPS" # broken build
    "IVAS" # depends on broken package nlopt
    "ivpack" # depends on broken package nlopt
    "jagsUI" # broken build
    "JAGUAR" # depends on broken package nlopt
    "joda" # depends on broken package nlopt
    "jomo" # build is broken
    "js" # depends on broken package V8
    "KoNLP" # broken build
    "kzft" # broken build
    "LaplaceDeconv" # depends on broken package orthopolynom
    "lawn" # depends on broken package V8
    "ldamatch" # broken build
    "learnstats" # depends on broken package nlopt
    "lefse" # build is broken
    "lessR" # depends on broken package nlopt
    "lgcp" # depends on broken package rpanel
    "Libra" # broken build
    "LinRegInteractive" # depends on broken package rpanel
    "lira" # broken build
    "littler" # broken build
    "lme4" # depends on broken package nlopt
    "LMERConvenienceFunctions" # depends on broken package nlopt
    "lmerTest" # depends on broken package nlopt
    "lmSupport" # depends on broken package nlopt
    "LOGIT" # depends on broken package caret
    "longpower" # depends on broken package nlopt
    "LPTime" # broken build
    "MAIT" # depends on broken package nlopt
    "mAPKL" # build is broken
    "maPredictDSC" # depends on broken package nlopt
    "mar1s" # broken build
    "marked" # depends on broken package nlopt
    "matchingMarkets" # broken build
    "MatrixRider" # depends on broken package DirichletMultinomial
    "MaxPro" # depends on broken package nlopt
    "mbest" # depends on broken package nlopt
    "MBmca" # depends on broken nloptr
    "mBvs" # build is broken
    "meboot" # depends on broken package nlopt
    "medflex" # depends on broken package car
    "mediation" # depends on broken package lme4
    "MEDME" # depends on broken package nlopt
    "MEMSS" # depends on broken package nlopt
    "merTools" # depends on broken package arm
    "meta4diag" # broken build
    "metagear" # build is broken
    "metaheur" # depends on broken package preprocomb
    "metamisc" # broken build
    "metaplus" # depends on broken package nlopt
    "metaSEM" # depends on broken package OpenMx
    "Metatron" # depends on broken package nlopt
    "miceadds" # depends on broken package nlopt
    "micEconAids" # depends on broken package nlopt
    "micEconCES" # depends on broken package nlopt
    "micEconSNQP" # depends on broken package nlopt
    "mi" # depends on broken package nlopt
    "MigClim" # Build Is Broken
    "migui" # depends on broken package nlopt
    "minimist" # depends on broken package V8
    "missMDA" # depends on broken package nlopt
    "mitoODE" # build is broken
    "mixAK" # depends on broken package nlopt
    "MixedPoisson" # broken build
    "mixlm" # depends on broken package nlopt
    "MixMAP" # depends on broken package nlopt
    "mlma" # depends on broken package lme4
    "mlmRev" # depends on broken package nlopt
    "MLSeq" # depends on broken package nlopt
    "mlVAR" # depends on broken package nlopt
    "MM" # broken build
    "mongolite" # build is broken
    "morse" # broken build
    "mosaic" # depends on broken package nlopt
    "mpoly" # broken build
    "mRMRe" # broken build
    "msa" # broken build
    "MSGFgui" # depends on broken package MSGFplus
    "MSGFplus" # Build Is Broken
    "MSstats" # depends on broken package nlopt
    "MultiRR" # depends on broken package nlopt
    "muma" # depends on broken package nlopt
    "munsellinterpol" # broken build
    "mutossGUI" # build is broken
    "mvinfluence" # depends on broken package nlopt
    "MXM" # broken build
    "NanoStringDiff" # broken build
    "NanoStringQCPro" # build is broken
    "nCal" # depends on broken package nlopt
    "ncdfFlow" # build is broken
    "NCIgraph" # depends on broken package RCytoscape
    "NHPoisson" # depends on broken package nlopt
    "nloptr" # depends on broken package nlopt
    "nlsem" # broken build
    "nlts" # broken build
    "nonrandom" # depends on broken package nlopt
    "NORRRM" # build is broken
    "npIntFactRep" # depends on broken package nlopt
    "NSM3" # broken build
    "omics" # depends on broken package lme4
    "OmicsMarkeR" # depends on broken package nlopt
    "OPDOE" # broken build
    "OpenCL" # build is broken
    "openCyto" # depends on broken package ncdfFlow
    "OpenMx" # build is broken
    "optBiomarker" # depends on broken package rpanel
    "ora" # depends on broken package ROracle
    "ordBTL" # depends on broken package nlopt
    "ordPens" # depends on broken package lme4
    "orthopolynom" # broken build
    "OUwie" # depends on broken package nlopt
    "oz" # broken build
    "PAA" # broken build
    "pamm" # depends on broken package nlopt
    "panelAR" # depends on broken package nlopt
    "papeR" # depends on broken package nlopt
    "parboost" # depends on broken package nlopt
    "parma" # depends on broken package nlopt
    "partitions" # broken build
    "PatternClass" # build is broken
    "PBImisc" # depends on broken package nlopt
    "pcaBootPlot" # depends on broken FactoMineR
    "pcaL1" # build is broken
    "pcnetmeta" # broken build
    "PDQutils" # broken build
    "pedigreemm" # depends on broken package nlopt
    "pequod" # depends on broken package nlopt
    "pglm" # depends on broken package car
    "PhenStat" # depends on broken package nlopt
    "phia" # depends on broken package nlopt
    "phylocurve" # depends on broken package nlopt
    "piecewiseSEM" # depends on broken package lme4
    "plateCore" # depends on broken package ncdfFlow
    "plfMA" # broken build
    "plm" # depends on broken package car
    "plsRbeta" # depends on broken package nlopt
    "plsRcox" # depends on broken package nlopt
    "plsRglm" # depends on broken package nlopt
    "pmm" # depends on broken package nlopt
    "polynom" # broken build
    "pomp" # depends on broken package nlopt
    "predictmeans" # depends on broken package nlopt
    "preprocomb" # depends on broken package caret
    "prevalence" # broken build
    "prLogistic" # depends on broken package nlopt
    "pRoloc" # depends on broken package nlopt
    "pRolocGUI" # depends on broken package nlopt
    "PSAboot" # depends on broken package nlopt
    "ptw" # depends on broken nloptr
    "PurBayes" # broken build
    "PVAClone" # broken build
    "pvca" # depends on broken package nlopt
    "PythonInR" # broken build
    "QFRM" # broken build
    "qgraph" # depends on broken package nlopt
    "qtbase" # build is broken
    "qtlnet" # depends on broken package nlopt
    "qtpaint" # depends on broken package qtbase
    "qtutils" # depends on broken package qtbase
    "QUALIFIER" # depends on broken package ncdfFlow
    "quantification" # depends on broken package nlopt
    "QuartPAC" # broken build
    "R2jags" # broken build
    "R2STATS" # depends on broken package nlopt
    "rain" # broken build
    "raincpc" # build is broken
    "rainfreq" # build is broken
    "RamiGO" # depends on broken package RCytoscape
    "RareVariantVis" # depends on broken VariantAnnotation
    "rasclass" # depends on broken package nlopt
    "rationalfun" # broken build
    "RBerkeley" # broken build
    "RbioRXN" # depends on broken package ChemmineR
    "Rblpapi" # broken build
    "Rchemcpp" # depends on broken package ChemmineR
    "rchess" # depends on broken package V8
    "Rchoice" # depends on broken package car
    "Rcmdr" # depends on broken package nlopt
    "RcmdrMisc" # depends on broken package nlopt
    "RcmdrPlugin_BCA" # depends on broken package nlopt
    "RcmdrPlugin_coin" # depends on broken package nlopt
    "RcmdrPlugin_depthTools" # depends on broken package nlopt
    "RcmdrPlugin_DoE" # depends on broken package nlopt
    "RcmdrPlugin_doex" # depends on broken package nlopt
    "RcmdrPlugin_EACSPIR" # depends on broken package nlopt
    "RcmdrPlugin_EBM" # depends on broken package nlopt
    "RcmdrPlugin_EcoVirtual" # depends on broken package nlopt
    "RcmdrPlugin_epack" # depends on broken package nlopt
    "RcmdrPlugin_Export" # depends on broken package Rcmdr
    "RcmdrPlugin_EZR" # depends on broken package nlopt
    "RcmdrPlugin_FactoMineR" # depends on broken package nlopt
    "RcmdrPlugin_HH" # depends on broken package nlopt
    "RcmdrPlugin_IPSUR" # depends on broken package nlopt
    "RcmdrPlugin_KMggplot2" # depends on broken package nlopt
    "RcmdrPlugin_lfstat" # depends on broken package nlopt
    "RcmdrPlugin_MA" # depends on broken package nlopt
    "RcmdrPlugin_mosaic" # depends on broken package nlopt
    "RcmdrPlugin_MPAStats" # depends on broken package nlopt
    "RcmdrPlugin_NMBU" # depends on broken package nlopt
    "RcmdrPlugin_orloca" # depends on broken package nlopt
    "RcmdrPlugin_plotByGroup" # depends on broken package nlopt
    "RcmdrPlugin_pointG" # depends on broken package nlopt
    "RcmdrPlugin_qual" # depends on broken package nlopt
    "RcmdrPlugin_RMTCJags" # depends on broken package nlopt
    "RcmdrPlugin_ROC" # depends on broken package nlopt
    "RcmdrPlugin_sampling" # depends on broken package nlopt
    "RcmdrPlugin_SCDA" # depends on broken package nlopt
    "RcmdrPlugin_seeg" # depends on broken package nlopt
    "RcmdrPlugin_SLC" # depends on broken package nlopt
    "RcmdrPlugin_SM" # depends on broken package nlopt
    "RcmdrPlugin_sos" # depends on broken package nlopt
    "RcmdrPlugin_steepness" # depends on broken package nlopt
    "RcmdrPlugin_survival" # depends on broken package nlopt
    "RcmdrPlugin_TeachingDemos" # depends on broken package nlopt
    "RcmdrPlugin_temis" # depends on broken package nlopt
    "RcmdrPlugin_UCA" # depends on broken package nlopt
    "Rcpi" # depends on broken package ChemmineR
    "Rcplex" # Build Is Broken
    "RcppAPT" # Build Is Broken
    "RcppRedis" # build is broken
    "rcrypt" # broken build
    "RCytoscape" # Build Is Broken
    "rdd" # depends on broken package nlopt
    "rddtools" # depends on broken package AER
    "rDEA" # build is broken
    "RDieHarder" # build is broken
    "REBayes" # depends on broken package Rmosek
    "referenceIntervals" # depends on broken package nlopt
    "refund" # depends on broken package nlopt
    "refund_shiny" # depends on broken package refund
    "REndo" # depends on broken package AER
    "repijson" # depends on broken package V8
    "REST" # depends on broken package nlopt
    "rgbif" # depends on broken package V8
    "Rgnuplot" # broken build
    "rhdf5" # build is broken
    "rjade" # depends on broken package V8
    "rjags" # broken build
    "rJPSGCS" # build is broken
    "rLindo" # build is broken
    "RLRsim" # depends on broken package lme4
    "RMallow" # broken build
    "rMAT" # build is broken
    "rmgarch" # depends on broken package nlopt
    "rminer" # depends on broken package nlopt
    "Rmosek" # build is broken
    "RMySQL" # broken build
    "RNAither" # depends on broken package nlopt
    "RnavGraph" # build is broken
    "rnetcarto" # broken build
    "robustlmm" # depends on broken package nlopt
    "rockchalk" # depends on broken package nlopt
    "ROI_plugin_symphony" # depends on broken package Rsymphony
    "rols" # build is broken
    "ROracle" # Build Is Broken
    "rpanel" # build is broken
    "Rpoppler" # broken build
    "rpubchem" # depends on broken package nlopt
    "RQuantLib" # build is broken
    "rr" # depends on broken package nlopt
    "RRreg" # depends on broken package lme4
    "RSAP" # build is broken
    "rsbml" # build is broken
    "RSDA" # depends on broken package nlopt
    "Rsomoclu" # broken build
    "RStoolbox" # depends on broken package caret
    "Rsymphony" # build is broken
    "rTableICC" # broken build
    "rTANDEM" # build is broken
    "RTN" # depends on broken package nlopt
    "rugarch" # depends on broken package nlopt
    "rUnemploymentData" # broken build
    "RVAideMemoire" # depends on broken package nlopt
    "RVFam" # depends on broken package nlopt
    "RVideoPoker" # depends on broken package rpanel
    "RWebServices" # broken build
    "ryouready" # depends on broken package nlopt
    "sadists" # broken build
    "sampleSelection" # depends on broken package nlopt
    "sapFinder" # depends on broken package rTANDEM
    "sdcMicro" # depends on broken package nlopt
    "sdcMicroGUI" # depends on broken package nlopt
    "SDD" # depends on broken package rpanel
    "seeg" # depends on broken package nlopt
    "Sejong" # broken build
    "sem" # depends on broken package nlopt
    "semdiag" # depends on broken package nlopt
    "semGOF" # depends on broken package nlopt
    "semPlot" # depends on broken package nlopt
    "SensMixed" # depends on broken package lme4
    "SensoMineR" # depends on broken package nlopt
    "seqCNA" # build is broken
    "SeqFeatR" # broken build
    "SeqGrapheR" # Build Is Broken
    "seqHMM" # depends on broken package nloptr
    "seqTools" # build is broken
    "SharpeR" # broken build
    "sharx" # broken build
    "shinyTANDEM" # depends on broken package rTANDEM
    "SIBER" # broken build
    "simmr" # broken build
    "simPop" # depends on broken package VIM
    "simr" # depends on broken package lme4
    "SJava" # broken build
    "sjPlot" # depends on broken package nlopt
    "smacof" # broken build
    "SNAGEE" # build is broken
    "snm" # depends on broken package nlopt
    "SOD" # depends on broken package cudatoolkit
    "sodium" # broken build
    "soilphysics" # depends on broken package rpanel
    "sortinghat" # broken build
    "SoyNAM" # depends on broken package lme4
    "spacom" # depends on broken package nlopt
    "SparseLearner" # depends on broken package qgraph
    "specificity" # depends on broken package nlopt
    "specmine" # depends on broken package caret
    "splm" # depends on broken package car
    "spocc" # depends on broken package V8
    "spoccutils" # depends on broken spocc
    "ssmrob" # depends on broken package nlopt
    "StatMethRank" # broken build
    "stepp" # depends on broken package nlopt
    "stringgaussnet" # build is broken
    "Surrogate" # depends on broken package nlopt
    "svglite" # depends on broken package gdtools
    "sybilSBML" # build is broken
    "synchronicity" # build is broken
    "synthpop" # build is broken
    "systemfit" # depends on broken package nlopt
    "TcGSA" # depends on broken package nlopt
    "TDMR" # depends on broken package nlopt
    "TextoMineR"  # depends on broken package FactoMineR
    "TFBSTools" # depends on broken package DirichletMultinomial
    "tigerstats" # depends on broken package nlopt
    "TLBC" # depends on broken package caret
    "tmle" # broken build
    "tnam" # depends on broken package lme4
    "tolBasis" # depends on broken package polynom
    "translateSPSS2R" # depends on broken car
    "TriMatch" # depends on broken package nlopt
    "TSMySQL" # broken build
    "tsoutliers" # broken build
    "UBCRM" # broken build
    "umx" # depends on broken package OpenMx
    "uniftest" # broken build
    "untb" # broken build
    "userfriendlyscience" # depends on broken package nlopt
    "V8" # build is broken
    "varComp" # depends on broken package lme4
    "varian" # build is broken
    "variancePartition" # depends on broken package lme4
    "VBmix" # broken build
    "VIM" # depends on broken package nlopt
    "VIMGUI" # depends on broken package nlopt
    "vows" # depends on broken package nlopt
    "webp" # build is broken
    "wfe" # depends on broken package nlopt
    "wordbankr" # depends on broken package RMySQL
    "xergm" # depends on broken package nlopt
    "xps" # build is broken
    "ZeligChoice" # depends on broken package AER
    "Zelig" # depends on broken package AER
    "zetadiv" # depends on broken package nlopt
    "zoib" # broken build
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
