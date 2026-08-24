# This file defines the composition for R packages.

let
  importJSON = f: builtins.fromJSON (builtins.readFile f);

  biocPackagesGenerated = importJSON ./bioc-packages.json;
  biocAnnotationPackagesGenerated = importJSON ./bioc-annotation-packages.json;
  biocExperimentPackagesGenerated = importJSON ./bioc-experiment-packages.json;
  cranPackagesGenerated = importJSON ./cran-packages.json;
in

{
  R,
  pkgs,
  overrides,
}:

let
  inherit (pkgs)
    cacert
    fetchurl
    stdenv
    lib
    ;

  buildRPackage = pkgs.callPackage ./generic-builder.nix {
    inherit R;
    inherit (pkgs) gettext gfortran;
  };

  # Generates package templates given per-repository settings
  #
  # some packages, e.g. cncaGUI, require X running while installation,
  # so that we use xvfb-run if requireX is true.
  mkDerive =
    {
      mkHomepage,
      mkUrls,
      hydraPlatforms ? null,
    }:
    args:
    let
      hydraPlatforms' = hydraPlatforms;
    in
    lib.makeOverridable (
      {
        name,
        version,
        sha256,
        depends ? [ ],
        doCheck ? true,
        requireX ? false,
        broken ? false,
        platforms ? R.meta.platforms,
        hydraPlatforms ? if hydraPlatforms' != null then hydraPlatforms' else platforms,
        maintainers ? [ ],
      }:
      buildRPackage {
        pname = name;
        inherit version;
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
      }
    );

  # Templates for generating Bioconductor and CRAN packages
  # from the name, version, sha256, and optional per-package arguments above
  #
  deriveBioc = mkDerive {
    mkHomepage =
      { name, biocVersion }: "https://bioconductor.org/packages/${biocVersion}/bioc/html/${name}.html";
    mkUrls =
      {
        name,
        version,
        biocVersion,
      }:
      [
        "mirror://bioc/${biocVersion}/bioc/src/contrib/${name}_${version}.tar.gz"
        "mirror://bioc/${biocVersion}/bioc/src/contrib/Archive/${name}/${name}_${version}.tar.gz"
        "mirror://bioc/${biocVersion}/bioc/src/contrib/Archive/${name}_${version}.tar.gz"
      ];
  };
  deriveBiocAnn = mkDerive {
    mkHomepage =
      { name, biocVersion }:
      "https://www.bioconductor.org/packages/${biocVersion}/data/annotation/html/${name}.html";
    mkUrls =
      {
        name,
        version,
        biocVersion,
      }:
      [
        "mirror://bioc/${biocVersion}/data/annotation/src/contrib/${name}_${version}.tar.gz"
      ];
    hydraPlatforms = [ ];
  };
  deriveBiocExp = mkDerive {
    mkHomepage =
      { name, biocVersion }:
      "https://www.bioconductor.org/packages/${biocVersion}/data/experiment/html/${name}.html";
    mkUrls =
      {
        name,
        version,
        biocVersion,
      }:
      [
        "mirror://bioc/${biocVersion}/data/experiment/src/contrib/${name}_${version}.tar.gz"
      ];
    hydraPlatforms = [ ];
  };
  deriveCran = mkDerive {
    mkHomepage = { name }: "https://cran.r-project.org/web/packages/${name}/";
    mkUrls =
      { name, version }:
      [
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
  overrideNativeBuildInputs =
    overrides: old:
    lib.mapAttrs (
      name: value:
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
  overrideBuildInputs =
    overrides: old:
    lib.mapAttrs (
      name: value:
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
  overrideMaintainers =
    overrides: old:
    lib.mapAttrs (
      name: value:
      (builtins.getAttr name old).override {
        maintainers = value;
      }
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
  #   foo = old.foo.overrideAttrs (attrs: {
  #     nativeBuildInputs = attrs.nativeBuildInputs ++ [ self.bar ];
  #     propagatedBuildInputs = attrs.propagatedBuildInputs ++ [ self.bar ];
  #   });
  # }
  overrideRDepends =
    overrides: old:
    lib.mapAttrs (
      name: value:
      (builtins.getAttr name old).overrideAttrs (attrs: {
        nativeBuildInputs = (attrs.nativeBuildInputs or [ ]) ++ value;
        propagatedBuildInputs = (attrs.propagatedBuildInputs or [ ]) ++ value;
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
  overrideRequireX =
    packageNames: old:
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
  overrideRequireHome =
    packageNames: old:
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
  overrideSkipCheck =
    packageNames: old:
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
  overrideBroken =
    packageNames: old:
    let
      nameValuePairs = map (name: {
        inherit name;
        value = (builtins.getAttr name old).override {
          broken = true;
        };
      }) packageNames;
    in
    builtins.listToAttrs nameValuePairs;

  defaultOverrides =
    old: new:
    let
      old0 = old;
    in
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
    in
    old // (otherOverrides old new);

  # Recursive override pattern.
  # `_self` is a collection of packages;
  # `self` is `_self` with overridden packages;
  # packages in `_self` may depends on overridden packages.
  self = (defaultOverrides _self self) // overrides;
  _self = {
    inherit buildRPackage;
  }
  // mkPackageSet deriveBioc biocPackagesGenerated
  // mkPackageSet deriveBiocAnn biocAnnotationPackagesGenerated
  // mkPackageSet deriveBiocExp biocExperimentPackagesGenerated
  // mkPackageSet deriveCran cranPackagesGenerated;

  # Takes in a generated JSON file's imported contents
  # and transforms it by swapping each element of the depends array with the dependency's derivation
  # and passing this new object to the provided derive function
  mkPackageSet =
    derive: packagesJSON:
    lib.mapAttrs (
      k: v:
      derive packagesJSON.extraArgs (
        v // { depends = lib.map (name: builtins.getAttr name self) v.depends; }
      )
    ) packagesJSON.packages;

  # tweaks for the individual packages and "in self" follow

  packagesWithMaintainers = with lib.maintainers; {
    # keep-sorted start block=yes
    BiocManager = [ jbedo ];
    RQuantLib = [ kupac ];
    StructuralVariantAnnotation = [ jbedo ];
    XLConnect = [ b-rodrigues ];
    data_table = [ jbedo ];
    ggplot2 = [ jbedo ];
    iscream = [ jamespeapen ];
    svaNUMT = [ jbedo ];
    svaRetro = [ jbedo ];
    # keep-sorted end
  };

  packagesWithRDepends = {
    # keep-sorted start block=yes
    BayesPET = [ self.rstantools ];
    TriDimRegression = [ self.rstantools ];
    bayesdfa = [ self.rstantools ];
    bbmix = [ self.rstantools ];
    disbayes = [ self.rstantools ];
    gastempt = [ self.rstantools ];
    interactiveDisplay = [ self.BiocManager ];
    pliman = [ self.EBImage ];
    rmsb = [ self.rstantools ];
    spectralGraphTopology = [ self.CVXR ];
    survextrap = [ self.rstantools ];
    tipsae = [ self.rstantools ];
    # keep-sorted end
  };

  packagesWithNativeBuildInputs = {
    # keep-sorted start block=yes
    Apollonius = [ pkgs.pkg-config ];
    BayesXsrc = [ pkgs.gsl ]; # for gsl-config
    BigDataStatMeth = [ pkgs.pkg-config ];
    BiocCheck = [ pkgs.which ];
    CBN2Path = [ pkgs.gsl ]; # for gsl-config
    CLVTools = [ pkgs.gsl ]; # for gsl-config via RcppGSL
    Cairo = [ pkgs.pkg-config ];
    Cardinal = [ pkgs.which ];
    ChemmineOB = [ pkgs.pkg-config ];
    CytoML = [ pkgs.libxml2 ]; # for xml2-config
    DirichletMultinomial = [ pkgs.gsl ]; # for gsl-config
    GLAD = [ pkgs.gsl ]; # for gsl-config
    GPBayes = [ pkgs.gsl ]; # for gsl-config
    JMcmprsk = [ pkgs.gsl ]; # for gsl-config
    KSgeneral = with pkgs; [ pkg-config ];
    LCMCR = [ pkgs.gsl ]; # for gsl-config
    ModelMetrics = lib.optional stdenv.hostPlatform.isDarwin pkgs.llvmPackages.openmp;
    PEPBVS = [ pkgs.gsl ]; # for gsl-config
    PICS = [ pkgs.gsl ];
    QF = [ pkgs.gsl ]; # for gsl-config
    R2SWF = [ pkgs.pkg-config ];
    RAppArmor = [ pkgs.pkg-config ];
    RCurl = [ pkgs.curl ]; # for curl-config
    RDieHarder = [ pkgs.gsl ]; # for gsl-config
    RFIF = [ pkgs.pkg-config ];
    RGtk2 = [ pkgs.pkg-config ];
    RJMCMCNucleosomes = [ pkgs.gsl ]; # for gsl-config
    RKHSMetaMod = [ pkgs.gsl ]; # for gsl-config via RcppGSL
    RMariaDB = [ pkgs.libmysqlclient ]; # for mysql_config
    RMySQL = [ pkgs.libmysqlclient ]; # for mysql_config
    RNetCDF = [ pkgs.pkg-config ];
    RPesto = with pkgs; [
      cargo
      rustc
    ];
    RPostgreSQL = with pkgs; [ libpq.pg_config ];
    RProtoBuf = [ pkgs.pkg-config ];
    RQuantLib = [ pkgs.quantlib ]; # for quantlib-config
    RationalMatrix = [ pkgs.pkg-config ];
    RcppCWB = with pkgs; [
      pkg-config
      pcre2 # for pcre2-config
    ];
    RcppDPR = [ pkgs.gsl ]; # for gsl-config via RcppGSL
    RcppGSL = [ pkgs.gsl ]; # for gsl-config
    RcppMeCab = [ pkgs.mecab ]; # for mecab-config
    RcppPlanc = with pkgs; [
      which
      cmake
      pkg-config
    ];
    RcppZiggurat = [ pkgs.gsl ]; # for gsl-config
    Rhdf5lib = with pkgs; [
      cmake
    ];
    Rhisat2 = [
      pkgs.which
      pkgs.hostname
    ];
    Rhpc = with pkgs; [
      mpi
      # deps for `R CMD config --ldflags`
      bzip2
      icu
      libdeflate
      xz
      zlib
      zstd
    ];
    Rigraphlib = [ pkgs.cmake ];
    Rlibeemd = [ pkgs.gsl ]; # for gsl-config
    RmecabKo = [ pkgs.mecab ]; # for mecab-config
    Rmpi = with pkgs; [
      pkg-config
      prrte
    ];
    RoBMA = [ pkgs.pkg-config ];
    RoBSA = [ pkgs.pkg-config ];
    Rpoppler = [ pkgs.pkg-config ];
    Rsubbotools = [ pkgs.gsl ]; # for gsl-config
    Rsymphony = [ pkgs.pkg-config ];
    SQLFormatteR = with pkgs; [
      cargo
      rustc
    ];
    SimInf = [ pkgs.gsl ]; # for gsl-config
    SuperGauss = [ pkgs.pkg-config ];
    SymTS = [ pkgs.gsl ]; # for gsl-config
    Uno = with pkgs; [
      cmake
      which
    ];
    V8 = [ pkgs.pkg-config ];
    VBLPCM = [ pkgs.gsl ]; # for gsl-config
    XBRL = [ pkgs.libxml2 ]; # for xml2-config
    XML = with pkgs; [
      pkg-config
      libxml2 # for xml2-config
    ];
    a5R = with pkgs; [
      cargo
      rustc
    ];
    abn = with pkgs; [
      gsl # for gsl-config
      jags
    ];
    adimpro = [ pkgs.imagemagick ];
    ahocorasick = with pkgs; [
      cargo
      rustc
    ];
    alcyon = with pkgs; [
      cmake
      which
    ];
    animation = [ pkgs.which ];
    apcf = [ pkgs.geos ]; # for geos-config
    apsimx = [ pkgs.which ];
    arcgisgeocode = with pkgs; [
      cargo
      rustc
    ];
    arcgisplaces = with pkgs; [
      cargo
      rustc
      pkg-config
    ];
    arcgisutils = with pkgs; [
      cargo
      rustc
    ];
    arcpbf = with pkgs; [
      cargo
      rustc
    ];
    arrow =
      with pkgs;
      [
        pkg-config
        cmake
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [ intltool ];
    astgrepr = with pkgs; [
      cargo
      rustc
    ];
    automerge = with pkgs; [
      cargo
      cmake
      rustc
    ];
    awdb = with pkgs; [
      cargo
      rustc
    ];
    b32 = with pkgs; [
      cargo
      rustc
    ];
    b64 = with pkgs; [
      cargo
      rustc
    ];
    bigGP = [ pkgs.mpi ];
    bigrquerystorage = with pkgs; [
      grpc
      protobuf
      which
    ];
    bioacoustics = [ pkgs.cmake ];
    blosc = [ pkgs.pkg-config ];
    cairoDevice = [ pkgs.pkg-config ];
    cartogramR = [ pkgs.pkg-config ];
    catSurv = [ pkgs.gsl ]; # for gsl-config via RcppGSL
    caugi = with pkgs; [
      cargo
      rustc
    ];
    caviarpd = with pkgs; [
      cargo
      rustc
    ];
    chebpol = [ pkgs.pkg-config ];
    ciflyr = with pkgs; [
      cargo
      rustc
    ];
    cit = [ pkgs.gsl ]; # for gsl-config
    clarabel = [ pkgs.cargo ];
    cld3 = [ pkgs.protobuf ];
    clustermq = [ pkgs.pkg-config ];
    coga = [ pkgs.gsl ]; # for gsl-config
    cpp11bigwig = [ pkgs.curl ]; # for curl-config
    crc32c = [
      pkgs.which
      pkgs.cmake
    ];
    data_table = (
      # added extra parentheses so that `keep-sorted` doesn't get tripped up
      [
        pkgs.pkg-config
      ]
      ++ lib.optional stdenv.hostPlatform.isDarwin pkgs.llvmPackages.openmp
    );
    datefixR = with pkgs; [
      cargo
      rustc
    ];
    diseq = [ pkgs.gsl ]; # for gsl-config
    diversitree = [ pkgs.gsl ]; # for gsl-config
    drogonR = [ pkgs.pkg-config ];
    dynr = [ pkgs.gsl ]; # for gsl-config
    eaf = [ pkgs.gsl ]; # for gsl-config
    econetwork = [ pkgs.gsl ]; # for gsl-config via RcppGSL
    enderecobr = with pkgs; [
      cargo
      rustc
    ];
    eulerr = with pkgs; [
      cargo
      rustc
    ];
    exactextractr = [ pkgs.geos ]; # for geos-config
    excursions = [ pkgs.gsl ]; # for gsl-config
    fRLR = [ pkgs.gsl ]; # for gsl-config
    fangs = with pkgs; [
      cargo
      rustc
    ];
    fastgeojson = with pkgs; [
      cargo
      rustc
    ];
    fcl = with pkgs; [
      cargo
      rustc
    ];
    fftw = [ pkgs.pkg-config ];
    fftwtools = [ pkgs.pkg-config ];
    fingerPro = [ pkgs.gsl ]; # for gsl-config via RcppGSL
    fio = with pkgs; [
      cargo
      rustc
    ];
    flan = [ pkgs.gsl ]; # for gsl-config
    flint = [ pkgs.pkg-config ];
    flowPeaks = [ pkgs.gsl ]; # for gsl-config
    fozziejoin = with pkgs; [
      cargo
      rustc
    ];
    frailtyMMpen = [ pkgs.gsl ]; # for gsl-config
    fraq = [ pkgs.pkg-config ];
    fru = with pkgs; [
      cargo
      rustc
    ];
    gadjid = with pkgs; [
      cargo
      rustc
    ];
    gdalcubes = with pkgs; [
      pkg-config
      gdal # for gdal-config
      netcdf # for nc-config
    ];
    gdalraster = with pkgs; [
      pkg-config
      gdal # for gdal-config
    ];
    gdtools = [ pkgs.pkg-config ];
    gert = [ pkgs.pkg-config ];
    gglinedensity = [ pkgs.cargo ];
    gifski = with pkgs; [
      cargo
      rustc
    ];
    git2r = [ pkgs.pkg-config ];
    glpkAPI = [ pkgs.glpk ]; # detects prefix from glpsol binary
    gridmicrotex = [ pkgs.pkg-config ];
    gsl = [ pkgs.gsl ]; # for gsl-config
    gslnls = [ pkgs.gsl ]; # for gsl-config
    gtfsrealtime = with pkgs; [
      cargo
      rustc
    ];
    h3o = with pkgs; [
      cargo
      rustc
    ];
    hSDM = [ pkgs.gsl ]; # for gsl-config
    harbinger = [ pkgs.glibcLocales ];
    heck = with pkgs; [
      cargo
      rustc
    ];
    hellorust = [ pkgs.cargo ];
    hgwrr = [ pkgs.gsl ]; # for gsl-config
    highs = [
      pkgs.which
      pkgs.cmake
    ];
    hypergeo2 = [ pkgs.pkg-config ];
    iBMQ = [ pkgs.gsl ]; # for gsl-config
    image_textlinedetector = [ pkgs.pkg-config ];
    imager = [ pkgs.pkg-config ];
    immunoClust = [ pkgs.gsl ]; # for gsl-config
    interpolation = [ pkgs.pkg-config ];
    iscream = with pkgs; [
      pkg-config
      which
    ];
    island = [ pkgs.gsl ]; # for gsl-config
    jSDM = [ pkgs.gsl ]; # for gsl-config
    jack = [ pkgs.pkg-config ];
    kza = [ pkgs.pkg-config ];
    libdeflate = with pkgs; [
      cmake
      pkg-config
    ];
    libimath = [ pkgs.cmake ];
    libipldr = with pkgs; [
      cargo
      rustc
    ];
    llmjson = with pkgs; [
      cargo
      rustc
    ];
    lnmixsurv = [ pkgs.gsl ]; # for gsl-config
    lpsymphony = with pkgs; [
      pkg-config
      gfortran
      gettext
    ];
    lwgeom = with pkgs; [
      pkg-config
      geos # for geos-config
    ];
    magick = [ pkgs.pkg-config ];
    markets = [ pkgs.gsl ]; # for gsl-config
    mashr = [ pkgs.gsl ]; # for gsl-config via RcppGSL
    mcrPioda = [ pkgs.gsl ]; # for gsl-config
    minimaxALT = [ pkgs.gsl ]; # for gsl-config via RcppGSL
    mixlink = [ pkgs.gsl ]; # for gsl-config
    mixture = [ pkgs.gsl ]; # for gsl-config
    mmpca = [ pkgs.gsl ]; # for gsl-config via RcppGSL
    monoreg = [ pkgs.gsl ]; # for gsl-config
    multibridge = [ pkgs.pkg-config ];
    mvabund = [ pkgs.gsl ]; # for gsl-config via RcppGSL
    mvst = [ pkgs.gsl ]; # for gsl-config
    mwaved = [ pkgs.pkg-config ];
    mx_crypto = with pkgs; [
      cargo
      rustc
    ];
    n1qn1 = [ pkgs.gfortran ];
    ncdf4 = [ pkgs.netcdf ]; # for nc-config
    neojags = [ pkgs.pkg-config ];
    netboost = [ pkgs.perl ];
    nloptr = [ pkgs.pkg-config ];
    npRmpi = with pkgs; [
      pkg-config
      prrte
    ];
    odbc = [ pkgs.pkg-config ];
    opencv = [ pkgs.pkg-config ];
    orbweaver = with pkgs; [
      cargo
      rustc
    ];
    osmnxr = with pkgs; [
      cargo
      rustc
    ];
    otelsdk = with pkgs; [
      cmake
      which
    ];
    pander = with pkgs; [
      pandoc
      which
    ];
    pbdMPI = [ pkgs.mpi ];
    pbdPROF = [ pkgs.mpi ];
    pbdZMQ = [ pkgs.pkg-config ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ pkgs.which ];
    pcaL1 = [ pkgs.pkg-config ];
    pdfsigner = with pkgs; [
      cargo
      rustc
    ];
    pdftools = [ pkgs.pkg-config ];
    pexm = [ pkgs.jags ];
    phytools = [ pkgs.which ];
    png = [ pkgs.libpng ]; # for libpng-config
    protolite = [ pkgs.protobuf ];
    prqlr = with pkgs; [
      cargo
      rustc
    ];
    qqconf = [ pkgs.pkg-config ];
    qspray = [ pkgs.pkg-config ];
    rGEDI = [ pkgs.gsl ]; # for gsl-config
    rJava = [ pkgs.stripJavaArchivesHook ];
    ragg = [ pkgs.pkg-config ];
    rapport = [ pkgs.which ];
    rapportools = [ pkgs.which ];
    ratioOfQsprays = [ pkgs.pkg-config ];
    ravetools = [ pkgs.pkg-config ];
    rbedrock = with pkgs; [
      which
      cmake
    ];
    rbm25 = with pkgs; [
      cargo
      rustc
    ];
    rcontroll = [ pkgs.gsl ]; # for gsl-config
    redux = [ pkgs.pkg-config ];
    reprex = [ pkgs.which ];
    resultant = [ pkgs.pkg-config ];
    rgdal = [ pkgs.gdal ]; # for gdal-config
    rgeos = [ pkgs.geos ]; # for geos-config
    ridge = [ pkgs.gsl ]; # for gsl-config
    rip_opencv = [ pkgs.pkg-config ];
    rjags = [ pkgs.pkg-config ];
    rlas = with pkgs; [
      pkg-config
      gdal # for gdal-config
      geos # for geos-config
    ];
    rlibkriging = [ pkgs.cmake ];
    rmatio = [ pkgs.pkg-config ];
    rnetcarto = [ pkgs.gsl ]; # for gsl-config
    roxigraph = with pkgs; [
      cargo
      rustc
    ];
    rpanel = [ pkgs.tclPackages.bwidget ];
    rrd = [ pkgs.pkg-config ];
    rsamplr = with pkgs; [
      cargo
      rustc
    ];
    rsbml = [ pkgs.pkg-config ];
    rsgeo = with pkgs; [
      cargo
      rustc
    ];
    rshift = with pkgs; [
      cargo
      rustc
    ];
    rsvg = [ pkgs.pkg-config ];
    rswipl = with pkgs; [
      cmake
      pkg-config
    ];
    rtiktoken = with pkgs; [
      cargo
      rustc
    ];
    rtracklayer = [ pkgs.pkg-config ];
    runjags = [ pkgs.pkg-config ];
    rzmq = [ pkgs.pkg-config ];
    s2 = [ pkgs.pkg-config ];
    salso = with pkgs; [
      cargo
      rustc
    ];
    sbrl = [ pkgs.gsl ]; # for gsl-config
    sceua = with pkgs; [
      cargo
      rustc
    ];
    scip = with pkgs; [
      cmake
      which
    ];
    scorematchingad = [ pkgs.cmake ];
    sf = with pkgs; [
      pkg-config
      gdal # for gdal-config
      geos # for geos-config
    ];
    showtext = [ pkgs.pkg-config ];
    shrinkTVP = [ pkgs.gsl ]; # for gsl-config via RcppGSL
    smam = [ pkgs.gsl ]; # for gsl-config
    smcryptoR = with pkgs; [
      cargo
      rustc
      which
    ];
    smoothbp = with pkgs; [
      cargo
      rustc
    ];
    socratadata = with pkgs; [
      cargo
      rustc
    ];
    sodium = [ pkgs.pkg-config ];
    spate = [ pkgs.pkg-config ];
    sphereTessellation = [ pkgs.pkg-config ];
    spopt = with pkgs; [
      cargo
      rustc
    ];
    stpphawkes = [ pkgs.gsl ]; # for gsl-config via RcppGSL
    string2path = [ pkgs.cargo ];
    stringfish = [ pkgs.pkg-config ];
    stringi = [ pkgs.pkg-config ];
    sundialr = [ pkgs.cmake ];
    survSNP = [ pkgs.gsl ]; # for gsl-config
    surveyvoi = [ pkgs.pkg-config ];
    symbolicQspray = [ pkgs.pkg-config ];
    sysfonts = [ pkgs.pkg-config ];
    systemfonts = [ pkgs.pkg-config ];
    talib = [ pkgs.pkg-config ];
    tergo = with pkgs; [
      cargo
      rustc
    ];
    terra = with pkgs; [
      pkg-config
      gdal # for gdal-config
      geos # for geos-config
    ];
    tesseract = [ pkgs.pkg-config ];
    textshaping = [ pkgs.pkg-config ];
    tfevents = [ pkgs.protobuf ];
    tinyimg = with pkgs; [
      cargo
      rustc
    ];
    tok = with pkgs; [
      cargo
      rustc
    ];
    tomledit = with pkgs; [
      cargo
      rustc
    ];
    unigd = [ pkgs.pkg-config ];
    unix = [ pkgs.pkg-config ];
    unsum = with pkgs; [
      cargo
      rustc
    ];
    uuidx = with pkgs; [
      cargo
      rustc
    ];
    vapour = with pkgs; [
      pkg-config
      gdal # for gdal-config
    ];
    watcher = with pkgs; [
      cmake
      which
    ];
    waysign = with pkgs; [
      cargo
      rustc
    ];
    webp = [ pkgs.pkg-config ];
    xactonomial = with pkgs; [
      cargo
      rustc
    ];
    xml2 = [ pkgs.pkg-config ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ pkgs.perl ];
    xslt = [ pkgs.pkg-config ];
    yaml12 = with pkgs; [
      cargo
      rustc
    ];
    ymd = with pkgs; [
      cargo
      rustc
    ];
    zoomerjoin = with pkgs; [
      cargo
      rustc
    ];
    # keep-sorted end
  };

  packagesWithBuildInputs = {
    # keep-sorted start block=yes
    AMOUNTAIN = [ pkgs.gsl ];
    Apollonius = with pkgs; [
      gmp
      mpfr
    ];
    ArrayExpressHTS = with pkgs; [
      zlib
      curl
      which
    ];
    BNSP = [ pkgs.gsl ];
    BayesChange = [ pkgs.gsl ];
    BayesSAE = [ pkgs.gsl ];
    BayesVarSel = [ pkgs.gsl ];
    BigDataStatMeth = [ pkgs.zlib ];
    BinaryDosage = [ pkgs.zlib ];
    BitSeq = [ pkgs.zlib ];
    CNEr = with pkgs; [ zlib ];
    Cairo = [ pkgs.cairo ];
    CellBarcode = [ pkgs.zlib ];
    ChemmineOB = with pkgs; [
      eigen
      openbabel
      zlib
    ];
    DEploid = [ pkgs.zlib ];
    DEploid_utils = [ pkgs.zlib ];
    DGP4LCF = [
      pkgs.lapack
      pkgs.blas
    ];
    DiffBind = with pkgs; [
      zlib
      xz
      bzip2
    ];
    DropletUtils = [ pkgs.zlib ];
    EHRmuse = [ pkgs.gsl ];
    FLAMES = with pkgs; [
      zlib
      bzip2
      xz
    ];
    GLAD = [ pkgs.gsl ];
    GMMAT = with pkgs; [
      zlib
      bzip2
    ];
    GRAB = [ pkgs.zlib ];
    GeneralizedWendland = [ pkgs.gsl ];
    GeoFIS = with pkgs; [
      mpfr
      gmp
    ];
    GrafGen = [ pkgs.zlib ];
    HDF5Array = [ pkgs.zlib ];
    HiCDCPlus = [ pkgs.zlib ];
    HiCParser = [ pkgs.zlib ];
    HiCseg = [ pkgs.gsl ];
    HiSpaR = [ pkgs.armadillo ];
    KFKSDS = [ pkgs.gsl ];
    KSgeneral = [ pkgs.fftw ];
    LOMAR = [ pkgs.gmp ];
    Libra = [ pkgs.gsl ];
    MAGEE = with pkgs; [
      zlib
      bzip2
    ];
    MedianaDesigner = [ pkgs.zlib ];
    MethScope = with pkgs; [
      ncurses
      zlib
    ];
    NanoMethViz = [ pkgs.zlib ];
    OpenCL = with pkgs; [
      opencl-clhpp
      ocl-icd
    ];
    PING = [ pkgs.gsl ];
    PKI = [ pkgs.openssl ];
    PROJ = [ pkgs.proj ];
    PoissonBinomial = [ pkgs.fftw ];
    PoissonMultinomial = [ pkgs.fftw ];
    PopGenome = [ pkgs.zlib ];
    QuasR = with pkgs; [
      zlib
      xz
      bzip2
    ];
    R2SWF = with pkgs; [
      zlib
      libpng
      freetype
    ];
    RAppArmor = lib.optionals stdenv.hostPlatform.isLinux [ pkgs.libapparmor ];
    RFIF = [ pkgs.fftw ];
    RGtk2 = [ pkgs.gtk2 ];
    RITCH = [ pkgs.zlib ];
    RKHSMetaMod = [ pkgs.gsl ];
    RMark = [ pkgs.which ];
    RNetCDF = with pkgs; [
      netcdf
      udunits
    ];
    RNifti = [ pkgs.zlib ];
    RNiftyReg = [ pkgs.zlib ];
    RODBC = [ pkgs.libiodbc ];
    RPostgres = with pkgs; [ libpq ];
    RProtoBuf = with pkgs; [
      protobuf
      abseil-cpp
    ];
    RPushbullet = [ pkgs.which ];
    RQuantLib = with pkgs; [
      boost
      quantlib
    ];
    RSclient = [ pkgs.openssl ];
    RVowpalWabbit = with pkgs; [
      boost
      zlib
    ];
    Rarr = [ pkgs.zlib ];
    RationalMatrix = [ pkgs.gmp ];
    Rbowtie = with pkgs; [ zlib ];
    Rbowtie2 = [ pkgs.zlib ];
    Rbwa = [ pkgs.zlib ];
    RcppAlgos = [ pkgs.gmp ];
    RcppBigIntAlgos = [ pkgs.gmp ];
    RcppCNPy = [ pkgs.zlib ];
    RcppCWB = with pkgs; [
      pcre2
      glib
    ];
    RcppPlanc = with pkgs; [
      hwloc
      hdf5
    ];
    RcppZiggurat = [ pkgs.gsl ];
    Rfastp = with pkgs; [
      xz
      bzip2
      zlib
    ];
    Rglpk = [ pkgs.glpk ];
    Rhdf5lib = with pkgs; [
      curl
      zlib
    ];
    Rhtslib = with pkgs; [
      bzip2
      curl
      xz
      zlib
    ];
    Rlibeemd = [ pkgs.gsl ];
    Rmmquant = [ pkgs.zlib ];
    Rmpfr = with pkgs; [
      gmp
      mpfr
    ];
    Rmpi = [ pkgs.mpi ];
    RoBMA = [ pkgs.jags ];
    RoBSA = [ pkgs.jags ];
    Rpoppler = [ pkgs.poppler ];
    Rsamtools = with pkgs; [
      bzip2
      xz
      zlib
    ];
    Rserve = [ pkgs.openssl ];
    Rssa = [ pkgs.fftw ];
    Rsubread = [ pkgs.zlib ];
    Rsymphony = with pkgs; [
      symphony
      doxygen
      graphviz
      subversion
      cgl
      clp
    ];
    Rwbo = [ pkgs.zlib ];
    SICtools = with pkgs; [
      zlib
      ncurses
    ];
    SLmetrics = [ pkgs.zlib ];
    SPARSEMODr = [ pkgs.gsl ];
    SemiCompRisks = [ pkgs.gsl ];
    ShortRead = [ pkgs.zlib ];
    Signac = [ pkgs.zlib ];
    SuperGauss = [ pkgs.fftw ];
    SynExtend = [ pkgs.zlib ];
    TAQMNGR = [ pkgs.zlib ];
    TDA = [ pkgs.gmp ];
    TransView = with pkgs; [
      xz
      bzip2
      zlib
    ];
    V8 = with pkgs; [
      nodejs-slim_22.libv8
      # This should be the same icu version as the one used by nodejs
      # See: pkgs/development/web/nodejs/nodejs.nix
      icu
    ];
    VariantAnnotation = with pkgs; [
      zlib
      curl
      bzip2
      xz
    ];
    XML = with pkgs; [
      libtool
      libxml2
      xmlsec
      libxslt
    ];
    XVector = [ pkgs.zlib ];
    XYomics = [ pkgs.boost ];
    adbcpostgresql = with pkgs; [
      readline
      zlib
      openssl
      libkrb5
      openpam
      libpq
    ];
    adimpro = with pkgs; [
      which
      xdpyinfo
    ];
    affyPLM = [ pkgs.zlib ];
    affyio = [ pkgs.zlib ];
    arcgisplaces = [ pkgs.openssl ];
    archive = [ pkgs.libarchive ];
    arrangements = with pkgs; [ gmp ];
    asciicast = with pkgs; [
      # deps for `R CMD config --ldflags`
      bzip2
      icu
      libdeflate
      xz
      zlib
      zstd
    ];
    audio = [ pkgs.portaudio ];
    bamsignals = with pkgs; [
      zlib
      xz
      bzip2
    ];
    baseline = [ pkgs.lapack ];
    bayesWatch = [ pkgs.boost ];
    bbl = with pkgs; [ gsl ];
    bgx = [ pkgs.boost ];
    bigmemory = lib.optionals stdenv.hostPlatform.isLinux [ pkgs.libuuid ];
    bigrquerystorage = with pkgs; [
      grpc
      protobuf
    ];
    bigsnpr = [ pkgs.zlib ];
    bio3d = [ pkgs.zlib ];
    bioacoustics = [ pkgs.fftw ];
    blosc = [ pkgs.c-blosc ];
    bnpmr = [ pkgs.gsl ];
    cairoDevice = [ pkgs.gtk2 ];
    cartogramR = [ pkgs.fftw ];
    catSurv = [ pkgs.gsl ];
    ccfindR = [ pkgs.gsl ];
    chebpol = with pkgs; [
      fftw
      gsl
    ];
    cit = [ pkgs.gsl ];
    cld3 = [ pkgs.protobuf ];
    clustermq = [ pkgs.zeromq ];
    cmtkr = [ pkgs.zlib ];
    cpp11bigwig = [ pkgs.zlib ];
    cpp11qpdf = with pkgs; [
      libjpeg
      zlib
    ];
    crandep = [ pkgs.gsl ];
    csaw = with pkgs; [
      zlib
      xz
      bzip2
      curl
    ];
    curl = [ pkgs.curl ];
    data_table = [ pkgs.zlib ];
    deepSNV = with pkgs; [
      xz
      bzip2
      zlib
    ];
    devEMF = [ pkgs.zlib ];
    diffHic = with pkgs; [
      xz
      bzip2
    ];
    diversitree = [ pkgs.fftw ];
    divest = [ pkgs.zlib ];
    drogonR = with pkgs; [
      openssl
      zlib
    ];
    econetwork = [ pkgs.gsl ];
    eds = [ pkgs.zlib ];
    epialleleR = with pkgs; [
      xz
      bzip2
      zlib
    ];
    fastpng = [ pkgs.zlib ];
    fftw = [ pkgs.fftw ];
    fftwtools = [ pkgs.fftw ];
    fingerPro = [ pkgs.gsl ];
    flan = [ pkgs.gsl ];
    flint = with pkgs; [
      gmp
      mpfr
      flint
    ];
    flowWorkspace = [ pkgs.zlib ];
    frailtyMMpen = [ pkgs.gsl ];
    fraq = with pkgs; [
      zlib
      zstd
    ];
    fs = [ pkgs.libuv ];
    gamstransfer = [ pkgs.zlib ];
    gaston = with pkgs; [ zlib ];
    gdalcubes = with pkgs; [
      proj
      sqlite
    ];
    gdalraster = [ pkgs.proj ];
    gdtools =
      with pkgs;
      [
        cairo
        fontconfig
        freetype
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        expat
        libxdmcp
      ];
    gert = [ pkgs.libgit2 ];
    gfilogisreg = [ pkgs.gmp ];
    ggiraph = [ pkgs.libpng ];
    git2r = [ pkgs.libgit2 ];
    glpkAPI = [ pkgs.gmp ];
    gmapR = [ pkgs.zlib ];
    gmp = [ pkgs.gmp ];
    gpg = [ pkgs.gpgme ];
    gpuMagic = [ pkgs.ocl-icd ];
    gridGraphics = [ pkgs.which ];
    gridmicrotex = [ pkgs.freetype ];
    h5vc = with pkgs; [
      zlib
      bzip2
      xz
    ];
    hadron = [ pkgs.gsl ];
    haven = [ pkgs.zlib ];
    hipread = [ pkgs.zlib ];
    httpuv = [ pkgs.zlib ];
    hypergeo2 = with pkgs; [
      gmp
      mpfr
    ];
    iBMQ = [ pkgs.gsl ];
    igraph = with pkgs; [
      gmp
      libxml2
      glpk
    ];
    ijtiff = with pkgs; [
      libtiff
      libjpeg
      zlib
    ];
    image_CannyEdges = with pkgs; [
      fftw
      libpng
    ];
    image_textlinedetector = [ pkgs.opencv ];
    imager = with pkgs; [
      fftw
      libtiff
      libx11
    ];
    imbibe = [ pkgs.zlib ];
    immunoClust = [ pkgs.gsl ];
    impARI = [ pkgs.boost ];
    interpolation = with pkgs; [
      gmp
      mpfr
    ];
    iscream = with pkgs; [
      bzip2
      xz
      zlib
    ];
    jack = with pkgs; [
      gmp
      mpfr
    ];
    jackalope = with pkgs; [
      zlib
      xz
      bzip2
    ];
    jpeg = [ pkgs.libjpeg ];
    jqr = [ pkgs.jq ];
    knowYourCG = with pkgs; [
      zlib
      ncurses
    ];
    kza = [ pkgs.fftw ];
    landsepi = [ pkgs.gsl ];
    largeList = [ pkgs.zlib ];
    leidenAlg = [ pkgs.gmp ];
    libdeflate = [ pkgs.libdeflate ];
    libstable4u = [ pkgs.gsl ];
    libstableR = [ pkgs.gsl ];
    littler = with pkgs; [
      # deps for `R CMD config --ldflags`
      bzip2
      icu
      libdeflate
      xz
      zlib
      zstd
    ];
    lpsymphony = with pkgs; [
      symphony
      cgl
      clp
    ];
    lstar = [ pkgs.zlib ];
    lwgeom = [ pkgs.proj ];
    mBvs = [ pkgs.gsl ];
    maftools = with pkgs; [
      zlib
      bzip2
      xz
    ];
    magick = [ pkgs.imagemagick ];
    mappoly = [ pkgs.zlib ];
    markets = [ pkgs.gsl ];
    matchingMarkets = [ pkgs.zlib ];
    methylKit = with pkgs; [
      zlib
      bzip2
      xz
    ];
    milorGWAS = [ pkgs.zlib ];
    minimaxALT = [ pkgs.gsl ];
    mitoClone2 = with pkgs; [
      xz
      bzip2
      zlib
    ];
    mixcat = [ pkgs.gsl ];
    multibridge = [ pkgs.mpfr ];
    mutscan = [ pkgs.zlib ];
    mvabund = [ pkgs.gsl ];
    mwaved = [ pkgs.fftw ];
    nanonext = with pkgs; [
      mbedtls
      nng
    ];
    nat = [ pkgs.which ];
    nat_templatebrains = [ pkgs.which ];
    ncdfFlow = [ pkgs.zlib ];
    ndjson = [ pkgs.zlib ];
    neojags = [ pkgs.jags ];
    nloptr = [ pkgs.nlopt ];
    npRmpi = [ pkgs.mpi ];
    odbc = [ pkgs.unixodbc ];
    oligo = [ pkgs.zlib ];
    otelsdk = with pkgs; [
      curl
      protobuf
      zlib
    ];
    pak = [ pkgs.curl ];
    parseLatex = [ pkgs.icu ];
    pbdZMQ = [ pkgs.zeromq ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ pkgs.darwin.binutils ];
    pcaL1 = [ pkgs.clp ];
    pdftools = [ pkgs.poppler ];
    pgenlibr = [ pkgs.zlib ];
    pliman = with pkgs; [
      fftw
      libpng
    ];
    png = [ pkgs.libpng ];
    podkat = with pkgs; [
      zlib
      xz
      bzip2
    ];
    poisbinom = [ pkgs.fftw ];
    pqsfinder = [ pkgs.boost ];
    proj4 = [ pkgs.proj ];
    protolite = [ pkgs.protobuf ];
    psbcGroup = [ pkgs.gsl ];
    qckitfastq = [ pkgs.zlib ];
    qpdf = with pkgs; [
      libjpeg
      zlib
    ];
    qqconf = [ pkgs.fftw ];
    qrqc = [ pkgs.zlib ];
    qspray = with pkgs; [
      gmp
      mpfr
    ];
    rDEA = [ pkgs.glpk ];
    rGEDI = with pkgs; [
      libgeotiff
      libaec
      zlib
      hdf5
    ];
    rJPSGCS = [ pkgs.zlib ];
    rJava = with pkgs; [
      # deps for `R CMD config --ldflags`
      bzip2
      icu
      libdeflate
      xz
      zstd
      zlib
    ];
    raer = with pkgs; [
      zlib
      xz
      bzip2
    ];
    ragg =
      with pkgs;
      [
        freetype
        libpng
        libtiff
        zlib
        libjpeg
        bzip2
        libwebp
      ]
      ++ lib.optional stdenv.hostPlatform.isDarwin lerc;
    ratioOfQsprays = with pkgs; [
      gmp
      mpfr
    ];
    ravetools = [ pkgs.fftw ];
    rawrr = [ pkgs.mono ];
    rbedrock = [ pkgs.zlib ];
    rcdd = [ pkgs.gmp ];
    redux = [ pkgs.hiredis ];
    resultant = with pkgs; [
      gmp
      mpfr
    ];
    rgdal = [ pkgs.proj ];
    rgl = with pkgs; [
      libGLU
      libGL
      libx11
      freetype
      libpng
    ];
    rhdf5filters = with pkgs; [
      zlib
      bzip2
    ];
    ridge = [ pkgs.gsl ];
    rip_opencv = [ pkgs.opencv ];
    rjags = [ pkgs.jags ];
    rlas = with pkgs; [
      proj
      sqlite
    ];
    rmatio = [ pkgs.zlib ];
    rmumps = with pkgs; [ zlib ];
    rrd = [ pkgs.rrdtool ];
    rsbml = [ pkgs.libsbml ];
    rsvg = [ pkgs.librsvg ];
    rswipl = with pkgs; [
      ncurses
      libxcrypt
      zlib
    ];
    rtk = [ pkgs.zlib ];
    rtmpt = [ pkgs.gsl ];
    rtracklayer = with pkgs; [
      zlib
      curl
    ];
    runjags = [ pkgs.jags ];
    rvMF = [ pkgs.mpfr ];
    rvg = [ pkgs.libpng ];
    rzmq = [ pkgs.zeromq ];
    s2 = with pkgs; [
      abseil-cpp
      openssl
    ];
    saeMSPE = [ pkgs.gsl ];
    sbrl = [ pkgs.gmp ];
    scModels = [ pkgs.mpfr ];
    scPipe = with pkgs; [
      bzip2
      xz
      zlib
    ];
    screenCounter = [ pkgs.zlib ];
    sdcTable = with pkgs; [
      gmp
      glpk
    ];
    seqTools = [ pkgs.zlib ];
    seqbias = with pkgs; [
      zlib
      bzip2
      xz
    ];
    seqinr = [ pkgs.zlib ];
    seqminer = with pkgs; [
      bzip2
      sqlite
      zlib
      zstd
    ];
    sf = with pkgs; [
      proj
      sqlite
    ];
    showtext = with pkgs; [
      zlib
      libpng
      freetype
    ];
    simplexreg = [ pkgs.gsl ];
    snpStats = [ pkgs.zlib ];
    sodium = [ pkgs.libsodium ];
    spFW = [ pkgs.fftw ];
    spaMM = [ pkgs.gsl ];
    sparkwarc = [ pkgs.zlib ];
    spate = [ pkgs.fftw ];
    specklestar = [ pkgs.fftw ];
    sphereTessellation = with pkgs; [
      gmp
      mpfr
    ];
    spp = with pkgs; [ zlib ];
    ssh = with pkgs; [ libssh ];
    strawr = [ pkgs.curl ];
    stringfish = [ pkgs.pcre2 ];
    stringi = [ pkgs.icu74 ];
    stsm = [ pkgs.gsl ];
    sundialr = [ pkgs.sundials ];
    surveyvoi = with pkgs; [
      gmp
      mpfr
    ];
    svKomodo = [ pkgs.which ];
    svglite = [ pkgs.libpng ];
    symbolicQspray = with pkgs; [
      gmp
      mpfr
    ];
    symengine = with pkgs; [
      mpfr
      symengine
      flint
    ];
    sysfonts = with pkgs; [
      zlib
      libpng
      freetype
    ];
    systemfonts = with pkgs; [
      fontconfig
      freetype
    ];
    talib = [ pkgs.ta-lib ];
    tcltk2 = with pkgs; [
      tcl
      tk
    ];
    telegramR = [ pkgs.openssl ];
    terra = with pkgs; [
      proj
      sqlite
    ];
    tesseract = with pkgs; [
      tesseract
      leptonica
    ];
    textshaping = with pkgs; [
      harfbuzz
      freetype
      fribidi
      libpng
    ];
    tfevents = [ pkgs.protobuf ];
    themetagenomics = [ pkgs.zlib ];
    tidypopgen = [ pkgs.zlib ];
    tiff = [ pkgs.libtiff ];
    tikzDevice = with pkgs; [
      which
      texliveMedium
    ];
    tkrplot = with pkgs; [
      libx11
      tk
    ];
    topicmodels = [ pkgs.gsl ];
    transmogR = [ pkgs.zlib ];
    udunits2 = with pkgs; [
      udunits
      expat
    ];
    ulid = [ pkgs.zlib ];
    unigd =
      with pkgs;
      [
        cairo
        libpng
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        expat
        libxdmcp
      ];
    units = [ pkgs.udunits ];
    unix = lib.optionals stdenv.hostPlatform.isLinux [ pkgs.libapparmor ];
    unrtf = with pkgs; [
      # deps from $(LIBS) (same as `R CMD config --ldflags`)
      bzip2
      icu
      libdeflate
      xz
      zlib
      zstd
    ];
    vapour = [ pkgs.proj ];
    vcfR = with pkgs; [ zlib ];
    vcfppR = with pkgs; [
      bzip2
      curl
      libdeflate
      xz
      zlib
    ];
    vdiffr = [ pkgs.libpng ];
    webp = [ pkgs.libwebp ];
    writexl = with pkgs; [ zlib ];
    xdvir = [ pkgs.freetype ];
    xml2 = [ pkgs.libxml2 ];
    xslt =
      with pkgs;
      [
        libxslt
        libxml2
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [ xz ];
    yyjsonr = [ pkgs.zlib ];
    zlib = [ pkgs.zlib ];
    # keep-sorted end
  };

  packagesRequiringX = [
    # keep-sorted start
    "AnalyzeFMRI"
    "AnnotLists"
    "BCA"
    "CommunityCorrelogram"
    "DeducerPlugInExample"
    "DeducerPlugInScaling"
    "DeducerSpatial"
    "DeducerSurvival"
    "DeducerText"
    "Demerelate"
    "EasyqpcR"
    "GGEBiplotGUI"
    "HiveR"
    "Meth27QC"
    "OligoSpecificitySystem"
    "RSurvey"
    "RandomFields"
    "RclusTool"
    "RcmdrPlugin_FuzzyClust"
    "RcmdrPlugin_IPSUR"
    "RcmdrPlugin_PcaRobust"
    "RcmdrPlugin_SCDA"
    "RcmdrPlugin_SLC"
    "RcmdrPlugin_coin"
    "RcmdrPlugin_lfstat"
    "RcmdrPlugin_plotByGroup"
    "RcmdrPlugin_pointG"
    "RcmdrPlugin_sampling"
    "RcmdrPlugin_steepness"
    "SOLOMON"
    "SimpleTable"
    "SyNet"
    "TTAinterfaceTrendAnalysis"
    "VecStatGraphs3D"
    "analogueExtra"
    "asbio"
    "biplotbootGUI"
    "cairoDevice"
    "cncaGUI"
    "dave"
    "diveR"
    "dpa"
    "dynamicGraph"
    "exactLoglinTest"
    "fisheyeR"
    "forams"
    "forensim"
    "gWidgets2RGtk2"
    "gWidgets2tcltk"
    "gsubfn"
    "iClick"
    "iDynoR"
    "ic50"
    "iplots"
    "likeLTD"
    "loon"
    "loon_ggplot"
    "loon_shiny"
    "loon_tourr"
    "mixsep"
    "multibiplotGUI"
    "optbdmaeAT"
    "optrcdmaeAT"
    "paleoMAS"
    "rfviz"
    "rich"
    "simba"
    "soptdmaeA"
    "strvalidator"
    "stylo"
    "switchboard"
    "tkImgR"
    "twiddler"
    "uHMM"
    # keep-sorted end
  ];

  packagesRequiringHome = [
    # keep-sorted start
    "ACNE"
    "APAlyzer"
    "BAT"
    "CaDrA"
    "CoTiMA"
    "DiceView"
    "EstMix"
    "GNOSIS"
    "GapAnalysis"
    "MSnID"
    "OmnipathR"
    "PCRA"
    "PECA"
    "PKbioanalysis"
    "PSCBS"
    "Patterns"
    "PhIPData"
    "Quartet"
    "RKorAPClient"
    "R_cache"
    "R_filesets"
    "R_rsp"
    "Rogue"
    "ShinyQuickStarter"
    "SpatialDecon"
    "TBRDist"
    "TIN"
    "TotalCopheneticIndex"
    "TreeDist"
    "TreeSearch"
    "TreeTools"
    "aroma_affymetrix"
    "aroma_cn"
    "aroma_core"
    "avotrex"
    "beer"
    "biocthis"
    "calmate"
    "ceramic"
    "cfdnakit"
    "connections"
    "covidmx"
    "csodata"
    "dataverse"
    "facmodTS"
    "fgga"
    "fixest"
    "fulltext"
    "fwtraits"
    "gasanalyzer"
    "ggiraph"
    "iemisc"
    "immuneSIM"
    "margaret"
    "mastif"
    "matlab2r"
    "orthGS"
    "pannotator"
    "paxtoolsr"
    "pins"
    "precommit"
    "protGear"
    "rdss"
    "ready4"
    "red"
    "repmis"
    "salso"
    "scholar"
    "shinymeta"
    "shinyobjects"
    "stepR"
    "styler"
    "systemPipeShiny"
    "tabs"
    "teal_code"
    "wppi"
    # keep-sorted end
  ];

  packagesToSkipCheck = [
    # keep-sorted start
    "ReactomeContentService4R" # tries to connect to Reactome
    "coMethDMR" # tries to connect to ExperimentHub
    "multiMiR" # tries to connect to DB
    "rfaRm" # tries to connect to Ebi
    "snapcount" # tries to connect to snaptron.cs.jhu.edu
    # keep-sorted end
  ];

  # Packages which cannot be installed due to lack of dependencies or other reasons.
  brokenPackages = [
    # keep-sorted start
    "HIBAG"
    "HierO"
    "HilbertVisGUI" # depends on the deprecated gtk2 via gtkmm2
    "HiveR"
    "NetLogoR"
    "av"
    "minired" # deprecated on CRAN
    "netboost" # opens store path in append mode
    "valse"
    # keep-sorted end

    # Impure network access during build
    # keep-sorted start
    "BulkSignalR"
    "switchr"
    "tiledb"
    "waddR"
    # keep-sorted end

    # ExperimentHub dependents, require net access during build
    # keep-sorted start
    "CTexploreR"
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
    "hpar"
    "metaboliteIDmapping"
    "msigdb"
    "muscData"
    "nullrangesData"
    "org_Mxanthus_db"
    "scpdata"
    "signatureSearch"
    # keep-sorted end
  ];

  otherOverrides = old: new: {
    # keep-sorted start block=yes newline_separated=yes
    ACME = old.ACME.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        # Avoid incompatible pointer type error
        NIX_CFLAGS_COMPILE = attrs.env.NIX_CFLAGS_COMPILE + " -Wno-incompatible-pointer-types";
      };
    });

    AneuFinder = old.AneuFinder.overrideAttrs (attrs: {
      postPatch = ''
        substituteInPlace src/utility.cpp src/densities.cpp src/loghmm.cpp src/scalehmm.cpp \
          --replace-fail "Calloc(" "R_Calloc(" \
          --replace-fail "Free(" "R_Free("
      '';
    });

    BiocParallel = old.BiocParallel.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        NIX_CFLAGS_COMPILE =
          attrs.env.NIX_CFLAGS_COMPILE
          + lib.optionalString stdenv.hostPlatform.isDarwin " -Wno-error=missing-template-arg-list-after-template-kw";
      };
    });

    ChIPXpress = old.ChIPXpress.override { hydraPlatforms = [ ]; };

    ChemmineOB = old.ChemmineOB.overrideAttrs (attrs: {
      # pkg-config knows openbabel-3 without the .0
      # Eigen3 is also looked for in the wrong location
      # pointer was changed in newer version of openbabel:
      #   https://github.com/openbabel/openbabel/commit/305a6fd3183540e4a8ae1d79d10bf1860e6aa373
      postPatch = ''
        substituteInPlace configure \
          --replace-fail openbabel-3.0 openbabel-3
        substituteInPlace src/Makevars.in \
          --replace-fail "-I/usr/include/eigen3" "-I${pkgs.eigen}/include/eigen3"
        substituteInPlace src/ChemmineOB.cpp \
          --replace-fail "obsharedptr<" "std::shared_ptr<"
      '';

      # copied from fastnlo-toolkit:
      # None of our currently packaged versions of swig are C++17-friendly
      # Use a workaround from https://github.com/swig/swig/issues/1538
      env = (attrs.env or { }) // {
        NIX_CFLAGS_COMPILE =
          (attrs.env.NIX_CFLAGS_COMPILE or "")
          + lib.optionalString stdenv.hostPlatform.isDarwin " -D_LIBCPP_ENABLE_CXX17_REMOVED_FEATURES";
      };
    });

    FLAMES = old.FLAMES.overrideAttrs (attrs: {
      patches = [ ./patches/FLAMES.patch ];
    });

    FlexReg = old.FlexReg.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        # needed to avoid "log limit exceeded" on Hydra
        NIX_CFLAGS_COMPILE = attrs.env.NIX_CFLAGS_COMPILE + " -Wno-ignored-attributes";
      };

      # consumes a lot of resources in parallel
      enableParallelBuilding = false;
    });

    HilbertVis = old.HilbertVis.overrideAttrs (attrs: {
      hardeningDisable = [ "format" ];
    });

    JavaGD = old.JavaGD.overrideAttrs (attrs: {
      preConfigure = ''
        export JAVA_CPPFLAGS=-I${pkgs.jdk}/include/
        export JAVA_HOME=${pkgs.jdk}
      '';
    });

    MANOR = old.MANOR.overrideAttrs (attrs: {
      hardeningDisable = [ "format" ];
    });

    ModelMetrics = old.ModelMetrics.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        NIX_CFLAGS_COMPILE =
          attrs.env.NIX_CFLAGS_COMPILE + lib.optionalString stdenv.hostPlatform.isDarwin " -fopenmp";
      };
    });

    NGCHM = old.NGCHM.overrideAttrs (attrs: {
      postPatch = ''
        substituteInPlace "inst/base.config/conf.d/01-server-protocol-scl.R" \
          --replace-fail \
          "/bin/hostname" "${lib.getBin pkgs.hostname}/bin/hostname"
      '';
    });

    OpenMx = old.OpenMx.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        # needed to avoid "log limit exceeded" on Hydra
        NIX_CFLAGS_COMPILE = attrs.env.NIX_CFLAGS_COMPILE + " -Wno-ignored-attributes";
      };
    });

    PICS = old.PICS.overrideAttrs (attrs: {
      postPatch = ''
        # https://developer.r-project.org/blosxom.cgi/R-devel/NEWS/2025/01/08#n2025-01-08
        substituteInPlace "src/segment.c" \
        --replace-fail "Calloc" "R_Calloc"
      '';
    });

    RAppArmor = old.RAppArmor.overrideAttrs (attrs: {
      postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
        # ignore apparmor detection logic
        substituteInPlace configure \
          --replace-fail '[ ! -e "/sys/module/apparmor" ]' 'false'
      '';
    });

    RBioFormats = old.RBioFormats.overrideAttrs (attrs: {
      # 1. Never download the jar file
      # 2. Use jar from pkgs.bftools instead
      # 3. Break the build if versions don't match
      propagatedBuildInputs = (attrs.propagatedBuildInputs or [ ]) ++ [ pkgs.bftools ];

      postPatch = ''
        substituteInPlace "R/zzz.R" \
          --replace-fail '!file.exists(bf_jar)' 'FALSE' \
          --replace-fail \
          '.jpackage(pkg, lib.loc = lib, morePaths = c(jars, bf_jar))' \
          '.jpackage(pkg, lib.loc = lib, morePaths = union(jars, "${lib.getBin pkgs.bftools}/share/java/bioformats_package.jar"))' \
          --replace-fail 'bf_jar <-' 'stopifnot(bf_ver == "${pkgs.bftools.version}");bf_jar <-'
      '';

      # Ensure that bftools version matches that in the package DESCRIPTION
      preInstall = ''
        rbf_version="$(sed  -n 's/^BioFormats: //p' DESCRIPTION)"
        bf_version="${pkgs.bftools.version}"
        if [ "$rbf_version" != "$bf_version" ]; then
           echo "BioFormats version mismatch detected!"
           echo "RBioformats needs: $rbf_version"
           echo "bftools provides: $bf_version"
           exit 1
        fi
      '';
    });

    ROracle = old.ROracle.overrideAttrs (attrs: {
      configureFlags = [
        "--with-oci-lib=${lib.getLib pkgs.oracle-instantclient}/lib"
        "--with-oci-inc=${lib.getDev pkgs.oracle-instantclient}/include"
      ];
    });

    RProtoBuf = old.RProtoBuf.overrideAttrs (attrs: {
      configureFlags = [ "ac_cv_prog_cxx_cxx11=" ];
    });

    RVowpalWabbit = old.RVowpalWabbit.overrideAttrs (attrs: {
      configureFlags = [
        "--with-boost=${lib.getDev pkgs.boost}"
        "--with-boost-libdir=${lib.getLib pkgs.boost}/lib"
      ];
    });

    RandomFieldsUtils = old.RandomFieldsUtils.override {
      platforms = lib.platforms.x86_64 ++ lib.platforms.x86;
    };

    Rbwa = old.Rbwa.overrideAttrs (attrs: {
      # Parallel build cleans up *.o before they can be packed in a library
      postPatch = ''
        substituteInPlace src/Makefile --replace-fail \
          "all:\$(PROG) ../inst/bwa clean" \
          "all:\$(PROG) ../inst/bwa"
      '';
    });

    Rdisop = old.Rdisop.overrideAttrs (_: {
      hardeningDisable = [ "format" ];
    });

    Rhdf5lib =
      let
        hdf5 = pkgs.hdf5.overrideAttrs (attrs: {
          cmakeFlags = attrs.cmakeFlags ++ [ "-DHDF5_ENABLE_ROS3_VFD:BOOL=TRUE" ];
          buildInputs = attrs.buildInputs ++ [ pkgs.curl ];
          postInstall = attrs.postInstall or "" + ''
            cp src/libhdf5.settings $dev/lib
          '';
        });
      in
      old.Rhdf5lib.overrideAttrs (attrs: {
        propagatedBuildInputs = attrs.propagatedBuildInputs ++ [
          hdf5
          pkgs.libaec
        ];
        patches = [ ./patches/Rhdf5lib.patch ];
        passthru.hdf5 = hdf5;
      });

    Rhisat2 = old.Rhisat2.overrideAttrs (attrs: {
      enableParallelBuilding = false;
    });

    Rhtslib = old.Rhtslib.overrideAttrs (attrs: {
      preConfigure = ''
        substituteInPlace R/zzz.R --replace-fail "-lcurl" "-L${pkgs.curl.out}/lib -lcurl"
      '';
    });

    Rrdrand = old.Rrdrand.override { platforms = lib.platforms.x86_64 ++ lib.platforms.x86; };

    Rserve = old.Rserve.overrideAttrs (attrs: {
      patches = [ ./patches/Rserve.patch ];
      configureFlags = [
        "--with-server"
        "--with-client"
      ];
    });

    SAIGEgds = old.SAIGEgds.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        NIX_CFLAGS_COMPILE = attrs.env.NIX_CFLAGS_COMPILE + " -fpermissive";
      };
    });

    SICtools = old.SICtools.overrideAttrs (attrs: {
      postPatch = ''
        substituteInPlace src/Makefile --replace-fail "-lcurses" "-lncurses"
      '';
      hardeningDisable = [ "format" ];
    });

    SamplerCompare = old.SamplerCompare.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        PKG_LIBS = "-L${pkgs.blas}/lib -lblas -L${pkgs.lapack}/lib -llapack";
      };
    });

    SingleR = old.SingleR.overrideAttrs (attrs: {
      postPatch = ''
        substituteInPlace src/find_classic_markers.cpp --replace-fail \
          "Rcpp::IntegerVector val(de_n);" \
          "Rcpp::IntegerVector val(static_cast<int>(de_n));"
      '';
    });

    SynExtend = old.SynExtend.overrideAttrs (attrs: {
      # build might fail due to race condition
      enableParallelBuilding = false;
    });

    V8 = old.V8.overrideAttrs (attrs: {
      preConfigure = ''
        export V8_PKG_CFLAGS="$(pkg-config --cflags v8)";
        export V8_PKG_LIBS="$(pkg-config --libs v8)";
      '';

      env = (attrs.env or { }) // {
        R_MAKEVARS_SITE = lib.optionalString (pkgs.stdenv.system == "aarch64-linux") (
          pkgs.writeText "Makevars" ''
            CXX14PICFLAGS = -fPIC
          ''
        );
      };
    });

    XLConnect =
      let
        poi-ooxml-full = fetchurl {
          url = "https://repo1.maven.org/maven2/org/apache/poi/poi-ooxml-full/5.4.1/poi-ooxml-full-5.4.1.jar";
          hash = "sha256-xRsFFlXVjXTV64nn03NscFLCV09Dx52wyKg60hb23Tc=";
        };
        poi-ooxml = fetchurl {
          url = "https://repo1.maven.org/maven2/org/apache/poi/poi-ooxml/5.4.1/poi-ooxml-5.4.1.jar";
          hash = "sha256-/SAMnm901wQWCpfp1SBBmV7YdDlFRTAAHt2SBojxn1M=";
        };
        poi = fetchurl {
          url = "https://repo1.maven.org/maven2/org/apache/poi/poi/5.4.1/poi-5.4.1.jar";
          hash = "sha256-2lq/QtpGBMWnvKOJVq9unW8ZbZttTLfqvuT0gLWA1QU=";
        };
        commons-compress = fetchurl {
          url = "https://repo1.maven.org/maven2/org/apache/commons/commons-compress/1.27.1/commons-compress-1.27.1.jar";
          hash = "sha256-KT2A9UtTa3QJXc1+o88KKbv8NAJRkoEzJJX0Qg03DRY=";
        };
        commons-lang3 = fetchurl {
          url = "https://repo1.maven.org/maven2/org/apache/commons/commons-lang3/3.16.0/commons-lang3-3.16.0.jar";
          hash = "sha256-CHCd101gK3Bc5AF9JlRCEAVqS6WD1bIMCTc0Bv56APg=";
        };
        xmlbeans = fetchurl {
          url = "https://repo1.maven.org/maven2/org/apache/xmlbeans/xmlbeans/5.3.0/xmlbeans-5.3.0.jar";
          hash = "sha256-bMado7TTW4PF5HfNTauiBORBCYM+NK8rmoosh4gomRc=";
        };
        commons-collections4 = fetchurl {
          url = "https://repo1.maven.org/maven2/org/apache/commons/commons-collections4/4.4/commons-collections4-4.4.jar";
          hash = "sha256-Hfi5QwtcjtFD14FeQD4z71NxskAKrb6b2giDdi4IRtE=";
        };
        commons-math3 = fetchurl {
          url = "https://repo1.maven.org/maven2/org/apache/commons/commons-math3/3.6.1/commons-math3-3.6.1.jar";
          hash = "sha256-HlbXsFjSi2Wr0la4RY44hbZ0wdWI+kPNfRy7nH7yswg=";
        };
        log4j-api = fetchurl {
          url = "https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-api/2.24.3/log4j-api-2.24.3.jar";
          hash = "sha256-W0oKDNDnUd7UMcFiRCvb3VMyjR+Lsrrl/Bu+7g9m2A8=";
        };
        commons-codec = fetchurl {
          url = "https://repo1.maven.org/maven2/commons-codec/commons-codec/1.18.0/commons-codec-1.18.0.jar";
          hash = "sha256-ugBfMEzvkqPe3iSjitWsm4r8zw2PdYOdbBM4Y0z39uQ=";
        };
        commons-io = fetchurl {
          url = "https://repo1.maven.org/maven2/commons-io/commons-io/2.18.0/commons-io-2.18.0.jar";
          hash = "sha256-88oPjWPEDiOlbVQQHGDV7e4Ta0LYS/uFvHljCTEJz4s=";
        };
        SparseBitSet = fetchurl {
          url = "https://repo1.maven.org/maven2/com/zaxxer/SparseBitSet/1.3/SparseBitSet-1.3.jar";
          hash = "sha256-92uFrbDAByGuJnt8/eTaf3HTEhzCFgyfwAwMifjFPIo=";
        };
      in
      old.XLConnect.overrideAttrs (attrs: {
        preConfigure = ''
          cp ${poi-ooxml-full} inst/java/poi-ooxml-full-5.4.1.jar
          cp ${poi-ooxml} inst/java/poi-ooxml-5.4.1.jar
          cp ${poi} inst/java/poi-5.4.1.jar
          cp ${commons-compress} inst/java/commons-compress-1.27.1.jar
          cp ${commons-lang3} inst/java/commons-lang3-3.16.0.jar
          cp ${xmlbeans} inst/java/xmlbeans-5.3.0.jar
          cp ${commons-collections4} inst/java/commons-collections4-4.4.jar
          cp ${commons-math3} inst/java/commons-math3-3.6.1.jar
          cp ${log4j-api} inst/java/log4j-api-2.24.3.jar
          cp ${commons-codec} inst/java/commons-codec-1.18.0.jar
          cp ${commons-io} inst/java/commons-io-2.18.0.jar
          cp ${SparseBitSet} inst/java/SparseBitSet-1.3.jar
        '';

        postPatch = ''
          substituteInPlace R/onLoad.R \
            --replace-fail 'system2("java",' 'system2("${lib.getExe pkgs.jre_headless}",'

          # Misleading startup message, JARs are downloaded at build-time
          substituteInPlace R/onAttach.R \
            --replace-fail 'if(file.exists(file.path(libname, pkgname, ".fail"))){' 'if(FALSE){'
        '';
      });

    alcyon = old.alcyon.overrideAttrs (attrs: {
      configureFlags = [
        "--enable-force-openmp"
      ];
    });

    # it can happen that the major version of arrow-cpp is ahead of the
    # rPackages.arrow that would be built from CRAN sources; therefore, to avoid
    # build failures and manual updates of the hash, we use the R source at
    # the GitHub release state of libarrow (arrow-cpp) in Nixpkgs. This may
    # not exactly represent the CRAN sources, but because patching of the
    # CRAN R package is mostly done to meet special CRAN build requirements,
    # this is a straightforward approach. Example where patching was necessary
    # -> arrow 14.0.0.2 on CRAN; was lagging behind libarrow release:
    #   https://github.com/apache/arrow/issues/39698 )
    arrow = old.arrow.overrideAttrs (attrs: {
      src = pkgs.arrow-cpp.src;
      name = "r-arrow-${pkgs.arrow-cpp.version}";
      prePatch = "cd r";
      buildInputs = attrs.buildInputs ++ [
        pkgs.arrow-cpp
      ];
    });

    cisPath = old.cisPath.overrideAttrs (attrs: {
      hardeningDisable = [ "format" ];
    });

    covidsymptom = old.covidsymptom.overrideAttrs (attrs: {
      preConfigure = "rm R/covidsymptomdata.R";
    });

    cubature = old.cubature.overrideAttrs (attrs: {
      enableParallelBuilding = false;
    });

    data_table = old.data_table.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        NIX_CFLAGS_COMPILE = attrs.env.NIX_CFLAGS_COMPILE + " -fopenmp";
      };
    });

    dbarts = old.dbarts.override { platforms = lib.platforms.x86_64 ++ lib.platforms.x86; };

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

    findpython = old.findpython.overrideAttrs (attrs: {
      postPatch = ''
        substituteInPlace "R/find_python_cmd.r" \
          --replace-fail 'python_cmds[which(python_cmds != "")]' \
          'python_cmds <- c(python_cmds, file.path("${lib.getBin pkgs.python3}", "bin", "python3"))
           python_cmds[which(python_cmds != "")]'
      '';
    });

    float = old.float.overrideAttrs (attrs: {
      enableParallelBuilding = false;
    });

    flowClust = old.flowClust.override { platforms = lib.platforms.x86_64 ++ lib.platforms.x86; };

    gdtools = old.gdtools.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        NIX_LDFLAGS = "-lfontconfig -lfreetype";
      };
    });

    genoCN = old.genoCN.overrideAttrs (attrs: {
      postPatch = ''
        # https://developer.r-project.org/blosxom.cgi/R-devel/NEWS/2025/01/08#n2025-01-08
        substituteInPlace "src/xCNV.c" \
        --replace-fail "Calloc" "R_Calloc" \
        --replace-fail "Free" "R_Free"
      '';
    });

    geojsonio = old.geojsonio.overrideAttrs (attrs: {
      buildInputs = [ cacert ] ++ attrs.buildInputs;
    });

    geomorph = old.geomorph.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        RGL_USE_NULL = "true";
      };
    });

    gmapR = old.gmapR.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        # Avoid incompatible pointer type error
        NIX_CFLAGS_COMPILE =
          attrs.env.NIX_CFLAGS_COMPILE
          + " -Wno-implicit-function-declaration -Wno-incompatible-pointer-types";
      };
    });

    gpuMagic = old.gpuMagic.overrideAttrs (_: {
      hardeningDisable = [ "format" ];
    });

    h2o = old.h2o.overrideAttrs (attrs: {
      preConfigure = ''
        # prevent download of jar file during install and postpone to first use
        sed -i '/downloadJar()/d' R/zzz.R

        # during runtime the package directory is not writable as it's in the
        # nix store, so store the jar in the user's cache directory instead
        substituteInPlace R/connection.R --replace-fail \
          'dest_file <- file.path(dest_folder, "h2o.jar")' \
          'dest_file <- file.path("~/.cache/", "h2o.jar")'
      '';
    });

    harbinger = old.harbinger.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        LC_ALL = "en_US.UTF-8";
      };
    });

    hdf5r = old.hdf5r.overrideAttrs (attrs: {
      nativeBuildInputs = attrs.nativeBuildInputs ++ [ new.Rhdf5lib.hdf5 ];
      buildInputs = attrs.buildInputs ++ [ new.Rhdf5lib.hdf5 ];
    });

    immunotation =
      let
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
      in
      old.immunotation.overrideAttrs (attrs: {
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

    iscream = old.iscream.overrideAttrs (attrs: {
      # https://huishenlab.github.io/iscream/articles/htslib.html
      # Rhtslib (in LinkingTo) is not needed if we provide a proper htslib
      propagatedBuildInputs =
        builtins.filter (el: el != pkgs.rPackages.Rhtslib) attrs.propagatedBuildInputs
        ++ [ pkgs.htslib ];
    });

    littler = old.littler.overrideAttrs (attrs: {
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
      postPatch = ''
        substituteInPlace configure \
          --replace-fail '--libs SYMPHONY' '--libs symphony' \
          --replace-fail '--cflags SYMPHONY' '--cflags symphony'
      '';
    });

    luajr = old.luajr.overrideAttrs (attrs: {
      hardeningDisable = [ "format" ];
    });

    metahdep = old.metahdep.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        # Avoid incompatible pointer type error
        NIX_CFLAGS_COMPILE = attrs.env.NIX_CFLAGS_COMPILE + " -Wno-int-conversion";
      };
    });

    mongolite = old.mongolite.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        PKGCONFIG_CFLAGS = "-I${lib.getDev pkgs.openssl}/include -I${lib.getDev pkgs.cyrus_sasl}/include -I${lib.getDev pkgs.zlib}/include";
        PKGCONFIG_LIBS = "-Wl,-rpath,${lib.getLib pkgs.openssl}/lib -L${lib.getLib pkgs.openssl}/lib -L${pkgs.cyrus_sasl.out}/lib -L${pkgs.zlib.out}/lib -lssl -lcrypto -lsasl2 -lz";
      };
    });

    nanonext = old.nanonext.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        NIX_LDFLAGS = "-lnng -lmbedtls -lmbedx509 -lmbedcrypto";
      };
    });

    nearfar =
      let
        angrist = fetchurl {
          url = "https://raw.githubusercontent.com/joerigdon/nearfar/master/angrist.csv";
          hash = "sha256-lb+HMHnRGonc26merFGB0B7Vk1Lk+sIJlay+JtQC8m4=";
        };
      in
      old.nearfar.overrideAttrs (attrs: {
        postPatch = ''
          substituteInPlace "R/nearfar.R" --replace-fail \
           'url("https://raw.githubusercontent.com/joerigdon/nearfar/master/angrist.csv")'  '"${angrist}"'
        '';
      });

    networkscaleup = old.networkscaleup.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        # needed to avoid "log limit exceeded" on Hydra
        NIX_CFLAGS_COMPILE = attrs.env.NIX_CFLAGS_COMPILE + " -Wno-ignored-attributes";
      };

      # consumes a lot of resources in parallel
      enableParallelBuilding = false;
    });

    oligo = old.oligo.overrideAttrs (_: {
      hardeningDisable = [ "format" ];
    });

    opencv =
      let
        opencvGtk = pkgs.opencv.override (old: {
          enableGtk3 = true;
        });
      in
      old.opencv.overrideAttrs (attrs: {
        buildInputs = attrs.buildInputs ++ [ opencvGtk ];
      });

    openssl = old.openssl.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        PKGCONFIG_CFLAGS = "-I${lib.getDev pkgs.openssl}/include";
        PKGCONFIG_LIBS = "-Wl,-rpath,${lib.getLib pkgs.openssl}/lib -L${lib.getLib pkgs.openssl}/lib -lssl -lcrypto";
      };
    });

    pak = old.pak.overrideAttrs (attrs: {
      preConfigure = ''
        patchShebangs src/library/*/configure
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

    rGADEM = old.rGADEM.overrideAttrs (attrs: {
      hardeningDisable = [ "format" ];
    });

    rJava = old.rJava.overrideAttrs (attrs: {
      preConfigure = ''
        export JAVA_CPPFLAGS=-I${pkgs.jdk}/include/
        export JAVA_HOME=${pkgs.jdk}
        substituteInPlace R/zzz.R.in \
          --replace-fail ".onLoad <- function(libname, pkgname) {" \
            ".onLoad <- function(libname, pkgname) {
             Sys.setenv(\"JAVA_HOME\" = Sys.getenv(\"JAVA_HOME\", unset = \"${pkgs.jdk}\"))"
      '';
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

    redatamx = old.redatamx.overrideAttrs (
      finalAttrs: previousAttrs:
      let
        fetchCore =
          { platform, hash }:
          pkgs.fetchzip {
            name = "redatam-core-${platform}-${finalAttrs.version}";
            url = "https://redatam-core.s3.us-west-2.amazonaws.com/core-dev/${platform}/redatamx-core-${platform}-${finalAttrs.version}-final.zip";
            inherit hash;
          };
      in
      {
        passthru = (previousAttrs.passthru or { }) // {
          redatam-core-per-system = {
            "x86_64-linux" = fetchCore {
              platform = "linux";
              hash = "sha256-LNusDc4K6B+kAd+qWo789eiQG0dToEwu/RWwoFEjgRo=";
            };
            "aarch64-darwin" = fetchCore {
              platform = "macos-arm64";
              hash = "sha256-l7qLjM6jDtytAPgY7qVuVPEE6HUnZ1fPFxAzS6VnFY4=";
            };
          };

          redatam-core = finalAttrs.passthru.redatam-core-per-system.${stdenv.hostPlatform.system};
        };

        # upstream is checking for the wrong filename, so it tries and fails to download redatam-core
        # even if it's already installed to the target location, so let's just disable the check
        postPatch = ''
          substituteInPlace configure \
            --replace-fail '[ ! -e inst/redengine/$engine_file ]' 'false'
        '';

        preConfigure = ''
          install -Dm755 ${finalAttrs.passthru.redatam-core}/lib/libredengine* -t ./inst/redengine/
        '';

        meta = (previousAttrs.meta or { }) // {
          platforms = lib.attrNames finalAttrs.passthru.redatam-core-per-system;
          license = lib.licenses.unfree; # See https://github.com/ideasybits/redatamx4r/blob/main/inst/License.txt
        };
      }
    );

    redland = old.redland.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        PKGCONFIG_CFLAGS = "-I${pkgs.redland}/include -I${pkgs.librdf_raptor2}/include/raptor2 -I${pkgs.librdf_rasqal}/include/rasqal";
        PKGCONFIG_LIBS = "-L${pkgs.redland}/lib -L${pkgs.librdf_raptor2}/lib -L${pkgs.librdf_rasqal}/lib -lrdf -lraptor2 -lrasqal";
      };
    });

    # Append cargo path to path variable
    # This will provide cargo in case it's not set by the user
    rextendr = old.rextendr.overrideAttrs (attrs: {
      postPatch = ''
        substituteInPlace R/zzz.R --replace-fail \
          ".onLoad <- function(...) {" \
          '.onLoad <- function(...) {
           Sys.setenv(PATH = paste0(Sys.getenv("PATH"), ":${lib.getBin pkgs.cargo}/bin"))'
      '';
    });

    rgl = old.rgl.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        RGL_USE_NULL = "true";
      };
    });

    rgoslin = old.rgoslin.overrideAttrs (attrs: {
      enableParallelBuilding = false;
    });

    rhdf5 = old.rhdf5.overrideAttrs (attrs: {
      patches = [ ./patches/rhdf5.patch ];
      env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
    });

    rhdf5filters = old.rhdf5filters.overrideAttrs (attrs: {
      patches = [ ./patches/rhdf5filters.patch ];
    });

    rlibkriging = old.rlibkriging.overrideAttrs (attrs: {
      preConfigure = ''
        patchShebangs tools/ src/libK/tools/
      '';
    });

    rmarkdown = old.rmarkdown.overrideAttrs (_: {
      preConfigure = ''
        substituteInPlace R/pandoc.R \
          --replace-fail '"~/opt/pandoc"' '"~/opt/pandoc", "${pkgs.pandoc}/bin"'
      '';
    });

    roxigraph = old.roxigraph.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        LIBCLANG_PATH = "${lib.getLib pkgs.libclang}/lib";
      };
    });

    rpanel = old.rpanel.overrideAttrs (attrs: {
      preConfigure = ''
        export TCLLIBPATH="${pkgs.tclPackages.bwidget}/lib/bwidget${pkgs.tclPackages.bwidget.version}"
      '';
      env = (attrs.env or { }) // {
        TCLLIBPATH = "${pkgs.tclPackages.bwidget}/lib/bwidget${pkgs.tclPackages.bwidget.version}";
      };
    });

    rstan = old.rstan.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        NIX_CFLAGS_COMPILE = attrs.env.NIX_CFLAGS_COMPILE + " -DBOOST_PHOENIX_NO_VARIADIC_EXPRESSION";
      };
    });

    rstanarm = old.rstanarm.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        # needed to avoid "log limit exceeded" on Hydra
        NIX_CFLAGS_COMPILE = attrs.env.NIX_CFLAGS_COMPILE + " -Wno-ignored-attributes";
      };
    });

    rvisidata = old.rvisidata.overrideAttrs (attrs: {
      postPatch = ''
        substituteInPlace R/main.r --replace-fail \
          "system(\"vd" "system(\"${lib.getBin pkgs.visidata}/bin/vd"
        substituteInPlace R/tmux.r --replace-fail \
          "return(\"vd\")" "return(\"${lib.getBin pkgs.visidata}/bin/vd\")"
      '';
    });

    s2 = old.s2.overrideAttrs (attrs: {
      preConfigure = ''
        substituteInPlace "configure" \
          --replace-fail "absl_s2" "absl_flags absl_check"
      '';
    });

    slfm = old.slfm.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        PKG_LIBS = "-L${pkgs.blas}/lib -lblas -L${pkgs.lapack}/lib -llapack";
      };
    });

    sparklyr = old.sparklyr.overrideAttrs (attrs: {
      # Pyspark's spark is full featured and better maintained than pkgs.spark
      preConfigure = ''
        if grep "onLoad" R/zzz.R; then
          echo "onLoad is already present, patch needs to be updated!"
          exit 1
        fi

        cat >> R/zzz.R <<EOF
        .onLoad <- function(...) {
          Sys.setenv("SPARK_HOME" = Sys.getenv("SPARK_HOME", unset = "${pkgs.python3Packages.pyspark}/${pkgs.python3Packages.python.sitePackages}/pyspark"))
          Sys.setenv("JAVA_HOME" = Sys.getenv("JAVA_HOME", unset = "${pkgs.jdk}"))
        }
        EOF
      '';
    });

    symengine = old.symengine.overrideAttrs (_: {
      preConfigure = ''
        rm configure
        cat > src/Makevars << EOF
        PKG_LIBS=-lsymengine
        all: $(SHLIB)
        EOF
      '';
    });

    talib = old.talib.overrideAttrs (attrs: {
      # the conftest.c compilation test fails because for some reason ta-lib doesn't link libm
      env = (attrs.env or { }) // {
        NIX_LDFLAGS = (attrs.env.NIX_LDFLAGS or "") + " -lm";
      };
    });

    tesseract = old.tesseract.overrideAttrs (_: {
      preConfigure = ''
        substituteInPlace configure \
          --replace-fail 'PKG_CONFIG_NAME="tesseract"' 'PKG_CONFIG_NAME="tesseract lept"'
      '';
    });

    textshaping = old.textshaping.overrideAttrs (attrs: {
      env.NIX_LDFLAGS = "-lfribidi -lharfbuzz";
    });

    timeless = old.timeless.overrideAttrs (attrs: {
      cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
        src = attrs.src;
        sourceRoot = "timeless/src/rust";
        hash = "sha256-5TV7iCzaaFwROfJNO6pvSUbJBzV+wZlU5+ZK4AMT6X0=";
      };

      cargoRoot = "src/rust";

      nativeBuildInputs = attrs.nativeBuildInputs ++ [
        pkgs.rustPlatform.cargoSetupHook
        pkgs.cargo
      ];
    });

    trajeR = old.trajeR.overrideAttrs (attrs: {
      patches = [ ./patches/trajeR.patch ];
    });

    trigger = old.trigger.overrideAttrs (attrs: {
      postPatch = ''
        # https://developer.r-project.org/blosxom.cgi/R-devel/NEWS/2025/01/08#n2025-01-08
        substituteInPlace "src/trigger.c" \
        --replace-fail "Calloc" "R_Calloc" \
        --replace-fail "Free" "R_Free"
      '';
    });

    universalmotif = old.universalmotif.overrideAttrs (attrs: {
      patches = [ ./patches/universalmotif.patch ];
    });

    unix = old.unix.overrideAttrs (attrs: {
      postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
        # ignore apparmor detection logic
        substituteInPlace configure \
          --replace-fail '[ ! -d "/sys/module/apparmor" ]' 'false'
      '';
    });

    vegan3d = old.vegan3d.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        RGL_USE_NULL = "true";
      };
    });

    websocket = old.websocket.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        PKGCONFIG_CFLAGS = "-I${lib.getDev pkgs.openssl}/include";
        PKGCONFIG_LIBS = "-Wl,-rpath,${lib.getLib pkgs.openssl}/lib -L${lib.getLib pkgs.openssl}/lib -lssl -lcrypto";
      };
    });

    xslt = old.xslt.overrideAttrs (attrs: {
      env = (attrs.env or { }) // {
        NIX_CFLAGS_COMPILE = attrs.env.NIX_CFLAGS_COMPILE + " -fpermissive";
      };
    });
    # keep-sorted end
  };
in
self
