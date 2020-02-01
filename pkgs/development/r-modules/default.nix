/* This file defines the composition for CRAN (R) packages. */

{ R, pkgs, overrides }:

let
  inherit (pkgs) cacert fetchurl stdenv lib;

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
    mkHomepage = {name, biocVersion, ...}: "https://bioconductor.org/packages/${biocVersion}/bioc/html/${name}.html";
    mkUrls = {name, version, biocVersion}: [ "mirror://bioc/${biocVersion}/bioc/src/contrib/${name}_${version}.tar.gz"
                                             "mirror://bioc/${biocVersion}/bioc/src/contrib/Archive/${name}_${version}.tar.gz" ];
  };
  deriveBiocAnn = mkDerive {
    mkHomepage = {name, ...}: "http://www.bioconductor.org/packages/${name}.html";
    mkUrls = {name, version, biocVersion}: [ "mirror://bioc/${biocVersion}/data/annotation/src/contrib/${name}_${version}.tar.gz" ];
  };
  deriveBiocExp = mkDerive {
    mkHomepage = {name, ...}: "http://www.bioconductor.org/packages/${name}.html";
    mkUrls = {name, version, biocVersion}: [ "mirror://bioc/${biocVersion}/data/experiment/src/contrib/${name}_${version}.tar.gz" ];
  };
  deriveCran = mkDerive {
    mkHomepage = {name, snapshot, ...}: "http://mran.revolutionanalytics.com/snapshot/${snapshot}/web/packages/${name}/";
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
  _self = { inherit buildRPackage; } //
          import ./bioc-packages.nix { inherit self; derive = deriveBioc; } //
          import ./bioc-annotation-packages.nix { inherit self; derive = deriveBiocAnn; } //
          import ./bioc-experiment-packages.nix { inherit self; derive = deriveBiocExp; } //
          import ./cran-packages.nix { inherit self; derive = deriveCran; };

  # tweaks for the individual packages and "in self" follow

  packagesWithRDepends = with self; {
    FactoMineR = [ car ];
    pander = [ codetools ];
  };

  packagesWithNativeBuildInputs = with pkgs; {
    rpanel = [ bwidget ];
    gdtools = [ cairo.dev fontconfig.lib freetype.dev ];
    curl = [ curl.dev ];
    chebpol = [ fftw ];
    Rssa = [ fftw.dev ];
    fftw = [ fftw.dev ];
    fftwtools = [ fftw.dev ];
    kza = [ fftw.dev ];
    mwaved = [ fftw.dev ];
    spate = [ fftw.dev ];
    seewave = [ fftw.dev libsndfile.dev ];
    systemfonts = [ fontconfig.dev freetype.dev ];
    sf = [ gdal proj geos ];
    rgeos = [ geos ];
    rggobi = [ ggobi gtk2.dev libxml2.dev ];
    Rglpk = [ glpk ];
    Formula = [ gmp ];
    glpkAPI = [ gmp glpk ];
    sdcTable = [ gmp glpk ];
    igraph = [ gmp libxml2.dev ];
    Rmpfr = [ gmp mpfr.dev ];
    gmp = [ gmp.dev ];
    rcdd = [ gmp.dev ];
    BayesSAE = [ gsl_1 ];
    BayesVarSel = [ gsl_1 ];
    GLAD = [ gsl_1 ];
    HiCseg = [ gsl_1 ];
    KFKSDS = [ gsl_1 ];
    RcppGSL = [ gsl_1 ];
    RcppZiggurat = [ gsl_1 ];
    Rlibeemd = [ gsl_1 ];
    TKF = [ gsl_1 ];
    abn = [ gsl_1 ];
    bnpmr = [ gsl_1 ];
    cit = [ gsl_1 ];
    geoCount = [ gsl_1 ];
    graphscan = [ gsl_1 ];
    gsl = [ gsl_1 ];
    iBMQ = [ gsl_1 ];
    mvabund = [ gsl_1 ];
    outbreaker = [ gsl_1 ];
    simplexreg = [ gsl_1 ];
    stsm = [ gsl_1 ];
    survSNP = [ gsl_1 ];
    topicmodels = [ gsl_1 ];
    diversitree = [ gsl_1 fftw ];
    RGtk2 = [ gtk2.dev ];
    cairoDevice = [ gtk2.dev ];
    stringi = [ icu.dev ];
    adimpro = [ imagemagick ];
    magick = [ imagemagick.dev ];
    rjags = [ jags ];
    runjags = [ jags ];
    JavaGD = [ jdk ];
    jqr = [ jq.dev ];
    RAppArmor = [ libapparmor ];
    readxl = [ libiconv ];
    haven = [ libiconv zlib.dev ];
    RODBC = [ libiodbc ];
    RODBCext = [ libiodbc ];
    jpeg = [ libjpeg.dev ];
    EMCluster = [ liblapack ];
    png = [ libpng.dev ];
    Cairo = [ libtiff libjpeg cairo.dev x11 fontconfig.lib ];
    rtiff = [ libtiff.dev ];
    tiff = [ libtiff.dev ];
    XML = [ libtool libxml2.dev xmlsec libxslt ];
    xml2 = [ libxml2.dev ] ++ lib.optionals stdenv.isDarwin [ perl ];
    ncdf4 = [ netcdf ];
    pbdNCDF4 = [ netcdf ];
    RNetCDF = [ netcdf udunits ];
    nloptr = [ nlopt pkgconfig ];
    ChemmineOB = [ openbabel pkgconfig ];
    Rmpi = [ openmpi ];
    bigGP = [ openmpi ];
    pbdMPI = [ openmpi ];
    pbdPROF = [ openmpi ];
    Rserve = [ openssl ];
    PKI = [ openssl.dev ];
    RSclient = [ openssl.dev ];
    pander = [ pandoc which ];
    rphast = [ pcre.dev zlib bzip2 gzip readline ];
    Rpoppler = [ poppler ];
    pdftools = [ poppler.dev ];
    audio = [ portaudio ];
    rpg = [ postgresql ];
    RPostgreSQL = [ postgresql postgresql ];
    proj4 = [ proj ];
    ssanv = [ proj ];
    rgdal = [ proj.dev gdal ];
    RProtoBuf = [ protobuf ];
    protolite = [ protobuf ];
    rPython = [ python ];
    qtbase = [ qt4 ];
    qtpaint = [ qt4 ];
    BayesXsrc = [ readline.dev ncurses ];
    tesseract = [ tesseract leptonica ];
    units = [ udunits ];
    udunits2 = [ udunits expat ];
    odbc = [ unixODBC ];
    V8 = [ v8 ];
    BiocCheck = [ which ];
    Cardinal = [ which ];
    animation = [ which ];
    phytools = [ which ];
    rapport = [ which ];
    rapportools = [ which ];
    reprex = [ which ];
    imager = [ x11 ];
    tkrplot = [ xorg.libX11 tk.dev ];
    devEMF = [ xorg.libXft.dev x11 ];
    rzmq = [ zeromq3 ];
    Biostrings = [ zlib ];
    DiffBind = [ zlib ];
    Rhdf5lib = [ zlib ];
    bio3d = [ zlib ];
    rhdf5 = [ zlib ];
    SAVE = [ zlib bzip2 icu lzma pcre ];
    Rhpc = [ zlib bzip2.dev icu lzma.dev openmpi pcre.dev ];
    rJava = [ zlib bzip2.dev icu lzma.dev pcre.dev jdk libzip ];
    RMySQL = [ zlib libmysqlclient openssl.dev ];
    R2SWF = [ zlib libpng freetype.dev ];
    sysfonts = [ zlib libpng freetype.dev ];
    showtext = [ zlib libpng icu freetype.dev ];
    XBRL = [ zlib libxml2.dev ];
    rtfbs = [ zlib pcre.dev bzip2 gzip readline ];
    BitSeq = [ zlib.dev ];
    RcppCNPy = [ zlib.dev ];
    Rsamtools = [ zlib.dev ];
    Rsubread = [ zlib.dev ];
    ShortRead = [ zlib.dev ];
    TAQMNGR = [ zlib.dev ];
    VariantAnnotation = [ zlib.dev ];
    WhopGenome = [ zlib.dev ];
    XVector = [ zlib.dev ];
    affyPLM = [ zlib.dev ];
    affyio = [ zlib.dev ];
    bamsignals = [ zlib.dev ];
    gmapR = [ zlib.dev ];
    h5vc = [ zlib.dev ];
    oligo = [ zlib.dev ];
    rmatio = [ zlib.dev ];
    rtracklayer = [ zlib.dev ];
    seqinr = [ zlib.dev ];
    snpStats = [ zlib.dev ];
    Rhtslib = [ zlib.dev automake autoconf ];
    RVowpalWabbit = [ zlib.dev boost ];
    seqminer = [ zlib.dev bzip2 ];
    git2r = [ zlib.dev openssl.dev libssh2.dev libgit2 pkgconfig ];
    data_table = [zlib.dev] ++ lib.optional stdenv.isDarwin llvmPackages.openmp;
    ModelMetrics = lib.optional stdenv.isDarwin llvmPackages.openmp;
    pbdZMQ = lib.optionals stdenv.isDarwin [ which ];
  };

  packagesWithBuildInputs = with pkgs; {
    # sort -t '=' -k 2
    qtpaint = [ cmake ];
    qtbase = [ cmake perl ];
    RCurl = [ curl.dev ];
    jqr = [ jq.lib ];
    rgl = [ libGLU libGLU.dev libGL xlibsWrapper ];
    KernSmooth = [ libiconv ];
    Matrix = [ libiconv ];
    RcppEigen = [ libiconv ];
    ape = [ libiconv ];
    cluster = [ libiconv ];
    expm = [ libiconv ];
    glmnet = [ libiconv ];
    igraph = [ libiconv ];
    mgcv = [ libiconv ];
    minqa = [ libiconv ];
    mnormt = [ libiconv ];
    nlme = [ libiconv ];
    pan = [ libiconv ];
    phangorn = [ libiconv ];
    quadprog = [ libiconv ];
    randomForest = [ libiconv ];
    sundialr = [ libiconv ];
    ucminf = [ libiconv ];
    mzR = [ netcdf ];
    Cairo = [ pkgconfig ];
    R2SWF = [ pkgconfig ];
    RGtk2 = [ pkgconfig ];
    RProtoBuf = [ pkgconfig ];
    Rpoppler = [ pkgconfig ];
    XML = [ pkgconfig ];
    cairoDevice = [ pkgconfig ];
    chebpol = [ pkgconfig ];
    fftw = [ pkgconfig ];
    gdtools = [ pkgconfig ];
    geoCount = [ pkgconfig ];
    kza = [ pkgconfig ];
    magick = [ pkgconfig ];
    mwaved = [ pkgconfig ];
    odbc = [ pkgconfig ];
    openssl = [ pkgconfig ];
    pdftools = [ pkgconfig ];
    rggobi = [ pkgconfig ];
    showtext = [ pkgconfig ];
    spate = [ pkgconfig ];
    stringi = [ pkgconfig ];
    sysfonts = [ pkgconfig ];
    systemfonts = [ pkgconfig ];
    tesseract = [ pkgconfig ];
    Rsymphony = [ pkgconfig doxygen graphviz subversion ];
    sf = [ pkgconfig sqlite.dev proj.dev ];
    tcltk2 = [ tcl tk ];
    RMark = [ which ];
    RPushbullet = [ which ];
    gridGraphics = [ which ];
    nat = [ which ];
    nat_templatebrains = [ which ];
    rPython = [ which ];
    svKomodo = [ which ];
    tikzDevice = [ which texlive.combined.scheme-medium ];
    adimpro = [ which xorg.xdpyinfo ];
    pbdZMQ = lib.optionals stdenv.isDarwin [ darwin.binutils ];
    SparseM = lib.optionals stdenv.isDarwin [ libiconv ];
    gam = lib.optionals stdenv.isDarwin [ libiconv ];
    quantreg = lib.optionals stdenv.isDarwin [ libiconv ];
    rmutil = lib.optionals stdenv.isDarwin [ libiconv ];
    robustbase = lib.optionals stdenv.isDarwin [ libiconv ];
  };

  packagesRequireingX = [
    "accrual"
    "ade4TkGUI"
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
    "BiodiversityR"
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
    "Deducer"
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
    "exactLoglinTest"
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
    "geomorph"
    "geoR"
    "geoRglm"
    "georob"
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
    "multgee"
    "multibiplotGUI"
    "OligoSpecificitySystem"
    "onemap"
    "OpenRepGrid"
    "paleoMAS"
    "pbatR"
    "PBSadmb"
    "PBSmodelling"
    "PCPS"
    "pez"
    "phylotools"
    "picante"
    "PKgraph"
    "plotSEMM"
    "plsRbeta"
    "plsRglm"
    "PopGenReport"
    "poppr"
    "powerpkg"
    "PredictABEL"
    "prefmod"
    "PrevMap"
    "ProbForecastGOP"
    "qtbase"
    "qtpaint"
    "r4ss"
    "RandomFields"
    "rareNMtests"
    "rAverage"
    "Rcmdr"
    "RcmdrPlugin_coin"
    "RcmdrPlugin_depthTools"
    "RcmdrPlugin_DoE"
    "RcmdrPlugin_EACSPIR"
    "RcmdrPlugin_EBM"
    "RcmdrPlugin_EcoVirtual"
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
    "RcmdrPlugin_sos"
    "RcmdrPlugin_steepness"
    "RcmdrPlugin_survival"
    "RcmdrPlugin_TeachingDemos"
    "RcmdrPlugin_temis"
    "RcmdrPlugin_UCA"
    "recluster"
    "relimp"
    "RenextGUI"
    "reportRx"
    "reshapeGUI"
    "rgl"
    "RHRV"
    "rich"
    "RNCEP"
    "RQDA"
    "RSDA"
    "rsgcc"
    "RSurvey"
    "RunuranGUI"
    "simba"
    "Simile"
    "SimpleTable"
    "SOLOMON"
    "soundecology"
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
    "Rmpi"     # tries to run MPI processes
    "pbdMPI"   # tries to run MPI processes
  ];

  # Packages which cannot be installed due to lack of dependencies or other reasons.
  brokenPackages = [
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

    data_table = old.data_table.overrideDerivation (attrs: {
      NIX_CFLAGS_COMPILE = attrs.NIX_CFLAGS_COMPILE
        + lib.optionalString stdenv.isDarwin " -fopenmp";
    });

    ModelMetrics = old.ModelMetrics.overrideDerivation (attrs: {
      NIX_CFLAGS_COMPILE = attrs.NIX_CFLAGS_COMPILE
        + lib.optionalString stdenv.isDarwin " -fopenmp";
    });

    rpf = old.rpf.overrideDerivation (attrs: {
      patchPhase = "patchShebangs configure";
    });

    BayesXsrc = old.BayesXsrc.overrideDerivation (attrs: {
      patches = [ ./patches/BayesXsrc.patch ];
    });

    Rhdf5lib = old.Rhdf5lib.overrideDerivation (attrs: {
      patches = [ ./patches/Rhdf5lib.patch ];
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

    jqr = old.jqr.overrideDerivation (attrs: {
      preConfigure = ''
        patchShebangs configure
        '';
    });

    pbdZMQ = old.pbdZMQ.overrideDerivation (attrs: {
      postPatch = lib.optionalString stdenv.isDarwin ''
        for file in R/*.{r,r.in}; do
            sed -i 's#system("which \(\w\+\)"[^)]*)#"${pkgs.darwin.cctools}/bin/\1"#g' $file
        done
      '';
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
      LIBAPPARMOR_HOME = pkgs.libapparmor;
    });

    RMySQL = old.RMySQL.overrideDerivation (attrs: {
      MYSQL_DIR="${pkgs.libmysqlclient}";
      preConfigure = ''
        patchShebangs configure
      '';
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

    openssl = old.openssl.overrideDerivation (attrs: {
      PKGCONFIG_CFLAGS = "-I${pkgs.openssl.dev}/include";
      PKGCONFIG_LIBS = "-Wl,-rpath,${pkgs.openssl.out}/lib -L${pkgs.openssl.out}/lib -lssl -lcrypto";
    });

    websocket = old.websocket.overrideDerivation (attrs: {
      PKGCONFIG_CFLAGS = "-I${pkgs.openssl.dev}/include";
      PKGCONFIG_LIBS = "-Wl,-rpath,${pkgs.openssl.out}/lib -L${pkgs.openssl.out}/lib -lssl -lcrypto";
    });

    Rserve = old.Rserve.overrideDerivation (attrs: {
      patches = [ ./patches/Rserve.patch ];
      configureFlags = [
        "--with-server" "--with-client"
      ];
    });

    nloptr = old.nloptr.overrideDerivation (attrs: {
      # Drop bundled nlopt source code. Probably unnecessary, but I want to be
      # sure we're using the system library, not this one.
      preConfigure = "rm -r src/nlopt_src";
    });

    V8 = old.V8.overrideDerivation (attrs: {
      postPatch = ''
        substituteInPlace configure \
          --replace " -lv8_libplatform" ""
      '';

      preConfigure = ''
        export INCLUDE_DIR=${pkgs.v8}/include
        export LIB_DIR=${pkgs.v8}/lib
        patchShebangs configure
      '';
    });

    acs = old.acs.overrideDerivation (attrs: {
      preConfigure = ''
        patchShebangs configure
        '';
    });

    gdtools = old.gdtools.overrideDerivation (attrs: {
      preConfigure = ''
        patchShebangs configure
        '';
      NIX_LDFLAGS = "-lfontconfig -lfreetype";
    });

    magick = old.magick.overrideDerivation (attrs: {
      preConfigure = ''
        patchShebangs configure
        '';
    });

    protolite = old.protolite.overrideDerivation (attrs: {
      preConfigure = ''
        patchShebangs configure
        '';
    });

    rpanel = old.rpanel.overrideDerivation (attrs: {
      preConfigure = ''
        export TCLLIBPATH="${pkgs.bwidget}/lib/bwidget${pkgs.bwidget.version}"
      '';
      TCLLIBPATH = "${pkgs.bwidget}/lib/bwidget${pkgs.bwidget.version}";
    });

    RPostgres = old.RPostgres.overrideDerivation (attrs: {
      preConfigure = ''
        export INCLUDE_DIR=${pkgs.postgresql}/include
        export LIB_DIR=${pkgs.postgresql.lib}/lib
        patchShebangs configure
        '';
    });

    OpenMx = old.OpenMx.overrideDerivation (attrs: {
      preConfigure = ''
        patchShebangs configure
        '';
    });

    odbc = old.odbc.overrideDerivation (attrs: {
      preConfigure = ''
        patchShebangs configure
        '';
    });

    x13binary = old.x13binary.overrideDerivation (attrs: {
      preConfigure = ''
        patchShebangs configure
        '';
    });

    geojsonio = old.geojsonio.overrideDerivation (attrs: {
      buildInputs = [ cacert ] ++ attrs.buildInputs;
    });

    rstan = old.rstan.overrideDerivation (attrs: {
      NIX_CFLAGS_COMPILE = "${attrs.NIX_CFLAGS_COMPILE} -DBOOST_PHOENIX_NO_VARIADIC_EXPRESSION";
    });

    mongolite = old.mongolite.overrideDerivation (attrs: {
      preConfigure = ''
        patchShebangs configure
        '';
      PKGCONFIG_CFLAGS = "-I${pkgs.openssl.dev}/include -I${pkgs.cyrus_sasl.dev}/include -I${pkgs.zlib.dev}/include";
      PKGCONFIG_LIBS = "-Wl,-rpath,${pkgs.openssl.out}/lib -L${pkgs.openssl.out}/lib -L${pkgs.cyrus_sasl.out}/lib -L${pkgs.zlib.out}/lib -lssl -lcrypto -lsasl2 -lz";
    });

    ps = old.ps.overrideDerivation (attrs: {
      preConfigure = "patchShebangs configure";
    });

    rlang = old.rlang.overrideDerivation (attrs: {
      preConfigure = "patchShebangs configure";
    });

    systemfonts = old.systemfonts.overrideDerivation (attrs: {
      preConfigure = "patchShebangs configure";
    });

    littler = old.littler.overrideAttrs (attrs: with pkgs; {
      buildInputs = [ pcre lzma zlib bzip2 icu which ] ++ attrs.buildInputs;
      postInstall = ''
        install -d $out/bin $out/share/man/man1
        ln -s ../library/littler/bin/r $out/bin/r
        ln -s ../library/littler/bin/r $out/bin/lr
        ln -s ../../../library/littler/man-page/r.1 $out/share/man/man1
        # these won't run without special provisions, so better remove them
        rm -r $out/library/littler/script-tests
      '';
    });

  };
in
  self
