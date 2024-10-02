/* This file defines the composition for R packages. */

let
  importJSON = f: builtins.fromJSON (builtins.readFile f);

  biocPackagesGenerated =  importJSON ./bioc-packages.json;
  biocAnnotationPackagesGenerated = importJSON ./bioc-annotation-packages.json;
  biocExperimentPackagesGenerated = importJSON ./bioc-experiment-packages.json;
  cranPackagesGenerated = importJSON ./cran-packages.json;
in

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
    mkHomepage = {name, biocVersion}: "https://bioconductor.org/packages/${biocVersion}/bioc/html/${name}.html";
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
    mkHomepage = {name}: "https://cran.r-project.org/web/packages/${name}/";
    mkUrls = {name, version}: [
      "mirror://cran/${name}_${version}.tar.gz"
      "mirror://cran/Archive/${name}/${name}_${version}.tar.gz"
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
  #   foo = old.foo.overrideAttrs (attrs: {
  #     nativeBuildInputs = attrs.nativeBuildInputs ++ [ pkgs.bar ];
  #   });
  # }
  overrideNativeBuildInputs = overrides: old:
    lib.mapAttrs (name: value:
      (builtins.getAttr name old).overrideAttrs (attrs: {
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
  #   foo = old.foo.overrideAttrs (attrs: {
  #     buildInputs = attrs.buildInputs ++ [ pkgs.bar ];
  #   });
  # }
  overrideBuildInputs = overrides: old:
    lib.mapAttrs (name: value:
      (builtins.getAttr name old).overrideAttrs (attrs: {
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
  #   foo = old.foo.overrideAttrs (attrs: {
  #     nativeBuildInputs = attrs.nativeBuildInputs ++ [ self.bar ];
  #     propagatedNativeBuildInputs = attrs.propagatedNativeBuildInputs ++ [ self.bar ];
  #   });
  # }
  overrideRDepends = overrides: old:
    lib.mapAttrs (name: value:
      (builtins.getAttr name old).overrideAttrs (attrs: {
        nativeBuildInputs = (attrs.nativeBuildInputs or []) ++ value;
        propagatedNativeBuildInputs = (attrs.propagatedNativeBuildInputs or []) ++ value;
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
          mkPackageSet deriveBioc biocPackagesGenerated //
          mkPackageSet deriveBiocAnn biocAnnotationPackagesGenerated //
          mkPackageSet deriveBiocExp biocExperimentPackagesGenerated //
          mkPackageSet deriveCran cranPackagesGenerated;

  # Takes in a generated JSON file's imported contents
  # and transforms it by swapping each element of the depends array with the dependency's derivation
  # and passing this new object to the provided derive function
  mkPackageSet = derive: packagesJSON: lib.mapAttrs (
    k: v: derive packagesJSON.extraArgs (v // { depends = lib.map (name: builtins.getAttr name self) v.depends; })
  ) packagesJSON.packages;


  # tweaks for the individual packages and "in self" follow

  packagesWithMaintainers = with lib.maintainers; {
    data_table = [ jbedo ];
    BiocManager = [ jbedo ];
    ggplot2 = [ jbedo ];
    svaNUMT = [ jbedo ];
    svaRetro = [ jbedo ];
    StructuralVariantAnnotation = [ jbedo ];
    RQuantLib = [ kupac ];
  };

  packagesWithRDepends = {
    spectralGraphTopology = [ self.CVXR ];
    FactoMineR = [ self.car ];
    pander = [ self.codetools ];
    rmsb = [ self.rstantools ];
    gastempt = [ self.rstantools ];
    interactiveDisplay = [ self.BiocManager ];
    disbayes = [ self.rstantools ];
    tipsae = [ self.rstantools ];
    TriDimRegression = [ self.rstantools ];
    bbmix = [ self.rstantools ];
  };

  packagesWithNativeBuildInputs = {
    adbcpostgresql = [ pkgs.postgresql ];
    adimpro = [ pkgs.imagemagick ];
    animation = [ pkgs.which ];
    Apollonius = with pkgs; [ pkg-config gmp.dev mpfr.dev ];
    arrow = with pkgs; [ pkg-config cmake ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ intltool ];
    audio = [ pkgs.portaudio ];
    BayesSAE = [ pkgs.gsl ];
    BayesVarSel = [ pkgs.gsl ];
    BayesXsrc = with pkgs; [ readline.dev ncurses gsl ];
    bioacoustics = [ pkgs.fftw.dev pkgs.cmake ];
    bigGP = [ pkgs.mpi ];
    bigrquerystorage = with pkgs; [ grpc protobuf which ];
    bio3d = [ pkgs.zlib ];
    BiocCheck = [ pkgs.which ];
    Biostrings = [ pkgs.zlib ];
    CellBarcode = [ pkgs.zlib ];
    cld3 = [ pkgs.protobuf ];
    bnpmr = [ pkgs.gsl ];
    caviarpd = [ pkgs.cargo ];
    cairoDevice = [ pkgs.gtk2.dev ];
    Cairo = with pkgs; [ libtiff libjpeg cairo.dev xorg.libXt.dev fontconfig.lib ];
    Cardinal = [ pkgs.which ];
    chebpol = [ pkgs.fftw.dev ];
    ChemmineOB = [ pkgs.pkg-config ];
    interpolation = [ pkgs.pkg-config ];
    clarabel = [ pkgs.cargo ];
    curl = [ pkgs.curl.dev ];
    CytoML = [ pkgs.libxml2.dev ];
    data_table = with pkgs; [ pkg-config zlib.dev ] ++ lib.optional stdenv.hostPlatform.isDarwin pkgs.llvmPackages.openmp;
    devEMF = with pkgs; [ xorg.libXft.dev ];
    diversitree = with pkgs; [ gsl fftw ];
    exactextractr = [ pkgs.geos ];
    EMCluster = [ pkgs.lapack ];
    fangs = [ pkgs.cargo ];
    fcl = [ pkgs.cargo ];
    fftw = [ pkgs.fftw.dev ];
    fftwtools = with pkgs; [ fftw.dev pkg-config ];
    fingerPro = [ pkgs.gsl ];
    Formula = [ pkgs.gmp ];
    frailtyMMpen = [ pkgs.gsl ];
    gamstransfer = [ pkgs.zlib ];
    gdalraster = [ pkgs.pkg-config ];
    gdtools = with pkgs; [ cairo.dev fontconfig.lib freetype.dev ];
    GeneralizedWendland = [ pkgs.gsl ];
    ggiraph = with pkgs; [ pkgs.libpng.dev ];
    git2r = with pkgs; [ zlib.dev openssl.dev libssh2.dev libgit2 pkg-config ];
    GLAD = [ pkgs.gsl ];
    glpkAPI = with pkgs; [ gmp glpk ];
    gmp = [ pkgs.gmp.dev ];
    GPBayes = [ pkgs.gsl ];
    graphscan = [ pkgs.gsl ];
    gsl = [ pkgs.gsl ];
    gslnls = [ pkgs.gsl ];
    gert = [ pkgs.libgit2 ];
    haven = with pkgs; [ zlib.dev ];
    hellorust = [ pkgs.cargo ];
    hgwrr = [ pkgs.gsl ];
    h5vc = with pkgs; [ zlib.dev bzip2.dev xz.dev ];
    yyjsonr = with pkgs; [ zlib.dev ];
    RNifti = with pkgs; [ zlib.dev ];
    RNiftyReg = with pkgs; [ zlib.dev ];
    highs = [ pkgs.which pkgs.cmake ];
    crc32c = [ pkgs.which pkgs.cmake ];
    rbedrock = [ pkgs.zlib.dev pkgs.which pkgs.cmake ];
    HiCseg = [ pkgs.gsl ];
    imager = [ pkgs.xorg.libX11.dev ];
    imbibe = [ pkgs.zlib.dev ];
    image_CannyEdges = with pkgs; [ fftw.dev libpng.dev ];
    iBMQ = [ pkgs.gsl ];
    jack = [ pkgs.pkg-config ];
    JavaGD = [ pkgs.jdk ];
    jpeg = [ pkgs.libjpeg.dev ];
    jqr = [ pkgs.jq.dev ];
    KFKSDS = [ pkgs.gsl ];
    KSgeneral = with pkgs; [ pkg-config ];
    kza = [ pkgs.fftw.dev ];
    leidenAlg = [ pkgs.gmp.dev ];
    Libra = [ pkgs.gsl ];
    libstable4u = [ pkgs.gsl ];
    heck = [ pkgs.cargo ];
    LOMAR = [ pkgs.gmp.dev ];
    littler = [ pkgs.libdeflate ];
    lpsymphony = with pkgs; [ pkg-config gfortran gettext ];
    lwgeom = with pkgs; [ proj geos gdal ];
    rsbml = [ pkgs.pkg-config ];
    rvg = [ pkgs.libpng.dev ];
    MAGEE = [ pkgs.zlib.dev pkgs.bzip2.dev ];
    magick = [ pkgs.imagemagick.dev ];
    ModelMetrics = lib.optional stdenv.hostPlatform.isDarwin pkgs.llvmPackages.openmp;
    mvabund = [ pkgs.gsl ];
    mwaved = [ pkgs.fftw.dev ];
    mzR = with pkgs; [ zlib netcdf ];
    nanonext = with pkgs; [ mbedtls nng ];
    ncdf4 = [ pkgs.netcdf ];
    neojags = [ pkgs.jags ];
    nloptr = with pkgs; [ nlopt pkg-config ];
    n1qn1 = [ pkgs.gfortran ];
    odbc = [ pkgs.unixODBC ];
    opencv = [ pkgs.pkg-config ];
    pak = [ pkgs.curl.dev ];
    pander = with pkgs; [ pandoc which ];
    pbdMPI = [ pkgs.mpi ];
    pbdPROF = [ pkgs.mpi ];
    pbdZMQ = [ pkgs.pkg-config ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ pkgs.which ];
    pcaL1 = [ pkgs.pkg-config pkgs.clp ];
    pdftools = [ pkgs.poppler.dev ];
    PEPBVS = [ pkgs.gsl ];
    phytools = [ pkgs.which ];
    PKI = [ pkgs.openssl.dev ];
    png = [ pkgs.libpng.dev ];
    protolite = [ pkgs.protobuf ];
    R2SWF = with pkgs; [ zlib libpng freetype.dev ];
    RAppArmor = [ pkgs.libapparmor ];
    rapportools = [ pkgs.which ];
    rapport = [ pkgs.which ];
    rcdd = [ pkgs.gmp.dev ];
    RcppCNPy = [ pkgs.zlib.dev ];
    RcppGSL = [ pkgs.gsl ];
    RcppZiggurat = [ pkgs.gsl ];
    reprex = [ pkgs.which ];
    rgdal = with pkgs; [ proj.dev gdal ];
    Rhisat2 = [ pkgs.which pkgs.hostname ];
    gdalcubes = [ pkgs.pkg-config ];
    rgeos = [ pkgs.geos ];
    Rglpk = [ pkgs.glpk ];
    RGtk2 = [ pkgs.gtk2.dev ];
    rhdf5 = [ pkgs.zlib ];
    Rhdf5lib = with pkgs; [ zlib.dev ];
    Rhpc = with pkgs; [ zlib bzip2.dev icu xz.dev mpi pcre.dev ];
    Rhtslib = with pkgs; [ zlib.dev automake autoconf bzip2.dev xz.dev curl.dev ];
    rjags = [ pkgs.jags ];
    rJava = with pkgs; [ zlib bzip2.dev icu xz.dev pcre.dev jdk libzip libdeflate ];
    Rlibeemd = [ pkgs.gsl ];
    rmatio = [ pkgs.zlib.dev pkgs.pkg-config ];
    Rmpfr = with pkgs; [ gmp mpfr.dev ];
    Rmpi = [ pkgs.mpi ];
    RMySQL = with pkgs; [ zlib libmysqlclient openssl.dev ];
    RNetCDF = with pkgs; [ netcdf udunits ];
    RODBC = [ pkgs.libiodbc ];
    rpanel = [ pkgs.bwidget ];
    Rpoppler = [ pkgs.poppler ];
    RPostgres = with pkgs; [ postgresql ];
    RPostgreSQL = with pkgs; [ postgresql postgresql ];
    RProtoBuf = [ pkgs.protobuf ];
    RSclient = [ pkgs.openssl.dev ];
    Rserve = [ pkgs.openssl ];
    Rssa = [ pkgs.fftw.dev ];
    rsvg = [ pkgs.pkg-config ];
    runjags = [ pkgs.jags ];
    xslt = [ pkgs.pkg-config ];
    RVowpalWabbit = with pkgs; [ zlib.dev boost ];
    rzmq = with pkgs; [ zeromq pkg-config ];
    httpuv = [ pkgs.zlib.dev ];
    clustermq = [ pkgs.zeromq ];
    SAVE = with pkgs; [ zlib bzip2 icu xz pcre ];
    salso = [ pkgs.cargo ];
    ymd = [ pkgs.cargo ];
    arcpbf = [ pkgs.cargo ];
    sdcTable = with pkgs; [ gmp glpk ];
    seewave = with pkgs; [ fftw.dev libsndfile.dev ];
    seqinr = [ pkgs.zlib.dev ];
    smcryptoR = with pkgs; [ cargo rustc which ];
    webp = [ pkgs.pkg-config ];
    seqminer = with pkgs; [ zlib.dev bzip2 ];
    sf = with pkgs; [ gdal proj geos libtiff curl ];
    strawr = with pkgs; [ curl.dev ];
    string2path = [ pkgs.cargo ];
    terra = with pkgs; [ gdal proj geos ];
    tok = [ pkgs.cargo ];
    rshift = [ pkgs.cargo ];
    arcgisutils = with pkgs; [ cargo rustc ];
    arcgisgeocode = with pkgs; [ cargo rustc ];
    arcgisplaces = with pkgs; [ pkg-config openssl.dev cargo rustc ];
    apcf = with pkgs; [ geos ];
    SemiCompRisks = [ pkgs.gsl ];
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
    TDA = [ pkgs.gmp ];
    tesseract = with pkgs; [ tesseract leptonica ];
    tiff = [ pkgs.libtiff.dev ];
    tkrplot = with pkgs; [ xorg.libX11 tk.dev ];
    topicmodels = [ pkgs.gsl ];
    udunits2 = with pkgs; [ udunits expat ];
    units = [ pkgs.udunits ];
    unigd = [ pkgs.pkg-config ];
    vdiffr = [ pkgs.libpng.dev ];
    V8 = [ pkgs.nodejs.libv8 ];
    XBRL = with pkgs; [ zlib libxml2.dev ];
    XLConnect = [ pkgs.jdk ];
    xml2 = [ pkgs.libxml2.dev ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ pkgs.perl ];
    XML = with pkgs; [ libtool libxml2.dev xmlsec libxslt ];
    affyPLM = [ pkgs.zlib.dev ];
    BitSeq = [ pkgs.zlib.dev ];
    DiffBind = with pkgs; [ zlib.dev xz.dev bzip2.dev ];
    ShortRead = [ pkgs.zlib.dev ];
    oligo = [ pkgs.zlib.dev ];
    gmapR = [ pkgs.zlib.dev ];
    Rsubread = [ pkgs.zlib.dev ];
    XVector = [ pkgs.zlib.dev ];
    Rsamtools = with pkgs; [ zlib.dev curl.dev bzip2 xz ];
    rtracklayer = with pkgs; [ zlib.dev curl.dev ];
    affyio = [ pkgs.zlib.dev ];
    snpStats = [ pkgs.zlib.dev ];
    vcfppR = [ pkgs.curl.dev pkgs.bzip2 pkgs.zlib.dev pkgs.xz];
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
    RationalMatrix = [ pkgs.pkg-config pkgs.gmp.dev];
    RcppCWB = [ pkgs.pkg-config pkgs.pcre2 ];
    redux = [ pkgs.pkg-config ];
    rswipl = with pkgs; [ cmake pkg-config ];
    rrd = [ pkgs.pkg-config ];
    surveyvoi = [ pkgs.pkg-config ];
    Rbwa = [ pkgs.zlib.dev ];
    trackViewer = [ pkgs.zlib.dev ];
    themetagenomics = [ pkgs.zlib.dev ];
    Rsymphony = [ pkgs.pkg-config ];
    NanoMethViz = [ pkgs.zlib.dev ];
    RcppMeCab = [ pkgs.pkg-config ];
    HilbertVisGUI = with pkgs; [ pkg-config which ];
    textshaping = [ pkgs.pkg-config ];
    ragg = [ pkgs.pkg-config ];
    qqconf = [ pkgs.pkg-config ];
    qspray = [ pkgs.pkg-config ];
    ratioOfQsprays = [ pkgs.pkg-config ];
    symbolicQspray = [ pkgs.pkg-config ];
    sphereTessellation = [ pkgs.pkg-config ];
    vapour = [ pkgs.pkg-config ];
  };

  packagesWithBuildInputs = {
    # sort -t '=' -k 2
    asciicast = with pkgs; [ xz.dev bzip2.dev zlib.dev icu.dev libdeflate ];
    island = [ pkgs.gsl.dev ];
    svKomodo = [ pkgs.which ];
    ulid = [ pkgs.zlib.dev ];
    unrtf = with pkgs; [ xz.dev bzip2.dev zlib.dev icu.dev libdeflate ];
    nat = [ pkgs.which ];
    nat_templatebrains = [ pkgs.which ];
    pbdZMQ = [ pkgs.zeromq ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ pkgs.darwin.binutils ];
    bigmemory = lib.optionals stdenv.hostPlatform.isLinux [ pkgs.libuuid.dev ];
    bayesWatch = [ pkgs.boost.dev ];
    clustermq = [  pkgs.pkg-config ];
    coga = [ pkgs.gsl.dev ];
    mBvs = [ pkgs.gsl.dev ];
    rcontroll = [ pkgs.gsl.dev ];
    deepSNV = with pkgs; [ xz.dev bzip2.dev zlib.dev ];
    epialleleR = with pkgs; [ xz.dev bzip2.dev zlib.dev ];
    gdalraster = with pkgs; [ gdal proj.dev sqlite.dev ];
    mitoClone2 = with pkgs; [ xz.dev bzip2.dev zlib.dev ];
    gpg = [ pkgs.gpgme ];
    webp = [ pkgs.libwebp ];
    RMark = [ pkgs.which ];
    RPushbullet = [ pkgs.which ];
    stpphawkes = [ pkgs.gsl ];
    registr = with pkgs; [ icu.dev zlib.dev bzip2.dev xz.dev libdeflate ];
    RCurl = [ pkgs.curl.dev ];
    R2SWF = [ pkgs.pkg-config ];
    rDEA = [ pkgs.glpk ];
    rgl = with pkgs; [ libGLU libGL xorg.libX11.dev freetype.dev libpng.dev ];
    RGtk2 = [ pkgs.pkg-config ];
    RProtoBuf = [ pkgs.pkg-config ];
    Rpoppler = [ pkgs.pkg-config ];
    XML = [ pkgs.pkg-config ];
    apsimx = [ pkgs.which ];
    cairoDevice = [ pkgs.pkg-config ];
    chebpol = [ pkgs.pkg-config ];
    eds = [ pkgs.zlib.dev ];
    pgenlibr = [ pkgs.zlib.dev ];
    fftw = [ pkgs.pkg-config ];
    gdtools = [ pkgs.pkg-config ];
    archive = [ pkgs.libarchive];
    gdalcubes = with pkgs; [ proj.dev gdal sqlite.dev netcdf ];
    rsbml = [ pkgs.libsbml ];
    SuperGauss = [ pkgs.pkg-config pkgs.fftw.dev];
    specklestar = [ pkgs.fftw.dev ];
    cartogramR = [ pkgs.fftw.dev ];
    jqr = [ pkgs.jq.lib ];
    kza = [ pkgs.pkg-config ];
    igraph = with pkgs; [ gmp libxml2.dev glpk ];
    interpolation = [ pkgs.gmp ];
    image_textlinedetector = with pkgs; [ pkg-config opencv ];
    lwgeom = with pkgs; [ pkg-config proj.dev sqlite.dev ];
    magick = [ pkgs.pkg-config ];
    mwaved = [ pkgs.pkg-config ];
    odbc = [ pkgs.pkg-config ];
    openssl = [ pkgs.pkg-config ];
    pdftools = [ pkgs.pkg-config ];
    qckitfastq = [ pkgs.zlib.dev ];
    raer = with pkgs; [ zlib.dev xz.dev bzip2.dev ];
    RQuantLib = with pkgs; [ quantlib.dev boost.dev ];
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
    excursions = [ pkgs.gsl ];
    gpuMagic = [ pkgs.ocl-icd ];
    JMcmprsk = [ pkgs.gsl ];
    KSgeneral = [ pkgs.fftw.dev ];
    mashr = [ pkgs.gsl ];
    hadron = [ pkgs.gsl ];
    AMOUNTAIN = [ pkgs.gsl ];
    Rsymphony = with pkgs; [ symphony doxygen graphviz subversion cgl clp];
    tcltk2 = with pkgs; [ tcl tk ];
    rswipl = with pkgs; [ ncurses.dev libxcrypt zlib.dev ];
    GrafGen = [ pkgs.zlib ];
    tikzDevice = with pkgs; [ which texliveMedium ];
    gridGraphics = [ pkgs.which ];
    adimpro = with pkgs; [ which xorg.xdpyinfo ];
    tfevents = [ pkgs.protobuf ];
    rsvg = [ pkgs.librsvg.dev ];
    ssh = with pkgs; [ libssh ];
    s2 = [ pkgs.openssl.dev ];
    ArrayExpressHTS = with pkgs; [ zlib.dev curl.dev which ];
    bbl = with pkgs; [ gsl ];
    diffHic = with pkgs; [ xz.dev bzip2.dev ];
    writexl = with pkgs; [ zlib.dev ];
    xslt = with pkgs; [ libxslt libxml2 ];
    qpdf = with pkgs; [ libjpeg.dev zlib.dev ];
    vcfR = with pkgs; [ zlib.dev ];
    bio3d = with pkgs; [ zlib.dev ];
    arrangements = with pkgs; [ gmp.dev ];
    gfilogisreg = [ pkgs.gmp.dev ];
    spp = with pkgs; [ zlib.dev ];
    bamsignals = with pkgs; [ zlib.dev xz.dev bzip2 ];
    Rbowtie = with pkgs; [ zlib.dev ];
    gaston = with pkgs; [ zlib.dev ];
    csaw = with pkgs; [ zlib.dev xz.dev bzip2.dev curl ];
    DirichletMultinomial = with pkgs; [ gsl ];
    DiffBind = with pkgs; [ zlib.dev ];
    CNEr = with pkgs; [ zlib ];
    GMMAT = with pkgs; [ zlib.dev bzip2.dev ];
    rmumps = with pkgs; [ zlib.dev ];
    HiCDCPlus = [ pkgs.zlib.dev ];
    PopGenome = [ pkgs.zlib.dev ];
    QuasR = with pkgs; [ zlib.dev xz.dev bzip2.dev ];
    Rarr = [ pkgs.zlib.dev ];
    Rbowtie2 = [ pkgs.zlib.dev ];
    Rfastp = with pkgs; [ xz.dev bzip2.dev zlib.dev ];
    maftools = with pkgs; [ zlib.dev bzip2 xz.dev ];
    Rmmquant = [ pkgs.zlib.dev ];
    SICtools = with pkgs; [ zlib.dev ncurses.dev ];
    Signac = [ pkgs.zlib.dev ];
    TransView = with pkgs; [ xz.dev bzip2.dev zlib.dev ];
    bigsnpr = [ pkgs.zlib.dev ];
    zlib = [ pkgs.zlib.dev ];
    divest = [ pkgs.zlib.dev ];
    hipread = [ pkgs.zlib.dev ];
    jack = with pkgs; [ gmp.dev mpfr.dev ];
    jackalope = with pkgs; [ zlib.dev xz.dev bzip2.dev ];
    largeList = [ pkgs.zlib.dev ];
    mappoly = [ pkgs.zlib.dev ];
    VariantAnnotation = with pkgs; [ zlib.dev curl.dev bzip2.dev xz.dev ];
    matchingMarkets = [ pkgs.zlib.dev ];
    methylKit = with pkgs; [ zlib.dev bzip2.dev xz.dev ];
    ndjson = [ pkgs.zlib.dev ];
    podkat = with pkgs; [ zlib.dev xz.dev bzip2.dev ];
    qrqc = [ pkgs.zlib.dev ];
    rJPSGCS = [ pkgs.zlib.dev ];
    rhdf5filters = with pkgs; [ zlib.dev bzip2.dev ];
    symengine = with pkgs; [ mpfr symengine flint ];
    rtk = [ pkgs.zlib.dev ];
    scPipe = with pkgs; [ bzip2.dev xz.dev zlib.dev ];
    seqTools = [ pkgs.zlib.dev ];
    seqbias = with pkgs; [ zlib.dev bzip2.dev xz.dev ];
    sparkwarc = [ pkgs.zlib.dev ];
    RoBMA = [ pkgs.jags ];
    RoBSA = [ pkgs.jags ];
    pexm = [ pkgs.jags ];
    rGEDI = with pkgs; [ libgeotiff.dev libaec zlib.dev hdf5.dev ];
    rawrr = [ pkgs.mono ];
    HDF5Array = [ pkgs.zlib.dev ];
    FLAMES = with pkgs; [ zlib.dev bzip2.dev xz.dev ];
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
    screenCounter = [ pkgs.zlib.dev ];
    SPARSEMODr = [ pkgs.gsl ];
    RKHSMetaMod = [ pkgs.gsl ];
    LCMCR = [ pkgs.gsl ];
    BNSP = [ pkgs.gsl ];
    scModels = [ pkgs.mpfr.dev ];
    multibridge = with pkgs; [ pkg-config mpfr.dev ];
    RcppCWB = with pkgs; [ pcre.dev glib.dev ];
    redux = [ pkgs.hiredis ];
    RmecabKo = [ pkgs.mecab ];
    markets = [ pkgs.gsl ];
    rlas = [ pkgs.boost ];
    PoissonBinomial = [ pkgs.fftw.dev ];
    poisbinom = [ pkgs.fftw.dev ];
    PoissonMultinomial = [ pkgs.fftw.dev ];
    psbcGroup = [ pkgs.gsl.dev ];
    rrd = [ pkgs.rrdtool ];
    flowWorkspace = [ pkgs.zlib.dev ];
    RITCH = [ pkgs.zlib.dev ];
    RcppMeCab = [ pkgs.mecab ];
    PING = [ pkgs.gsl ];
    PROJ = [ pkgs.proj.dev ];
    RcppAlgos = [ pkgs.gmp.dev ];
    RcppBigIntAlgos = [ pkgs.gmp.dev ];
    spaMM = [ pkgs.gsl ];
    shrinkTVP = [ pkgs.gsl ];
    sbrl = with pkgs; [ gsl gmp.dev ];
    surveyvoi = with pkgs; [ gmp.dev mpfr.dev ];
    unigd = with pkgs; [ cairo.dev libpng.dev ];
    HilbertVisGUI = [ pkgs.gtkmm2.dev ];
    textshaping = with pkgs; [ harfbuzz.dev freetype.dev fribidi libpng ];
    DropletUtils = [ pkgs.zlib.dev ];
    RMariaDB = [ pkgs.libmysqlclient.dev ];
    ijtiff = [ pkgs.libtiff ];
    ragg = with pkgs; [ freetype.dev libpng.dev libtiff.dev zlib.dev libjpeg.dev bzip2.dev ] ++ lib.optional stdenv.hostPlatform.isDarwin lerc.dev;
    qqconf = [ pkgs.fftw.dev ];
    spFW = [ pkgs.fftw.dev ];
    qspray = with pkgs; [ gmp.dev mpfr.dev ];
    ratioOfQsprays = with pkgs; [ gmp.dev mpfr.dev ];
    symbolicQspray = with pkgs; [ gmp.dev mpfr.dev ];
    sphereTessellation = with pkgs; [ gmp.dev mpfr.dev ];
    vapour = with pkgs; [ proj.dev gdal ];
    MedianaDesigner = [ pkgs.zlib.dev ];
    ChemmineOB = [ pkgs.eigen ];
    DGP4LCF = [ pkgs.lapack pkgs.blas ];
  };

  packagesRequiringX = [
    "analogueExtra"
    "AnalyzeFMRI"
    "AnnotLists"
    "asbio"
    "BCA"
    "biplotbootGUI"
    "cairoDevice"
    "cncaGUI"
    "CommunityCorrelogram"
    "dave"
    "DeducerPlugInExample"
    "DeducerPlugInScaling"
    "DeducerSpatial"
    "DeducerSurvival"
    "DeducerText"
    "Demerelate"
    "diveR"
    "dpa"
    "dynamicGraph"
    "EasyqpcR"
    "exactLoglinTest"
    "fisheyeR"
    "forams"
    "forensim"
    "GGEBiplotGUI"
    "gsubfn"
    "gWidgets2RGtk2"
    "gWidgets2tcltk"
    "HiveR"
    "ic50"
    "iDynoR"
    "iplots"
    "likeLTD"
    "loon"
    "loon_ggplot"
    "loon_shiny"
    "loon_tourr"
    "Meth27QC"
    "mixsep"
    "multibiplotGUI"
    "OligoSpecificitySystem"
    "optbdmaeAT"
    "optrcdmaeAT"
    "paleoMAS"
    "RandomFields"
    "rfviz"
    "RclusTool"
    "RcmdrPlugin_coin"
    "RcmdrPlugin_FuzzyClust"
    "RcmdrPlugin_IPSUR"
    "RcmdrPlugin_lfstat"
    "RcmdrPlugin_PcaRobust"
    "RcmdrPlugin_plotByGroup"
    "RcmdrPlugin_pointG"
    "RcmdrPlugin_sampling"
    "RcmdrPlugin_SCDA"
    "RcmdrPlugin_SLC"
    "RcmdrPlugin_steepness"
    "rich"
    "RSurvey"
    "simba"
    "SimpleTable"
    "SOLOMON"
    "soptdmaeA"
    "strvalidator"
    "stylo"
    "SyNet"
    "switchboard"
    "tkImgR"
    "TTAinterfaceTrendAnalysis"
    "twiddler"
    "uHMM"
    "VecStatGraphs3D"
  ];

  packagesRequiringHome = [
    "aroma_affymetrix"
    "aroma_cn"
    "aroma_core"
    "avotrex"
    "beer"
    "ceramic"
    "connections"
    "covidmx"
    "csodata"
    "DiceView"
    "facmodTS"
    "gasanalyzer"
    "margaret"
    "MSnID"
    "OmnipathR"
    "precommit"
    "protGear"
    "PCRA"
    "PSCBS"
    "iemisc"
    "repmis"
    "R_cache"
    "R_filesets"
    "RKorAPClient"
    "R_rsp"
    "salso"
    "scholar"
    "SpatialDecon"
    "stepR"
    "styler"
    "teal_code"
    "TreeTools"
    "TreeSearch"
    "ACNE"
    "APAlyzer"
    "EstMix"
    "Patterns"
    "PECA"
    "Quartet"
    "ShinyQuickStarter"
    "TIN"
    "cfdnakit"
    "CaDrA"
    "GNOSIS"
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
    "matlab2r"
    "GNOSIS"
  ];

  packagesToSkipCheck = [
    "MsDataHub" # tries to connect to ExperimentHub
    "Rmpi"     # tries to run MPI processes
    "ReactomeContentService4R" # tries to connect to Reactome
    "PhIPData" # tries to download something from a DB
    "RBioFormats" # tries to download jar during load test
    "pbdMPI"   # tries to run MPI processes
    "CTdata" # tries to connect to ExperimentHub
    "rfaRm" # tries to connect to Ebi
    "data_table" # fails to rename shared library before check
    "coMethDMR" # tries to connect to ExperimentHub
    "multiMiR" # tries to connect to DB
    "snapcount" # tries to connect to snaptron.cs.jhu.edu
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
    "hpar"
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
    "CTexploreR"
    "depmap"
    "emtdata"
    "metaboliteIDmapping"
    "msigdb"
    "muscData"
    "org_Mxanthus_db"
    "scpdata"
    "signatureSearch"
    "nullrangesData"
  ];

  otherOverrides = old: new: {
    # it can happen that the major version of arrow-cpp is ahead of the
    # rPackages.arrow that would be built from CRAN sources; therefore, to avoid
    # build failures and manual updates of the hash, we use the R source at
    # the GitHub release state of libarrow (arrow-cpp) in Nixpkgs. This may
    # not exactly represent the CRAN sources, but because patching of the
    # CRAN R package is mostly done to meet special CRAN build requirements,
    # this is a straightforward approach. Example where patching was necessary
    # -> arrow 14.0.0.2 on CRAN; was lagging behind libarrow release:
    #   https://github.com/apache/arrow/issues/39698 )

    vegan3d = old.vegan3d.overrideAttrs (attrs: {
      RGL_USE_NULL = "true";
    });

    arrow = old.arrow.overrideAttrs (attrs: {
      src = pkgs.arrow-cpp.src;
      name = "r-arrow-${pkgs.arrow-cpp.version}";
      prePatch = "cd r";
      postPatch = ''
        patchShebangs configure
      '';
      buildInputs = attrs.buildInputs ++ [
        pkgs.arrow-cpp
      ];
    });

    gifski = old.gifski.overrideAttrs (attrs: {
      cargoDeps = pkgs.rustPlatform.fetchCargoTarball {
        src = attrs.src;
        sourceRoot = "gifski/src/myrustlib";
        hash = "sha256-e6nuiQU22GiO2I+bu0muyICGrdkCLSZUDHDz2mM2hz0=";
      };

      cargoRoot = "src/myrustlib";

      nativeBuildInputs = attrs.nativeBuildInputs ++ [
        pkgs.rustPlatform.cargoSetupHook
        pkgs.cargo
        pkgs.rustc
      ];
    });

    timeless = old.timeless.overrideAttrs (attrs: {
      cargoDeps = pkgs.rustPlatform.fetchCargoTarball {
        src = attrs.src;
        sourceRoot = "timeless/src/rust";
        hash = "sha256-n0/52CV3NzWe7T3N6VoaURMxWrnqeYaUMPKkUy+LRQs=";
      };

      cargoRoot = "src/rust";

      nativeBuildInputs = attrs.nativeBuildInputs ++ [
        pkgs.rustPlatform.cargoSetupHook
        pkgs.cargo
      ];
    });

    stringi = old.stringi.overrideAttrs (attrs: {
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

    xml2 = old.xml2.overrideAttrs (attrs: {
      preConfigure = ''
        export LIBXML_INCDIR=${pkgs.libxml2.dev}/include/libxml2
        patchShebangs configure
        '';
    });

    rzmq = old.rzmq.overrideAttrs (attrs: {
      preConfigure = "patchShebangs configure";
    });

    clustermq = old.clustermq.overrideAttrs (attrs: {
      preConfigure = "patchShebangs configure";
    });

    Cairo = old.Cairo.overrideAttrs (attrs: {
      NIX_LDFLAGS = "-lfontconfig";
    });

    curl = old.curl.overrideAttrs (attrs: {
      preConfigure = "patchShebangs configure";
    });

    Cyclops = old.Cyclops.overrideAttrs (attrs: {
      preConfigure = "patchShebangs configure";
    });

    RcppParallel = old.RcppParallel.overrideAttrs (attrs: {
      preConfigure = "patchShebangs configure";
    });

    Colossus = old.Colossus.overrideAttrs (_: {
      postPatch = "patchShebangs configure";
    });

   gmailr = old.gmailr.overrideAttrs (attrs: {
      postPatch = "patchShebangs configure";
    });

    heck = old.heck.overrideAttrs (attrs: {
      postPatch = "patchShebangs configure";
    });

   surtvep = old.surtvep.overrideAttrs (attrs: {
      postPatch = "patchShebangs configure";
    });

    purrr = old.purrr.overrideAttrs (attrs: {
      patchPhase = "patchShebangs configure";
    });

    luajr = old.luajr.overrideAttrs (attrs: {
      hardeningDisable = [ "format" ];
      postPatch = "patchShebangs configure";
    });

    RcppArmadillo = old.RcppArmadillo.overrideAttrs (attrs: {
      patchPhase = "patchShebangs configure";
    });

    RcppGetconf = old.RcppGetconf.overrideAttrs (attrs: {
      postPatch = "patchShebangs configure";
    });

    SpliceWiz = old.SpliceWiz.overrideAttrs (attrs: {
      postPatch = "patchShebangs configure";
    });

    zoomerjoin = old.zoomerjoin.overrideAttrs (attrs: {
      nativeBuildInputs = [ pkgs.cargo ] ++ attrs.nativeBuildInputs;
      postPatch = "patchShebangs configure";
    });

    b64 = old.b64.overrideAttrs (attrs: {
      nativeBuildInputs = [ pkgs.cargo ] ++ attrs.nativeBuildInputs;
      postPatch = "patchShebangs configure";
    });

   ocf = old.ocf.overrideAttrs (attrs: {
      postPatch = "patchShebangs configure";
    });

    data_table = old.data_table.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        NIX_CFLAGS_COMPILE = attrs.env.NIX_CFLAGS_COMPILE + " -fopenmp";
      };
      patchPhase = "patchShebangs configure";
    });

    cisPath = old.cisPath.overrideAttrs (attrs: {
      hardeningDisable = [ "format" ];
    });

    HilbertVis = old.HilbertVis.overrideAttrs (attrs: {
      hardeningDisable = [ "format" ];
    });

    HilbertVisGUI = old.HilbertVisGUI.overrideAttrs (attrs: {
      hardeningDisable = [ "format" ];
    });

    MANOR = old.MANOR.overrideAttrs (attrs: {
      hardeningDisable = [ "format" ];
    });

    rGADEM = old.rGADEM.overrideAttrs (attrs: {
      hardeningDisable = [ "format" ];
    });

   rsgeo = old.rsgeo.overrideAttrs (attrs: {
      nativeBuildInputs = [ pkgs.cargo ] ++ attrs.nativeBuildInputs;
      postPatch = "patchShebangs configure";
    });

   instantiate = old.instantiate.overrideAttrs (attrs: {
      postPatch = "patchShebangs configure";
    });

    exifr = old.exifr.overrideAttrs (attrs: {
      postPatch = ''
        for f in .onLoad .onAttach ; do
          substituteInPlace R/load_hook.R \
            --replace-fail \
            "$f <- function(libname, pkgname) {" \
            "$f <- function(libname, pkgname) {
                 options(
                     exifr.perlpath = \"${lib.getBin pkgs.perl}/bin/perl\",
                     exifr.exiftoolcommand = \"${lib.getBin pkgs.exiftool}/bin/exiftool\"
                 )"
        done
      '';
    });

    NGCHM = old.NGCHM.overrideAttrs (attrs: {
      postPatch = ''
          substituteInPlace "inst/base.config/conf.d/01-server-protocol-scl.R" \
            --replace-fail \
            "/bin/hostname" "${lib.getBin pkgs.hostname}/bin/hostname"
      '';
    });

    ModelMetrics = old.ModelMetrics.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        NIX_CFLAGS_COMPILE = attrs.env.NIX_CFLAGS_COMPILE + lib.optionalString stdenv.hostPlatform.isDarwin " -fopenmp";
      };
    });

    rawrr = old.rawrr.overrideAttrs (attrs: {
      postPatch = ''
        substituteInPlace "R/zzz.R" "R/dotNetAssembly.R" --replace-warn \
          "Sys.which('mono')" "'${lib.getBin pkgs.mono}/bin/mono'"

        substituteInPlace "R/dotNetAssembly.R" --replace-warn \
          "Sys.which(\"xbuild\")" "\"${lib.getBin pkgs.mono}/bin/xbuild\""

        substituteInPlace "R/dotNetAssembly.R" --replace-warn \
          "cmd <- ifelse(Sys.which(\"msbuild\") != \"\", \"msbuild\", \"xbuild\")" \
          "cmd <- \"${lib.getBin pkgs.mono}/bin/xbuild\""

        substituteInPlace "R/rawrr.R" --replace-warn \
          "Sys.which(\"mono\")" "\"${lib.getBin pkgs.mono}/bin/mono\""
      '';
    });

    rpf = old.rpf.overrideAttrs (attrs: {
      patchPhase = "patchShebangs configure";
    });

    rJava = old.rJava.overrideAttrs (attrs: {
      preConfigure = ''
        export JAVA_CPPFLAGS=-I${pkgs.jdk}/include/
        export JAVA_HOME=${pkgs.jdk}
      '';
    });

    JavaGD = old.JavaGD.overrideAttrs (attrs: {
      preConfigure = ''
        export JAVA_CPPFLAGS=-I${pkgs.jdk}/include/
        export JAVA_HOME=${pkgs.jdk}
      '';
    });

    jqr = old.jqr.overrideAttrs (attrs: {
      preConfigure = ''
        patchShebangs configure
        '';
    });

    pathfindR = old.pathfindR.overrideAttrs (attrs: {
      postPatch = ''
        substituteInPlace "R/zzz.R" \
          --replace-fail "    check_java_version()" "    Sys.setenv(JAVA_HOME = \"${lib.getBin pkgs.jre_minimal}\"); check_java_version()"
        substituteInPlace "R/active_snw_search.R" \
          --replace-fail "system(paste0(\"java" "system(paste0(\"${lib.getBin pkgs.jre_minimal}/bin/java"
      '';
    });

    pbdZMQ = old.pbdZMQ.overrideAttrs (attrs: {
      postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
        for file in R/*.{r,r.in}; do
            sed -i 's#system("which \(\w\+\)"[^)]*)#"${pkgs.cctools}/bin/\1"#g' $file
        done
      '';
    });

    quarto = old.quarto.overrideAttrs (attrs: {
      propagatedBuildInputs = attrs.propagatedBuildInputs ++ [ pkgs.quarto ];
      postPatch = ''
        substituteInPlace "R/quarto.R" \
          --replace-fail "Sys.getenv(\"QUARTO_PATH\", unset = NA_character_)" "Sys.getenv(\"QUARTO_PATH\", unset = '${lib.getBin pkgs.quarto}/bin/quarto')"
      '';
    });

    Rhisat2 = old.Rhisat2.overrideAttrs (attrs: {
      enableParallelBuilding = false;
    });

    s2 = old.s2.overrideAttrs (attrs: {
      PKGCONFIG_CFLAGS = "-I${pkgs.openssl.dev}/include";
      PKGCONFIG_LIBS = "-Wl,-rpath,${lib.getLib pkgs.openssl}/lib -L${lib.getLib pkgs.openssl}/lib -lssl -lcrypto";
    });

    Rmpi = old.Rmpi.overrideAttrs (attrs: {
      configureFlags = [
        "--with-Rmpi-type=OPENMPI"
      ];
    });

    Rmpfr = old.Rmpfr.overrideAttrs (attrs: {
      configureFlags = [
        "--with-mpfr-include=${pkgs.mpfr.dev}/include"
      ];
    });

    covidsymptom = old.covidsymptom.overrideAttrs (attrs: {
      preConfigure = "rm R/covidsymptomdata.R";
    });

    cubature = old.cubature.overrideAttrs (attrs: {
      enableParallelBuilding = false;
    });

    RVowpalWabbit = old.RVowpalWabbit.overrideAttrs (attrs: {
      configureFlags = [
        "--with-boost=${pkgs.boost.dev}" "--with-boost-libdir=${pkgs.boost.out}/lib"
      ];
    });

    RAppArmor = old.RAppArmor.overrideAttrs (attrs: {
      patches = [ ./patches/RAppArmor.patch ];
      LIBAPPARMOR_HOME = pkgs.libapparmor;
    });

    RMySQL = old.RMySQL.overrideAttrs (attrs: {
      MYSQL_DIR = "${pkgs.libmysqlclient}";
      PKGCONFIG_CFLAGS = "-I${pkgs.libmysqlclient.dev}/include/mysql";
      NIX_CFLAGS_LINK = "-L${pkgs.libmysqlclient}/lib/mysql -lmysqlclient";
      preConfigure = ''
        patchShebangs configure
      '';
    });

    devEMF = old.devEMF.overrideAttrs (attrs: {
      NIX_CFLAGS_LINK = "-L${pkgs.xorg.libXft.out}/lib -lXft";
      NIX_LDFLAGS = "-lX11";
    });

    hdf5r = old.hdf5r.overrideAttrs (attrs: {
      buildInputs = attrs.buildInputs ++ [ new.Rhdf5lib.hdf5 ];
    });

    slfm = old.slfm.overrideAttrs (attrs: {
      PKG_LIBS = "-L${pkgs.blas}/lib -lblas -L${pkgs.lapack}/lib -llapack";
    });

    SamplerCompare = old.SamplerCompare.overrideAttrs (attrs: {
      PKG_LIBS = "-L${pkgs.blas}/lib -lblas -L${pkgs.lapack}/lib -llapack";
    });

    FLAMES = old.FLAMES.overrideAttrs (attrs: {
      patches = [ ./patches/FLAMES.patch ];
    });

    openssl = old.openssl.overrideAttrs (attrs: {
      preConfigure = ''
        patchShebangs configure
      '';
      PKGCONFIG_CFLAGS = "-I${pkgs.openssl.dev}/include";
      PKGCONFIG_LIBS = "-Wl,-rpath,${lib.getLib pkgs.openssl}/lib -L${lib.getLib pkgs.openssl}/lib -lssl -lcrypto";
    });

    websocket = old.websocket.overrideAttrs (attrs: {
      PKGCONFIG_CFLAGS = "-I${pkgs.openssl.dev}/include";
      PKGCONFIG_LIBS = "-Wl,-rpath,${lib.getLib pkgs.openssl}/lib -L${lib.getLib pkgs.openssl}/lib -lssl -lcrypto";
    });

    Rserve = old.Rserve.overrideAttrs (attrs: {
      patches = [ ./patches/Rserve.patch ];
      configureFlags = [
        "--with-server" "--with-client"
      ];
    });

    universalmotif = old.universalmotif.overrideAttrs (attrs: {
      patches = [ ./patches/universalmotif.patch];
    });

    V8 = old.V8.overrideAttrs (attrs: {
      postPatch = ''
        substituteInPlace configure \
          --replace-fail " -lv8_libplatform" ""
        # Bypass the test checking if pointer compression is needed
        substituteInPlace configure \
          --replace-fail "./pctest1" "true"
      '';

      preConfigure = ''
        export INCLUDE_DIR=${pkgs.nodejs.libv8}/include
        export LIB_DIR=${pkgs.nodejs.libv8}/lib
        patchShebangs configure
      '';

      R_MAKEVARS_SITE = lib.optionalString (pkgs.stdenv.system == "aarch64-linux")
        (pkgs.writeText "Makevars" ''
          CXX14PICFLAGS = -fPIC
        '');
    });

    acs = old.acs.overrideAttrs (attrs: {
      preConfigure = ''
        patchShebangs configure
        '';
    });

    gdtools = old.gdtools.overrideAttrs (attrs: {
      preConfigure = ''
        patchShebangs configure
        '';
      NIX_LDFLAGS = "-lfontconfig -lfreetype";
    });

    magick = old.magick.overrideAttrs (attrs: {
      preConfigure = ''
        patchShebangs configure
        '';
    });

    libgeos = old.libgeos.overrideAttrs (attrs: {
      preConfigure = ''
        patchShebangs configure
        '';
    });

    protolite = old.protolite.overrideAttrs (attrs: {
      preConfigure = ''
        patchShebangs configure
        '';
    });

    rgoslin = old.rgoslin.overrideAttrs (attrs: {
      enableParallelBuilding = false;
    });

    rpanel = old.rpanel.overrideAttrs (attrs: {
      preConfigure = ''
        export TCLLIBPATH="${pkgs.bwidget}/lib/bwidget${pkgs.bwidget.version}"
      '';
      TCLLIBPATH = "${pkgs.bwidget}/lib/bwidget${pkgs.bwidget.version}";
    });

    networkscaleup = old.networkscaleup.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        # needed to avoid "log limit exceeded" on Hydra
        NIX_CFLAGS_COMPILE = attrs.env.NIX_CFLAGS_COMPILE + " -Wno-ignored-attributes";
      };

      # consumes a lot of resources in parallel
      enableParallelBuilding = false;
    });

    RPostgres = old.RPostgres.overrideAttrs (attrs: {
      preConfigure = ''
        export INCLUDE_DIR=${pkgs.postgresql}/include
        export LIB_DIR=${pkgs.postgresql.lib}/lib
        patchShebangs configure
        '';
    });

    OpenMx = old.OpenMx.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        # needed to avoid "log limit exceeded" on Hydra
        NIX_CFLAGS_COMPILE = attrs.env.NIX_CFLAGS_COMPILE + " -Wno-ignored-attributes";
      };
      preConfigure = ''
        patchShebangs configure
        '';
    });

    odbc = old.odbc.overrideAttrs (attrs: {
      preConfigure = ''
        patchShebangs configure
        '';
    });

    x13binary = old.x13binary.overrideAttrs (attrs: {
      preConfigure = ''
        patchShebangs configure
        '';
    });

    FlexReg = old.FlexReg.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        # needed to avoid "log limit exceeded" on Hydra
        NIX_CFLAGS_COMPILE = attrs.env.NIX_CFLAGS_COMPILE + " -Wno-ignored-attributes";
      };

      # consumes a lot of resources in parallel
      enableParallelBuilding = false;
    });

    geojsonio = old.geojsonio.overrideAttrs (attrs: {
      buildInputs = [ cacert ] ++ attrs.buildInputs;
    });


    immunotation = let
      MHC41alleleList = fetchurl {
        url = "https://services.healthtech.dtu.dk/services/NetMHCpan-4.1/allele.list";
        hash = "sha256-CRZ+0uHzcq5zK5eONucAChXIXO8tnq5sSEAS80Z7jhg=";
      };

      MHCII40alleleList = fetchurl {
        url = "https://services.healthtech.dtu.dk/services/NetMHCIIpan-4.0/alleles_name.list";
        hash = "sha256-K4Ic2NUs3P4IkvOODwZ0c4Yh8caex5Ih0uO5jXRHp40=";
      };

      # List of valid countries, regions and ethnic groups
      # The original page is changing a bit every day, but the relevant
      # content does not. Use archive.org to get a stable snapshot.
      # It can be updated from time to time, or when the package becomes
      # deficient. This may be difficult to know.
      # Update the snapshot date, and add id_ after it, as described here:
      # https://web.archive.org/web/20130806040521/http://faq.web.archive.org/page-without-wayback-code/
      validGeographics = fetchurl {
        url = "https://web.archive.org/web/20240418194005id_/http://www.allelefrequencies.net/hla6006a.asp";
        hash = "sha256-m7Wkmh/cPxeqn94LwoznIh+fcFXskmSGErUYj6kTqak=";
      };
    in old.immunotation.overrideAttrs (attrs: {
      patches = [ ./patches/immunotation.patch ];
      postPatch = ''
        substituteInPlace "R/external_resources_input.R" --replace-fail \
          "nix-NetMHCpan-4.1-allele-list" ${MHC41alleleList}

        substituteInPlace "R/external_resources_input.R" --replace-fail \
          "nix-NETMHCIIpan-4.0-alleles-name-list" ${MHCII40alleleList}

        substituteInPlace "R/AFND_interface.R" --replace-fail \
          "nix-valid-geographics" ${validGeographics}
      '';
    });

    nearfar = let
      angrist = fetchurl {
        url = "https://raw.githubusercontent.com/joerigdon/nearfar/master/angrist.csv";
        hash = "sha256-lb+HMHnRGonc26merFGB0B7Vk1Lk+sIJlay+JtQC8m4=";
      };
    in old.nearfar.overrideAttrs (attrs: {
      postPatch = ''
        substituteInPlace "R/nearfar.R" --replace-fail \
         'url("https://raw.githubusercontent.com/joerigdon/nearfar/master/angrist.csv")'  '"${angrist}"'
      '';
    });

    rstan = old.rstan.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        NIX_CFLAGS_COMPILE = attrs.env.NIX_CFLAGS_COMPILE + " -DBOOST_PHOENIX_NO_VARIADIC_EXPRESSION";
      };
    });

    mongolite = old.mongolite.overrideAttrs (attrs: {
      preConfigure = ''
        patchShebangs configure
        '';
      PKGCONFIG_CFLAGS = "-I${pkgs.openssl.dev}/include -I${pkgs.cyrus_sasl.dev}/include -I${pkgs.zlib.dev}/include";
      PKGCONFIG_LIBS = "-Wl,-rpath,${lib.getLib pkgs.openssl}/lib -L${lib.getLib pkgs.openssl}/lib -L${pkgs.cyrus_sasl.out}/lib -L${pkgs.zlib.out}/lib -lssl -lcrypto -lsasl2 -lz";
    });

    ChemmineOB = let
      # R package doesn't compile with the latest (unstable) version.
      # Override from nixpkgs-23.11
      openbabel3 = pkgs.openbabel.overrideAttrs (attrs: {
        version = "3.1.1";
        src = pkgs.fetchFromGitHub {
          owner = "openbabel";
          repo = "openbabel";
          rev = "openbabel-${lib.replaceStrings ["."] ["-"] attrs.version}";
          sha256 = "sha256-wQpgdfCyBAoh4pmj9j7wPTlMtraJ62w/EShxi/olVMY=";
        };
      });
    in
    old.ChemmineOB.overrideAttrs (attrs: {
      # pkg-config knows openbabel-3 without the .0
      # Eigen3 is also looked for in the wrong location
      postPatch = ''
        substituteInPlace configure \
          --replace-fail openbabel-3.0 openbabel-3
        substituteInPlace src/Makevars.in \
          --replace-fail "-I/usr/include/eigen3" "-I${pkgs.eigen}/include/eigen3"
      '';
      buildInputs = attrs.buildInputs ++ [openbabel3];
    });

    ps = old.ps.overrideAttrs (attrs: {
      preConfigure = "patchShebangs configure";
    });

    rlang = old.rlang.overrideAttrs (attrs: {
      preConfigure = "patchShebangs configure";
    });

    systemfonts = old.systemfonts.overrideAttrs (attrs: {
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

    lpsymphony = old.lpsymphony.overrideAttrs (attrs: {
      preConfigure = ''
        patchShebangs configure
      '';
    });

    sodium = old.sodium.overrideAttrs (attrs: with pkgs; {
      preConfigure = ''
        patchShebangs configure
      '';
      nativeBuildInputs = [ pkg-config ] ++ attrs.nativeBuildInputs;
      buildInputs = [ libsodium.dev ] ++ attrs.buildInputs;
    });

    keyring = old.keyring.overrideAttrs (attrs: {
      preConfigure = ''
        patchShebangs configure
      '';
    });

    Rhtslib = old.Rhtslib.overrideAttrs (attrs: {
      preConfigure = ''
        substituteInPlace R/zzz.R --replace "-lcurl" "-L${pkgs.curl.out}/lib -lcurl"
      '';
    });

    h2o = old.h2o.overrideAttrs (attrs: {
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

    SICtools = old.SICtools.overrideAttrs (attrs: {
      postPatch = ''
        substituteInPlace src/Makefile --replace-fail "-lcurses" "-lncurses"
      '';
      hardeningDisable = [ "format" ];
    });

    Rbwa = old.Rbwa.overrideAttrs (attrs: {
      # Parallel build cleans up *.o before they can be packed in a library
      postPatch = ''
        substituteInPlace src/Makefile --replace-fail \
          "all:\$(PROG) ../inst/bwa clean" \
          "all:\$(PROG) ../inst/bwa" \
      '';
    });

    ROracle = old.ROracle.overrideAttrs (attrs: {
      configureFlags = [
        "--with-oci-lib=${pkgs.oracle-instantclient.lib}/lib"
        "--with-oci-inc=${pkgs.oracle-instantclient.dev}/include"
      ];
    });

    xslt = old.xslt.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        NIX_CFLAGS_COMPILE = attrs.env.NIX_CFLAGS_COMPILE + " -fpermissive";
      };
    });

    sparklyr = old.sparklyr.overrideAttrs (attrs: {
      # Pyspark's spark is full featured and better maintained than pkgs.spark
      preConfigure = ''
        substituteInPlace R/zzz.R \
          --replace ".onLoad <- function(...) {" \
            ".onLoad <- function(...) {
          Sys.setenv(\"SPARK_HOME\" = Sys.getenv(\"SPARK_HOME\", unset = \"${pkgs.python3Packages.pyspark}/${pkgs.python3Packages.python.sitePackages}/pyspark\"))
          Sys.setenv(\"JAVA_HOME\" = Sys.getenv(\"JAVA_HOME\", unset = \"${pkgs.jdk}\"))"
      '';
    });

    proj4 = old.proj4.overrideAttrs (attrs: {
      preConfigure = ''
        substituteInPlace configure \
          --replace "-lsqlite3" "-L${lib.makeLibraryPath [ pkgs.sqlite ]} -lsqlite3"
      '';
    });

    rrd = old.rrd.overrideAttrs (attrs: {
      preConfigure = ''
        patchShebangs configure
      '';
    });

    ChIPXpress = old.ChIPXpress.override { hydraPlatforms = []; };

    rgl = old.rgl.overrideAttrs (attrs: {
      RGL_USE_NULL = "true";
    });

    Rrdrand = old.Rrdrand.override { platforms = lib.platforms.x86_64 ++ lib.platforms.x86; };

    symengine = old.symengine.overrideAttrs (_: {
      preConfigure = ''
        rm configure
        cat > src/Makevars << EOF
        PKG_LIBS=-lsymengine
        all: $(SHLIB)
        EOF
      '';
    });

    RandomFieldsUtils = old.RandomFieldsUtils.override { platforms = lib.platforms.x86_64 ++ lib.platforms.x86; };

    flowClust = old.flowClust.override { platforms = lib.platforms.x86_64 ++ lib.platforms.x86; };

    RcppCGAL = old.RcppCGAL.overrideAttrs (_: {
      postPatch = "patchShebangs configure";
    });

    SharedObject = old.SharedObject.overrideAttrs (attrs: {
      # backport PR resolving build issues: https://github.com/Jiefei-Wang/SharedObject/pull/17
      patches = let inherit (pkgs) fetchpatch; in [
        (fetchpatch {
          url = "https://github.com/Jiefei-Wang/SharedObject/pull/17/commits/50c4b2964649d7f5a14d843bd7089ab62650fcd3.patch";
          sha256 = "sha256-zn535IeOYRvyQ2yxgoGEq2wccrl9xdu9nREmy7sV+PQ=";
        })
        (fetchpatch {
          url = "https://github.com/Jiefei-Wang/SharedObject/pull/17/commits/bf096a39858e9210cbe246d4b136905d4cfbfaf4.patch";
          sha256 = "sha256-Z+BZOkFnLgIBiVuPsAHp7bMXzADcvuHV4hILdmLvd+k=";
        })
      ];
    });

    httr2 = old.httr2.overrideAttrs (attrs: {
      preConfigure = "patchShebangs configure";
    });

    dbarts = old.dbarts.override { platforms = lib.platforms.x86_64 ++ lib.platforms.x86; };

    geomorph = old.geomorph.overrideAttrs (attrs: {
      RGL_USE_NULL = "true";
    });

    gpuMagic = old.gpuMagic.overrideAttrs (_: {
      hardeningDisable = ["format"];
    });

    Rdisop = old.Rdisop.overrideAttrs (_: {
      hardeningDisable = ["format"];
    });

    opencv = let
      opencvGtk = pkgs.opencv.override (old : { enableGtk2 = true; });
    in old.opencv.overrideAttrs (attrs: {
      buildInputs = attrs.buildInputs ++ [ opencvGtk ];
    });

    Rhdf5lib = let
      hdf5 = pkgs.hdf5_1_10.overrideAttrs (attrs: {configureFlags = attrs.configureFlags ++ [ "--enable-cxx" ];});
    in old.Rhdf5lib.overrideAttrs (attrs: {
      propagatedBuildInputs = attrs.propagatedBuildInputs ++ [ hdf5.dev pkgs.libaec ];
      patches = [ ./patches/Rhdf5lib.patch ];
      passthru.hdf5 = hdf5;
    });

    rhdf5filters = old.rhdf5filters.overrideAttrs (attrs: {
      patches = [ ./patches/rhdf5filters.patch ];
    });

    rhdf5= old.rhdf5.overrideAttrs (attrs: {
      patches = [ ./patches/rhdf5.patch ];
    });

    rmarkdown = old.rmarkdown.overrideAttrs (_: {
      preConfigure = ''
        substituteInPlace R/pandoc.R \
          --replace '"~/opt/pandoc"' '"~/opt/pandoc", "${pkgs.pandoc}/bin"'
      '';
    });

    redland = old.redland.overrideAttrs (_: {
      PKGCONFIG_CFLAGS="-I${pkgs.redland}/include -I${pkgs.librdf_raptor2}/include/raptor2 -I${pkgs.librdf_rasqal}/include/rasqal";
      PKGCONFIG_LIBS="-L${pkgs.redland}/lib -L${pkgs.librdf_raptor2}/lib -L${pkgs.librdf_rasqal}/lib -lrdf -lraptor2 -lrasqal";
    });

    textshaping = old.textshaping.overrideAttrs (attrs: {
      env.NIX_LDFLAGS = "-lfribidi -lharfbuzz";
    });

    httpuv = old.httpuv.overrideAttrs (_: {
      preConfigure = ''
        patchShebangs configure
      '';
    });

    oligo = old.oligo.overrideAttrs (_: {
      hardeningDisable = ["format"];
    });

    tesseract = old.tesseract.overrideAttrs (_: {
      preConfigure = ''
        substituteInPlace configure \
          --replace 'PKG_CONFIG_NAME="tesseract"' 'PKG_CONFIG_NAME="tesseract lept"'
      '';
    });

    ijtiff = old.ijtiff.overrideAttrs (_: {
      preConfigure = ''
        patchShebangs configure
      '';
    });

    torch = old.torch.overrideAttrs (attrs: {
      preConfigure = ''
        patchShebangs configure
      '';
    });

    pak = old.pak.overrideAttrs (attrs: {
      preConfigure = ''
        patchShebangs configure
        patchShebangs src/library/curl/configure
        patchShebangs src/library/pkgdepends/configure
        patchShebangs src/library/ps/configure
      '';
    });

    pkgdepends = old.pkgdepends.overrideAttrs (attrs: {
      postPatch = ''
        patchShebangs configure
      '';
    });
  };
in
  self
