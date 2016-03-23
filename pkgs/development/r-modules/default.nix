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
    "a4Base" # depends on broken package annaffy-1.41.1
    "a4Classif" # broken build
    "a4Core" # broken build
    "a4" # depends on broken package annaffy-1.41.1
    "a4Preproc" # broken build
    "a4Reporting" # depends on broken package annaffy-1.41.1
    "ABAEnrichment" # broken build
    "ABarray" # broken build
    "abd" # depends on broken package nlopt-2.4.2
    "aCGH" # broken build
    "ACME" # broken build
    "Actigraphy" # Build Is Broken
    "adabag" # depends on broken package nlopt-2.4.2
    "ADaCGH2" # depends on broken package tilingArray-1.47.0
    "adhoc" # broken build
    "adSplit" # build is broken
    "AER" # depends on broken package nlopt-2.4.2
    "afex" # depends on broken package nlopt-2.4.2
    "AffyCompatible" # broken build
    "affycomp" # broken build
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
    "AGDEX" # broken build
    "AgiMicroRna" # depends on broken package affyio-1.37.0
    "agRee" # depends on broken package nlopt-2.4.2
    "AIMS" # broken build
    "ALDEx2" # broken build
    "aLFQ" # depends on broken package nlopt-2.4.2
    "algstat" # broken build
    "AllelicImbalance" # depends on broken package Rsamtools-1.21.8
    "alr3" # depends on broken package nlopt-2.4.2
    "alr4" # depends on broken package nlopt-2.4.2
    "alsace" # depends on broken nloptr-1.0.4
    "altcdfenvs" # depends on broken package affyio-1.37.0
    "ampliQueso" # depends on broken package Rsamtools-1.21.8
    "anacor" # depends on broken package nlopt-2.4.2
    "AnalysisPageServer" # broken build
    "animation" # broken build
    "anim_plots" # broken build
    "annaffy" # build is broken
    "annmap" # depends on broken package Rsamtools-1.21.8
    "annotate" # broken build
    "AnnotationDbi" # broken build
    "AnnotationForge" # Build Is Broken
    "AnnotationFuncs" # broken build
    "AnnotationHubData" # depends on broken package r-AnnotationForge-1.11.19
    "AnnotationHub" # depends on broken package interactiveDisplayBase-1.7.0
    "annotationTools" # broken build
    "anota" # broken build
    "aods3" # depends on broken package nlopt-2.4.2
    "aop" # broken build
    "apaTables" # depends on broken package r-car-2.1-0
    "apComplex" # build is broken
    "apex" # depends on broken package Biostrings-2.38.2
    "apmsWAPP" # broken build
    "apt" # depends on broken package nlopt-2.4.2
    "ArfimaMLM" # depends on broken package nlopt-2.4.2
    "arm" # depends on broken package nlopt-2.4.2
    "ArrayBin" # broken build
    "ArrayExpress" # depends on broken package affyio-1.37.0
    "ArrayExpressHTS" # depends on broken package Rsamtools-1.21.8
    "arrayMvout" # depends on broken package affyio-1.37.0
    "arrayQualityMetrics" # depends on broken package affyio-1.37.0
    "ArrayTools" # depends on broken package affyio-1.37.0
    "ArrayTV" # depends on broken package affyio-1.37.0
    "ARRmNormalization" # Build Is Broken
    "ART" # depends on broken package ar-car-2.1-0
    "ARTool" # depends on broken package nlopt-2.4.2
    "AssetPricing" # broken build
    "AtelieR" # broken build
    "attract" # depends on broken package AnnotationForge-1.11.3
    "auRoc" # depends on broken package rjags-4-4
    "AutoModel" # depends on broken package r-car-2.1-0
    "babel" # broken build
    "BACA" # depends on broken package Category-2.35.1
    "backShift" # broken build
    "BAGS" # build is broken
    "ballgown" # depends on broken package Rsamtools-1.21.8
    "bamdit"
    "bamsignals" # build is broken
    "BANOVA"
    "bapred" # depends on broken package r-lme4-1.1-9
    "bartMachine" # depends on broken package nlopt-2.4.2
    "Basic4Cseq" # depends on broken package Rsamtools-1.21.8
    "bayescount"
    "bayesDem" # depends on broken package nlopt-2.4.2
    "bayesLife" # depends on broken package nlopt-2.4.2
    "BayesMed"
    "bayesmix"
    "BayesPeak" # broken build
    "bayesPop" # depends on broken package nlopt-2.4.2
    "Bayesthresh" # depends on broken package nlopt-2.4.2
    "bayou" # broken build
    "baySeq" # broken build
    "BaySIC"
    "BBCAnalyzer" # depends on broken package r-Rsamtools-1.21.18
    "BBRecapture" # depends on broken package nlopt-2.4.2
    "BCA" # depends on broken package nlopt-2.4.2
    "BcDiag" # broken build
    "BCRANK" # broken build
    "bcrypt"
    "bdynsys" # depends on broken package car-2.1
    "beadarray" # broken build
    "beadarrayFilter" # broken build
    "beadarrayMSV" # broken build
    "beadarraySNP" # broken build
    "BEAT" # depends on broken package Rsamtools-1.21.8
    "BEDMatrix" # broken build
    "bedr" # broken build
    "BEST"
    "betr" # broken build
    "bgmm" # depends on broken package nlopt-2.4.2
    "bgx" # depends on broken package affyio-1.37.0
    "BicARE" # broken build
    "BIFIEsurvey" # depends on broken package nlopt-2.4.2
    "bigGP" # build is broken
    "BiGGR" # depends on broken package rsbml-2.27.0
    "bigmemoryExtras" # broken build
    "bioassayR" # broken build
    "Biobase" # broken build
    "biobroom" # depends on broken package r-Biobase-2.30.0
    "BiocCaseStudies" # broken build
    "BiocCheck" # broken build
    "BiocGenerics" # broken build
    "biocGraph" # broken build
    "biocViews" # broken build
    "bioDist" # broken build
    "BiodiversityR" # depends on broken package nlopt-2.4.2
    "biomaRt" # broken build
    "biomartr" # broken build
    "BioMVCClass" # broken build
    "biomvRCNS" # depends on broken package Rsamtools-1.21.8
    "BioNet" # broken build
    "BioSeqClass" # broken build
    "Biostrings" # broken build
    "biosvd" # broken build
    "biotools" # depends on broken package rpanel-1.1-3
    "biovizBase" # depends on broken package Rsamtools-1.21.8
    "birta" # broken build
    "birte" # build is broken
    "bisectr" # broken build
    "BiSEp" # depends on broken package GOSemSim-1.27.3
    "BiSeq" # depends on broken package Rsamtools-1.21.8
    "BitSeq" # depends on broken package Rsamtools-1.21.8
    "BLCOP" # depends on broken package Rsymphony-0.1-20
    "blima" # broken build
    "blmeco" # depends on broken package nlopt-2.4.2
    "blme" # depends on broken package nlopt-2.4.2
    "bmd" # depends on broken package nlopt-2.4.2
    "bmem" # depends on broken package nlopt-2.4.2
    "bmeta" # depends on broken package r-R2jags-0.5-7
    "BMhyd" # broken build
    "bnclassify" # broken build
    "bootnet" # depends on broken package nlopt-2.4.2
    "boral"
    "BradleyTerry2" # depends on broken package nlopt-2.4.2
    "BrailleR" # broken build
    "BRAIN" # broken build
    "brainGraph" # build is broken
    "BrainStars" # broken build
    "brms" # build is broken
    "BrowserViz" # broken build
    "BrowserVizDemo" # broken build
    "brr" # broken build
    "BRugs" # build is broken
    "BSgenome" # depends on broken package Rsamtools-1.21.8
    "bsseq" # broken build
    "BTSPAS"
    "BubbleTree" # depends on broken package r-biovizBase-1.17.2
    "bumphunter" # depends on broken package Rsamtools-1.21.8
    "CADFtest" # depends on broken package nlopt-2.4.2
    "CAFE" # depends on broken package affyio-1.37.0
    "CAGEr" # depends on broken package Rsamtools-1.21.8
    "cAIC4" # depends on broken package nlopt-2.4.2
    "CAMERA" # depends on broken package mzR-2.3.1
    "cancerclass" # broken build
    "canceR" # depends on broken package Category-2.35.1
    "CancerMutationAnalysis" # broken build
    "candisc" # depends on broken package nlopt-2.4.2
    "carcass" # depends on broken package nlopt-2.4.2
    "car" # depends on broken package nlopt-2.4.2
    "Cardinal" # broken build
    "caret" # depends on broken package nlopt-2.4.2
    "caretEnsemble" # depends on broken package nlopt-2.4.2
    "caRpools" # broken build
    "CARrampsOcl" # depends on broken package OpenCL-0.1-3
    "casper" # depends on broken package Rsamtools-1.21.8
    "cate" # broken build
    "Category" # Build Is Broken
    "categoryCompare" # depends on broken package Category-2.35.1
    "Causata" # broken build
    "CCpop" # depends on broken package nlopt-2.4.2
    "CCTpack"
    "cdcfluview" # broken build
    "cellHTS2" # depends on broken package Category-2.35.1
    "cellHTS" # broken build
    "CellNOptR" # broken build
    "CexoR" # depends on broken package Rsamtools-1.21.8
    "CGHbase" # broken build
    "CGHcall" # broken build
    "cghMCR" # broken build
    "CGHnormaliter" # broken build
    "CGHregions" # broken build
    "ChainLadder" # depends on broken package nlopt-2.4.2
    "ChAMP" # depends on broken package affyio-1.37.0
    "charm" # depends on broken package affyio-1.37.0
    "ChemmineOB" # broken build
    "ChemmineR" # Build Is Broken
    "chimera" # depends on broken package Rsamtools-1.21.8
    "ChIPComp" # depends on broken package r-Rsamtools-1.21.18
    "chipenrich" # build is broken
    "chipPCR" # depends on broken nloptr-1.0.4
    "ChIPpeakAnno" # depends on broken package Rsamtools-1.21.8
    "ChIPQC" # depends on broken package AnnotationForge-1.11.3
    "ChIPseeker" # depends on broken package Rsamtools-1.21.8
    "chipseq" # depends on broken package Rsamtools-1.21.8
    "ChIPseqR" # depends on broken package Rsamtools-1.21.8
    "ChIPsim" # depends on broken package Rsamtools-1.21.8
    "ChIPXpress" # depends on broken package affyio-1.37.0
    "chroGPS" # broken build
    "chromDraw" # broken build
    "ChromHeatMap" # depends on broken package Rsamtools-1.21.8
    "classGraph" # broken build
    "classify"
    "ClassifyR" # broken build
    "cleanUpdTSeq" # depends on broken package Rsamtools-1.21.8
    "cleaver" # broken build
    "clere" # broken build
    "climwin" # depends on broken package nlopt-2.4.2
    "clippda" # broken build
    "clipper" # depends on broken package Rsamtools-1.21.8
    "CLME" # depends on broken package nlopt-2.4.2
    "clpAPI" # build is broken
    "clusterPower" # depends on broken package nlopt-2.4.2
    "clusterProfiler" # depends on broken package GOSemSim-1.27.3
    "clusterSEs" # depends on broken AER-1.2-4
    "clusterStab" # broken build
    "ClustGeo" # depends on broken FactoMineR-1.31.3
    "CMA" # broken build
    "CNEr" # depends on broken package Rsamtools-1.21.8
    "cn_farms" # depends on broken package affyio-1.37.0
    "cn_mops" # depends on broken package Rsamtools-1.21.8
    "CNORdt" # broken build
    "CNORfeeder" # broken build
    "CNORfuzzy" # depends on broken package nlopt-2.4.2
    "CNORode" # broken build
    "CNPBayes" # depends on broken package r-BiocGenerics-0.16.1
    "CNTools" # broken build
    "cnvGSA" # broken build
    "CNVPanelizer" # depends on broken cn.mops-1.15.1
    "CNVrd2" # depends on broken package Rsamtools-1.21.8
    "coalescentMCMC" # depends on broken package Biostrings-2.38.2
    "cobindR" # depends on broken package Rsamtools-1.21.8
    "CoCiteStats" # Build Is Broken
    "codelink" # broken build
    "CODEX" # depends on broken package Rsamtools-1.21.8
    "coefplot" # build is broken
    "cogena" # broken build
    "COHCAP" # build is broken
    "colorscience"
    "coMET" # depends on broken package Rsamtools-1.21.8
    "CommT" # depends on broken package Biostrings-2.38.2
    "compcodeR" # broken build
    "compendiumdb" # broken build
    "compEpiTools" # depends on broken package topGO-2.21.0
    "CompGO" # depends on broken package Category-2.35.1
    "conformal" # depends on broken package nlopt-2.4.2
    "ConsensusClusterPlus" # Build Is Broken
    "conumee" # depends on broken package Rsamtools-1.21.8
    "convert" # broken build
    "convevol" # broken build
    "copa" # broken build
    "CopulaDTA" # depends on broken package r-rstan-2.8.2
    "CopyNumber450k" # depends on broken package Rsamtools-1.21.8
    "copynumber" # broken build
    "CopywriteR" # depends on broken package Rsamtools-1.21.8
    "corHMM" # depends on broken package nlopt-2.4.2
    "Cormotif" # depends on broken package affyio-1.37.0
    "coRNAi" # depends on broken package Category-2.35.1
    "cosmiq" # depends on broken package mzR-2.3.1
    "CosmoPhotoz" # depends on broken package nlopt-2.4.2
    "CoverageView" # depends on broken package Rsamtools-1.21.8
    "covmat" # depends on broken package r-VIM-4.4.1
    "covr" # broken build
    "cp4p" # broken build
    "cpgen" # depends on broken package r-pedigreemm-0.3-3
    "cplexAPI" # build is broken
    "cpvSNP" # depends on broken package Rsamtools-1.21.8
    "cquad" # depends on broken package car-2.1-1
    "creditr" # broken build
    "CRImage" # broken build
    "CRISPRseek" # depends on broken package Rsamtools-1.21.8
    "crlmm" # depends on broken package affyio-1.37.0
    "crmn" # broken build
    "crmPack" # depends on broken package r-rjags-4-4
    "Crossover" # Build Is Broken
    "CrypticIBDcheck" # depends on broken package nlopt-2.4.2
    "CSAR" # broken build
    "csaw" # depends on broken package Rsamtools-1.21.8
    "ctsem" # depends on broken package r-OpenMx-2.2.6
    "cudaBayesreg" # build is broken
    "cummeRbund" # depends on broken package Rsamtools-1.21.8
    "curvHDR" # broken build
    "customProDB" # depends on broken package Rsamtools-1.21.8
    "cycle" # broken build
    "cytofkit" # broken build
    "D2C" # broken build
    "daff" # depends on broken package V8-0.6
    "dagbag" # build is broken
    "dagLogo" # depends on broken package Rsamtools-1.21.8
    "DAMisc" # depends on broken package nlopt-2.4.2
    "DAPAR" # depends on broken package r-imputeLCMD-2.0
    "DASiR" # broken build
    "datafsm" # depends on broken package r-caret-6.0-52
    "DBChIP" # broken build
    "dbConnect" # broken build
    "DBKGrad" # depends on broken package rpanel-1.1-3
    "dcGOR" # broken build
    "DChIPRep" # depends on broken package r-DESeq2-1.10.0
    "dcmle"
    "ddCt" # broken build
    "DDD" # depends on broken package r-phytools-0.5-00
    "ddgraph" # broken build
    "ddst" # broken build
    "DECIPHER" # broken build
    "DeconRNASeq" # broken build
    "Deducer" # depends on broken package nlopt-2.4.2
    "DeducerExtras" # depends on broken package nlopt-2.4.2
    "DeducerPlugInExample" # depends on broken package nlopt-2.4.2
    "DeducerPlugInScaling" # depends on broken package nlopt-2.4.2
    "DeducerSpatial" # depends on broken package nlopt-2.4.2
    "DeducerSurvival" # depends on broken package nlopt-2.4.2
    "DeducerText" # depends on broken package nlopt-2.4.2
    "deepSNV" # depends on broken package Rsamtools-1.21.8
    "DEGraph" # depends on broken package RCytoscape-1.19.0
    "DEGreport" # broken build
    "demi" # depends on broken package affyio-1.37.0
    "derfinder" # depends on broken package Rsamtools-1.21.8
    "derfinderHelper" # broken build
    "derfinderPlot" # depends on broken package Rsamtools-1.21.8
    "DescribeDisplay" # build is broken
    "DESeq2" # broken build
    "DESeq" # broken build
    "DESP" # broken build
    "destiny" # depends on broken package VIM-4.3.0
    "DEXSeq" # depends on broken package Rsamtools-1.21.8
    "dexus" # broken build
    "DFP" # broken build
    "DiagTest3Grp" # depends on broken package nlopt-2.4.2
    "DiffBind" # depends on broken package AnnotationForge-1.11.3
    "DiffCorr" # broken build
    "diffHic" # depends on broken package rhdf5-2.13.1
    "difR" # depends on broken package nlopt-2.4.2
    "diggit" # broken build
    "DirichletMultinomial" # Build Is Broken
    "discSurv" # depends on broken package nlopt-2.4.2
    "DistatisR" # depends on broken package nlopt-2.4.2
    "diveRsity" # depends on broken package nlopt-2.4.2
    "DJL" # depends on broken package r-car-2.1-0
    "DMRcaller" # broken build
    "DMRcate" # depends on broken package Rsamtools-1.21.8
    "DMRforPairs" # depends on broken package Rsamtools-1.21.8
    "dnet" # broken build
    "docxtractr" # broken build
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
    "DSS" # broken build
    "dualKS" # depends on broken package affyio-1.37.0
    "dupRadar" # depends on broken package r-Rsubread-1.19.5
    "dyebias" # broken build
    "dynlm" # depends on broken package nlopt-2.4.2
    "easyanova" # depends on broken package nlopt-2.4.2
    "EasyMARK"
    "easyRNASeq" # depends on broken package Rsamtools-1.21.8
    "EBarrays" # broken build
    "EBcoexpress" # broken build
    "EBImage" # broken build
    "ecd" # depends on broken package r-polynom-1.3-8
    "ecolitk" # broken build
    "EDASeq" # depends on broken package Rsamtools-1.21.8
    "EDDA" # broken build
    "edge" # depends on broken package nlopt-2.4.2
    "edgeR" # broken build
    "edgeRun" # broken build
    "edmr" # broken build
    "eeptools" # depends on broken package nlopt-2.4.2
    "EffectLiteR" # depends on broken package nlopt-2.4.2
    "effects" # depends on broken package nlopt-2.4.2
    "eiR" # depends on broken package ChemmineR-2.21.7
    "eisa" # depends on broken package Category-2.35.1
    "ELMER" # depends on broken package Rsamtools-1.21.8
    "EMA" # depends on broken package nlopt-2.4.2
    "embryogrowth" # broken build
    "emg" # broken build
    "empiricalFDR_DESeq2" # broken build
    "ENmix" # depends on broken package affyio-1.37.0
    "EnQuireR" # depends on broken package nlopt-2.4.2
    "EnrichedHeatmap" # broken build
    "EnrichmentBrowser" # depends on broken package r-EDASeq-2.3.2
    "ensembldb" # depends on broken package interactiveDisplayBase-1.7.0
    "ensemblVEP" # depends on broken package Rsamtools-1.21.8
    "epigenomix" # depends on broken package Rsamtools-1.21.8
    "episplineDensity" # depends on broken package nlopt-2.4.2
    "epivizr" # depends on broken package Rsamtools-1.21.8
    "epoc" # broken build
    "epr" # depends on broken package nlopt-2.4.2
    "erccdashboard" # broken build
    "erer" # depends on broken package nlopt-2.4.2
    "erma" # depends on broken GenomicFiles-1.5.4
    "erpR" # depends on broken package rpanel-1.1-3
    "ESKNN" # depends on broken package r-caret-6.0-52
    "eulerian" # broken build
    "euroMix" # build is broken
    "evobiR" # broken build
    "evolqg" # broken build
    "ExiMiR" # depends on broken package affyio-1.37.0
    "exomeCopy" # depends on broken package Rsamtools-1.21.8
    "ExomeDepth" # depends on broken package Rsamtools-1.21.8
    "exomePeak" # depends on broken package Rsamtools-1.21.8
    "ExpressionView" # depends on broken package Category-2.35.1
    "extRemes" # depends on broken package nlopt-2.4.2
    "ez" # depends on broken package nlopt-2.4.2
    "ezec" # depends on broken package drc-2.5
    "fabia" # broken build
    "facopy" # depends on broken package nlopt-2.4.2
    "factDesign" # broken build
    "FactoMineR" # depends on broken package nlopt-2.4.2
    "Factoshiny" # depends on broken package nlopt-2.4.2
    "faoutlier" # depends on broken package nlopt-2.4.2
    "farms" # depends on broken package affyio-1.37.0
    "fastLiquidAssociation" # depends on broken package LiquidAssociation-1.23.0
    "fastR" # depends on broken package nlopt-2.4.2
    "fastseg" # broken build
    "fdrDiscreteNull" # broken build
    "FDRreg" # depends on broken package nlopt-2.4.2
    "FedData" # broken build
    "FEM" # build is broken
    "ffpe" # depends on broken package affyio-1.37.0
    "FIACH" # broken build
    "FindMyFriends" # broken build
    "FISHalyseR" # broken build
    "fishmethods" # depends on broken package r-lme4-1.1-10
    "flagme" # depends on broken package mzR-2.3.1
    "flipflop" # broken build
    "flowBeads" # broken build
    "flowBin" # broken build
    "flowcatchR" # broken build
    "flowCHIC" # broken build
    "flowCL" # broken build
    "flowClean" # broken build
    "flowClust" # broken build
    "flowCore" # broken build
    "flowDensity" # depends on broken package nlopt-2.4.2
    "flowDiv" # depends on broken package r-flowCore-1.35.11
    "flowFit" # broken build
    "flowFP" # broken build
    "flowMatch" # broken build
    "flowMeans" # broken build
    "flowMerge" # broken build
    "flowPeaks" # build is broken
    "flowQB" # broken build
    "flowQ" # build is broken
    "FlowSOM" # depends on broken package ConsensusClusterPlus-1.23.0
    "flowStats" # depends on broken package ncdfFlow-2.15.2
    "flowTrans" # broken build
    "flowType" # broken build
    "flowUtils" # broken build
    "flowViz" # broken build
    "flowVS" # depends on broken package ncdfFlow-2.15.2
    "flowWorkspace" # depends on broken package ncdfFlow-2.15.2
    "fmcsR" # depends on broken package ChemmineR-2.21.7
    "focalCall" # broken build
    "FourCSeq" # depends on broken package Rsamtools-1.21.8
    "fPortfolio" # depends on broken package Rsymphony-0.1-20
    "fracprolif" # broken build
    "FreeSortR" # broken build
    "freqweights" # depends on broken package nlopt-2.4.2
    "frma" # depends on broken package affyio-1.37.0
    "frmaTools" # depends on broken package affyio-1.37.0
    "frmqa" # broken build
    "FSA" # depends on broken package car-2.1-1
    "fscaret" # depends on broken package nlopt-2.4.2
    "fulltext" # broken build
    "FunciSNP" # depends on broken package snpStats-1.19.0
    "FunctionalNetworks" # Build Is Broken
    "funcy" # depends on broken package r-car-2.1-0
    "fxregime" # depends on broken package nlopt-2.4.2
    "gaga" # broken build
    "gage" # broken build
    "gaggle" # broken build
    "gamclass" # depends on broken package nlopt-2.4.2
    "gamlss_demo" # depends on broken package rpanel-1.1-3
    "gamm4" # depends on broken package nlopt-2.4.2
    "gaucho" # broken build
    "gaussquad" # broken build
    "gCMAP" # depends on broken package Category-2.35.1
    "gCMAPWeb" # depends on broken package Category-2.35.1
    "gcmr" # depends on broken package nlopt-2.4.2
    "gcrma" # depends on broken package affyio-1.37.0
    "GDAtools" # depends on broken package nlopt-2.4.2
    "gdtools" # broken build
    "gemtc"
    "GeneAnswers" # broken build
    "GeneBreak" # depends on broken package r-CGHbase-1.30.0
    "GENE_E" # depends on broken package rhdf5-2.13.1
    "GeneExpressionSignature" # depends on broken package annaffy-1.41.1
    "genefilter" # broken build
    "genefu" # broken build
    "GeneMeta" # broken build
    "GeneNetworkBuilder" # broken build
    "geneplotter" # broken build
    "geneRecommender" # broken build
    "GeneRegionScan" # broken build
    "geneRxCluster" # broken build
    "GeneSelectMMD" # broken build
    "GeneSelector" # broken build
    "GENESIS" # broken build
    "geNetClassifier" # broken build
    "GeneticTools" # depends on broken package snpStats-1.19.0
    "genomation" # depends on broken package Rsamtools-1.21.8
    "GenomeGraphs" # broken build
    "GenomeInfoDb" # broken build
    "genomeIntervals" # broken build
    "genomes" # broken build
    "GenomicAlignments" # depends on broken package Rsamtools-1.21.8
    "GenomicFeatures" # depends on broken package Rsamtools-1.21.8
    "GenomicFiles" # depends on broken package Rsamtools-1.21.8
    "GenomicInteractions" # depends on broken package Rsamtools-1.21.8
    "GenomicRanges" # broken build
    "GenomicTuples" # broken build
    "Genominator" # broken build
    "genoset" # broken build
    "genotypeeval" # depends on broken package r-rtracklayer-1.29.12
    "GenoView" # depends on broken package Rsamtools-1.21.8
    "genridge" # depends on broken package nlopt-2.4.2
    "geojsonio" # depends on broken package V8-0.6
    "GEOmetadb" # broken build
    "geomorph" # broken build
    "GEOquery" # broken build
    "GEOsearch" # broken build
    "GEOsubmission" # depends on broken package affyio-1.37.0
    "GERGM"
    "gespeR" # depends on broken package Category-2.35.1
    "GEWIST" # depends on broken package nlopt-2.4.2
    "GExMap" # broken build
    "gfcanalysis" # broken build
    "GGBase" # depends on broken package snpStats-1.19.0
    "ggbio" # depends on broken package Rsamtools-1.21.8
    "ggtern" # build is broken
    "GGtools" # depends on broken package snpStats-1.19.0
    "ggtree" # broken build
    "gimme" # depends on broken package nlopt-2.4.2
    "girafe" # depends on broken package Rsamtools-1.21.8
    "gitter" # broken build
    "GlobalAncova" # broken build
    "globaltest" # broken build
    "gmapR" # depends on broken package Rsamtools-1.21.8
    "gmatrix" # depends on broken package cudatoolkit-5.5.22
    "gMCP" # build is broken
    "gmum_r" # broken build
    "GOexpress" # broken build
    "GOFunction" # build is broken
    "GOGANPA" # depends on broken package WGCNA-1.47
    "GoogleGenomics" # depends on broken package Rsamtools-1.21.8
    "googlesheets" # broken build
    "goProfiles" # build is broken
    "GOSemSim" # Build Is Broken
    "goseq" # build is broken
    "GOSim" # depends on broken package topGO-2.21.0
    "Goslate" # depends on broken package r-PythonInR-0.1-2
    "GOstats" # depends on broken package AnnotationForge-1.11.3
    "GOTHiC" # depends on broken package Rsamtools-1.21.8
    "goTools" # build is broken
    "GPC" # broken build
    "gplm" # depends on broken package nlopt-2.4.2
    "gpuR" # depends on GPU-specific header files
    "gputools" # depends on broken package cudatoolkit-5.5.22
    "gQTLBase" # depends on broken package r-GenomicFiles-1.5.8
    "gQTLstats" # depends on broken package snpStats-1.19.0
    "gRain" # broken build
    "granova" # depends on broken package nlopt-2.4.2
    "GraphAT" # broken build
    "graph" # broken build
    "gRapHD" # broken build
    "graphicalVAR" # depends on broken package nlopt-2.4.2
    "graphite" # broken build
    "GraphPAC" # broken build
    "gRbase" # broken build
    "gRc" # broken build
    "GreyListChIP" # depends on broken package Rsamtools-1.21.8
    "gridDebug" # broken build
    "gridGraphics" # build is broken
    "gridGraphviz" # broken build
    "gRim" # broken build
    "groHMM" # depends on broken package Rsamtools-1.21.8
    "GSAgm" # broken build
    "GSCA" # depends on broken package rhdf5-2.13.1
    "GSEABase" # broken build
    "GSEAlm" # broken build
    "gsheet" # broken build
    "GSRI" # broken build
    "GSVA" # broken build
    "GUIDE" # depends on broken package rpanel-1.1-3
    "GUIDEseq" # depends on broken package r-BiocGenerics-0.16.1
    "GUIProfiler" # broken build
    "Guitar" # depends on broken package r-GenomicAlignments-1.5.18
    "Gviz" # depends on broken package Rsamtools-1.21.8
    "GWAF" # depends on broken package nlopt-2.4.2
    "gwascat" # depends on broken package interactiveDisplayBase-1.7.0
    "GWASTools" # broken build
    "h2o" # build is broken
    "h5" # build is broken
    "h5vc" # depends on broken package rhdf5-2.13.1
    "hapFabia" # broken build
    "Harshlight" # depends on broken package affyio-1.37.0
    "hasseDiagram" # broken build
    "hbsae" # depends on broken package nlopt-2.4.2
    "HCsnip" # broken build
    "hddplot" # broken build
    "HELP" # broken build
    "HEM" # broken build
    "heplots" # depends on broken package nlopt-2.4.2
    "hiAnnotator" # depends on broken package Rsamtools-1.21.8
    "HiCfeat" # depends on broken package r-GenomeInfoDb-1.5.16
    "HiDimMaxStable" # broken build
    "hierGWAS"
    "HierO" # Build Is Broken
    "highriskzone"
    "HilbertCurve" # broken build
    "HilbertVisGUI" # Build Is Broken
    "HiPLARM" # Build Is Broken
    "hiReadsProcessor" # depends on broken package Rsamtools-1.21.8
    "hisse" # broken build
    "HistDAWass" # depends on broken package nlopt-2.4.2
    "HiTC" # depends on broken package Rsamtools-1.21.8
    "HLMdiag" # depends on broken package nlopt-2.4.2
    "HMMcopy" # broken build
    "homomorpheR" # broken build
    "hopach" # broken build
    "hpcwld" # broken build
    "hpoPlot" # broken build
    "HTqPCR" # depends on broken package affyio-1.37.0
    "HTSanalyzeR" # depends on broken package Category-2.35.1
    "HTSCluster" # broken build
    "HTSeqGenie" # depends on broken package Rsamtools-1.21.8
    "htSeqTools" # depends on broken package Rsamtools-1.21.8
    "HTSFilter" # broken build
    "hwwntest" # broken build
    "HybridMTest" # broken build
    "HydeNet" # broken build
    "hyperdraw" # broken build
    "hypergraph" # broken build
    "hysteresis" # depends on broken package nlopt-2.4.2
    "IATscores" # depends on broken package nlopt-2.4.2
    "ibd" # depends on broken package nlopt-2.4.2
    "ibh" # build is broken
    "iBMQ" # broken build
    "iccbeta" # depends on broken package nlopt-2.4.2
    "iCheck" # depends on broken package r-affy-1.48.0
    "iClick" # depends on broken package rugarch-1.3-6
    "IdeoViz" # depends on broken package Rsamtools-1.21.8
    "idiogram" # broken build
    "IdMappingAnalysis" # broken build
    "IdMappingRetrieval" # broken build
    "idm" # broken build
    "ifaTools" # depends on broken package r-OpenMx-2.2.6
    "imageHTS" # depends on broken package Category-2.35.1
    "imager" # broken build
    "Imetagene" # depends on broken package r-metagene-2.2.0
    "immer" # depends on broken package r-sirt-1.8-9
    "immunoClust" # build is broken
    "imputeLCMD" # broken build
    "in2extRemes" # depends on broken package nlopt-2.4.2
    "inferference" # depends on broken package nlopt-2.4.2
    "influence_ME" # depends on broken package nlopt-2.4.2
    "InPAS" # depends on broken package Rsamtools-1.21.8
    "inSilicoDb" # broken build
    "inSilicoMerging" # build is broken
    "INSPEcT" # depends on broken GenomicFeatures-1.21.13
    "intansv" # depends on broken package Rsamtools-1.21.8
    "IntegratedJM" # broken build
    "interactiveDisplayBase" # build is broken
    "interactiveDisplay" # depends on broken package Category-2.35.1
    "interplot" # depends on broken arm-1.8-5
    "ioncopy" # broken build
    "ionflows" # broken build
    "IONiseR" # depends on broken rhdf5-2.13.4
    "iPAC" # broken build
    "iptools"
    "IRanges" # broken build
    "iRefR" # broken build
    "IsingFit" # depends on broken package nlopt-2.4.2
    "isobar" # broken build
    "IsoGene" # depends on broken package affyio-1.37.0
    "IsoGeneGUI" # depends on broken package affyio-1.37.0
    "ITALICS" # depends on broken package oligo-1.33.0
    "ITEMAN" # depends on broken package r-car-2.1-0
    "iteRates" # broken build
    "iterativeBMA" # broken build
    "iterpc" # broken build
    "IUPS"
    "IVAS" # depends on broken package nlopt-2.4.2
    "ivpack" # depends on broken package nlopt-2.4.2
    "jagsUI"
    "JAGUAR" # depends on broken package nlopt-2.4.2
    "jetset"
    "jmosaics" # broken build
    "joda" # depends on broken package nlopt-2.4.2
    "jomo" # build is broken
    "js" # depends on broken package V8-0.6
    "KANT" # depends on broken package affyio-1.37.0
    "KCsmart" # broken build
    "kebabs" # broken build
    "KEGGgraph" # broken build
    "keggorthology" # build is broken
    "KEGGprofile" # Build Is Broken
    "KEGGREST" # broken build
    "KoNLP" # broken build
    "ktspair" # broken build
    "kza" # broken build
    "kzft" # broken build
    "LANDD" # depends on broken package r-GOSemSim-1.27.4
    "LaplaceDeconv" # depends on broken package r-orthopolynom-1.0-5
    "lapmix" # broken build
    "lawn" # depends on broken package V8-0.6
    "ldamatch" # broken build
    "ldblock" # depends on broken package r-snpStats-1.19.3
    "leapp" # broken build
    "learnstats" # depends on broken package nlopt-2.4.2
    "LedPred" # broken build
    "lefse" # build is broken
    "lessR" # depends on broken package nlopt-2.4.2
    "lfe" # build is broken
    "lgcp" # depends on broken package rpanel-1.1-3
    "Libra" # broken build
    "limmaGUI" # depends on broken package affyio-1.37.0
    "LinRegInteractive" # depends on broken package rpanel-1.1-3
    "LiquidAssociation" # build is broken
    "lira"
    "littler" # broken build
    "lmdme" # build is broken
    "lme4" # depends on broken package nlopt-2.4.2
    "LMERConvenienceFunctions" # depends on broken package nlopt-2.4.2
    "lmerTest" # depends on broken package nlopt-2.4.2
    "LMGene" # depends on broken package affyio-1.37.0
    "lmSupport" # depends on broken package nlopt-2.4.2
    "LogisticDx" # depends on broken package nlopt-2.4.2
    "LOGIT" # depends on broken package r-caret-6.0-58
    "logitT" # depends on broken package affyio-1.37.0
    "LOLA" # broken build
    "longpower" # depends on broken package nlopt-2.4.2
    "LOST" # broken build
    "LowMACA" # depends on broken package Rsamtools-1.21.8
    "lpNet" # broken build
    "LPTime" # broken build
    "lumi" # depends on broken package affyio-1.37.0
    "LVSmiRNA" # depends on broken package affyio-1.37.0
    "M3D" # depends on broken package Rsamtools-1.21.8
    "maanova" # broken build
    "macat" # broken build
    "maGUI" # depends on broken package r-affy-1.47.1
    "maigesPack" # broken build
    "MAIT" # depends on broken package nlopt-2.4.2
    "makecdfenv" # depends on broken package affyio-1.37.0
    "MAMA" # broken build
    "manta" # broken build
    "mAPKL" # build is broken
    "maPredictDSC" # depends on broken package nlopt-2.4.2
    "mar1s" # broken build
    "marked" # depends on broken package nlopt-2.4.2
    "markophylo" # depends on broken package r-Biostrings-2.38.2
    "maSigPro" # broken build
    "maskBAD" # depends on broken package affyio-1.37.0
    "massiR" # broken build
    "matchingMarkets" # broken build
    "MatrixRider" # depends on broken package DirichletMultinomial-1.11.1
    "MaxPro" # depends on broken package nlopt-2.4.2
    "MazamaSpatialUtils" # broken build
    "MBASED" # broken build
    "mbest" # depends on broken package nlopt-2.4.2
    "MBmca" # depends on broken nloptr-1.0.4
    "mBPCR" # depends on broken package affyio-1.37.0
    "mBvs" # build is broken
    "mcaGUI" # depends on broken package Rsamtools-1.21.8
    "MCRestimate" # build is broken
    "mdgsa" # build is broken
    "MEAL" # depends on broken package r-Biobase-2.30.0
    "meboot" # depends on broken package nlopt-2.4.2
    "medflex" # depends on broken package r-car-2.1-0
    "mediation" # depends on broken package r-lme4-1.1-8
    "MEDIPS" # depends on broken package Rsamtools-1.21.8
    "MEDME" # depends on broken package nlopt-2.4.2
    "MEET" # broken build
    "MEIGOR" # broken build
    "MEMSS" # depends on broken package nlopt-2.4.2
    "MergeMaid" # broken build
    "merTools" # depends on broken package r-arm-1.8-6
    "MeSHDbi" # broken build
    "meshr" # depends on broken package Category-2.35.1
    "meta4diag" # broken build
    "metaArray" # broken build
    "Metab" # depends on broken package mzR-2.3.1
    "metabolomics" # broken build
    "metabomxtr" # broken build
    "metacom" # broken build
    "MetaDE" # broken build
    "metagear" # build is broken
    "metagene" # depends on broken package Rsamtools-1.21.8
    "metagenomeFeatures" # depends on broken package r-Biobase-2.30.0
    "metagenomeSeq" # broken build
    "metaheur" # depends on broken package r-preprocomb-0.2.0
    "MetaLandSim" # broken build
    "metamisc"
    "metaMix" # build is broken
    "metaMS" # depends on broken package mzR-2.3.1
    "MetaPath" # depends on broken package r-Biobase-2.29.1
    "metaplus" # depends on broken package nlopt-2.4.2
    "metaSEM" # depends on broken package OpenMx-2.2.4
    "metaSeq" # broken build
    "metaseqR" # depends on broken package affyio-1.37.0
    "Metatron" # depends on broken package nlopt-2.4.2
    "metaX" # depends on broken package r-CAMERA-1.25.2
    "MethTargetedNGS" # broken build
    "methVisual" # broken build
    "methyAnalysis" # depends on broken package affyio-1.37.0
    "MethylAid" # depends on broken package Rsamtools-1.21.8
    "methylMnM" # broken build
    "methylPipe" # depends on broken package Rsamtools-1.21.8
    "MethylSeekR" # depends on broken package Rsamtools-1.21.8
    "methylumi" # depends on broken package Rsamtools-1.21.8
    "Mfuzz" # broken build
    "MGFM" # broken build
    "mGSZ" # broken build
    "miceadds" # depends on broken package nlopt-2.4.2
    "micEconAids" # depends on broken package nlopt-2.4.2
    "micEconCES" # depends on broken package nlopt-2.4.2
    "micEconSNQP" # depends on broken package nlopt-2.4.2
    "MiChip" # broken build
    "microRNA" # broken build
    "mi" # depends on broken package nlopt-2.4.2
    "MigClim" # Build Is Broken
    "migui" # depends on broken package nlopt-2.4.2
    "MIMOSA" # broken build
    "MineICA" # depends on broken package AnnotationForge-1.11.3
    "minfi" # depends on broken package Rsamtools-1.21.8
    "minimist" # depends on broken package V8-0.6
    "MinimumDistance" # depends on broken package affyio-1.37.0
    "MiPP" # broken build
    "MiRaGE" # broken build
    "miRcomp" # depends on broken package r-Biobase-2.30.0
    "mirIntegrator" # build is broken
    "miRLAB" # broken build
    "miRNAtap" # broken build
    "miRtest" # broken build
    "missDeaths"
    "missMDA" # depends on broken package nlopt-2.4.2
    "missMethyl" # depends on broken package Rsamtools-1.21.8
    "mitoODE" # build is broken
    "mixAK" # depends on broken package nlopt-2.4.2
    "MixedPoisson" # broken build
    "MIXFIM" # build is broken
    "mixlm" # depends on broken package nlopt-2.4.2
    "MixMAP" # depends on broken package nlopt-2.4.2
    "MLInterfaces" # broken build
    "mlma" # depends on broken package r-lme4-1.1-10
    "mlmRev" # depends on broken package nlopt-2.4.2
    "MLP" # depends on broken package affyio-1.37.0
    "MLSeq" # depends on broken package nlopt-2.4.2
    "mlVAR" # depends on broken package nlopt-2.4.2
    "MM2S" # broken build
    "MM2Sdata" # broken build
    "MM" # broken build
    "MMDiff" # depends on broken package AnnotationForge-1.11.3
    "mmnet" # broken build
    "MmPalateMiRNA" # depends on broken package affyio-1.37.0
    "mogsa" # broken build
    "molaR" # depends on broken package r-geomorph-2.1.7-1
    "mongolite" # build is broken
    "monocle" # build is broken
    "monogeneaGM" # broken build
    "MonoPhy" # depends on broken package r-phytools-0.5-00
    "MoPS" # broken build
    "morse"
    "mosaic" # depends on broken package nlopt-2.4.2
    "mosaics" # broken build
    "motifbreakR" # depends on broken package r-BSgenome-1.37.5
    "MotifDb" # depends on broken package Rsamtools-1.21.8
    "motifRG" # depends on broken package Rsamtools-1.21.8
    "motifStack" # depends on broken package Rsamtools-1.21.8
    "MotIV" # depends on broken package Rsamtools-1.21.8
    "mpoly" # broken build
    "mRMRe" # broken build
    "msa" # broken build
    "msarc" # broken build
    "MSeasy" # depends on broken package mzR-2.3.1
    "MSeasyTkGUI" # depends on broken package mzR-2.3.1
    "MSGFgui" # depends on broken package MSGFplus-1.3.0
    "MSGFplus" # Build Is Broken
    "MSIseq" # broken build
    "msmsEDA" # depends on broken package affyio-1.37.0
    "msmsTests" # depends on broken package affyio-1.37.0
    "MSnbase" # depends on broken package affyio-1.37.0
    "MSnID" # depends on broken package affyio-1.37.0
    "MSstats" # depends on broken package nlopt-2.4.2
    "msSurv" # broken build
    "Mulcom" # broken build
    "MultiRR" # depends on broken package nlopt-2.4.2
    "multiscan" # broken build
    "multtest" # broken build
    "muma" # depends on broken package nlopt-2.4.2
    "munsellinterpol"
    "muscle" # broken build
    "mutoss" # broken build
    "mutossGUI" # build is broken
    "mvGST" # depends on broken package AnnotationForge-1.11.3
    "mvinfluence" # depends on broken package nlopt-2.4.2
    "mvMORPH" # broken build
    "MXM" # broken build
    "mygene" # depends on broken package Rsamtools-1.21.8
    "myTAI" # broken build
    "myvariant" # depends on broken package r-VariantAnnotation-1.15.31
    "mzID" # broken build
    "mzR" # build is broken
    "NanoStringDiff" # broken build
    "NanoStringNorm" # depends on broken package r-vsn-3.38.0
    "NanoStringQCPro" # build is broken
    "NAPPA" # depends on broken package r-vsn-3.38.0
    "NarrowPeaks" # broken build
    "nCal" # depends on broken package nlopt-2.4.2
    "ncdfFlow" # build is broken
    "NCIgraph" # depends on broken package RCytoscape-1.19.0
    "ndtv" # broken build
    "nem" # broken build
    "netbenchmark" # build is broken
    "netClass" # broken build
    "nethet" # broken build
    "NetPreProc" # depends on broken package graph-1.48.0
    "netresponse" # broken build
    "NetSAM" # broken build
    "nettools" # depends on broken package WGCNA-1.47
    "NGScopy"
    "nhanesA" # broken build
    "NHPoisson" # depends on broken package nlopt-2.4.2
    "NIPTeR" # depends on broken package r-Rsamtools-1.21.18
    "nloptr" # depends on broken package nlopt-2.4.2
    "nlsem" # broken build
    "nlts" # broken build
    "NOISeq" # broken build
    "nondetects" # depends on broken package affyio-1.37.0
    "nonrandom" # depends on broken package nlopt-2.4.2
    "NormqPCR" # depends on broken package affyio-1.37.0
    "NORRRM" # build is broken
    "npGSEA" # broken build
    "npIntFactRep" # depends on broken package nlopt-2.4.2
    "NSM3" # broken build
    "nucleR" # depends on broken package Rsamtools-1.21.8
    "OCplus" # broken build
    "OGSA" # broken build
    "oligoClasses" # depends on broken package affyio-1.37.0
    "oligo" # depends on broken package affyio-1.37.0
    "OmicCircos" # broken build
    "omics" # depends on broken package lme4-1.1-10
    "OmicsMarkeR" # depends on broken package nlopt-2.4.2
    "OncoSimulR" # broken build
    "oneChannelGUI" # depends on broken package affyio-1.37.0
    "OPDOE" # broken build
    "OpenCL" # build is broken
    "opencpu" # broken build
    "openCyto" # depends on broken package ncdfFlow-2.15.2
    "OpenMx" # build is broken
    "openssl"
    "OperaMate" # depends on broken package Category-2.35.1
    "oposSOM" # broken build
    "optBiomarker" # depends on broken package rpanel-1.1-3
    "ora" # depends on broken package ROracle-1.1-12
    "ordBTL" # depends on broken package nlopt-2.4.2
    "OrderedList" # broken build
    "ordPens" # depends on broken package r-lme4-1.1-9
    "OrganismDbi" # depends on broken package Rsamtools-1.21.8
    "orQA" # broken build
    "orthopolynom" # broken build
    "OTUbase" # depends on broken package Rsamtools-1.21.8
    "OutlierD" # broken build
    "OUwie" # depends on broken package nlopt-2.4.2
    "oz" # broken build
    "PAA" # broken build
    "pacman" # broken build
    "PADOG" # build is broken
    "paircompviz" # broken build
    "PairViz" # broken build
    "paleotree" # broken build
    "pamm" # depends on broken package nlopt-2.4.2
    "PANDA" # build is broken
    "panelAR" # depends on broken package nlopt-2.4.2
    "PAnnBuilder" # broken build
    "panp" # depends on broken package affyio-1.37.0
    "papeR" # depends on broken package nlopt-2.4.2
    "PAPi" # broken build
    "parboost" # depends on broken package nlopt-2.4.2
    "parglms" # broken build
    "parma" # depends on broken package nlopt-2.4.2
    "partitions" # broken build
    "Pasha" # depends on broken package GenomicAlignments-1.5.12
    "pathClass" # depends on broken package affyio-1.37.0
    "pathRender" # build is broken
    "pathview" # build is broken
    "PatternClass" # build is broken
    "Pbase" # depends on broken package affyio-1.37.0
    "pbdBASE" # depends on broken package pbdSLAP-0.2-0
    "PBD" # broken build
    "pbdDEMO" # depends on broken package pbdSLAP-0.2-0
    "pbdDMAT" # depends on broken package pbdSLAP-0.2-0
    "pbdSLAP" # build is broken
    "PBImisc" # depends on broken package nlopt-2.4.2
    "PBSddesolve" # build is broken
    "PBSmapping" # build is broken
    "pcaBootPlot" # depends on broken FactoMineR-1.31.3
    "pcaGoPromoter" # broken build
    "pcaL1" # build is broken
    "pcalg" # broken build
    "pcaMethods" # broken build
    "PCGSE" # broken build
    "pcnetmeta"
    "pcot2" # broken build
    "PCpheno" # depends on broken package Category-2.35.1
    "PCS" # broken build
    "pdInfoBuilder" # depends on broken package affyio-1.37.0
    "pdmclass" # build is broken
    "PDQutils" # broken build
    "PECA" # depends on broken package affyio-1.37.0
    "pedigreemm" # depends on broken package nlopt-2.4.2
    "pedometrics" # depends on broken package nlopt-2.4.2
    "PepPrep" # broken build
    "pepStat" # broken build
    "pequod" # depends on broken package nlopt-2.4.2
    "PerfMeas" # broken build
    "PGA" # depends on broken package Rsamtools-1.21.8
    "pglm" # depends on broken package car-2.1-1
    "PGSEA" # depends on broken package annaffy-1.41.1
    "phangorn" # depends on broken package Biostrings-2.38.2
    "PharmacoGx"
    "phenoDist" # depends on broken package Category-2.35.1
    "phenoTest" # depends on broken package Category-2.35.1
    "PhenStat" # depends on broken package nlopt-2.4.2
    "phia" # depends on broken package nlopt-2.4.2
    "phreeqc" # broken build
    "phylocurve" # depends on broken package nlopt-2.4.2
    "phyloseq" # broken build
    "PhySortR" # depends on broken package phytools-0.5-10
    "phytools" # broken build
    "piano" # broken build
    "PICS" # depends on broken package Rsamtools-1.21.8
    "piecewiseSEM" # depends on broken package r-lme4-1.1-10
    "PING" # depends on broken package Rsamtools-1.21.8
    "pkgDepTools" # broken build
    "plateCore" # depends on broken package ncdfFlow-2.15.2
    "plethy" # broken build
    "plfMA" # broken build
    "plgem" # broken build
    "plier" # depends on broken package affyio-1.37.0
    "plm" # depends on broken package car-2.1-1
    "PLPE" # broken build
    "plrs" # broken build
    "plsRbeta" # depends on broken package nlopt-2.4.2
    "plsRcox" # depends on broken package nlopt-2.4.2
    "plsRglm" # depends on broken package nlopt-2.4.2
    "plw" # depends on broken package affyio-1.37.0
    "pmclust" # build is broken
    "pmm" # depends on broken package nlopt-2.4.2
    "podkat" # depends on broken package Rsamtools-1.21.8
    "polyester" # broken build
    "Polyfit" # broken build
    "polynom" # broken build
    "pomp" # depends on broken package nlopt-2.4.2
    "poppr" # depends on broken package  Biostrings-2.38.2
    "popprxl" # depends on broken package Biostrings-2.38.2
    "ppiPre" # depends on broken package GOSemSim-1.27.3
    "ppiStats" # depends on broken package Category-2.35.1
    "prada" # broken build
    "prebs" # depends on broken package affyio-1.37.0
    "PREDA" # broken build
    "predictionet" # broken build
    "predictmeans" # depends on broken package nlopt-2.4.2
    "preprocomb" # depends on broken package r-caret-6.0-58
    "prevalence"
    "pRF" # broken build
    "prLogistic" # depends on broken package nlopt-2.4.2
    "proBAMr" # depends on broken package Rsamtools-1.21.8
    "ProCoNA" # depends on broken package AnnotationForge-1.11.3
    "pRoloc" # depends on broken package nlopt-2.4.2
    "pRolocGUI" # depends on broken package nlopt-2.4.2
    "PROMISE" # broken build
    "PROPER" # broken build
    "propOverlap" # broken build
    "Prostar" # depends on broken package r-imputeLCMD-2.0
    "prot2D" # broken build
    "ProteomicsAnnotationHubData" # depends on broken package r-AnnotationHub-2.1.40
    "proteoQC" # depends on broken package affyio-1.37.0
    "ProtGenerics" # broken build
    "protiq" # broken build
    "provenance" # broken build
    "PSAboot" # depends on broken package nlopt-2.4.2
    "PSEA" # broken build
    "PSICQUIC" # broken build
    "ptw" # depends on broken nloptr-1.0.4
    "puma" # depends on broken package affyio-1.37.0
    "PurBayes"
    "purge" # depends on broken package r-lme4-1.1-9
    "pvac" # depends on broken package affyio-1.37.0
    "PVAClone"
    "pvca" # depends on broken package nlopt-2.4.2
    "Pviz" # depends on broken package Rsamtools-1.21.8
    "PWMEnrich" # broken build
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
    "QuACN" # broken build
    "QUALIFIER" # depends on broken package ncdfFlow-2.15.2
    "quantification" # depends on broken package nlopt-2.4.2
    "quantro" # depends on broken package Rsamtools-1.21.8
    "QuartPAC" # broken build
    "QuasiSeq" # broken build
    "QuasR" # depends on broken package Rsamtools-1.21.8
    "qusage" # broken build
    "R2jags"
    "R2STATS" # depends on broken package nlopt-2.4.2
    "R3CPET" # depends on broken package Rsamtools-1.21.8
    "r3Cseq" # depends on broken package Rsamtools-1.21.8
    "R453Plus1Toolbox" # depends on broken package Rsamtools-1.21.8
    "RADami" # broken build
    "rain" # broken build
    "raincpc" # build is broken
    "rainfreq" # build is broken
    "RAM" # broken build
    "RamiGO" # depends on broken package RCytoscape-1.19.0
    "randPack" # broken build
    "RANKS" # depends on broken package graph-1.48.0
    "RapidPolygonLookup" # depends on broken package PBSmapping-2.69.76
    "RAPIDR" # depends on broken package Rsamtools-1.21.8
    "RareVariantVis" # depends on broken VariantAnnotation-1.15.19
    "Rariant" # depends on broken package Rsamtools-1.21.8
    "rasclass" # depends on broken package nlopt-2.4.2
    "rase" # broken build
    "rationalfun" # broken build
    "RbcBook1" # broken build
    "RBerkeley"
    "RBGL" # broken build
    "RBioinf" # broken build
    "RbioRXN" # depends on broken package ChemmineR-2.21.7
    "Rblpapi" # broken build
    "rbsurv" # broken build
    "rbundler" # broken build
    "Rcade" # depends on broken package Rsamtools-1.21.8
    "rcellminer" # broken build
    "rCGH" # depends on broken package r-affy-1.47.1
    "Rchemcpp" # depends on broken package ChemmineR-2.21.7
    "rchess" # depends on broken package r-V8-0.9
    "Rchoice" # depends on broken package car-2.1
    "RchyOptimyx" # broken build
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
    "RcmdrPlugin_Export" # depends on broken package r-Rcmdr-2.2-3
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
    "rcrypt" # broken build
    "RCy3" # depends on broken package r-graph-1.48.0
    "RCyjs" # broken build
    "RCytoscape" # Build Is Broken
    "RDAVIDWebService" # depends on broken package Category-2.35.1
    "rdd" # depends on broken package nlopt-2.4.2
    "rddtools" # depends on broken package r-AER-1.2-4
    "rDEA" # build is broken
    "RDieHarder" # build is broken
    "ReactomePA" # depends on broken package GOSemSim-1.27.3
    "ReadqPCR" # depends on broken package affyio-1.37.0
    "REBayes" # depends on broken package Rmosek-1.2.5.1
    "reb" # broken build
    "recluster" # broken build
    "REDseq" # depends on broken package Rsamtools-1.21.8
    "referenceIntervals" # depends on broken package nlopt-2.4.2
    "RefNet" # depends on broken package interactiveDisplayBase-1.7.0
    "RefPlus" # depends on broken package affyio-1.37.0
    "refund" # depends on broken package nlopt-2.4.2
    "refund_shiny" # depends on broken package r-refund-0.1-13
    "regioneR" # depends on broken package Rsamtools-1.21.8
    "regionReport" # depends on broken package Rsamtools-1.21.8
    "regRSM" # broken build
    "REndo" # depends on broken package AER-1.2-4
    "repijson" # depends on broken package V8-0.6
    "Repitools" # depends on broken package affyio-1.37.0
    "ReportingTools" # depends on broken package Category-2.35.1
    "ReQON" # depends on broken package Rsamtools-1.21.8
    "rerddap" # broken build
    "REST" # depends on broken package nlopt-2.4.2
    "rfPred" # depends on broken package Rsamtools-1.21.8
    "rGADEM" # depends on broken package Rsamtools-1.21.8
    "RGalaxy" # broken build
    "rgbif" # depends on broken package V8-0.6
    "Rgnuplot"
    "rgp" # build is broken
    "rgpui" # depends on broken package rgp-0.4-1
    "Rgraphviz" # broken build
    "rGREAT" # broken build
    "RGSEA" # broken build
    "rgsepd" # depends on broken package goseq-1.21.1
    "rhdf5" # build is broken
    "rHVDM" # depends on broken package affyio-1.37.0
    "RiboProfiling" # depends on broken package r-BiocGenerics-0.16.1
    "riboSeqR" # broken build
    "Ringo" # depends on broken package affyio-1.37.0
    "RIPSeeker" # depends on broken package Rsamtools-1.21.8
    "Risa" # depends on broken package affyio-1.37.0
    "rjade" # depends on broken package V8-0.6
    "rjags"
    "rJPSGCS" # build is broken
    "rLindo" # build is broken
    "RLRsim" # depends on broken package r-lme4-1.1-9
    "Rmagpie" # broken build
    "RMallow" # broken build
    "RMassBank" # depends on broken package mzR-2.3.1
    "rMAT" # build is broken
    "rmgarch" # depends on broken package nlopt-2.4.2
    "rminer" # depends on broken package nlopt-2.4.2
    "RmiR" # Build Is Broken
    "Rmosek" # build is broken
    "rmumps" # build is broken
    "RMySQL" # broken build
    "RNAinteract" # depends on broken package Category-2.35.1
    "RNAither" # depends on broken package nlopt-2.4.2
    "RNAprobR" # depends on broken package Rsamtools-1.21.8
    "rnaSeqMap" # depends on broken package Rsamtools-1.21.8
    "RnaSeqSampleSize" # Build Is Broken
    "RnavGraph" # build is broken
    "RnBeads" # depends on broken package Rsamtools-1.21.8
    "rnetcarto" # broken build
    "Rnits" # depends on broken package affyio-1.37.0
    "rNOMADS" # broken build
    "roar" # depends on broken package Rsamtools-1.21.8
    "RobLoxBioC" # depends on broken package affyio-1.37.0
    "RobLox" # broken build
    "robustlmm" # depends on broken package nlopt-2.4.2
    "rockchalk" # depends on broken package nlopt-2.4.2
    "RockFab" # broken build
    "ROI_plugin_symphony" # depends on broken package Rsymphony-0.1-20
    "Roleswitch" # broken build
    "Rolexa" # depends on broken package Rsamtools-1.21.8
    "rols" # build is broken
    "ROntoTools" # broken build
    "ROracle" # Build Is Broken
    "RPA" # depends on broken package affyio-1.37.0
    "rpanel" # build is broken
    "Rphylopars" # broken build
    "Rpoppler" # broken build
    "RPPanalyzer" # broken build
    "RpsiXML" # broken build
    "rpubchem" # depends on broken package nlopt-2.4.2
    "Rqc" # depends on broken package Rsamtools-1.21.8
    "RQuantLib" # build is broken
    "rqubic" # broken build
    "rr" # depends on broken package nlopt-2.4.2
    "rRDP" # broken build
    "RRreg" # depends on broken package r-lme4-1.1-10
    "Rsamtools" # Build Is Broken
    "RSAP" # build is broken
    "rsbml" # build is broken
    "rscala" # build is broken
    "RSDA" # depends on broken package nlopt-2.4.2
    "RSeed" # broken build
    "rSFFreader" # depends on broken package Rsamtools-1.21.8
    "Rsomoclu"
    "rstan" # build is broken
    "RStoolbox" # depends on broken package r-caret-6.0-52
    "Rsubread" # Build Is Broken
    "RSVSim" # depends on broken package Rsamtools-1.21.8
    "Rsymphony" # build is broken
    "rTableICC" # broken build
    "rTANDEM" # build is broken
    "RTCA" # broken build
    "RTCGA" # depends on broken package r-rvest-0.3.0
    "RTN" # depends on broken package nlopt-2.4.2
    "RTopper" # broken build
    "rtracklayer" # depends on broken package Rsamtools-1.21.8
    "Rtreemix" # broken build
    "rTRM" # broken build
    "rTRMui" # depends on broken package Rsamtools-1.21.8
    "rugarch" # depends on broken package nlopt-2.4.2
    "rUnemploymentData" # broken build
    "RUVcorr" # build is broken
    "RUVnormalize" # Build Is Broken
    "RUVSeq" # depends on broken package Rsamtools-1.21.8
    "RVAideMemoire" # depends on broken package nlopt-2.4.2
    "rvest" # broken build
    "RVFam" # depends on broken package nlopt-2.4.2
    "RVideoPoker" # depends on broken package rpanel-1.1-3
    "RWebServices" # broken build
    "ryouready" # depends on broken package nlopt-2.4.2
    "S4Vectors" # broken build
    "sadists" # broken build
    "safe" # broken build
    "SAGx" # broken build
    "sampleSelection" # depends on broken package nlopt-2.4.2
    "sangerseqR" # broken build
    "sapFinder" # depends on broken package rTANDEM-1.9.0
    "saps" # broken build
    "SCAN_UPC" # depends on broken package affyio-1.37.0
    "scholar" # depends on broken package r-rvest-0.3.1
    "ScISI" # depends on broken package apComplex-2.35.0
    "scmamp" # broken build
    "scsR" # broken build
    "sdcMicro" # depends on broken package nlopt-2.4.2
    "sdcMicroGUI" # depends on broken package nlopt-2.4.2
    "SDD" # depends on broken package rpanel-1.1-3
    "seeg" # depends on broken package nlopt-2.4.2
    "segmentSeq" # depends on broken package Rsamtools-1.21.8
    "sejmRP" # depends on broken package r-rvest-0.3.0
    "Sejong" # broken build
    "SELEX" # broken build
    "sem" # depends on broken package nlopt-2.4.2
    "semdiag" # depends on broken package nlopt-2.4.2
    "SemDist" # Build Is Broken
    "semGOF" # depends on broken package nlopt-2.4.2
    "semPlot" # depends on broken package nlopt-2.4.2
    "SensMixed" # depends on broken package r-lme4-1.1-9
    "SensoMineR" # depends on broken package nlopt-2.4.2
    "SEPA" # depends on broken package topGO-2.21.0
    "seq2pathway" # depends on broken package WGCNA-1.47
    "SeqArray" # depends on broken package Rsamtools-1.21.8
    "seqbias" # depends on broken package Rsamtools-1.21.8
    "seqCNA" # build is broken
    "SeqFeatR" # broken build
    "SeqGrapheR" # Build Is Broken
    "SeqGSEA" # broken build
    "seqHMM" # depends on broken package nloptr-1.0.4
    "seqPattern" # broken build
    "seqplots" # depends on broken package Rsamtools-1.21.8
    "seqTools" # build is broken
    "sequenza" # broken build
    "SeqVarTools" # depends on broken package Rsamtools-1.21.8
    "SGSeq" # depends on broken package Rsamtools-1.21.8
    "SharpeR" # broken build
    "sharx"
    "shinyMethyl" # depends on broken package Rsamtools-1.21.8
    "shinyTANDEM" # depends on broken package rTANDEM-1.9.0
    "ShortRead" # depends on broken package Rsamtools-1.21.8
    "Shrinkage" # depends on broken package r-multtest-2.25.2
    "SIBER"
    "SICtools" # depends on broken package r-Biostrings-2.38.2
    "SID" # broken build
    "sigaR" # broken build
    "SigCheck" # broken build
    "SigFuge" # broken build
    "siggenes" # broken build
    "sigsquared" # broken build
    "SigTree" # broken build
    "SIMAT" # depends on broken package mzR-2.3.1
    "SimBindProfiles" # depends on broken package affyio-1.37.0
    "SIM" # broken build
    "similaRpeak" # depends on broken package Rsamtools-1.21.8
    "simmr"
    "simpleaffy" # depends on broken package affyio-1.37.0
    "simPop" # depends on broken package r-VIM-4.4.1
    "SimRAD" # depends on broken package Rsamtools-1.21.8
    "simr" # depends on broken package r-lme4-1.1-10
    "SimReg" # broken build
    "simulatorZ" # broken build
    "sirt" # depends on broken package nlopt-2.4.2
    "SISPA" # depends on broken package r-GSVA-1.18.0
    "SJava" # broken build
    "sjPlot" # depends on broken package nlopt-2.4.2
    "skewr" # depends on broken package affyio-1.37.0
    "SLGI" # depends on broken package apComplex-2.35.0
    "smacof" # broken build
    "SNAGEE" # build is broken
    "snapCGH" # depends on broken package tilingArray-1.47.0
    "snm" # depends on broken package nlopt-2.4.2
    "SNPchip" # depends on broken package affyio-1.37.0
    "snpEnrichment" # depends on broken package snpStats-1.19.0
    "SNPhood" # depends on broken package r-BiocGenerics-0.16.1
    "snplist" # broken build
    "snpStats" # build is broken
    "snpStatsWriter" # depends on broken package snpStats-1.19.0
    "SNPtools" # depends on broken package Rsamtools-1.21.8
    "SOD" # depends on broken package cudatoolkit-5.5.22
    "sodium" # broken build
    "soGGi" # depends on broken package Rsamtools-1.21.8
    "soilphysics" # depends on broken package rpanel-1.1-3
    "SomatiCA" # broken build
    "SomaticSignatures" # depends on broken package Rsamtools-1.21.8
    "sortinghat" # broken build
    "SoyNAM" # depends on broken package r-lme4-1.1-8
    "SpacePAC" # broken build
    "spacom" # depends on broken package nlopt-2.4.2
    "spade" # broken build
    "SparseLearner" # depends on broken package r-qgraph-1.3.1
    "spdynmod" # broken build
    "specificity" # depends on broken package nlopt-2.4.2
    "specmine" # depends on broken package r-caret-6.0-58
    "SpeCond" # broken build
    "SPEM" # broken build
    "SPIA" # broken build
    "spkTools" # broken build
    "splicegear" # broken build
    "spliceR" # depends on broken package Rsamtools-1.21.8
    "spliceSites" # broken build
    "SplicingGraphs" # depends on broken package Rsamtools-1.21.8
    "splm" # depends on broken package car-2.1-1
    "spocc" # depends on broken package V8-0.6
    "spoccutils" # depends on broken spocc-0.3.0
    "spsann" # depends on broken package r-pedometrics-0.6-2
    "SRAdb" # broken build
    "srd" # broken build
    "sscore" # depends on broken package affyio-1.37.0
    "ssizeRNA" # broken build
    "ssmrob" # depends on broken package nlopt-2.4.2
    "ssviz" # depends on broken package Rsamtools-1.21.8
    "stagePop" # depends on broken package PBSddesolve-1.11.29
    "staRank" # depends on broken package Category-2.35.1
    "Starr" # depends on broken package affyio-1.37.0
    "STATegRa" # depends on broken package affyio-1.37.0
    "StatMethRank"
    "Statomica" # broken build
    "stepp" # depends on broken package nlopt-2.4.2
    "stepwiseCM" # broken build
    "stream" # broken build
    "Streamer" # broken build
    "streamMOA" # broken build
    "stringgaussnet" # build is broken
    "structSSI" # broken build
    "strum" # broken build
    "subSeq" # depends on broken package r-Biobase-2.30.0
    "SummarizedExperiment" # broken build
    "superbiclust" # broken build
    "Surrogate" # depends on broken package nlopt-2.4.2
    "Sushi" # broken build
    "sva" # broken build
    "svglite" # depends on broken package gdtools-0.0.6
    "SVM2CRM" # depends on broken package Rsamtools-1.21.8
    "sybilSBML" # build is broken
    "synapter" # depends on broken package affyio-1.37.0
    "synchronicity" # build is broken
    "synthpop" # build is broken
    "systemfit" # depends on broken package nlopt-2.4.2
    "systemPipeR" # depends on broken package AnnotationForge-1.11.3
    "TargetSearch" # depends on broken package mzR-2.3.1
    "TarSeqQC" # depends on broken package r-BiocGenerics-0.16.1
    "TCC" # broken build
    "TCGA2STAT" # broken build
    "TCGAbiolinks" # depends on broken package r-affy-1.47.1
    "TcGSA" # depends on broken package nlopt-2.4.2
    "TDARACNE" # broken build
    "TDMR" # depends on broken package nlopt-2.4.2
    "TED" # broken build
    "TEQC" # depends on broken package Rsamtools-1.21.8
    "TextoMineR"  # depends on broken package FactoMineR-1.31.4
    "TFBSTools" # depends on broken package DirichletMultinomial-1.11.1
    "tigerstats" # depends on broken package nlopt-2.4.2
    "tigre" # broken build
    "tilingArray" # depends on broken package affyio-1.37.0
    "timecourse" # broken build
    "timeSeq" # broken build
    "timetree" # depends on broken package Biostrings-2.38.2
    "TIN" # depends on broken package WGCNA-1.47
    "TitanCNA" # depends on broken package Rsamtools-1.21.8
    "TKF" # broken build
    "TLBC" # depends on broken package r-caret-6.0-58
    "tmle" # broken build
    "tnam" # depends on broken package r-lme4-1.1-9
    "tolBasis" # depends on broken package r-polynom-1.3-8
    "ToPASeq" # depends on broken package Rsamtools-1.21.8
    "topGO" # build is broken
    "topologyGSA" # depends on broken package Rsamtools-1.21.8
    "TPP" # broken build
    "tracktables" # depends on broken package Rsamtools-1.21.8
    "trackViewer" # depends on broken package Rsamtools-1.21.8
    "translateSPSS2R" # depends on broken car-2.0-25
    "tRanslatome" # depends on broken package GOSemSim-1.27.3
    "TransView" # depends on broken package Rsamtools-1.21.8
    "traseR"
    "treescape" # depends on broken package Biostrings-2.38.2
    "triform" # broken build
    "trigger" # broken build
    "TriMatch" # depends on broken package nlopt-2.4.2
    "triplex" # broken build
    "TROM" # depends on broken package topGO-2.21.0
    "TRONCO" # broken build
    "TSdist" # broken build
    "TSMySQL" # broken build
    "tsoutliers" # broken build
    "tspair" # broken build
    "TSSi" # broken build
    "ttScreening" # broken build
    "TurboNorm" # depends on broken package affyio-1.37.0
    "tweeDEseq" # broken build
    "twilight" # broken build
    "UBCRM" # broken build
    "umx" # depends on broken package r-OpenMx-2.2.6
    "UNDO" # broken build
    "unifiedWMWqPCR" # depends on broken package affyio-1.37.0
    "uniftest" # broken build
    "UniProt_ws" # broken build
    "untb" # broken build
    "userfriendlyscience" # depends on broken package nlopt-2.4.2
    "V8" # build is broken
    "VanillaICE" # depends on broken package affyio-1.37.0
    "varComp" # depends on broken package r-lme4-1.1-9
    "varian" # build is broken
    "variancePartition" # depends on broken package lme4-1.1-8
    "VariantAnnotation" # depends on broken package Rsamtools-1.21.8
    "VariantFiltering" # depends on broken package Rsamtools-1.21.8
    "VariantTools" # depends on broken package Rsamtools-1.21.8
    "VBmix" # broken build
    "VegaMC" # broken build
    "VIM" # depends on broken package nlopt-2.4.2
    "VIMGUI" # depends on broken package nlopt-2.4.2
    "viper" # broken build
    "vmsbase" # depends on broken package PBSmapping-2.69.76
    "vows" # depends on broken package nlopt-2.4.2
    "vsn" # depends on broken package affyio-1.37.0
    "vtpnet" # depends on broken package interactiveDisplayBase-1.7.0
    "wateRmelon" # depends on broken package affyio-1.37.0
    "wavClusteR" # depends on broken package Rsamtools-1.21.8
    "waveTiling" # depends on broken package affyio-1.37.0
    "webbioc" # depends on broken package affyio-1.37.0
    "webp" # build is broken
    "wfe" # depends on broken package nlopt-2.4.2
    "WGCNA" # build is broken
    "wgsea" # depends on broken package snpStats-1.19.0
    "wikipediatrend" # broken build
    "wordbankr" # depends on broken package r-RMySQL-0.10.7
    "XBSeq" # broken build
    "xcms" # depends on broken package mzR-2.3.1
    "XDE" # broken build
    "x_ent" # broken build
    "xergm" # depends on broken package nlopt-2.4.2
    "xps" # build is broken
    "XVector" # broken build
    "yaqcaffy" # depends on broken package affyio-1.37.0
    "yCrypticRNAs" # depends on broken package biomaRt-2.26.1
    "ZeligChoice" # depends on broken package r-AER-1.2-4
    "Zelig" # depends on broken package r-AER-1.2-4
    "zetadiv" # depends on broken package nlopt-2.4.2
    "zoib"
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
