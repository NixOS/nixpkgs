/* This file defines the composition for CRAN (R) packages. */

{ pkgs, overrides }:

let
  inherit (pkgs) R fetchurl stdenv lib xvfb_run utillinux;

  buildRPackage = import ./generic-builder.nix { inherit R xvfb_run utillinux ; };

  # Package template
  #
  # some packages, e.g. cncaGUI, require X running while installation,
  # so that we use xvfb-run if requireX is true.
  derive = lib.makeOverridable ({
        name, version, sha256,
        depends ? [],
        doCheck ? true,
        requireX ? false,
        broken ? false,
        hydraPlatforms ? R.meta.hydraPlatforms
      }: buildRPackage {
    name = "${name}-${version}";
    src = fetchurl {
      urls = [
        "mirror://cran/src/contrib/${name}_${version}.tar.gz"
        "mirror://cran/src/contrib/Archive/${name}/${name}_${version}.tar.gz"
      ];
      inherit sha256;
    };
    inherit doCheck requireX;
    propagatedBuildInputs = depends;
    nativeBuildInputs = depends;
    meta.homepage = "http://cran.r-project.org/web/packages/${name}/";
    meta.platforms = R.meta.platforms;
    meta.hydraPlatforms = hydraPlatforms;
    meta.broken = broken;
  });

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
    let
      attrNames = builtins.attrNames overrides;
      nameValuePairs = map (name: rec {
        inherit name;
        nativeBuildInputs = builtins.getAttr name overrides;
        value = (builtins.getAttr name old).overrideDerivation (attrs: {
          nativeBuildInputs = attrs.nativeBuildInputs ++ nativeBuildInputs;
        });
      }) attrNames;
    in
      builtins.listToAttrs nameValuePairs;

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
    let
      attrNames = builtins.attrNames overrides;
      nameValuePairs = map (name: rec {
        inherit name;
        buildInputs = builtins.getAttr name overrides;
        value = (builtins.getAttr name old).overrideDerivation (attrs: {
          buildInputs = attrs.buildInputs ++ buildInputs;
        });
      }) attrNames;
    in
      builtins.listToAttrs nameValuePairs;

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
      old3 = old2 // (overrideNativeBuildInputs packagesWithNativeBuildInputs old2);
      old4 = old3 // (overrideBuildInputs packagesWithBuildInputs old3);
      old5 = old4 // (overrideBroken brokenPackages old4);
      old = old5;
    in old // (otherOverrides old new);

  # Recursive override pattern.
  # `_self` is a collection of packages;
  # `self` is `_self` with overridden packages;
  # packages in `_self` may depends on overridden packages.
  self = (defaultOverrides _self self) // overrides;
  _self = import ./cran-packages.nix { inherit self derive; };

  # tweaks for the individual packages and "in self" follow

  packagesWithNativeBuildInputs = {
    # sort -t '=' -k 2
    RAppArmor = [ pkgs.apparmor ];
    SOD = [ pkgs.cudatoolkit ]; # requres CL/cl.h
    curl = [ pkgs.curl pkgs.openldap ];
    Rssa = [ pkgs.fftw ];
    fftw = [ pkgs.fftw ];
    fftwtools = [ pkgs.fftw ];
    kza = [ pkgs.fftw ];
    mwaved = [ pkgs.fftw ];
    spate = [ pkgs.fftw ];
    chebpol = [ pkgs.fftw ];
    seewave = [ pkgs.fftw pkgs.libsndfile ];
    rgeos = [ pkgs.geos ];
    Rglpk = [ pkgs.glpk ];
    RCA = [ pkgs.gmp ];
    gmp = [ pkgs.gmp ];
    rcdd = [ pkgs.gmp ];
    igraph = [ pkgs.gmp ];
    glpkAPI = [ pkgs.gmp pkgs.glpk ];
    sdcTable = [ pkgs.gmp pkgs.glpk ];
    Rmpfr = [ pkgs.gmp pkgs.mpfr ];
    BNSP = [ pkgs.gsl ];
    BayesSAE = [ pkgs.gsl ];
    BayesVarSel = [ pkgs.gsl ];
    HiCseg = [ pkgs.gsl ];
    KFKSDS = [ pkgs.gsl ];
    R2GUESS = [ pkgs.gsl ];
    RcppZiggurat = [ pkgs.gsl ];
    SemiCompRisks = [ pkgs.gsl ];
    VBLPCM = [ pkgs.gsl ];
    abn = [ pkgs.gsl ];
    cit = [ pkgs.gsl ];
    libamtrack = [ pkgs.gsl ];
    mixcat = [ pkgs.gsl ];
    outbreaker = [ pkgs.gsl ];
    pcaPA = [ pkgs.gsl ];
    ridge = [ pkgs.gsl ];
    simplexreg = [ pkgs.gsl ];
    stsm = [ pkgs.gsl ];
    survSNP = [ pkgs.gsl ];
    topicmodels = [ pkgs.gsl ];
    RcppGSL = [ pkgs.gsl ];
    bnpmr = [ pkgs.gsl ];
    geoCount = [ pkgs.gsl ];
    gsl = [ pkgs.gsl ];
    mvabund = [ pkgs.gsl ];
    diversitree = [ pkgs.gsl pkgs.fftw ];
    VBmix = [ pkgs.gsl pkgs.fftw pkgs.qt4 ];
    RGtk2 = [ pkgs.gtk2 ];
    cairoDevice = [ pkgs.gtk2 ];
    adimpro = [ pkgs.imagemagick ];
    rjags = [ pkgs.jags ];
    runjags = [ pkgs.jags ];
    JavaGD = [ pkgs.jdk ];
    RODBC = [ pkgs.libiodbc ];
    RODBCext = [ pkgs.libiodbc ];
    jpeg = [ pkgs.libjpeg ];
    EMCluster = [ pkgs.liblapack ];
    png = [ pkgs.libpng ];
    rtiff = [ pkgs.libtiff ];
    tiff = [ pkgs.libtiff ];
    Cairo = [ pkgs.libtiff pkgs.libjpeg pkgs.cairo ];
    XML = [ pkgs.libtool pkgs.libxml2 pkgs.xmlsec pkgs.libxslt ];
    rpud = [ pkgs.linuxPackages.nvidia_x11 ];
    CARramps = [ pkgs.linuxPackages.nvidia_x11 pkgs.liblapack ];
    rgl = [ pkgs.mesa pkgs.x11 ];
    ncdf = [ pkgs.netcdf ];
    ncdf4 = [ pkgs.netcdf ];
    pbdNCDF4 = [ pkgs.netcdf ];
    RNetCDF = [ pkgs.netcdf pkgs.udunits ];
    nloptr = [ pkgs.nlopt ];
    npRmpi = [ pkgs.openmpi ];
    pbdPROF = [ pkgs.openmpi ];
    sprint = [ pkgs.openmpi ];
    Rmpi = [ pkgs.openmpi ];
    openssl = [ pkgs.openssl ];
    PKI = [ pkgs.openssl ];
    RSclient = [ pkgs.openssl ];
    Rserve = [ pkgs.openssl ];
    Rpoppler = [ pkgs.poppler ];
    audio = [ pkgs.portaudio ];
    rpg = [ pkgs.postgresql ];
    RPostgreSQL = [ pkgs.postgresql ];
    ssanv = [ pkgs.proj ];
    proj4 = [ pkgs.proj ];
    rgdal = [ pkgs.proj pkgs.gdal ];
    RProtoBuf = [ pkgs.protobuf ];
    rPython = [ pkgs.python ];
    qtpaint = [ pkgs.qt4 ];
    qtbase = [ pkgs.qt4 ];
    BayesXsrc = [ pkgs.readline pkgs.ncurses ];
    udunits2 = [ pkgs.udunits pkgs.expat ];
    tkrplot = [ pkgs.xlibs.libX11 ];
    rzmq = [ pkgs.zeromq2 ];
    PopGenome = [ pkgs.zlib ];
    RJaCGH = [ pkgs.zlib ];
    RcppCNPy = [ pkgs.zlib ];
    Rniftilib = [ pkgs.zlib ];
    WhopGenome = [ pkgs.zlib ];
    devEMF = [ pkgs.zlib ];
    gdsfmt = [ pkgs.zlib ];
    rbamtools = [ pkgs.zlib ];
    rmatio = [ pkgs.zlib ];
    RVowpalWabbit = [ pkgs.zlib pkgs.boost ];
    seqminer = [ pkgs.zlib pkgs.bzip2 ];
    rphast = [ pkgs.zlib pkgs.bzip2 pkgs.gzip pkgs.readline ];
    rtfbs = [ pkgs.zlib pkgs.bzip2 pkgs.gzip pkgs.readline ];
    Rhpc = [ pkgs.zlib pkgs.bzip2 pkgs.icu pkgs.lzma pkgs.openmpi pkgs.pcre ];
    SAVE = [ pkgs.zlib pkgs.bzip2 pkgs.icu pkgs.lzma pkgs.pcre ];
    RcppOctave = [ pkgs.zlib pkgs.bzip2 pkgs.icu pkgs.lzma pkgs.pcre pkgs.octave ];
    rJava = [ pkgs.zlib pkgs.bzip2 pkgs.icu pkgs.lzma pkgs.pcre pkgs.jdk pkgs.libzip ];
    R2SWF = [ pkgs.zlib pkgs.libpng pkgs.freetype ];
    sysfonts = [ pkgs.zlib pkgs.libpng pkgs.freetype ];
    showtext = [ pkgs.zlib pkgs.libpng pkgs.icu pkgs.freetype ];
    XBRL = [ pkgs.zlib pkgs.libxml2 ];
    RMySQL = [ pkgs.zlib pkgs.mysql ];
  };

  packagesWithBuildInputs = {
    # sort -t '=' -k 2
    qtpaint = [ pkgs.cmake ];
    qtbase = [ pkgs.cmake pkgs.perl ];
    gmatrix = [ pkgs.cudatoolkit ];
    WideLM = [ pkgs.cudatoolkit ];
    RCurl = [ pkgs.curl ];
    Rgnuplot = [ pkgs.gnuplot ];
    R2SWF = [ pkgs.pkgconfig ];
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
    tcltk2 = [ pkgs.tcl pkgs.tk ];
    tikzDevice = [ pkgs.texLive ];
    rPython = [ pkgs.which ];
    CARramps = [ pkgs.which pkgs.cudatoolkit ];
    gputools = [ pkgs.which pkgs.cudatoolkit ];
    rpud = [ pkgs.which pkgs.cudatoolkit ];
    adimpro = [ pkgs.which pkgs.xorg.xdpyinfo ];
    PET = [ pkgs.which pkgs.xorg.xdpyinfo pkgs.imagemagick ];
    dti = [ pkgs.which pkgs.xorg.xdpyinfo pkgs.imagemagick ];
  };

  packagesRequireingX = [
    "AnalyzeFMRI"
    "AnnotLists"
    "AnthropMMD"
    "AtelieR"
    "BAT"
    "BCA"
    "BEQI2"
    "BHMSMAfMRI"
    "BioGeoBEARS"
    "BiodiversityR"
    "CCTpack"
    "CommunityCorrelogram"
    "ConvergenceConcepts"
    "DALY"
    "DSpat"
    "Deducer"
    "DeducerExtras"
    "DeducerPlugInExample"
    "DeducerPlugInScaling"
    "DeducerSpatial"
    "DeducerSurvival"
    "DeducerText"
    "Demerelate"
    "DescTools"
    "DivMelt"
    "ENiRG"
    "EcoVirtual"
    "EnQuireR"
    "FAiR"
    "FD"
    "FFD"
    "FeedbackTS"
    "FreeSortR"
    "GGEBiplotGUI"
    "GPCSIV"
    "GUniFrac"
    "Geneland"
    "GeoGenetix"
    "GeoXp"
    "GrammR"
    "GrapheR"
    "GroupSeq"
    "HH"
    "HiveR"
    "IsotopeR"
    "JGR"
    "KappaGUI"
    "LS2Wstat"
    "MAR1"
    "MTurkR"
    "MVPARTwrap"
    "MareyMap"
    "MergeGUI"
    "Meth27QC"
    "MicroStrategyR"
    "MissingDataGUI"
    "MplusAutomation"
    "OligoSpecificitySystem"
    "OpenRepGrid"
    "PBSadmb"
    "PBSmodelling"
    "PCPS"
    "PKmodelFinder"
    "PoMoS"
    "PopGenReport"
    "PredictABEL"
    "PrevMap"
    "ProbForecastGOP"
    "QCAGUI"
    "R2STATS"
    "RHRV"
    "RNCEP"
    "RQDA"
    "RSDA"
    "RSurvey"
    "RandomFields"
    "Rcmdr"
    "RcmdrPlugin_BCA"
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
    "RcmdrPlugin_NMBU"
    "RcmdrPlugin_ROC"
    "RcmdrPlugin_SCDA"
    "RcmdrPlugin_SLC"
    "RcmdrPlugin_SM"
    "RcmdrPlugin_StatisticalURV"
    "RcmdrPlugin_TeachingDemos"
    "RcmdrPlugin_UCA"
    "RcmdrPlugin_coin"
    "RcmdrPlugin_depthTools"
    "RcmdrPlugin_doex"
    "RcmdrPlugin_epack"
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
    "SPACECAP"
    "SRRS"
    "SSDforR"
    "STEPCAM"
    "SYNCSA"
    "Simile"
    "SimpleTable"
    "StatDA"
    "SyNet"
    "TDMR"
    "TED"
    "TIMP"
    "TTAinterfaceTrendAnalysis"
    "TestScorer"
    "VIMGUI"
    "VecStatGraphs3D"
    "VisuClust"
    "WMCapacity"
    "accrual"
    "ade4TkGUI"
    "adehabitat"
    "analogue"
    "analogueExtra"
    "aplpack"
    "aqfig"
    "arf3DS4"
    "asbio"
    "bayesDem"
    "betapart"
    "betaper"
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
    "debug"
    "detrendeR"
    "dgmb"
    "dpa"
    "dynBiplotGUI"
    "dynamicGraph"
    "eVenn"
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
    "geoRglm"
    "geomorph"
    "georob"
    "gnm"
    "gsubfn"
    "iBUGS"
    "iDynoR"
    "ic50"
    "in2extRemes"
    "iplots"
    "isopam"
    "likeLTD"
    "loe"
    "logmult"
    "memgene"
    "metacom"
    "migui"
    "miniGUI"
    "mixsep"
    "mlDNA"
    "mpmcorrelogram"
    "mritc"
    "multgee"
    "multibiplotGUI"
    "nodiv"
    "onemap"
    "palaeoSig"
    "paleoMAS"
    "pbatR"
    "pez"
    "phylotools"
    "picante"
    "playwith"
    "plotSEMM"
    "plsRbeta"
    "plsRglm"
    "pmg"
    "poppr"
    "powerpkg"
    "prefmod"
    "qtbase"
    "qtpaint"
    "qtutils"
    "r4ss"
    "rAverage"
    "rareNMtests"
    "recluster"
    "relax"
    "relimp"
    "reportRx"
    "reshapeGUI"
    "rgl"
    "rich"
    "ringscale"
    "rioja"
    "ripa"
    "rite"
    "rnbn"
    "rriskDistributions"
    "rsgcc"
    "sdcMicroGUI"
    "sharpshootR"
    "simba"
    "soundecology"
    "spacodiR"
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
    "xergm"
  ];

  packagesToSkipCheck = [
    "Rmpi" # tries to run MPI processes
    "gmatrix" # requires CUDA runtime
    "npRmpi" # tries to run MPI processes
    "sprint" # tries to run MPI processes
  ];

  # Packages which cannot be installed due to lack of dependencies or other reasons.
  brokenPackages = [
    # sort -t '#' -k 2

    "rpanel" # I could not make Tcl to recognize BWidget. HELP WANTED!
    "MigClim" # SDMTools.So: Undefined Symbol: X
    "PatternClass" # SDMTools.So: Undefined Symbol: X
    "Actigraphy" # SDMTools.so: undefined symbol: X
    "lefse" # SDMTools.so: undefined symbol: X
    "raincpc" # SDMTools.so: undefined symbol: X
    "rainfreq" # SDMTools.so: undefined symbol: X
    "CARrampsOcl" # depends on OpenCL
    "RGA" # jsonlite.so: undefined symbol: XXX
    "RSiteCatalyst" # jsonlite.so: undefined symbol: XXX
    "RSocrata" # jsonlite.so: undefined symbol: XXX
    "SGP" # jsonlite.so: undefined symbol: XXX
    "SocialMediaMineR" # jsonlite.so: undefined symbol: XXX
    "WikipediR" # jsonlite.so: undefined symbol: XXX
    "alm" # jsonlite.so: undefined symbol: XXX
    "archivist" # jsonlite.so: undefined symbol: XXX
    "bold" # jsonlite.so: undefined symbol: XXX
    "enigma" # jsonlite.so: undefined symbol: XXX
    "exCon" # jsonlite.so: undefined symbol: XXX
    "gender" # jsonlite.so: undefined symbol: XXX
    "jSonarR" # jsonlite.so: undefined symbol: XXX
    "leafletR" # jsonlite.so: undefined symbol: XXX
    "opencpu" # jsonlite.so: undefined symbol: XXX
    "pdfetch" # jsonlite.so: undefined symbol: XXX
    "polidata" # jsonlite.so: undefined symbol: XXX
    "pollstR" # jsonlite.so: undefined symbol: XXX
    "rHealthDataGov" # jsonlite.so: undefined symbol: XXX
    "rWBclimate" # jsonlite.so: undefined symbol: XXX
    "rbison" # jsonlite.so: undefined symbol: XXX
    "rinat" # jsonlite.so: undefined symbol: XXX
    "rjstat" # jsonlite.so: undefined symbol: XXX
    "rmongodb" # jsonlite.so: undefined symbol: XXX
    "rnoaa" # jsonlite.so: undefined symbol: XXX
    "rsunlight" # jsonlite.so: undefined symbol: XXX
    "slackr" # jsonlite.so: undefined symbol: XXX
    "webutils" # jsonlite.so: undefined symbol: XXX
    "msarc" # requires AnnotationDbi
    "MetaLandSim" # requires Biobase
    "RobLox" # requires Biobase
    "RobLoxBioC" # requires Biobase
    "compendiumdb" # requires Biobase
    "ktspair" # requires Biobase
    "permGPU" # requires Biobase
    "propOverlap" # requires Biobase
    "GExMap" # requires Biobase and multtest
    "IsoGene" # requires Biobase, and affy
    "mGSZ" # requires Biobase, and limma
    "netweavers" # requires BiocGenerics, Biobase, and limma
    "NCmisc" # requires BiocInstaller
    "EMDomics" # requires BiocParallel
    "RADami" # requires Biostrings
    "ionflows" # requires Biostrings
    "RAPIDR" # requires Biostrings, Rsamtools, and GenomicRanges
    "SimRAD" # requires Biostrings, and ShortRead
    "SeqFeatR" # requires Biostrings, qvalue, and widgetTools
    "OpenCL" # requires CL/opencl.h
    "cplexAPI" # requires CPLEX
    "empiricalFDR_DESeq2" # requires DESeq2, and GenomicRanges
    "CHAT" # requires DNAcopy
    "PSCBS" # requires DNAcopy
    "ParDNAcopy" # requires DNAcopy
    "Rcell" # requires EBImage
    "RockFab" # requires EBImage
    "gitter" # requires EBImage
    "rggobi" # requires GGobi
    "PANDA" # requires GO.db
    "BiSEp" # requires GOSemSim, GO.db, and org.Hs.eg.db
    "PubMedWordcloud" # requires GOsummaries
    "ExomeDepth" # requires GenomicRanges, and Rsamtools
    "HTSDiff" # requires HTSCluster
    "RAM" # requires Heatplus
    "RcppRedis" # requires Hiredis
    "MSIseq" # requires IRanges
    "SNPtools" # requires IRanges, GenomicRanges, Biostrings, and Rsamtools
    "interval" # requires Icens
    "PhViD" # requires LBE
    "rLindo" # requires LINDO API
    "magma" # requires MAGMA
    "HiPLARM" # requires MAGMA or PLASMA
    "bigGP" # requires MPI running. HELP WANTED!
    "doMPI" # requires MPI running. HELP WANTED!
    "metaMix" # requires MPI running. HELP WANTED!
    "pbdMPI" # requires MPI running. HELP WANTED!
    "pmclust" # requires MPI running. HELP WANTED!
    "MSeasyTkGUI" # requires MSeasyTkGUI
    "bigpca" # requires NCmisc
    "reader" # requires NCmisc
    "ROracle" # requires OCI
    "BRugs" # requires OpenBUGS
    "smart" # requires PMA
    "aroma_cn" # requires PSCBS
    "aroma_core" # requires PSCBS
    "RQuantLib" # requires QuantLib
    "RSeed" # requires RBGL, and graph
    "gRbase" # requires RBGL, and graph
    "ora" # requires ROracle
    "semiArtificial" # requires RSNNS
    "branchLars" # requires Rgraphviz
    "gcExplorer" # requires Rgraphviz
    "hasseDiagram" # requires Rgraphviz
    "hpoPlot" # requires Rgraphviz
    "strum" # requires Rgraphviz
    "dagbag" # requires Rlapack
    "ltsk" # requires Rlapack and Rblas
    "REBayes" # requires Rmosek
    "cqrReg" # requires Rmosek
    "LinRegInteractive" # requires Rpanel
    "RVideoPoker" # requires Rpanel
    "ArrayBin" # requires SAGx
    "RSAP" # requires SAPNWRFCSDK
    "DBKGrad" # requires SDD
    "pubmed_mineR" # requires SSOAP
    "ENA" # requires WGCNA
    "GOGANPA" # requires WGCNA
    "nettools" # requires WGCNA
    "rneos" # requires XMLRPC
    "demi" # requires affy, affxparser, and oligo
    "KANT" # requires affy, and Biobase
    "pathClass" # requires affy, and Biobase
    "ACNE" # requires aroma_affymetrix
    "NSA" # requires aroma_core
    "aroma_affymetrix" # requires aroma_core
    "calmate" # requires aroma_core
    "beadarrayFilter" # requires beadarray
    "PepPrep" # requires biomaRt
    "snplist" # requires biomaRt
    "FunctionalNetworks" # requires breastCancerVDX, and Biobase
    "rJPSGCS" # requires chopsticks
    "clpAPI" # requires clp
    "pcaL1" # requires clp
    "bmrm" # requires clpAPI
    "sequenza" # requires copynumber
    "Rcplex" # requires cplexAPI
    "dcGOR" # requires dnet
    "bcool" # requires doMPI
    "GSAgm" # requires edgeR
    "HTSCluster" # requires edgeR
    "QuasiSeq" # requires edgeR
    "SimSeq" # requires edgeR
    "babel" # requires edgeR
    "edgeRun" # requires edgeR
    "BcDiag" # requires fabia
    "superbiclust" # requires fabia
    "curvHDR" # requires flowCore
    "RbioRXN" # requires fmcsR, and KEGGREST
    "D2C" # requires gRbase
    "LogisticDx" # requires gRbase
    "gRain" # requires gRbase
    "gRc" # requires gRbase
    "gRim" # requires gRbase
    "topologyGSA" # requires gRbase
    "qdap" # requires gender
    "orQA" # requires genefilter
    "apmsWAPP" # requires genefilter, Biobase, multtest, edgeR, DESeq, and aroma.light
    "miRtest" # requires globaltest, GlobalAncova, and limma
    "PairViz" # requires graph
    "eulerian" # requires graph
    "gRapHD" # requires graph
    "msSurv" # requires graph
    "QuACN" # requires graph, RBGL
    "RnavGraph" # requires graph, and RBGL
    "iRefR" # requires graph, and RBGL
    "pcalg" # requires graph, and RBGL
    "protiq" # requires graph, and RBGL
    "classGraph" # requires graph, and Rgraphviz
    "epoc" # requires graph, and Rgraphviz
    "gridGraphviz" # requires graph, and Rgraphviz
    "ddepn" # requires graph, and genefilter
    "gridDebug" # requires gridGraphviz
    "FAMT" # requires impute
    "PMA" # requires impute
    "WGCNA" # requires impute
    "moduleColor" # requires impute
    "samr" # requires impute
    "swamp" # requires impute
    "MetaDE" # requires impute, and Biobase
    "FHtest" # requires interval
    "RefFreeEWAS" # requires isva
    "AntWeb" # requires leafletR
    "ecoengine" # requires leafletR
    "spocc" # requires leafletR
    "sybilSBML" # requires libSBML
    "RDieHarder" # requires libdieharder
    "CORM" # requires limma
    "DAAGbio" # requires limma
    "DCGL" # requires limma
    "SQDA" # requires limma
    "metaMA" # requires limma
    "plmDE" # requires limma
    "RPPanalyzer" # requires limma, and Biobase
    "PerfMeas" # requires limma, graph, and RBGL
    "MAMA" # requires metaMA
    "Rmosek" # requires mosek
    "PCS" # requires multtest
    "TcGSA" # requires multtest
    "hddplot" # requires multtest
    "mutoss" # requires multtest
    "structSSI" # requires multtest
    "mutossGUI" # requires mutoss
    "Biograph" # requires mvna
    "MSeasy" # requires mzR, and xcms
    "x_ent" # requires opencpu
    "pbdBASE" # requires pbdMPI
    "pbdDEMO" # requires pbdMPI
    "pbdDMAT" # requires pbdMPI
    "pbdSLAP" # requires pbdMPI
    "LOST" # requires pcaMethods
    "agridat" # requires pcaMethods
    "multiDimBio" # requires pcaMethods
    "crmn" # requires pcaMethods, and Biobase
    "imputeLCMD" # requires pcaMethods, and impute
    "MEET" # requires pcaMethods, and seqLogo
    "qtlnet" # requires pcalg
    "SigTree" # requires phyloseq
    "saps" # requires piano, and survcomp
    "surveillance" # requires polyCub
    "aLFQ" # requires protiq
    "NLPutils" # requires qdap
    "NBPSeq" # requires qvalue
    "RSNPset" # requires qvalue
    "evora" # requires qvalue
    "isva" # requires qvalue
    "pi0" # requires qvalue
    "CrypticIBDcheck" # requires rJPSGCS
    "PKgraph" # requires rggobi
    "SeqGrapheR" # requires rggobi
    "beadarrayMSV" # requires rggobi
    "clusterfly" # requires rggobi
    "HierO" # requires rneos
    "fPortfolio" # requires rneos
    "GUIDE" # requires rpanel
    "SDD" # requires rpanel
    "biotools" # requires rpanel
    "erpR" # requires rpanel
    "gamlss_demo" # requires rpanel
    "lgcp" # requires rpanel
    "optBiomarker" # requires rpanel
    "soilphysics" # requires rpanel
    "vows" # requires rpanel
    "PCGSE" # requires safe
    "DepthProc" # requires samr
    "netClass" # requires samr
    "RcmdrPlugin_seeg" # requires seeg
    "EMA" # requires siggenes, affy, multtest, gcrma, biomaRt, and AnnotationDbi
    "GeneticTools" # requires snpStats
    "snpEnrichment" # requires snpStats
    "snpStatsWriter" # requires snpStats
    "wgsea" # requires snpStats
    "rysgran" # requires soiltexture
    "DSpat" # requires spatstat
    "Digiroo2" # requires spatstat
    "ETAS" # requires spatstat
    "GriegSmith" # requires spatstat
    "RImageJROI" # requires spatstat
    "SGCS" # requires spatstat
    "SpatialVx" # requires spatstat
    "adaptsmoFMRI" # requires spatstat
    "ads" # requires spatstat
    "aoristic" # requires spatstat
    "dbmss" # requires spatstat
    "dixon" # requires spatstat
    "dpcR" # requires spatstat
    "ecespa" # requires spatstat
    "ecospat" # requires spatstat
    "intamapInteractive" # requires spatstat
    "latticeDensity" # requires spatstat
    "polyCub" # requires spatstat
    "seeg" # requires spatstat
    "siar" # requires spatstat
    "siplab" # requires spatstat
    "sparr" # requires spatstat
    "spatialsegregation" # requires spatstat
    "stpp" # requires spatstat
    "trip" # requires spatstat
    "dnet" # requires supraHex, graph, Rgraphviz, and Biobase
    "plsRcox" # requires survcomp
    "rsig" # requires survcomp
    "leapp" # requires sva
    "ttScreening" # requires sva, and limma
    "cudaBayesreg" # requres Rmath
    "taxize" # requres bold
    "rsprng" # requres sprng
    "evobiR" # requres taxiz
    "RNeXML" # requres taxize
    "TR8" # requres taxize
    "bdvis" # requres taxize
  ];

  otherOverrides = old: new: {
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
      PKG_LIBS = "-L${pkgs.atlas}/lib -lf77blas -latlas";
    });

    qtbase = old.qtbase.overrideDerivation (attrs: {
      patches = [ ./patches/qtbase.patch ];
    });

    Rmpi = old.Rmpi.overrideDerivation (attrs: {
      configureFlags = [
        "--with-Rmpi-type=OPENMPI"
      ];
    });

    npRmpi = old.npRmpi.overrideDerivation (attrs: {
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
      LIBAPPARMOR_HOME = "${pkgs.apparmor}";
    });

    RMySQL = old.RMySQL.overrideDerivation (attrs: {
      configureFlags = [
        "--with-mysql-dir=${pkgs.mysql}"
      ];
    });

    slfm = old.slfm.overrideDerivation (attrs: {
      PKG_LIBS = "-L${pkgs.atlas}/lib -lf77blas -latlas";
    });

    SamplerCompare = old.SamplerCompare.overrideDerivation (attrs: {
      PKG_LIBS = "-L${pkgs.atlas}/lib -lf77blas -latlas";
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
      CUDA_INC_PATH = "${pkgs.cudatoolkit}/usr_include";
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
    });

    BayesBridge = old.BayesBridge.overrideDerivation (attrs: {
      patches = [ ./patches/BayesBridge.patch ];
    });

    openssl = old.openssl.overrideDerivation (attrs: {
      patches = [ ./patches/openssl.patch ];
      OPENSSL_HOME = "${pkgs.openssl}";
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
  };
in
  self
