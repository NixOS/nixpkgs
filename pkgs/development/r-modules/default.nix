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
    propagatedBuildInputs = depends  ++ ( with pkgs;
      # packages assumed very often by R package tools are added to buildInputs
      (lib.optionals stdenv.isDarwin [ libiconv flock which ])
      ++ [ pkgs.gsl liblapack gmp.dev gtk2.dev bzip2.dev pkgs.pkgconfig
           lzma icu.dev pcre.dev zlib.dev curl.dev libpng libtiff libjpeg
         ]);
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
    mkHomepage = {name, biocVersion, ...}: "https://bioconductor.org/packages/${biocVersion}/data/annotation/html/${name}.html";
    mkUrls = {name, version, biocVersion}: [ "mirror://bioc/${biocVersion}/data/annotation/src/contrib/${name}_${version}.tar.gz" ];
  };
  deriveBiocExp = mkDerive {
    mkHomepage = {name, biocVersion, ...}: "http://www.bioconductor.org/packages/${biocVersion}/data/experiment/html/${name}.html";
    mkUrls = {name, version, biocVersion}: [ "mirror://bioc/${biocVersion}/data/experiment/src/contrib/${name}_${version}.tar.gz" ];
  };
  deriveBiocWrk = mkDerive { # not available on mirrors afaik
    mkHomepage = {name, biocVersion, ...}: "https://www.bioconductor.org/packages/${biocVersion}/workflows/html/${name}.html";
    mkUrls = {name, version, biocVersion}: [ "https://www.bioconductor.org/packages/${biocVersion}/workflows/src/contrib/${name}_${version}.tar.gz"];
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
      old1 = old0 // (overrideRequireX packagesRequiringX old0);
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
          import ./bioc-packages.nix            { inherit self; derive = deriveBioc; } //
          import ./bioc-annotation-packages.nix { inherit self; derive = deriveBiocAnn; } //
          import ./bioc-experiment-packages.nix { inherit self; derive = deriveBiocExp; } //
          import ./bioc-workflows-packages.nix  { inherit self; derive = deriveBiocWrk; } //
          import ./cran-packages.nix            { inherit self; derive = deriveCran; };

  # tweaks for the individual packages and "in self" follow

  packagesWithRDepends = {
    # if R deps are missing for some reason, add them here.
    tesseract = [ self.pdftools ];
    TextForecast = [ self.Rpoppler ];
    qmix = [ self.rstantools ]; # slow compile. Use linking and rstan?
    cbq = [ self.rstantools ]; # slow compile. Use linking and rstan?
    RBesT = [ self.rstantools ]; # slow compile. Use linking and rstan?
  };

  packagesWithNativeBuildInputs = with pkgs; {
    BayesXsrc = [ readline.dev ncurses ];
    Cairo = [ libtiff libjpeg cairo.dev x11 fontconfig.lib ];
    ChemmineOB = [ openbabel ];
    FDX = [ fftw.dev ];
    GLPK = [ glpk ];
    JavaGD = [ jdk ];
    KRIG  = lib.optional stdenv.isDarwin llvmPackages.openmp;
    KSgeneral = [ fftw.dev ];
    LBLGXE = lib.optional stdenv.isDarwin llvmPackages.openmp;
    MSGFplus = [ jdk ];
    ModelMetrics = lib.optional stdenv.isDarwin llvmPackages.openmp;
    PKI = [ openssl.dev ];
    PoissonBinomial = [ fftw.dev ];
    PythonInR = [ python3 ncurses ];
    R2SWF = [ freetype.dev ];
    RAppArmor = [ libapparmor ];
    RGtk2 = [ gtk2.dev ];
    RMariaDB = [ libmysqlclient ];
    RMySQL = [ libmysqlclient openssl.dev ];
    RNetCDF = [ netcdf udunits ];
    RODBC = [ libiodbc ];
    RPostgreSQL = [ postgresql postgresql ];
    RProtoBuf = [ protobuf ];
    RSclient = [ openssl.dev ];
    RVowpalWabbit = [ boost ];
    Rblpapi = [ ]; # needs proprietary "Bloomberg LP api" lib
    RcppCWB = [ ncurses.dev ];
    Rglpk = [ glpk ];
    Rhpc = [ openmpi ];
    Rhtslib = [ automake autoconf ] ;
    Rmpfr = [ mpfr.dev ];
    Rmpi = [ openmpi ];
    Rserve = [ openssl ];
    V8 = [ v8 ];
    XBRL = [ libxml2.dev ];
    XML = [ libtool libxml2.dev xmlsec ];
    adimpro = [ imagemagick ];
    audio = [ portaudio ];
    bigGP = [ openmpi ];
    bioacoustics = [ fftw.dev ];
    cairoDevice = [ gtk2.dev ];
    data_table = lib.optional stdenv.isDarwin llvmPackages.openmp;
    devEMF = [ xorg.libXft.dev x11 ];
    exactextractr = [ geos ];
    exifr = [ pkgs.perl ];
    gdalcubes = [ gdal proj.dev netcdf sqlite.dev ];
    gdtools = [ cairo.dev fontconfig.lib freetype ];
    gert = [ libgit2 ];
    git2r = [  openssl.dev libssh2.dev libgit2  ];
    glpkAPI = [ gmp glpk ];
    gmp = [ gmp.dev ];
    hdf5r = [ hdf5.dev];
    igraph = [ gmp libxml2.dev ];
    imager = [ x11 ];
    jpeg = [ libjpeg.dev ];
    jqr = [ jq.dev ];
    landsepi = [ gdal ];
    lwgeom = [ proj.dev geos ];
    magick = [ imagemagick.dev ];
    matchingMarkets = [ jdk ];
    mongolite = [ openssl cyrus_sasl ]; 
    mwaved = [ fftw.dev ];
    ncdf4 = [ netcdf ];
    odbc = [ unixODBC ];
    pander = [ pandoc  ];
    pathfindR = [ jdk ];
    pbdMPI = [ openmpi ];
    pbdNCDF4 = [ netcdf ];
    pbdPROF = [ openmpi ];
    pcaL1 = [ clp ];
    poisbinom = [ fftw.dev ];
    proj4 = [ proj.dev ];
    protolite = [ protobuf ];
    qgg =  lib.optional stdenv.isDarwin llvmPackages.openmp;
    qtbase = [ qt5.dev ]; # patches/qtbase.patch still needed? don't think so. TODO: delete it.
    qtpaint = [ qt5 ];
    rDEA = [ glpk] ;
    rJava = [ jdk libzip ];
    rPython = [ (python3.withPackages(ps : with ps; []))  ncurses ]; # broken
    rcdd = [ gmp.dev ];
    rcrypt = [ gnupg ];
    readtext = [ poppler.dev ];    
    redux = [ hiredis ];
    rgdal = [ proj.dev gdal ];
    rgeos = [ geos ];
    rggobi = [ ggobi gtk2.dev libxml2.dev ];
    rjags = [ jags ];
    rpanel = [ bwidget ];
    rpg = [ postgresql ];
    rscala = [ scala ];
    runjags = [ jags ];
    rzmq = [ zeromq3 ];
    scModels = [ mpfr.dev ];
    sdcTable = [ glpk ];
    seewave = [ libsndfile.dev ];
    sf = [ gdal proj.dev geos ];
    showtext = [ freetype.dev ];
    specklestar = [ fftw.dev ]; 
    ssanv = [ proj.dev ];
    sysfonts = [ freetype.dev ];
    systemfonts = [ fontconfig.dev freetype.dev ];
    tesseract = [ pkgs.tesseract leptonica ];
    tkrplot = [ xorg.libX11 tk.dev ];
    uFTIR = [ gdal ];
    udunits2 = [ udunits expat ];
    units = [ udunits ];
    vapour = [ gdal ];
    websocket = [ pkgs.openssl.dev ];
    xml2 = [ libxml2.dev ] ++ lib.optionals stdenv.isDarwin [ perl ];
  };

  packagesWithBuildInputs = with pkgs; {
    BALD = [ jags ];
    CopulaCenR = [ pkgs.openssl.dev];
    CytoML = [ libxml2.dev ];
    HilbertVisGUI = [ gtkmm2.dev gnumake ];
    RAppArmor = [ libapparmor ]; 
    Rcplex = [ cplex ]; 
    RcppMeCab = [ mecab ];
    RmecabKo = [ mecab ] ;
    Rpoppler = [  poppler.dev ];
    Rsymphony = [  doxygen graphviz subversion ];
    SparseM = lib.optionals stdenv.isDarwin [  ];
    SuperGauss = [ pkgs.fftw.dev] ;
    TextForecast = [ poppler.dev ]; 
    adimpro = [ xorg.xdpyinfo ];
    av = [ libav ffmpeg-full ];
    baseflow = [ cargo ];
    bioacoustics = [ cmake soxr ];
    cld3 = [ protobuf ];
    clpAPI = [ CoinMP ];
    commonsMath = [ pkgs.commonsMath ];
    fftw = [ pkgs.fftw.dev ]; # uses doubles. other variations needed?
    fftwtools = [ pkgs.fftw.dev ];
    gifski = [ pkgs.gifski ];
    gsl = [ pkgs.gsl];
    gsubfn = [ xorg.xdpyinfo x11 ];
    jqr = [ jq.lib ];
    libsoc = [ libxml2.dev ];
    mzR = [ netcdf ];
    nandb = [libtiff.dev ];
    nloptr = [ nlopt ];
    opencv = [ opencv4 ];
    openssl = [ pkgs.openssl.dev ];
    pbdZMQ = lib.optionals stdenv.isDarwin [ darwin.binutils ];
    pdftools = [ poppler_data poppler.dev libjpeg.dev];
    qpdf = [ libjpeg.dev ];
    qtbase = [ cmake perl ];
    qtpaint = [ cmake ];
    redland = [ librdf_redland ];
    rgl = [ libGLU libGLU.dev libGL xlibsWrapper ];
    rrd = [ rrdtool ];
    rsvg = [ librsvg.dev  ];
    salso = [ cargo ];
    sf = [  sqlite.dev proj.dev ];
    sodium = [ libsodium.dev ]; 
    ssh = [ libssh ]; 
    tcltk2 = [ tcl tk ];
    tikzDevice = [ texlive.combined.scheme-medium ];
    webp = [ libwebp ];
    xslt = [ libxslt.dev libxml2.dev ];
  };

  # TODO: some of these have been removed from the upstream source. delete them.
  packagesRequiringX = [
    "AnalyzeFMRI"
    "AnnotLists"
    "AnthropMMD"
    "AtelieR"
    "BAT"
    "BCA"
    "BiodiversityR"
    "CCTpack"
    "CommunityCorrelogram"
    "ConvergenceConcepts"
    "DALY"
    "DSpat"
    "Deducer"
    "DeducerPlugInExample"
    "DeducerPlugInScaling"
    "DeducerSpatial"
    "DeducerSurvival"
    "DeducerText"
    "Demerelate"
    "DivMelt"
    "ENiRG"
    "EasyqpcR"
    "EcoVirtual"
    "FD"
    "FFD"
    "FeedbackTS"
    "FreeSortR"
    "GGEBiplotGUI"
    "GPCSIV"
    "GUniFrac"
    "GrammR"
    "GrapheR"
    "GroupSeq"
    "HH"
    "HierO"
    "HiveR"
    "IsotopeR"
    "JFE" 
    "JGR"
    "KappaGUI"
    "LS2Wstat"
    "MareyMap"
    "MergeGUI"
    "MetSizeR"
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
    "RHRV"
    "RNCEP"
    "RQDA"
    "RSDA"
    "RSurvey"
    "RandomFields"
    "Rcmdr"
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
    "RcmdrPlugin_TeachingDemos"
    "RcmdrPlugin_UCA"
    "RcmdrPlugin_coin"
    "RcmdrPlugin_depthTools"
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
    "SRRS"
    "SSDforR"
    "STEPCAM"
    "SYNCSA"
    "Simile"
    "SimpleTable"
    "StatDA"
    "SyNet"
    "TIMP"
    "TTAinterfaceTrendAnalysis"
    "TestScorer"
    "VecStatGraphs3D"
    "WMCapacity"
    "accrual"
    "ade4TkGUI"
    "analogue"
    "analogueExtra"
    "aplpack"
    "asbio"
    "bayesDem"
    "betapart"
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
    "detrendeR"
    "dgmb"
    "dpa"
    "dynBiplotGUI"
    "dynamicGraph"
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
    "geomorph"
    "georob"
    "ggtern"
    "gnm"
    "gsubfn"
    "iDynoR"
    "ic50"
    "in2extRemes"
    "iplots"
    "isopam"
    "likeLTD"
    "logmult"
    "loon"
    "memgene"
    "metacom"
    "migui"
    "miniGUI"
    "mixsep"
    "mpmcorrelogram"
    "mritc"
    "multgee"
    "multibiplotGUI"
    "onemap"
    "optbdmaeAT" 
    "optrcdmaeAT" 
    "paleoMAS"
    "pbatR"
    "pez"
    "phylotools"
    "picante"
    "plotSEMM"
    "plsRbeta"
    "plsRglm"
    "poppr"
    "powerpkg"
    "prefmod"
    "qtbase"
    "qtpaint"
    "r4ss"
    "rAverage"
    "rMouse"
    "rareNMtests"
    "recluster"
    "relimp"
    "reshapeGUI"
    "rfviz"
    "rgl"
    "rich"
    "rpanel"
    "simba"
    "soptdmaeA"
    "soundecology"
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
    "xRing"
  ];

  packagesToSkipCheck = [
    "HDCytoData"
    "Rmpi"     # tries to run MPI processes
    "pbdMPI"   # tries to run MPI processes
    "x12GUI"
    "regRSM" # tries to run MPI processes
    "TabulaMurisData"
    "dmdScheme"
    "exifr"
    "fulltext"
    "ggtern"
    "packagefinder" 
    "spi"
    "wrswoR_benchmark"
    "FlowSorted_CordBlood_450k" # impure test
    "FlowSorted_CordBloodCombined_450k" # impure test
    "DuoClustering2018" # impure test
  ];

  # Packages which cannot be installed due to lack of dependencies or other reasons.
  brokenPackages = [
    # comments are hints/tags. many issues are fixable and the fix may apply to multiple packages. Have a go!
    "AntMAN" # salso. Cargo related.
    "ArrayExpressHTS" # Error: package or namespace load failed for 'ArrayExpressHTS'
    "BRugs" # there is no openbugs, a dependency.
    "ChoR" # maven, impure
    "DBKGrad" # rpanel
    "DriftBurstHypothesis" # compile error
    "GRANBase" # impure
    "GRANCore" # impure?
    "GUIDE" # rpanel (bwidget)
    "GeneBook" # impure?
    "HierO" # similar to rpanel
    "RBLpapi" # lib not available
    "RGreenplum" # RPostgres
    "RKEEL" # impure
    "RKEELjars" # impure
    "ROI_plugin_clp" # cplex
    "ROI_plugin_cplex" #  " # cplex. different errors on darwin and linux
    "ROI_plugin_symphony" # symphony
    "ROracle" # OCI
    "RQuantLib" # no lib to link. wants QuantLib. 
    "RVideoPoker" # rpanel
    "Rcplex" # needs cplex
    "Rsymphony" # SYMPHONY
    "SDD" # rpanel
    "anomaly" # compile error
    "bamboo" # unable to load R code in package 'rscala
    "baseflow" # cargo (rust) config problem
    "baseflow" # ld: cannot find -lrustlib
    "bigGP" # ompi_mpi_init: ompi_rte_init faile
    "biotools" # rpanel
    "clustermq" # ERROR: dependency 'rzmq' is not available for package 'clustermq', but rzmq builds ok.
    "cocktailApp" # ggtern. object 'expand_default' not found.
    "commonsMath" # impure build
    "cplexAPI" #  CPLEX interactive optimizer not found
    "cytofWorkflow" # impure build, maybe patch NAMESPACE  
    "dataone" # redland
    "doMPI" # ompi_mpi_init: ompi_rte_init failed
    "erpR" # rpanel
    "expands" # impure. commonsMath
    "freetypeharfbuzz" # impure? /download.sh "https://github.com/lionel-/freetypeharfbuzz/raw/v`cat version`/tools/freetype-2.9-patched.tar.gz" freetype-2.9-patched.tar.gz
    "ggtern" # Error in get(x, envir = ns, inherits = FALSE) :     object 'expand_default' not found.
    "ggtern" # object 'expand_default' not found
    "gifski" # Cargo
    "googleformr" # impure? Could not resolve host: docs.google.com
    "gpuR" # linker error. lib needed?
    "h2o" # impure. cannot open URL 'http://s3.amazonaws.com/h2o-release/h2o/rel-yu/4/Rjar/h2o.jar.md5
    "kazaam" # ompi_mpi_init: ompi_rte_init failed
    "kmcudaR" # rror: "NVCC not found; check CUDA install"
    "lazytrade" # h2o impure? URL 'http://s3.amazonaws.com/h2o-release/h2o/rel-yu/4/Rjar/h2o.jar.md5
    "lgcp" # rpanel
    "metaMix" # ompi_mpi_init: ompi_rte_init failed
    "metaMix" # ompi_mpi_init: ompi_rte_init failed
    "moc_gapbk" # ompi_mpi_init: ompi_rte_init failed
    "moc_gapbk" # ompi_mpi_init: ompi_rte_init failed
    "moveVis" # gifski
    "nearfar" # impure? cannot open the connection to 'https://raw.githubusercontent.com/joerigdon/nearfar/master/angrist.csv'
    "optBiomarker" # rpanel
    "ora" # ROracle
    "pbdBASE" # ompi_mpi_init: ompi_rte_init failed
    "pbdSLAP" # ompi_mpi_init: ompi_rte_init failed
    "permGPU" # nvcc not found. needs cudatoolkit most likely
    "plfMA" # might be gtk2 related 
    "plot3logit" # ggtern
    "rLindo" # needs lindo.
    "rPython" # configure.ac needs a patch to work
    "randstr" # cannot open the connection to 'https://www.random.org/quota/?format=plain'.
    "rdflib" # redland
    "redland" # needs lib configuration for librdf_redland
    "regRSM" # ompi_mpi_init: ompi_rte_init failed
    "rpanel" #  Error in structure(.External(.C_dotTcl, ...), class = "tclObj") :     [tcl] can't find package BWidget.
    "rsparkling" # impure. relies on impure h2o
    "salso" # Cargo
    "sdols" # Cargo
    "seeds" # rpanel
    "shallot" # commonsMath
    "shinyML" # h2o
    "sismonr" # needs julia
    "smovie" # rpanel
    "soilphysics" # rpanel
    "spate" # config issue
    "spatstat_gui" # rpanel
    "tesseract" # patch config  
    "vdiffr" # freetypeharfbuzz 
    "x12" # same as x12GUI?
    "x12GUI" # ????
    "xRing" # rpanel (bwidget)
    # possibly broken ...
    # zooaRchGUI # byte compile takes a very long time. uses cpu, so not hung? maybe large, single threaded?
    # uHMM # byte compile takes a very long time. uses cpu, so not hung? maybe large, single threaded?
  ];

  otherOverrides = old: new: {
    
    data_table = old.data_table.overrideDerivation (attrs: {
      NIX_CFLAGS_COMPILE = attrs.NIX_CFLAGS_COMPILE
        + lib.optionalString stdenv.isDarwin " -fopenmp";
    });

    ModelMetrics = old.ModelMetrics.overrideDerivation (attrs: {
      NIX_CFLAGS_COMPILE = attrs.NIX_CFLAGS_COMPILE
        + lib.optionalString stdenv.isDarwin " -fopenmp";
    });

    Rhdf5lib = old.Rhdf5lib.overrideDerivation (attrs: {
      patches = [ ./patches/Rhdf5lib.patch ];
    });

    sodium = old.sodium.overrideDerivation ( attrs: {
      preConfigure = ''
        patchShebangs configure    
      '';
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

    pbdZMQ = old.pbdZMQ.overrideDerivation (attrs: {
      postPatch = lib.optionalString stdenv.isDarwin ''
        for file in R/*.{r,r.in}; do
            sed -i 's#system("which \(\w\+\)"[^)]*)#"${pkgs.darwin.cctools}/bin/\1"#g' $file
        done
      '';
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

    RMySQL = old.RMySQL.overrideDerivation (attrs: {
      MYSQL_DIR="${pkgs.libmysqlclient}";
      preConfigure = ''
        patchShebangs configure
      '';
    });

    SamplerCompare = old.SamplerCompare.overrideDerivation (attrs: {
      PKG_LIBS = "-L${pkgs.blas}/lib -lblas -L${pkgs.lapack}/lib -llapack";
    });

    openssl = old.openssl.overrideDerivation (attrs: {
      NIX_CFLAGS_COMPILE="-I${pkgs.openssl.dev}/include";
      NIX_LDFLAGS="-rpath ${pkgs.openssl.out}/lib -L${pkgs.openssl.out}/lib -lssl -lcrypto";
    });

    websocket = old.websocket.overrideDerivation (attrs: {
      NIX_CFLAGS_COMPILE = "-I${pkgs.openssl.dev}/include";
      NIX_LDFLAGS = "-rpath ${pkgs.openssl.out}/lib -L${pkgs.openssl.out}/lib -lssl -lcrypto";
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
        "--with-nlopt-libs=${pkgs.nlopt}/lib"
      ];
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
    
    gdtools = old.gdtools.overrideDerivation (attrs: {
      preConfigure = ''
        patchShebangs configure
        '';          
      NIX_LDFLAGS = "-lfontconfig -lfreetype";
    });

    # not working
    rpanel = old.rpanel.overrideDerivation (attrs: {
      preConfigure = ''
        export TCLLIBPATH=". ${pkgs.bwidget}/lib/${pkgs.bwidget.libPrefix}"
      '';
      #TCLLIBPATH="${pkgs.bwidget}/lib/${pkgs.bwidget.libPrefix}";
    });

    # needs another patch in custom configure file 
    RPostgres = old.RPostgres.overrideDerivation (attrs: {
      preConfigure = ''
        #export INCLUDE_DIR=${pkgs.postgresql}/include
        #export LIB_DIR=${pkgs.postgresql.lib}/lib
        patchShebangs configure
        '';
    });

    # TODO: needs patch like openssl
    tesseract = old.tesseract.overrideDerivation (attrs: {
      PKG_CFLAGS = "-I${pkgs.tesseract}/include -I${pkgs.leptonica}/include";
      PKG_LIBS = "-Wl,-rpath,${pkgs.tesseract}/lib -L${pkgs.tesseract}/lib";
      
    });

    xslt = old.xslt.overrideDerivation (attrs: {
      preConfigure = "patchShebangs configure";
    });
    
    geojsonio = old.geojsonio.overrideDerivation (attrs: {
      buildInputs = [ cacert ] ++ attrs.buildInputs;
    });

    rstan = old.rstan.overrideDerivation (attrs: {
      NIX_CFLAGS_COMPILE = "${attrs.NIX_CFLAGS_COMPILE} -DBOOST_PHOENIX_NO_VARIADIC_EXPRESSION";
    });

    mongolite = old.mongolite.overrideDerivation (attrs: {
      NIX_CFLAGS_COMPILE = "-I${pkgs.openssl.dev}/include -I${pkgs.cyrus_sasl.dev}/include -I${pkgs.zlib.dev}/include";
      NIX_LDFLAGS = "-rpath ${pkgs.openssl.out}/lib -L${pkgs.openssl.out}/lib -L${pkgs.cyrus_sasl.out}/lib -L${pkgs.zlib.out}/lib -lssl -lcrypto -lsasl2 -lz";
      preConfigure = ''
        patchShebangs configure
      '';  
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

    # broken. needs Cargo too
    gifski = old.gifski.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });

    #broken. needs config help
    redland = old.redland.overrideDerivation (attrs: {
      # NIX_CFLAGS_COMPILE = "-I${pkgs.librdf_redland}/include";
      # NIX_LDFLAGS = "-rpath ${pkgs.librdf_redland}/lib -L${pkgs.librdf_redland}/lib -lrdf -lredland";
      #PKGCONFIG_CFLAGS = "-I${pkgs.librdf_redland}/include";
      #PKGCONFIG_LIBS = "-WL -rpath,${pkgs.librdf_redland}/lib -L${pkgs.librdf_redland}/lib";
      preConfigure = "patchShebangs configure";
    });

    xml2 = old.xml2.overrideDerivation (attrs: {
      preConfigure = ''
        export LIBXML_INCDIR=${pkgs.libxml2.dev}/include/libxml2
        patchShebangs configure
        '';
    });

    # Packages that only need patchShebangs ... not very "DRY".  
    DeLorean = old.DeLorean.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    OpenMx = old.OpenMx.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    RKorAPClient = old.RKorAPClient.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    RMariaDB = old.RMariaDB.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    Rblpapi = old.Rblpapi.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    RcppArmadillo = old.RcppArmadillo.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    RcppCWB = old.RcppCWB.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    RcppParallel= old.RcppParallel.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    acs = old.acs.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    av = old.av.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    cld3 = old.cld3.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    curl = old.curl.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    freetypeharfbuzz = old.freetypeharfbuzz.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    gert = old.gert.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    ijtiff = old.ijtiff.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    jqr = old.jqr.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    keyring = old.keyring.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    libsoc = old.libsoc.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    liquidSVM = old.liquidSVM.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    magick = old.magick.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    missSBM = old.missSBM.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; }); 
    odbc = old.odbc.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    opencv = old.opencv.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    pdftools = old.pdftools.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    protolite = old.protolite.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    ps = old.ps.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    qmix = old.qmix.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    qtpaint = old.qtpaint.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    redux = old.redux.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    rlang = old.rlang.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    rpf = old.rpf.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    rpg = old.rpg.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    rrd = old.rrd.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    rsvg = old.rsvg.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    rzmq = old.rzmq.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    strex = old.strex.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    systemfonts = old.systemfonts.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    webp = old.webp.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });
    x13binary = old.x13binary.overrideDerivation (attrs: { preConfigure = "patchShebangs configure"; });

  };
in self

