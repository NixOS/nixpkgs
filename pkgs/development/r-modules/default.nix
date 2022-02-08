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
  mkDerive = {mkHomepage, mkUrls, hydraPlatforms ? null}: args:
    let hydraPlatforms' = hydraPlatforms; in
      lib.makeOverridable ({
        name, version, sha256,
        depends ? [],
        doCheck ? true,
        requireX ? false,
        broken ? false,
        platforms ? R.meta.platforms,
        hydraPlatforms ? if hydraPlatforms' != null then hydraPlatforms' else platforms,
        maintainers ? []
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
    meta.platforms = platforms;
    meta.hydraPlatforms = hydraPlatforms;
    meta.broken = broken;
    meta.maintainers = maintainers;
  });

  # Templates for generating Bioconductor and CRAN packages
  # from the name, version, sha256, and optional per-package arguments above
  #
  deriveBioc = mkDerive {
    mkHomepage = {name, biocVersion, ...}: "https://bioconductor.org/packages/${biocVersion}/bioc/html/${name}.html";
    mkUrls = {name, version, biocVersion}: [
      "mirror://bioc/${biocVersion}/bioc/src/contrib/${name}_${version}.tar.gz"
      "mirror://bioc/${biocVersion}/bioc/src/contrib/Archive/${name}/${name}_${version}.tar.gz"
      "mirror://bioc/${biocVersion}/bioc/src/contrib/Archive/${name}_${version}.tar.gz"
    ];
  };
  deriveBiocAnn = mkDerive {
    mkHomepage = {name, ...}: "http://www.bioconductor.org/packages/${name}.html";
    mkUrls = {name, version, biocVersion}: [
      "mirror://bioc/${biocVersion}/data/annotation/src/contrib/${name}_${version}.tar.gz"
    ];
    hydraPlatforms = [];
  };
  deriveBiocExp = mkDerive {
    mkHomepage = {name, ...}: "http://www.bioconductor.org/packages/${name}.html";
    mkUrls = {name, version, biocVersion}: [
      "mirror://bioc/${biocVersion}/data/experiment/src/contrib/${name}_${version}.tar.gz"
    ];
    hydraPlatforms = [];
  };
  deriveCran = mkDerive {
    mkHomepage = {name, snapshot, ...}: "http://mran.revolutionanalytics.com/snapshot/${snapshot}/web/packages/${name}/";
    mkUrls = {name, version, snapshot}: [
      "http://mran.revolutionanalytics.com/snapshot/${snapshot}/src/contrib/${name}_${version}.tar.gz"
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

  # Overrides package definitions with maintainers.
  # For example,
  #
  # overrideMaintainers {
  #   foo = [ lib.maintainers.jsmith ]
  # } old
  #
  # results in
  #
  # {
  #   foo = old.foo.override {
  #     maintainers = [ lib.maintainers.jsmith ];
  #   };
  # }
  overrideMaintainers = overrides: old:
    lib.mapAttrs (name: value:
      (builtins.getAttr name old).override {
        maintainers = value;
      }) overrides;

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

  # Overrides package definition requiring a home directory to install or to
  # run tests.
  # For example,
  #
  # overrideRequireHome [
  #   "foo"
  # ] old
  #
  # results in
  #
  # {
  #   foo = old.foo.overrideAttrs (oldAttrs:  {
  #     preInstall = ''
  #       ${oldAttrs.preInstall or ""}
  #       export HOME=$(mktemp -d)
  #     '';
  #   });
  # }
  overrideRequireHome = packageNames: old:
    let
      nameValuePairs = map (name: {
        inherit name;
        value = (builtins.getAttr name old).overrideAttrs (oldAttrs: {
          preInstall = ''
            ${oldAttrs.preInstall or ""}
            export HOME=$(mktemp -d)
          '';
        });
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
      old2 = old1 // (overrideRequireHome packagesRequiringHome old1);
      old3 = old2 // (overrideSkipCheck packagesToSkipCheck old2);
      old4 = old3 // (overrideRDepends packagesWithRDepends old3);
      old5 = old4 // (overrideNativeBuildInputs packagesWithNativeBuildInputs old4);
      old6 = old5 // (overrideBuildInputs packagesWithBuildInputs old5);
      old7 = old6 // (overrideBroken brokenPackages old6);
      old8 = old7 // (overrideMaintainers packagesWithMaintainers old7);
      old = old8;
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

  packagesWithMaintainers = with lib.maintainers; {
    data_table = [ jbedo ];
    BiocManager = [ jbedo ];
    ggplot2 = [ jbedo ];
    svaNUMT = [ jbedo ];
    svaRetro = [ jbedo ];
    StructuralVariantAnnotation = [ jbedo ];
  };

  packagesWithRDepends = {
    FactoMineR = [ self.car ];
    pander = [ self.codetools ];
  };

  packagesWithNativeBuildInputs = {
    arrow = [ pkgs.pkg-config pkgs.arrow-cpp ];
    adimpro = [ pkgs.imagemagick ];
    animation = [ pkgs.which ];
    audio = [ pkgs.portaudio ];
    BayesSAE = [ pkgs.gsl ];
    BayesVarSel = [ pkgs.gsl ];
    BayesXsrc = with pkgs; [ readline.dev ncurses gsl ];
    bigGP = [ pkgs.mpi ];
    bio3d = [ pkgs.zlib ];
    BiocCheck = [ pkgs.which ];
    Biostrings = [ pkgs.zlib ];
    bnpmr = [ pkgs.gsl ];
    cairoDevice = [ pkgs.gtk2.dev ];
    Cairo = with pkgs; [ libtiff libjpeg cairo.dev xlibsWrapper fontconfig.lib ];
    Cardinal = [ pkgs.which ];
    chebpol = [ pkgs.fftw ];
    ChemmineOB = with pkgs; [ openbabel pkg-config ];
    curl = [ pkgs.curl.dev ];
    data_table = [ pkgs.zlib.dev ] ++ lib.optional stdenv.isDarwin pkgs.llvmPackages.openmp;
    devEMF = with pkgs; [ xorg.libXft.dev xlibsWrapper ];
    diversitree = with pkgs; [ gsl fftw ];
    exactextractr = [ pkgs.geos ];
    EMCluster = [ pkgs.lapack ];
    fftw = [ pkgs.fftw.dev ];
    fftwtools = with pkgs; [ fftw.dev pkg-config ];
    Formula = [ pkgs.gmp ];
    gdtools = with pkgs; [ cairo.dev fontconfig.lib freetype.dev ];
    ggiraph = with pkgs; [ pkgs.libpng.dev ];
    git2r = with pkgs; [ zlib.dev openssl.dev libssh2.dev libgit2 pkg-config ];
    GLAD = [ pkgs.gsl ];
    glpkAPI = with pkgs; [ gmp glpk ];
    gmp = [ pkgs.gmp.dev ];
    graphscan = [ pkgs.gsl ];
    gsl = [ pkgs.gsl ];
    gert = [ pkgs.libgit2 ];
    haven = with pkgs; [ libiconv zlib.dev ];
    h5vc = [ pkgs.zlib.dev ];
    HiCseg = [ pkgs.gsl ];
    imager = [ pkgs.xlibsWrapper ];
    iBMQ = [ pkgs.gsl ];
    igraph = with pkgs; [ gmp libxml2.dev ];
    JavaGD = [ pkgs.jdk ];
    jpeg = [ pkgs.libjpeg.dev ];
    jqr = [ pkgs.jq.dev ];
    KFKSDS = [ pkgs.gsl ];
    kza = [ pkgs.fftw.dev ];
    lpsymphony = with pkgs; [ pkg-config gfortran gettext ];
    lwgeom = with pkgs; [ proj geos gdal ];
    magick = [ pkgs.imagemagick.dev ];
    ModelMetrics = lib.optional stdenv.isDarwin pkgs.llvmPackages.openmp;
    mvabund = [ pkgs.gsl ];
    mwaved = [ pkgs.fftw.dev ];
    mzR = with pkgs; [ zlib boost159.dev netcdf ];
    ncdf4 = [ pkgs.netcdf ];
    nloptr = with pkgs; [ nlopt pkg-config ];
    n1qn1 = [ pkgs.gfortran ];
    odbc = [ pkgs.unixODBC ];
    pander = with pkgs; [ pandoc which ];
    pbdMPI = [ pkgs.mpi ];
    pbdPROF = [ pkgs.mpi ];
    pbdZMQ = lib.optionals stdenv.isDarwin [ pkgs.which ];
    pdftools = [ pkgs.poppler.dev ];
    phytools = [ pkgs.which ];
    PKI = [ pkgs.openssl.dev ];
    png = [ pkgs.libpng.dev ];
    protolite = [ pkgs.protobuf ];
    R2SWF = with pkgs; [ zlib libpng freetype.dev ];
    RAppArmor = [ pkgs.libapparmor ];
    rapportools = [ pkgs.which ];
    rapport = [ pkgs.which ];
    readxl = [ pkgs.libiconv ];
    rcdd = [ pkgs.gmp.dev ];
    RcppCNPy = [ pkgs.zlib.dev ];
    RcppGSL = [ pkgs.gsl ];
    RcppZiggurat = [ pkgs.gsl ];
    reprex = [ pkgs.which ];
    rgdal = with pkgs; [ proj.dev gdal ];
    rgeos = [ pkgs.geos ];
    Rglpk = [ pkgs.glpk ];
    RGtk2 = [ pkgs.gtk2.dev ];
    rhdf5 = [ pkgs.zlib ];
    Rhdf5lib = [ pkgs.zlib.dev ];
    Rhpc = with pkgs; [ zlib bzip2.dev icu xz.dev mpi pcre.dev ];
    Rhtslib = with pkgs; [ zlib.dev automake autoconf bzip2.dev xz.dev curl.dev ];
    rjags = [ pkgs.jags ];
    rJava = with pkgs; [ zlib bzip2.dev icu xz.dev pcre.dev jdk libzip ];
    Rlibeemd = [ pkgs.gsl ];
    rmatio = [ pkgs.zlib.dev ];
    Rmpfr = with pkgs; [ gmp mpfr.dev ];
    Rmpi = [ pkgs.mpi ];
    RMySQL = with pkgs; [ zlib libmysqlclient openssl.dev ];
    RNetCDF = with pkgs; [ netcdf udunits ];
    RODBC = [ pkgs.libiodbc ];
    rpanel = [ pkgs.bwidget ];
    Rpoppler = [ pkgs.poppler ];
    RPostgreSQL = with pkgs; [ postgresql postgresql ];
    RProtoBuf = [ pkgs.protobuf ];
    RSclient = [ pkgs.openssl.dev ];
    Rserve = [ pkgs.openssl ];
    Rssa = [ pkgs.fftw.dev ];
    rsvg = [ pkgs.pkg-config ];
    runjags = [ pkgs.jags ];
    RVowpalWabbit = with pkgs; [ zlib.dev boost ];
    rzmq = with pkgs; [ zeromq pkg-config ];
    httpuv = [ pkgs.zlib.dev ];
    clustermq = [ pkgs.zeromq ];
    SAVE = with pkgs; [ zlib bzip2 icu xz pcre ];
    sdcTable = with pkgs; [ gmp glpk ];
    seewave = with pkgs; [ fftw.dev libsndfile.dev ];
    seqinr = [ pkgs.zlib.dev ];
    seqminer = with pkgs; [ zlib.dev bzip2 ];
    sf = with pkgs; [ gdal proj geos ];
    terra = with pkgs; [ gdal proj geos ];
    showtext = with pkgs; [ zlib libpng icu freetype.dev ];
    simplexreg = [ pkgs.gsl ];
    spate = [ pkgs.fftw.dev ];
    ssanv = [ pkgs.proj ];
    stsm = [ pkgs.gsl ];
    stringi = [ pkgs.icu.dev ];
    survSNP = [ pkgs.gsl ];
    svglite = [ pkgs.libpng.dev ];
    sysfonts = with pkgs; [ zlib libpng freetype.dev ];
    systemfonts = with pkgs; [ fontconfig.dev freetype.dev ];
    TAQMNGR = [ pkgs.zlib.dev ];
    tesseract = with pkgs; [ tesseract leptonica ];
    tiff = [ pkgs.libtiff.dev ];
    tkrplot = with pkgs; [ xorg.libX11 tk.dev ];
    topicmodels = [ pkgs.gsl ];
    udunits2 = with pkgs; [ udunits expat ];
    units = [ pkgs.udunits ];
    V8 = [ pkgs.v8 ];
    XBRL = with pkgs; [ zlib libxml2.dev ];
    xml2 = [ pkgs.libxml2.dev ] ++ lib.optionals stdenv.isDarwin [ pkgs.perl ];
    XML = with pkgs; [ libtool libxml2.dev xmlsec libxslt ];
    affyPLM = [ pkgs.zlib.dev ];
    bamsignals = [ pkgs.zlib.dev ];
    BitSeq = [ pkgs.zlib.dev ];
    DiffBind = [ pkgs.zlib ];
    ShortRead = [ pkgs.zlib.dev ];
    oligo = [ pkgs.zlib.dev ];
    gmapR = [ pkgs.zlib.dev ];
    Rsubread = [ pkgs.zlib.dev ];
    XVector = [ pkgs.zlib.dev ];
    Rsamtools = with pkgs; [ zlib.dev curl.dev ];
    rtracklayer = [ pkgs.zlib.dev ];
    affyio = [ pkgs.zlib.dev ];
    VariantAnnotation = with pkgs; [ zlib.dev curl.dev ];
    snpStats = [ pkgs.zlib.dev ];
    hdf5r = [ pkgs.hdf5.dev ];
    httpgd = with pkgs; [ cairo.dev ];
    SymTS = [ pkgs.gsl ];
    VBLPCM = [ pkgs.gsl ];
    dynr = [ pkgs.gsl ];
    mixlink = [ pkgs.gsl ];
    ridge = [ pkgs.gsl ];
    smam = [ pkgs.gsl ];
    rnetcarto = [ pkgs.gsl ];
    rGEDI = [ pkgs.gsl ];
    mmpca = [ pkgs.gsl ];
    monoreg = [ pkgs.gsl ];
    mvst = [ pkgs.gsl ];
    mixture = [ pkgs.gsl ];
    jSDM = [ pkgs.gsl ];
    immunoClust = [ pkgs.gsl ];
    hSDM = [ pkgs.gsl ];
    flowPeaks = [ pkgs.gsl ];
    fRLR = [ pkgs.gsl ];
    eaf = [ pkgs.gsl ];
    diseq = [ pkgs.gsl ];
    cit = [ pkgs.gsl ];
    abn = [ pkgs.gsl ];
    SimInf = [ pkgs.gsl ];
    RJMCMCNucleosomes = [ pkgs.gsl ];
    RDieHarder = [ pkgs.gsl ];
    QF = [ pkgs.gsl ];
    PICS = [ pkgs.gsl ];
    RcppCWB = [ pkgs.pkg-config ];
    rrd = [ pkgs.pkg-config ];
    trackViewer = [ pkgs.zlib.dev ];
    themetagenomics = [ pkgs.zlib.dev ];
    NanoMethViz = [ pkgs.zlib.dev ];
    RcppMeCab = [ pkgs.pkg-config ];
    HilbertVisGUI = with pkgs; [ pkg-config which ];
    textshaping = [ pkgs.pkg-config ];
    ragg = [ pkgs.pkg-config ];
  };

  packagesWithBuildInputs = {
    # sort -t '=' -k 2
    gam = lib.optionals stdenv.isDarwin [ pkgs.libiconv ];
    RcppArmadillo = lib.optionals stdenv.isDarwin [ pkgs.libiconv ];
    quantreg = lib.optionals stdenv.isDarwin [ pkgs.libiconv ];
    rmutil = lib.optionals stdenv.isDarwin [ pkgs.libiconv ];
    robustbase = lib.optionals stdenv.isDarwin [ pkgs.libiconv ];
    SparseM = lib.optionals stdenv.isDarwin [ pkgs.libiconv ];
    hexbin = lib.optionals stdenv.isDarwin [ pkgs.libiconv ];
    svKomodo = [ pkgs.which ];
    nat = [ pkgs.which ];
    nat_templatebrains = [ pkgs.which ];
    pbdZMQ = lib.optionals stdenv.isDarwin [ pkgs.darwin.binutils ];
    clustermq = [  pkgs.pkg-config ];
    RMark = [ pkgs.which ];
    RPushbullet = [ pkgs.which ];
    RcppEigen = [ pkgs.libiconv ];
    RCurl = [ pkgs.curl.dev ];
    R2SWF = [ pkgs.pkg-config ];
    rgl = with pkgs; [ libGLU libGLU.dev libGL xlibsWrapper ];
    RGtk2 = [ pkgs.pkg-config ];
    RProtoBuf = [ pkgs.pkg-config ];
    Rpoppler = [ pkgs.pkg-config ];
    XML = [ pkgs.pkg-config ];
    cairoDevice = [ pkgs.pkg-config ];
    chebpol = [ pkgs.pkg-config ];
    fftw = [ pkgs.pkg-config ];
    gdtools = [ pkgs.pkg-config ];
    jqr = [ pkgs.jq.lib ];
    kza = [ pkgs.pkg-config ];
    lwgeom = with pkgs; [ pkg-config proj.dev sqlite.dev ];
    magick = [ pkgs.pkg-config ];
    mwaved = [ pkgs.pkg-config ];
    odbc = [ pkgs.pkg-config ];
    openssl = [ pkgs.pkg-config ];
    pdftools = [ pkgs.pkg-config ];
    sf = with pkgs; [ pkg-config sqlite.dev proj.dev ];
    terra = with pkgs; [ pkg-config sqlite.dev proj.dev ];
    showtext = [ pkgs.pkg-config ];
    spate = [ pkgs.pkg-config ];
    stringi = [ pkgs.pkg-config ];
    sysfonts = [ pkgs.pkg-config ];
    systemfonts = [ pkgs.pkg-config ];
    tesseract = [ pkgs.pkg-config ];
    Cairo = [ pkgs.pkg-config ];
    CLVTools = [ pkgs.gsl ];
    JMcmprsk = [ pkgs.gsl ];
    mashr = [ pkgs.gsl ];
    hadron = [ pkgs.gsl ];
    AMOUNTAIN = [ pkgs.gsl ];
    Rsymphony = with pkgs; [ pkg-config doxygen graphviz subversion ];
    tcltk2 = with pkgs; [ tcl tk ];
    tikzDevice = with pkgs; [ which texlive.combined.scheme-medium ];
    gridGraphics = [ pkgs.which ];
    adimpro = with pkgs; [ which xorg.xdpyinfo ];
    cluster = [ pkgs.libiconv ];
    KernSmooth = [ pkgs.libiconv ];
    nlme = [ pkgs.libiconv ];
    Matrix = [ pkgs.libiconv ];
    mgcv = [ pkgs.libiconv ];
    minqa = [ pkgs.libiconv ];
    igraph = [ pkgs.libiconv ];
    ape = [ pkgs.libiconv ];
    expm = [ pkgs.libiconv ];
    mnormt = [ pkgs.libiconv ];
    pan = [ pkgs.libiconv ];
    phangorn = [ pkgs.libiconv ];
    quadprog = [ pkgs.libiconv ];
    randomForest = [ pkgs.libiconv ];
    sundialr = [ pkgs.libiconv ];
    ucminf = [ pkgs.libiconv ];
    glmnet = [ pkgs.libiconv ];
    mvtnorm = [ pkgs.libiconv ];
    statmod = [ pkgs.libiconv ];
    rsvg = [ pkgs.librsvg.dev ];
    ssh = with pkgs; [ libssh ];
    s2 = [ pkgs.openssl.dev ];
    ArrayExpressHTS = with pkgs; [ zlib.dev curl.dev which ];
    bbl = with pkgs; [ gsl ];
    writexl = with pkgs; [ zlib.dev ];
    qpdf = with pkgs; [ libjpeg.dev zlib.dev ];
    vcfR = with pkgs; [ zlib.dev ];
    bio3d = with pkgs; [ zlib.dev ];
    arrangements = with pkgs; [ gmp.dev ];
    spp = with pkgs; [ zlib.dev ];
    Rbowtie = with pkgs; [ zlib.dev ];
    gaston = with pkgs; [ zlib.dev ];
    csaw = with pkgs; [ zlib.dev curl ];
    DirichletMultinomial = with pkgs; [ gsl ];
    DiffBind = with pkgs; [ zlib.dev ];
    CNEr = with pkgs; [ zlib ];
    GMMAT = with pkgs; [ zlib.dev bzip2.dev ];
    HiCDCPlus = [ pkgs.zlib.dev ];
    PopGenome = [ pkgs.zlib.dev ];
    QuasR = [ pkgs.zlib.dev ];
    Rbowtie2 = [ pkgs.zlib.dev ];
    Rmmquant = [ pkgs.zlib.dev ];
    SICtools = with pkgs; [ zlib.dev ncurses.dev ];
    Signac = [ pkgs.zlib.dev ];
    TransView = [ pkgs.zlib.dev ];
    bigsnpr = [ pkgs.zlib.dev ];
    divest = [ pkgs.zlib.dev ];
    hipread = [ pkgs.zlib.dev ];
    jackalope = with pkgs; [ zlib.dev xz.dev ];
    largeList = [ pkgs.zlib.dev ];
    mappoly = [ pkgs.zlib.dev ];
    matchingMarkets = [ pkgs.zlib.dev ];
    methylKit = [ pkgs.zlib.dev ];
    ndjson = [ pkgs.zlib.dev ];
    podkat = [ pkgs.zlib.dev ];
    qrqc = [ pkgs.zlib.dev ];
    rJPSGCS = [ pkgs.zlib.dev ];
    rhdf5filters = [ pkgs.zlib.dev ];
    rtk = [ pkgs.zlib.dev ];
    scPipe = [ pkgs.zlib.dev ];
    seqTools = [ pkgs.zlib.dev ];
    seqbias = [ pkgs.zlib.dev ];
    sparkwarc = [ pkgs.zlib.dev ];
    RoBMA = [ pkgs.jags ];
    rGEDI = with pkgs; [ libgeotiff.dev libaec zlib.dev hdf5.dev ];
    rawrr = [ pkgs.mono ];
    HDF5Array = [ pkgs.zlib.dev ];
    FLAMES = [ pkgs.zlib.dev ];
    ncdfFlow = [ pkgs.zlib.dev ];
    proj4 = [ pkgs.proj.dev ];
    rtmpt = [ pkgs.gsl ];
    mixcat = [ pkgs.gsl ];
    libstableR = [ pkgs.gsl ];
    landsepi = [ pkgs.gsl ];
    flan = [ pkgs.gsl ];
    econetwork = [ pkgs.gsl ];
    crandep = [ pkgs.gsl ];
    catSurv = [ pkgs.gsl ];
    ccfindR = [ pkgs.gsl ];
    SPARSEMODr = [ pkgs.gsl ];
    RKHSMetaMod = [ pkgs.gsl ];
    LCMCR = [ pkgs.gsl ];
    BNSP = [ pkgs.gsl ];
    scModels = [ pkgs.mpfr.dev ];
    multibridge = [ pkgs.mpfr.dev ];
    RcppCWB = with pkgs; [ pcre.dev glib.dev ];
    RmecabKo = [ pkgs.mecab ];
    PoissonBinomial = [ pkgs.fftw.dev ];
    rrd = [ pkgs.rrdtool ];
    flowWorkspace = [ pkgs.zlib.dev ];
    RcppMeCab = [ pkgs.mecab ];
    PING = [ pkgs.gsl ];
    RcppAlgos = [ pkgs.gmp.dev ];
    RcppBigIntAlgos = [ pkgs.gmp.dev ];
    HilbertVisGUI = [ pkgs.gtkmm2.dev ];
    textshaping = with pkgs; [ harfbuzz.dev freetype.dev fribidi libpng ];
    DropletUtils = [ pkgs.zlib.dev ];
    RMariaDB = [ pkgs.libmysqlclient.dev ];
    ragg = with pkgs; [ freetype.dev libpng.dev libtiff.dev zlib.dev libjpeg.dev bzip2.dev ];
  };

  packagesRequiringX = [
    "accrual"
    "ade4TkGUI"
    "analogue"
    "analogueExtra"
    "AnalyzeFMRI"
    "AnnotLists"
    "AnthropMMD"
    "aplpack"
    "asbio"
    "BAT"
    "BCA"
    "betapart"
    "BiodiversityR"
    "bio_infer"
    "bipartite"
    "biplotbootGUI"
    "blender"
    "cairoDevice"
    "canceR"
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
    "dpa"
    "dynamicGraph"
    "dynBiplotGUI"
    "EasyqpcR"
    "EcoVirtual"
    "exactLoglinTest"
    "fat2Lpoly"
    "fbati"
    "FD"
    "feature"
    "FeedbackTS"
    "FFD"
    "fgui"
    "fisheyeR"
    "forams"
    "forensim"
    "FreeSortR"
    "fscaret"
    "gcmr"
    "geomorph"
    "geoR"
    "georob"
    "GGEBiplotGUI"
    "gnm"
    "GrapheR"
    "GroupSeq"
    "gsubfn"
    "GUniFrac"
    "gWidgets2RGtk2"
    "gWidgets2tcltk"
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
    "loon"
    "LS2Wstat"
    "MareyMap"
    "memgene"
    "metacom"
    "Meth27QC"
    "migui"
    "miniGUI"
    "mixsep"
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
    "plotSEMM"
    "plsRbeta"
    "plsRglm"
    "PopGenReport"
    "poppr"
    "powerpkg"
    "PredictABEL"
    "prefmod"
    "PrevMap"
    "r4ss"
    "RandomFields"
    "rareNMtests"
    "rAverage"
    "RclusTool"
    "Rcmdr"
    "RcmdrPlugin_coin"
    "RcmdrPlugin_depthTools"
    "RcmdrPlugin_DoE"
    "RcmdrPlugin_EACSPIR"
    "RcmdrPlugin_EBM"
    "RcmdrPlugin_EcoVirtual"
    "RcmdrPlugin_EZR"
    "RcmdrPlugin_FactoMineR"
    "RcmdrPlugin_FuzzyClust"
    "RcmdrPlugin_HH"
    "RcmdrPlugin_IPSUR"
    "RcmdrPlugin_KMggplot2"
    "RcmdrPlugin_lfstat"
    "RcmdrPlugin_MA"
    "RcmdrPlugin_MPAStats"
    "RcmdrPlugin_orloca"
    "RcmdrPlugin_PcaRobust"
    "RcmdrPlugin_plotByGroup"
    "RcmdrPlugin_pointG"
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
    "RHRV"
    "rich"
    "RNCEP"
    "RSDA"
    "RSurvey"
    "simba"
    "Simile"
    "SimpleTable"
    "SOLOMON"
    "soundecology"
    "spatsurv"
    "sqldf"
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
    "tkrplot"
    "tmap"
    "tspmeta"
    "TTAinterfaceTrendAnalysis"
    "twiddler"
    "uHMM"
    "vcdExtra"
    "VecStatGraphs3D"
    "vegan"
    "vegan3d"
    "vegclust"
    "x12GUI"
  ];

  packagesRequiringHome = [
    "aroma_affymetrix"
    "aroma_cn"
    "aroma_core"
    "csodata"
    "DiceView"
    "MSnID"
    "OmnipathR"
    "precommit"
    "PSCBS"
    "repmis"
    "R_cache"
    "R_filesets"
    "RKorAPClient"
    "R_rsp"
    "scholar"
    "stepR"
    "styler"
    "TreeTools"
    "ACNE"
    "APAlyzer"
    "EstMix"
    "PECA"
    "Quartet"
    "ShinyQuickStarter"
    "TIN"
    "TotalCopheneticIndex"
    "TreeDist"
    "biocthis"
    "calmate"
    "fgga"
    "fulltext"
    "immuneSIM"
    "mastif"
    "shinymeta"
    "shinyobjects"
    "wppi"
    "pins"
    "CoTiMA"
    "TBRDist"
    "Rogue"
    "fixest"
    "paxtoolsr"
    "systemPipeShiny"
  ];

  packagesToSkipCheck = [
    "Rmpi"     # tries to run MPI processes
    "pbdMPI"   # tries to run MPI processes
    "data_table" # fails to rename shared library before check
  ];

  # Packages which cannot be installed due to lack of dependencies or other reasons.
  brokenPackages = [
    "av"
    "NetLogoR"
    "valse"
    "HierO"
    "HIBAG"
    "HiveR"

    # Impure network access during build
    "waddR"
    "tiledb"
    "x13binary"
    "switchr"

    # ExperimentHub dependents, require net access during build
    "DuoClustering2018"
    "FieldEffectCrc"
    "GenomicDistributionsData"
    "HDCytoData"
    "HMP16SData"
    "PANTHER_db"
    "RNAmodR_Data"
    "SCATEData"
    "SingleMoleculeFootprintingData"
    "TabulaMurisData"
    "benchmarkfdrData2019"
    "bodymapRat"
    "clustifyrdatahub"
    "depmap"
    "emtdata"
    "metaboliteIDmapping"
    "msigdb"
    "muscData"
    "org_Mxanthus_db"
    "scpdata"
    "nullrangesData"
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

    rzmq = old.rzmq.overrideDerivation (attrs: {
      preConfigure = "patchShebangs configure";
    });

    clustermq = old.clustermq.overrideDerivation (attrs: {
      preConfigure = "patchShebangs configure";
    });

    Cairo = old.Cairo.overrideDerivation (attrs: {
      NIX_LDFLAGS = "-lfontconfig";
    });

    curl = old.curl.overrideDerivation (attrs: {
      preConfigure = "patchShebangs configure";
    });

    RcppParallel = old.RcppParallel.overrideDerivation (attrs: {
      preConfigure = "patchShebangs configure";
    });

    RcppArmadillo = old.RcppArmadillo.overrideDerivation (attrs: {
      patchPhase = "patchShebangs configure";
    });

    data_table = old.data_table.overrideDerivation (attrs: {
      NIX_CFLAGS_COMPILE = attrs.NIX_CFLAGS_COMPILE + " -fopenmp";
      patchPhase = "patchShebangs configure";
    });

    ModelMetrics = old.ModelMetrics.overrideDerivation (attrs: {
      NIX_CFLAGS_COMPILE = attrs.NIX_CFLAGS_COMPILE
        + lib.optionalString stdenv.isDarwin " -fopenmp";
    });

    rpf = old.rpf.overrideDerivation (attrs: {
      patchPhase = "patchShebangs configure";
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
      MYSQL_DIR = "${pkgs.libmysqlclient}";
      PKGCONFIG_CFLAGS = "-I${pkgs.libmysqlclient.dev}/include/mysql";
      NIX_CFLAGS_LINK = "-L${pkgs.libmysqlclient}/lib/mysql -lmysqlclient";
      preConfigure = ''
        patchShebangs configure
      '';
    });

    devEMF = old.devEMF.overrideDerivation (attrs: {
      NIX_CFLAGS_LINK = "-L${pkgs.xorg.libXft.out}/lib -lXft";
      NIX_LDFLAGS = "-lX11";
    });

    slfm = old.slfm.overrideDerivation (attrs: {
      PKG_LIBS = "-L${pkgs.blas}/lib -lblas -L${pkgs.lapack}/lib -llapack";
    });

    SamplerCompare = old.SamplerCompare.overrideDerivation (attrs: {
      PKG_LIBS = "-L${pkgs.blas}/lib -lblas -L${pkgs.lapack}/lib -llapack";
    });

    spMC = old.spMC.overrideDerivation (attrs: {
      patches = [ ./patches/spMC.patch ];
    });

    openssl = old.openssl.overrideDerivation (attrs: {
      preConfigure = ''
        patchShebangs configure
      '';
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

      R_MAKEVARS_SITE = lib.optionalString (pkgs.stdenv.system == "aarch64-linux")
        (pkgs.writeText "Makevars" ''
          CXX14PICFLAGS = -fPIC
        '');
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

    libgeos = old.libgeos.overrideDerivation (attrs: {
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
      buildInputs = [ pcre xz zlib bzip2 icu which ] ++ attrs.buildInputs;
      postInstall = ''
        install -d $out/bin $out/share/man/man1
        ln -s ../library/littler/bin/r $out/bin/r
        ln -s ../library/littler/bin/r $out/bin/lr
        ln -s ../../../library/littler/man-page/r.1 $out/share/man/man1
        # these won't run without special provisions, so better remove them
        rm -r $out/library/littler/script-tests
      '';
    });

    lpsymphony = old.lpsymphony.overrideDerivation (attrs: {
      preConfigure = ''
        patchShebangs configure
      '';
    });

    sodium = old.sodium.overrideDerivation (attrs: with pkgs; {
      preConfigure = ''
        patchShebangs configure
      '';
      nativeBuildInputs = [ pkg-config ] ++ attrs.nativeBuildInputs;
      buildInputs = [ libsodium.dev ] ++ attrs.buildInputs;
    });

    keyring = old.keyring.overrideDerivation (attrs: {
      preConfigure = ''
        patchShebangs configure
      '';
    });

    Rhtslib = old.Rhtslib.overrideDerivation (attrs: {
      preConfigure = ''
        substituteInPlace R/zzz.R --replace "-lcurl" "-L${pkgs.curl.out}/lib -lcurl"
      '';
    });

    h2o = old.h2o.overrideDerivation (attrs: {
      preConfigure = ''
        # prevent download of jar file during install and postpone to first use
        sed -i '/downloadJar()/d' R/zzz.R

        # during runtime the package directory is not writable as it's in the
        # nix store, so store the jar in the user's cache directory instead
        substituteInPlace R/connection.R --replace \
          'dest_file <- file.path(dest_folder, "h2o.jar")' \
          'dest_file <- file.path("~/.cache/", "h2o.jar")'
      '';
    });

    SICtools = old.SICtools.overrideDerivation (attrs: {
      preConfigure = ''
        substituteInPlace src/Makefile --replace "-lcurses" "-lncurses"
      '';
    });

    arrow = old.arrow.overrideDerivation (attrs: {
      preConfigure = ''
        patchShebangs configure
      '';
    });

    proj4 = old.proj4.overrideDerivation (attrs: {
      preConfigure = ''
        substituteInPlace configure \
          --replace "-lsqlite3" "-L${lib.makeLibraryPath [ pkgs.sqlite ]} -lsqlite3"
      '';
    });

    rrd = old.rrd.overrideDerivation (attrs: {
      preConfigure = ''
        patchShebangs configure
      '';
    });

    ChIPXpress = old.ChIPXpress.override { hydraPlatforms = []; };

    rgl = old.rgl.overrideDerivation (attrs: {
      RGL_USE_NULL = "true";
    });

    Rrdrand = old.Rrdrand.override { platforms = lib.platforms.x86_64 ++ lib.platforms.x86; };

    RandomFieldsUtils = old.RandomFieldsUtils.override { platforms = lib.platforms.x86_64 ++ lib.platforms.x86; };

    flowClust = old.flowClust.override { platforms = lib.platforms.x86_64 ++ lib.platforms.x86; };

    geomorph = old.geomorph.overrideDerivation (attrs: {
      RGL_USE_NULL = "true";
    });
  };
in
  self
