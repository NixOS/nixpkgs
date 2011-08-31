# Haskell packages in Nixpkgs
#
# If you have any questions about the packages defined here or how to
# contribute, please contact Andres Loeh.
#
# This file defines all packages that depend on GHC, the Glasgow Haskell
# compiler. They are usually distributed via Hackage, the central Haskell
# package repository. Since at least the libraries are incompatible between
# different compiler versions, the whole file is parameterized by the GHC
# that is being used. GHC itself is defined in all-packages.nix
#
# Note that next to the packages defined here, there is another way to build
# arbitrary packages from HackageDB in Nix, using the hack-nix tool that is
# developed by Marc Weber.
# -> http://github.com/MarcWeber/hack-nix. Read its README file.
#
#
# This file defines a function parameterized by the following:
#
#    pkgs:
#       the whole Nixpkgs (so that we can depend on non-Haskell packages)
#
#    newScope:
#       for redefining callPackage locally to resolve dependencies of
#       Haskell packages automatically
#
#    ghc:
#       the GHC version to be used for building the Haskell packages
#
#    prefFun:
#       version preferences for Haskell packages (see below)
#
#    enableLibraryProfiling:
#       Boolean flag indicating whether profiling libraries for all Haskell
#       packages should be built. If a library is to be built with profiling
#       enabled, its dependencies should have profiling enabled as well.
#       Therefore, this is implemented as a global flag.
#
#    modifyPrio:
#       Either the identity function or lowPrio is intended to be passed
#       here. The idea is that we can make a complete set of Haskell packages
#       have low priority from the outside.
#
#
# Policy for keeping multiple versions:
#
# We keep multiple versions for
#
#    * packages that are part of the Haskell Platform
#    * packages that are known to have severe interface changes
#
# For the packages where we keep multiple versions, version x.y.z is mapped
# to an attribute of name package_x_y_z and stored in a Nix expression called
# x.y.z.nix. There is no default.nix for such packages. There also is an
# attribute package that is defined to be self.package_x_y_z where x.y.z is
# the default version of the package. The global default can be overridden by
# passing a preferences function.
#
# For most packages, however, we keep only one version, and use default.nix.

{pkgs, newScope, ghc, prefFun, enableLibraryProfiling ? false, modifyPrio ? (x : x)}:

# We redefine callPackage to take into account the new scope. The optional
# modifyPrio argument can be set to lowPrio to make all Haskell packages have
# low priority.

let result = let callPackage = x : y : modifyPrio (newScope result.final x y);
                 self = (prefFun result) result; in

# Indentation deliberately broken at this point to keep the bulk
# of this file at a low indentation level.

{

  final = self;

  # Preferences
  #
  # Different versions of GHC need different versions of certain core packages.
  # We start with a suitable platform version per GHC version.

  emptyPrefs   = super : super // { };
  ghc6104Prefs = super : super // super.haskellPlatformDefaults_2009_2_0_2 super;
  ghc6121Prefs = super : super // super.haskellPlatformDefaults_2010_1_0_0 super;
  ghc6122Prefs = super : super // super.haskellPlatformDefaults_2010_2_0_0 super; # link
  ghc6123Prefs = super : super // super.haskellPlatformDefaults_2010_2_0_0 super;
  ghc701Prefs  = super : super // super.haskellPlatformDefaults_2011_2_0_0 super; # link
  ghc702Prefs  = super : super // super.haskellPlatformDefaults_2011_2_0_0 super;
  ghc703Prefs  = super : super // super.haskellPlatformDefaults_2011_2_0_1 super;
  ghc704Prefs  = super : super // super.haskellPlatformDefaults_2011_2_0_1 super; # link
  ghc721Prefs  = super : super // super.haskellPlatformDefaults_future super;
  ghcHEADPrefs = super : super // super.haskellPlatformDefaults_future super; # link

  # GHC and its wrapper
  #
  # We use a wrapped version of GHC for nearly everything. The wrapped version
  # adds functionality to GHC to find libraries depended on or installed via
  # Nix. Because the wrapper is so much more useful than the plain GHC, we
  # call the plain GHC ghcPlain and the wrapped GHC simply ghc.

  ghcPlain = pkgs.lowPrio ghc; # Note that "ghc" is not "self.ghc" and
                               # refers to the function argument at the
                               # top of this file.

  ghc = callPackage ../development/compilers/ghc/wrapper.nix {
    ghc = ghc;
  };

  # This is the Cabal builder, the function we use to build most Haskell
  # packages. It isn't the Cabal library, which is a core package of GHC
  # and therefore not separately listed here.

  cabal = callPackage ../development/libraries/haskell/cabal/cabal.nix {
    enableLibraryProfiling = enableLibraryProfiling;
  };

  # Haskell Platform
  #
  # We try to support several platform versions. For these, we set all
  # versions explicitly.

  # NOTE: 2011.2.0.1 is the current default.

  haskellPlatformArgs_future = self : {
    inherit (self) cabal ghc;
    cgi          = self.cgi_3001_1_7_4; # 7.2 ok, 7.3 ok
    fgl          = self.fgl_5_4_2_4; # 7.2 ok, 7.3 fails
    GLUT         = self.GLUT_2_1_2_1; # 7.2 ok, 7.3 ok
    haskellSrc   = self.haskellSrc_1_0_1_4; # 7.2 fails, 7.3 fails
    html         = self.html_1_0_1_2; # 7.2 ok, 7.3 ok
    HUnit        = self.HUnit_1_2_2_3; # 7.2 ok, 7.3 ok
    network      = self.network_2_3_0_5; # 7.2 ok, 7.3 ok
    OpenGL       = self.OpenGL_2_2_3_0; # 7.2 ok, 7.3 ok
    parallel     = self.parallel_3_1_0_1; # 7.2 ok, 7.3 ok
    parsec       = self.parsec_3_1_1; # 7.2 ok, 7.3 ok
    QuickCheck   = self.QuickCheck_2_4_0_1; # 7.2 ok, 7.3 ok
    regexBase    = self.regexBase_0_93_2; # 7.2 ok, 7.3 ok
    regexCompat  = self.regexCompat_0_93_1; # 7.2 ok, 7.3 ok
    regexPosix   = self.regexPosix_0_94_4; # 7.2 ok, 7.3 ok
    stm          = self.stm_2_2_0_1; # 7.2 ok, 7.3 ok
    syb          = self.syb_0_3_3; # 7.2 ok, 7.3 ok
    xhtml        = self.xhtml_3000_2_0_1; # 7.2 ok, 7.3 ok
    zlib         = self.zlib_0_5_3_1; # 7.2 ok, 7.3 ok
    HTTP         = self.HTTP_4000_1_2; # 7.2 ok, 7.3 fails
    deepseq      = self.deepseq_1_1_0_2; # 7.2 ok, 7.3 ok
    text         = self.text_0_11_1_5; # 7.2 ok, 7.3 fails
    transformers = self.transformers_0_2_2_0; # 7.2 ok, 7.3 ok
    mtl          = self.mtl_2_0_1_0; # 7.2 ok, 7.3 ok
    random       = self.random_1_0_0_3; # 7.2 ok, 7.3 ok
    cabalInstall = self.cabalInstall_0_10_2; # 7.2 fails, 7.3 fails
    alex         = self.alex_3_0_1; # 7.2 ok, 7.3 ok
    happy        = self.happy_1_18_6; # 7.2 ok, 7.3 ok
    haddock      = self.haddock_2_9_2; # 7.2 fails, 7.3 fails
  };

  haskellPlatformDefaults_future =
    self : self.haskellPlatformArgs_future self // {
      mtl1 = self.mtl_1_1_1_1; # 7.2 ok, 7.3 ok
    };

  haskellPlatformArgs_2011_2_0_1 = self : {
    inherit (self) cabal ghc;
    cgi          = self.cgi_3001_1_7_4;
    fgl          = self.fgl_5_4_2_3;
    GLUT         = self.GLUT_2_1_2_1;
    haskellSrc   = self.haskellSrc_1_0_1_4;
    html         = self.html_1_0_1_2;
    HUnit        = self.HUnit_1_2_2_3;
    network      = self.network_2_3_0_2;
    OpenGL       = self.OpenGL_2_2_3_0;
    parallel     = self.parallel_3_1_0_1;
    parsec       = self.parsec_3_1_1;
    QuickCheck   = self.QuickCheck_2_4_0_1;
    regexBase    = self.regexBase_0_93_2;
    regexCompat  = self.regexCompat_0_93_1;
    regexPosix   = self.regexPosix_0_94_4;
    stm          = self.stm_2_2_0_1;
    syb          = self.syb_0_3;
    xhtml        = self.xhtml_3000_2_0_1;
    zlib         = self.zlib_0_5_3_1;
    HTTP         = self.HTTP_4000_1_1;
    deepseq      = self.deepseq_1_1_0_2;
    text         = self.text_0_11_0_6;
    transformers = self.transformers_0_2_2_0;
    mtl          = self.mtl_2_0_1_0;
    cabalInstall = self.cabalInstall_0_10_2;
    alex         = self.alex_2_3_5;
    happy        = self.happy_1_18_6;
    haddock      = self.haddock_2_9_2;
  };

  haskellPlatformDefaults_2011_2_0_1 =
    self : self.haskellPlatformArgs_2011_2_0_1 self // {
      haskellPlatform = self.haskellPlatform_2011_2_0_1;
      mtl1 = self.mtl_1_1_1_1;
      text = self.text_0_11_1_5;
    };

  haskellPlatform_2011_2_0_1 =
    callPackage ../development/libraries/haskell/haskell-platform/2011.2.0.1.nix
      (self.haskellPlatformArgs_2011_2_0_1 self);

  haskellPlatformArgs_2011_2_0_0 = self : {
    inherit (self) cabal ghc;
    cgi          = self.cgi_3001_1_7_4;
    fgl          = self.fgl_5_4_2_3;
    GLUT         = self.GLUT_2_1_2_1;
    haskellSrc   = self.haskellSrc_1_0_1_4;
    html         = self.html_1_0_1_2;
    HUnit        = self.HUnit_1_2_2_3;
    network      = self.network_2_3_0_2;
    OpenGL       = self.OpenGL_2_2_3_0;
    parallel     = self.parallel_3_1_0_1;
    parsec       = self.parsec_3_1_1;
    QuickCheck   = self.QuickCheck_2_4_0_1;
    regexBase    = self.regexBase_0_93_2;
    regexCompat  = self.regexCompat_0_93_1;
    regexPosix   = self.regexPosix_0_94_4;
    stm          = self.stm_2_2_0_1;
    syb          = self.syb_0_3;
    xhtml        = self.xhtml_3000_2_0_1;
    zlib         = self.zlib_0_5_3_1;
    HTTP         = self.HTTP_4000_1_1;
    deepseq      = self.deepseq_1_1_0_2;
    text         = self.text_0_11_0_5;
    transformers = self.transformers_0_2_2_0;
    mtl          = self.mtl_2_0_1_0;
    cabalInstall = self.cabalInstall_0_10_2;
    alex         = self.alex_2_3_5;
    happy        = self.happy_1_18_6;
    haddock      = self.haddock_2_9_2;
  };

  haskellPlatformDefaults_2011_2_0_0 =
    self : self.haskellPlatformArgs_2011_2_0_0 self // {
      haskellPlatform = self.haskellPlatform_2011_2_0_0;
      mtl1 = self.mtl_1_1_1_1;
    };

  haskellPlatform_2011_2_0_0 =
    callPackage ../development/libraries/haskell/haskell-platform/2011.2.0.0.nix
      (self.haskellPlatformArgs_2011_2_0_0 self);

  haskellPlatformArgs_2010_2_0_0 = self : {
    inherit (self) cabal ghc;
    cgi          = self.cgi_3001_1_7_3;
    fgl          = self.fgl_5_4_2_3;
    GLUT         = self.GLUT_2_1_2_1;
    haskellSrc   = self.haskellSrc_1_0_1_3;
    html         = self.html_1_0_1_2;
    HUnit        = self.HUnit_1_2_2_1;
    mtl          = self.mtl_1_1_0_2;
    network      = self.network_2_2_1_7;
    OpenGL       = self.OpenGL_2_2_3_0;
    parallel     = self.parallel_2_2_0_1;
    parsec       = self.parsec_2_1_0_1;
    QuickCheck   = self.QuickCheck_2_1_1_1;
    regexBase    = self.regexBase_0_93_2;
    regexCompat  = self.regexCompat_0_93_1;
    regexPosix   = self.regexPosix_0_94_2;
    stm          = self.stm_2_1_2_1;
    xhtml        = self.xhtml_3000_2_0_1;
    zlib         = self.zlib_0_5_2_0;
    HTTP         = self.HTTP_4000_0_9;
    deepseq      = self.deepseq_1_1_0_0;
    cabalInstall = self.cabalInstall_0_8_2;
    alex         = self.alex_2_3_3;
    happy        = self.happy_1_18_5;
    haddock      = self.haddock_2_7_2;
  };

  haskellPlatformDefaults_2010_2_0_0 =
    self : self.haskellPlatformArgs_2010_2_0_0 self // {
      haskellPlatform = self.haskellPlatform_2010_2_0_0;
    };

  haskellPlatform_2010_2_0_0 =
    callPackage ../development/libraries/haskell/haskell-platform/2010.2.0.0.nix
      (self.haskellPlatformArgs_2010_2_0_0 self);

  haskellPlatformArgs_2010_1_0_0 = self : {
    inherit (self) cabal ghc;
    haskellSrc   = self.haskellSrc_1_0_1_3;
    html         = self.html_1_0_1_2;
    fgl          = self.fgl_5_4_2_2;
    cabalInstall = self.cabalInstall_0_8_0;
    GLUT         = self.GLUT_2_1_2_1;
    OpenGL       = self.OpenGL_2_2_3_0;
    zlib         = self.zlib_0_5_2_0;
    alex         = self.alex_2_3_2;
    cgi          = self.cgi_3001_1_7_2;
    QuickCheck   = self.QuickCheck_2_1_0_3;
    HTTP         = self.HTTP_4000_0_9;
    HUnit        = self.HUnit_1_2_2_1;
    network      = self.network_2_2_1_7;
    parallel     = self.parallel_2_2_0_1;
    parsec       = self.parsec_2_1_0_1;
    regexBase    = self.regexBase_0_93_1;
    regexCompat  = self.regexCompat_0_92;
    regexPosix   = self.regexPosix_0_94_1;
    stm          = self.stm_2_1_1_2;
    xhtml        = self.xhtml_3000_2_0_1;
    haddock      = self.haddock_2_7_2;
    happy        = self.happy_1_18_4;
  };

  haskellPlatformDefaults_2010_1_0_0 =
    self : self.haskellPlatformArgs_2010_1_0_0 self // {
      haskellPlatform = self.haskellPlatform_2010_1_0_0;
      extensibleExceptions = self.extensibleExceptions_0_1_1_0;
    };

  haskellPlatform_2010_1_0_0 =
    callPackage ../development/libraries/haskell/haskell-platform/2010.1.0.0.nix
      (self.haskellPlatformArgs_2010_1_0_0 self);

  haskellPlatformArgs_2009_2_0_2 = self : {
    inherit (self) cabal ghc editline;
    time         = self.time_1_1_2_4;
    haddock      = self.haddock_2_4_2;
    cgi          = self.cgi_3001_1_7_1;
    fgl          = self.fgl_5_4_2_2;
    GLUT         = self.GLUT_2_1_1_2;
    haskellSrc   = self.haskellSrc_1_0_1_3;
    html         = self.html_1_0_1_2;
    HUnit        = self.HUnit_1_2_0_3;
    network      = self.network_2_2_1_4;
    OpenGL       = self.OpenGL_2_2_1_1;
    parallel     = self.parallel_1_1_0_1;
    parsec       = self.parsec_2_1_0_1;
    QuickCheck   = self.QuickCheck_1_2_0_0;
    regexBase    = self.regexBase_0_72_0_2;
    regexCompat  = self.regexCompat_0_71_0_1;
    regexPosix   = self.regexPosix_0_72_0_3;
    stm          = self.stm_2_1_1_2;
    xhtml        = self.xhtml_3000_2_0_1;
    zlib         = self.zlib_0_5_0_0;
    HTTP         = self.HTTP_4000_0_6;
    cabalInstall = self.cabalInstall_0_6_2;
    alex         = self.alex_2_3_1;
    happy        = self.happy_1_18_4;
  };

  haskellPlatformDefaults_2009_2_0_2 =
    self : self.haskellPlatformArgs_2009_2_0_2 self // {
      haskellPlatform = self.haskellPlatform_2009_2_0_2;
      extensibleExceptions = self.extensibleExceptions_0_1_1_0;
    };

  haskellPlatform_2009_2_0_2 =
    callPackage ../development/libraries/haskell/haskell-platform/2009.2.0.2.nix
      (self.haskellPlatformArgs_2009_2_0_2 self);


  # Haskell libraries.

  Agda = callPackage ../development/libraries/haskell/Agda {
    syb = self.syb02;
    haskellSrcExts = self.haskellSrcExts_1_9_6;
  };

  ACVector = callPackage ../development/libraries/haskell/AC-Vector {};

  aeson = callPackage ../development/libraries/haskell/aeson {};

  aesonNative = callPackage ../development/libraries/haskell/aeson-native {};

  ansiTerminal = callPackage ../development/libraries/haskell/ansi-terminal {};

  ansiWlPprint = callPackage ../development/libraries/haskell/ansi-wl-pprint {};

  asn1Data = callPackage ../development/libraries/haskell/asn1-data {};

  AspectAG = callPackage ../development/libraries/haskell/AspectAG {};

  async = callPackage ../development/libraries/haskell/async {};

  attempt = callPackage ../development/libraries/haskell/attempt {};

  attoparsec = callPackage ../development/libraries/haskell/attoparsec {};

  attoparsecEnumerator = callPackage ../development/libraries/haskell/attoparsec/enumerator.nix {};

  attoparsecText = callPackage ../development/libraries/haskell/attoparsec-text {};

  attoparsecTextEnumerator = callPackage ../development/libraries/haskell/attoparsec-text-enumerator {};

  authenticate = callPackage ../development/libraries/haskell/authenticate {};

  base64String = callPackage ../development/libraries/haskell/base64-string {};

  base64Bytestring = callPackage ../development/libraries/haskell/base64-bytestring {};

  baseUnicodeSymbols = callPackage ../development/libraries/haskell/base-unicode-symbols {};

  benchpress = callPackage ../development/libraries/haskell/benchpress {
    time = self.time_1_1_3;
  };

  bimap = callPackage ../development/libraries/haskell/bimap {};

  binary = callPackage ../development/libraries/haskell/binary {};

  binaryShared = callPackage ../development/libraries/haskell/binary-shared {};

  bitmap = callPackage ../development/libraries/haskell/bitmap {};

  bktrees = callPackage ../development/libraries/haskell/bktrees {};

  blazeBuilder = callPackage ../development/libraries/haskell/blaze-builder {};

  blazeBuilderEnumerator = callPackage ../development/libraries/haskell/blaze-builder-enumerator {};

  blazeHtml = callPackage ../development/libraries/haskell/blaze-html {};

  blazeTextual = callPackage ../development/libraries/haskell/blaze-textual {};

  blazeTextualNative = callPackage ../development/libraries/haskell/blaze-textual-native {};

  bmp = callPackage ../development/libraries/haskell/bmp {};

  Boolean = callPackage ../development/libraries/haskell/Boolean {};

  bytestringNums = callPackage ../development/libraries/haskell/bytestring-nums {};

  bytestringMmap = callPackage ../development/libraries/haskell/bytestring-mmap {};

  bytestringTrie = callPackage ../development/libraries/haskell/bytestring-trie {};

  cairo = callPackage ../development/libraries/haskell/cairo {
    inherit (pkgs) cairo zlib;
  };

  caseInsensitive_0_3 = callPackage ../development/libraries/haskell/case-insensitive/0.3.nix {};
  caseInsensitive_0_3_0_1 = callPackage ../development/libraries/haskell/case-insensitive/0.3.0.1.nix {};
  caseInsensitive = self.caseInsensitive_0_3_0_1;

  cautiousFile = callPackage ../development/libraries/haskell/cautious-file {};

  cereal = callPackage ../development/libraries/haskell/cereal {};

  certificate = callPackage ../development/libraries/haskell/certificate {};

  cgi_3001_1_7_1 = callPackage ../development/libraries/haskell/cgi/3001.1.7.1.nix {};
  cgi_3001_1_7_2 = callPackage ../development/libraries/haskell/cgi/3001.1.7.2.nix {};
  cgi_3001_1_7_3 = callPackage ../development/libraries/haskell/cgi/3001.1.7.3.nix {};
  cgi_3001_1_7_4 = callPackage ../development/libraries/haskell/cgi/3001.1.7.4.nix {};
  cgi_3001_1_8_2 = callPackage ../development/libraries/haskell/cgi/3001.1.8.2.nix {};
  cgi = self.cgi_3001_1_7_1;

  Chart = callPackage ../development/libraries/haskell/Chart {};

  citeprocHs = callPackage ../development/libraries/haskell/citeproc-hs {};

  clientsession = callPackage ../development/libraries/haskell/clientsession {};

  cmdargs = callPackage ../development/libraries/haskell/cmdargs {};

  cmdlib = callPackage ../development/libraries/haskell/cmdlib {};

  colorizeHaskell = callPackage ../development/libraries/haskell/colorize-haskell {};

  colour = callPackage ../development/libraries/haskell/colour {};

  ConfigFile = callPackage ../development/libraries/haskell/ConfigFile {};

  controlMonadAttempt = callPackage ../development/libraries/haskell/control-monad-attempt {};

  convertible = callPackage ../development/libraries/haskell/convertible {
    time = self.time_1_1_3;
  };

  continuedFractions = callPackage ../development/libraries/haskell/continued-fractions {};

  converge = callPackage ../development/libraries/haskell/converge {};

  cookie = callPackage ../development/libraries/haskell/cookie {};

  cprngAes = callPackage ../development/libraries/haskell/cprng-aes {};

  criterion = callPackage ../development/libraries/haskell/criterion {
    parsec = self.parsec3;
  };

  Crypto = callPackage ../development/libraries/haskell/Crypto {};

  cryptoApi = callPackage ../development/libraries/haskell/crypto-api {};

  cryptocipher = callPackage ../development/libraries/haskell/cryptocipher {};

  cryptohash = callPackage ../development/libraries/haskell/cryptohash {};

  csv = callPackage ../development/libraries/haskell/csv {};

  cssText = callPackage ../development/libraries/haskell/css-text {};

  dataAccessor = callPackage ../development/libraries/haskell/data-accessor/data-accessor.nix {};

  dataAccessorTemplate = callPackage ../development/libraries/haskell/data-accessor/data-accessor-template.nix {};

  dataDefault = callPackage ../development/libraries/haskell/data-default {};

  dataenc = callPackage ../development/libraries/haskell/dataenc {};

  dataReify = callPackage ../development/libraries/haskell/data-reify {};

  datetime = callPackage ../development/libraries/haskell/datetime {};

  deepseq_1_1_0_0 = callPackage ../development/libraries/haskell/deepseq/1.1.0.0.nix {};
  deepseq_1_1_0_2 = callPackage ../development/libraries/haskell/deepseq/1.1.0.2.nix {};
  deepseq = self.deepseq_1_1_0_0;

  derive = callPackage ../development/libraries/haskell/derive {};

  Diff = callPackage ../development/libraries/haskell/Diff {};

  digest = callPackage ../development/libraries/haskell/digest {
    inherit (pkgs) zlib;
  };

  dimensional = callPackage ../development/libraries/haskell/dimensional {};

  directoryTree = callPackage ../development/libraries/haskell/directory-tree {};

  dlist = callPackage ../development/libraries/haskell/dlist {};

  dotgen = callPackage ../development/libraries/haskell/dotgen {};

  doubleConversion = callPackage ../development/libraries/haskell/double-conversion {};

  editline = callPackage ../development/libraries/haskell/editline {
    inherit (pkgs) libedit;
  };

  emailValidate = callPackage ../development/libraries/haskell/email-validate {};

  enumerator = callPackage ../development/libraries/haskell/enumerator {};

  entropy = callPackage ../development/libraries/haskell/entropy {};

  erf = callPackage ../development/libraries/haskell/erf {};

  filepath = callPackage ../development/libraries/haskell/filepath {};

  extensibleExceptions_0_1_1_0 = callPackage ../development/libraries/haskell/extensible-exceptions/0.1.1.0.nix {};
  extensibleExceptions_0_1_1_2 = callPackage ../development/libraries/haskell/extensible-exceptions/0.1.1.2.nix {};
  extensibleExceptions_0_1_1_3 = callPackage ../development/libraries/haskell/extensible-exceptions/0.1.1.3.nix {};
  extensibleExceptions = null; # a core package in recent GHCs

  failure = callPackage ../development/libraries/haskell/failure {};

  fclabels = callPackage ../development/libraries/haskell/fclabels {};

  funcmp = callPackage ../development/libraries/haskell/funcmp {};

  feed = callPackage ../development/libraries/haskell/feed {};

  fileEmbed = callPackage ../development/libraries/haskell/file-embed {};

  flexibleDefaults = callPackage ../development/libraries/haskell/flexible-defaults {};

  filestore = callPackage ../development/libraries/haskell/filestore {};

  fgl_5_4_2_2 = callPackage ../development/libraries/haskell/fgl/5.4.2.2.nix {};
  fgl_5_4_2_3 = callPackage ../development/libraries/haskell/fgl/5.4.2.3.nix {};
  fgl_5_4_2_4 = callPackage ../development/libraries/haskell/fgl/5.4.2.4.nix {};
  fgl = self.fgl_5_4_2_2;

  fingertree = callPackage ../development/libraries/haskell/fingertree {};

  gamma = callPackage ../development/libraries/haskell/gamma {};

  gdiff = callPackage ../development/libraries/haskell/gdiff {};

  getOptions = callPackage ../development/libraries/haskell/get-options {};

  ghcCore = callPackage ../development/libraries/haskell/ghc-core {};

  ghcEvents = callPackage ../development/libraries/haskell/ghc-events {
    mtl = self.mtl1;
  };

  ghcMtl = callPackage ../development/libraries/haskell/ghc-mtl {};

  ghcPaths_0_1_0_5 = callPackage ../development/libraries/haskell/ghc-paths/0.1.0.5.nix {};
  ghcPaths_0_1_0_6 = callPackage ../development/libraries/haskell/ghc-paths/0.1.0.6.nix {};
  ghcPaths_0_1_0_8 = callPackage ../development/libraries/haskell/ghc-paths/0.1.0.8.nix {};
  ghcPaths = self.ghcPaths_0_1_0_6; # version 0.1.0.5 doesn't build with an up-to-date GHC

  ghcSyb = callPackage ../development/libraries/haskell/ghc-syb {};

  ghcSybUtils = callPackage ../development/libraries/haskell/ghc-syb-utils {};

  gitit = callPackage ../development/libraries/haskell/gitit {
    xssSanitize = self.xssSanitize_0_2_6;
  };

  glade = callPackage ../development/libraries/haskell/glade {
    inherit (pkgs) pkgconfig glibc;
    inherit (pkgs.gnome) libglade;
    gtkC = pkgs.gnome.gtk;
  };

  glib = callPackage ../development/libraries/haskell/glib {
    inherit (pkgs) pkgconfig glib glibc;
  };

  GlomeVec = callPackage ../development/libraries/haskell/GlomeVec {};

  GLURaw = callPackage ../development/libraries/haskell/GLURaw {
    GLU = pkgs.freeglut;
  };

  GLUT_2_1_1_2 = callPackage ../development/libraries/haskell/GLUT/2.1.1.2.nix {
    glut = pkgs.freeglut;
    inherit (pkgs) mesa;
    inherit (pkgs.xlibs) libSM libICE libXmu libXi;
  };
  GLUT_2_1_2_1 = callPackage ../development/libraries/haskell/GLUT/2.1.2.1.nix {
    glut = pkgs.freeglut;
    inherit (pkgs) mesa;
    inherit (pkgs.xlibs) libSM libICE libXmu libXi;
  };
  GLUT_2_2_2_0 = callPackage ../development/libraries/haskell/GLUT/2.2.2.0.nix {
    glut = pkgs.freeglut;
    OpenGL = self.OpenGL_2_4_0_1;
    inherit (pkgs) mesa;
    inherit (pkgs.xlibs) libSM libICE libXmu libXi;
  };
  GLUT = self.GLUT_2_1_1_2;

  gtk = callPackage ../development/libraries/haskell/gtk {
    inherit (pkgs) pkgconfig glibc;
    inherit (pkgs.gtkLibs) gtk;
  };

  gtk2hsBuildtools = callPackage ../development/libraries/haskell/gtk2hs-buildtools {};
  gtk2hsC2hs = self.gtk2hsBuildtools;

  gtksourceview2 = callPackage ../development/libraries/haskell/gtksourceview2 {
    inherit (pkgs) pkgconfig glibc;
    inherit (pkgs.gnome) gtksourceview;
  };

  Graphalyze = callPackage ../development/libraries/haskell/Graphalyze {};

  graphviz = callPackage ../development/libraries/haskell/graphviz {};

  hakyll = callPackage ../development/libraries/haskell/hakyll {
    hamlet = self.hamlet_0_8_2_1;
  };

  hamlet_0_8_2_1 = callPackage ../development/libraries/haskell/hamlet/0.8.2.1.nix {};
  hamlet_0_10_0 = callPackage ../development/libraries/haskell/hamlet/0.10.0.nix {};
  hamlet = self.hamlet_0_10_0;

  happstackData = callPackage ../development/libraries/haskell/happstack/happstack-data.nix {};

  happstackUtil = callPackage ../development/libraries/haskell/happstack/happstack-util.nix {};

  happstackServer = callPackage ../development/libraries/haskell/happstack/happstack-server.nix {};

  hashable = callPackage ../development/libraries/haskell/hashable {};

  hashedStorage = callPackage ../development/libraries/haskell/hashed-storage {};

  haskeline = callPackage ../development/libraries/haskell/haskeline {};

  haskelineClass = callPackage ../development/libraries/haskell/haskeline-class {
    mtl = self.mtl1;
  };

  haskellLexer = callPackage ../development/libraries/haskell/haskell-lexer {};

  haskellSrc_1_0_1_3 = callPackage ../development/libraries/haskell/haskell-src/1.0.1.3.nix {};
  haskellSrc_1_0_1_4 = callPackage ../development/libraries/haskell/haskell-src/1.0.1.4.nix {};
  haskellSrc = self.haskellSrc_1_0_1_3;

  # The old version is required for Agda.
  haskellSrcExts_1_11_1 = callPackage ../development/libraries/haskell/haskell-src-exts/1.11.1.nix {};
  haskellSrcExts_1_9_6 = callPackage ../development/libraries/haskell/haskell-src-exts/1.9.6.nix {};
  haskellSrcExts = self.haskellSrcExts_1_11_1;

  haskellSrcMeta = callPackage ../development/libraries/haskell/haskell-src-meta {};

  HTTP_3001_1_5 = callPackage ../development/libraries/haskell/HTTP/3001.1.5.nix {};
  HTTP_4000_0_6 = callPackage ../development/libraries/haskell/HTTP/4000.0.6.nix {};
  HTTP_4000_0_9 = callPackage ../development/libraries/haskell/HTTP/4000.0.9.nix {};
  HTTP_4000_1_1 = callPackage ../development/libraries/haskell/HTTP/4000.1.1.nix {};
  HTTP_4000_1_2 = callPackage ../development/libraries/haskell/HTTP/4000.1.2.nix {};
  HTTP = self.HTTP_4000_0_6;

  hackageDb = callPackage ../development/libraries/haskell/hackage-db {};

  haxr = callPackage ../development/libraries/haskell/haxr {};

  haxr_th = callPackage ../development/libraries/haskell/haxr-th {};

  HaXml = callPackage ../development/libraries/haskell/HaXml {};

  HDBC = callPackage ../development/libraries/haskell/HDBC/HDBC.nix {};

  HDBCPostgresql = callPackage ../development/libraries/haskell/HDBC/HDBC-postgresql.nix {
    inherit (pkgs) postgresql;
  };

  HDBCSqlite = callPackage ../development/libraries/haskell/HDBC/HDBC-sqlite3.nix {
    inherit (pkgs) sqlite;
  };

  HFuse = callPackage ../development/libraries/haskell/hfuse {
    inherit (pkgs) fuse;
  };

  HGL = callPackage ../development/libraries/haskell/HGL {};

  highlightingKate = callPackage ../development/libraries/haskell/highlighting-kate {};

  hint = callPackage ../development/libraries/haskell/hint {
    ghcPaths = self.ghcPaths_0_1_0_6;
  };

  Hipmunk = callPackage ../development/libraries/haskell/Hipmunk {};

  hjsmin = callPackage ../development/libraries/haskell/hjsmin {};

  hledger = callPackage ../development/libraries/haskell/hledger {};
  hledgerLib = callPackage ../development/libraries/haskell/hledger-lib {};
  hledgerVty = callPackage ../development/libraries/haskell/hledger-vty {
    vty = self.vty_4_6_0_4;
  };
  hledgerChart = callPackage ../development/libraries/haskell/hledger-chart {};
  hledgerInterest = callPackage ../applications/office/hledger-interest {};

  HList = callPackage ../development/libraries/haskell/HList {};

  hmatrix = callPackage ../development/libraries/haskell/hmatrix {
    inherit (pkgs) gsl liblapack/* lapack library */ blas;
  };

  hopenssl = callPackage ../development/libraries/haskell/hopenssl {};

  hostname = callPackage ../development/libraries/haskell/hostname {};

  hp2anyCore = callPackage ../development/libraries/haskell/hp2any-core {};

  hp2anyGraph = callPackage ../development/libraries/haskell/hp2any-graph {
    glut = pkgs.freeglut;
  };

  hsBibutils = callPackage ../development/libraries/haskell/hs-bibutils {};

  hscolour = callPackage ../development/libraries/haskell/hscolour {};

  hsdns = callPackage ../development/libraries/haskell/hsdns {
    inherit (pkgs) adns;
  };

  hsemail = callPackage ../development/libraries/haskell/hsemail {};

  HsSyck = callPackage ../development/libraries/haskell/HsSyck {};

  HStringTemplate = callPackage ../development/libraries/haskell/HStringTemplate {};

  hspread = callPackage ../development/libraries/haskell/hspread {};

  hsloggerTemplate = callPackage ../development/libraries/haskell/hslogger-template {};

  hsyslog = callPackage ../development/libraries/haskell/hsyslog {};

  html_1_0_1_2 = callPackage ../development/libraries/haskell/html/1.0.1.2.nix {};
  html = self.html_1_0_1_2;

  httpdShed = callPackage ../development/libraries/haskell/httpd-shed {};

  httpDate = callPackage ../development/libraries/haskell/http-date {};

  httpEnumerator = callPackage ../development/libraries/haskell/http-enumerator {};

  httpTypes = callPackage ../development/libraries/haskell/http-types {};

  HUnit_1_2_0_3 = callPackage ../development/libraries/haskell/HUnit/1.2.0.3.nix {};
  HUnit_1_2_2_1 = callPackage ../development/libraries/haskell/HUnit/1.2.2.1.nix {};
  HUnit_1_2_2_3 = callPackage ../development/libraries/haskell/HUnit/1.2.2.3.nix {};
  HUnit_1_2_4_3 = callPackage ../development/libraries/haskell/HUnit/1.2.4.2.nix {};
  HUnit = self.HUnit_1_2_0_3;

  irc = callPackage ../development/libraries/haskell/irc {
    parsec = self.parsec2;
  };

  ivor = callPackage ../development/libraries/haskell/ivor {};

  jpeg = callPackage ../development/libraries/haskell/jpeg {};

  JsContracts = callPackage ../development/libraries/haskell/JsContracts {
    WebBits = self.WebBits_1_0;
  };

  json = callPackage ../development/libraries/haskell/json/default.nix {};

  jsonEnumerator = callPackage ../development/libraries/haskell/jsonEnumerator {};

  jsonTypes = callPackage ../development/libraries/haskell/jsonTypes {};

  languageJavascript = callPackage ../development/libraries/haskell/language-javascript {};

  languageHaskellExtract = callPackage ../development/libraries/haskell/language-haskell-extract {};

  largeword = callPackage ../development/libraries/haskell/largeword {};

  leksahServer = callPackage ../development/libraries/haskell/leksah/leksah-server.nix {};

  ListLike = callPackage ../development/libraries/haskell/ListLike {};

  ltk = callPackage ../development/libraries/haskell/ltk {};

  logfloat = callPackage ../development/libraries/haskell/logfloat {};

  MaybeT = callPackage ../development/libraries/haskell/MaybeT {};

  MemoTrie = callPackage ../development/libraries/haskell/MemoTrie {};

  mersenneRandomPure64 = callPackage ../development/libraries/haskell/mersenne-random-pure64 {};

  mimeMail = callPackage ../development/libraries/haskell/mime-mail {};

  MissingH = callPackage ../development/libraries/haskell/MissingH {};

  mmap = callPackage ../development/libraries/haskell/mmap {};

  MonadCatchIOMtl = callPackage ../development/libraries/haskell/MonadCatchIO-mtl {};

  MonadCatchIOTransformers = callPackage ../development/libraries/haskell/MonadCatchIO-transformers {};

  monadControl = callPackage ../development/libraries/haskell/monad-control {};

  monadLoops = callPackage ../development/libraries/haskell/monad-loops {};

  monadPar = callPackage ../development/libraries/haskell/monad-par {};

  monadPeel = callPackage ../development/libraries/haskell/monad-peel {};

  MonadPrompt = callPackage ../development/libraries/haskell/MonadPrompt {};

  MonadRandom = callPackage ../development/libraries/haskell/MonadRandom {};

  mpppc = callPackage ../development/libraries/haskell/mpppc {};

  mtl_1_1_0_2 = callPackage ../development/libraries/haskell/mtl/1.1.0.2.nix {};
  mtl_1_1_1_1 = callPackage ../development/libraries/haskell/mtl/1.1.1.1.nix {};
  mtl_2_0_1_0 = callPackage ../development/libraries/haskell/mtl/2.0.1.0.nix {};
  mtl1 = self.mtl_1_1_0_2;
  mtl2 = self.mtl_2_0_1_0;
  mtl  = self.mtl1;

  mtlparse  = callPackage ../development/libraries/haskell/mtlparse {};

  multiplate = callPackage ../development/libraries/haskell/multiplate {};

  multirec_0_5_1 = callPackage ../development/libraries/haskell/multirec/0.5.1.nix {};
  multirec_0_6 = callPackage ../development/libraries/haskell/multirec/0.6.nix {};
  multirec = self.multirec_0_6;

  multiset = callPackage ../development/libraries/haskell/multiset {};

  murmurHash = callPackage ../development/libraries/haskell/murmur-hash {};

  mwcRandom = callPackage ../development/libraries/haskell/mwc-random {};

  neither = callPackage ../development/libraries/haskell/neither {};

  network_2_2_1_4 = callPackage ../development/libraries/haskell/network/2.2.1.4.nix {};
  network_2_2_1_7 = callPackage ../development/libraries/haskell/network/2.2.1.7.nix {};
  network_2_3_0_2 = callPackage ../development/libraries/haskell/network/2.3.0.2.nix {};
  network_2_3_0_5 = callPackage ../development/libraries/haskell/network/2.3.0.5.nix {};
  network = self.network_2_2_1_4;

  nixosTypes = callPackage ../development/libraries/haskell/nixos-types {};

  nonNegative = callPackage ../development/libraries/haskell/non-negative {};

  numericPrelude = callPackage ../development/libraries/haskell/numeric-prelude {};

  numtype = callPackage ../development/libraries/haskell/numtype {};

  OneTuple = callPackage ../development/libraries/haskell/OneTuple {};

  ObjectName = callPackage ../development/libraries/haskell/ObjectName {};

  OpenAL = callPackage ../development/libraries/haskell/OpenAL {
    inherit (pkgs) openal;
  };

  OpenGL_2_2_1_1 = callPackage ../development/libraries/haskell/OpenGL/2.2.1.1.nix {
    inherit (pkgs) mesa;
    inherit (pkgs.xlibs) libX11;
  };
  OpenGL_2_2_3_0 = callPackage ../development/libraries/haskell/OpenGL/2.2.3.0.nix {
    inherit (pkgs) mesa;
    inherit (pkgs.xlibs) libX11;
  };
  OpenGL_2_4_0_1 = callPackage ../development/libraries/haskell/OpenGL/2.4.0.1.nix {
    inherit (pkgs) mesa;
    inherit (pkgs.xlibs) libX11;
  };
  OpenGL = self.OpenGL_2_2_1_1;

  OpenGLRaw = callPackage ../development/libraries/haskell/OpenGLRaw {
    GL = pkgs.mesa;
  };

  pathPieces = callPackage ../development/libraries/haskell/path-pieces {};

  pandoc = callPackage ../development/libraries/haskell/pandoc/default.nix {};

  pandocTypes = callPackage ../development/libraries/haskell/pandoc-types {};

  pango = callPackage ../development/libraries/haskell/pango {
    inherit (pkgs) pkgconfig glibc;
    inherit (pkgs.gtkLibs) pango;
  };

  parallel_1_1_0_1 = callPackage ../development/libraries/haskell/parallel/1.1.0.1.nix {};
  parallel_2_2_0_1 = callPackage ../development/libraries/haskell/parallel/2.2.0.1.nix {};
  parallel_3_1_0_1 = callPackage ../development/libraries/haskell/parallel/3.1.0.1.nix {};
  parallel = self.parallel_1_1_0_1;

  parseargs = callPackage ../development/libraries/haskell/parseargs {};

  parsec_2_1_0_1 = callPackage ../development/libraries/haskell/parsec/2.1.0.1.nix {};
  parsec_3_1_1   = callPackage ../development/libraries/haskell/parsec/3.1.1.nix {};
  parsec2 = self.parsec_2_1_0_1;
  parsec3 = self.parsec_3_1_1;
  parsec  = self.parsec2;

  parsimony = callPackage ../development/libraries/haskell/parsimony {};

  pathtype = callPackage ../development/libraries/haskell/pathtype {};

  pcreLight = callPackage ../development/libraries/haskell/pcre-light {
    inherit (pkgs) pcre;
  };

  persistent = callPackage ../development/libraries/haskell/persistent {};

  persistentTemplate = callPackage ../development/libraries/haskell/persistent-template {};

  polyparse = callPackage ../development/libraries/haskell/polyparse/default.nix {};

  pool = callPackage ../development/libraries/haskell/pool {};

  ppm = callPackage ../development/libraries/haskell/ppm {};

  prettyShow = callPackage ../development/libraries/haskell/pretty-show {};

  primitive = callPackage ../development/libraries/haskell/primitive {};

  processLeksah = callPackage ../development/libraries/haskell/leksah/process-leksah.nix {};

  PSQueue = callPackage ../development/libraries/haskell/PSQueue {};

  pureMD5 = callPackage ../development/libraries/haskell/pureMD5 {};

  pwstoreFast = callPackage ../development/libraries/haskell/pwstore-fast {};

  QuickCheck_1_2_0_0 = callPackage ../development/libraries/haskell/QuickCheck/1.2.0.0.nix {};
  QuickCheck_1_2_0_1 = callPackage ../development/libraries/haskell/QuickCheck/1.2.0.1.nix {};
  QuickCheck_2_1_0_3 = callPackage ../development/libraries/haskell/QuickCheck/2.1.0.3.nix {};
  QuickCheck_2_1_1_1 = callPackage ../development/libraries/haskell/QuickCheck/2.1.1.1.nix {};
  QuickCheck_2_4_0_1 = callPackage ../development/libraries/haskell/QuickCheck/2.4.0.1.nix {};
  QuickCheck_2_4_1_1 = callPackage ../development/libraries/haskell/QuickCheck/2.4.1.1.nix {};
  QuickCheck1 = self.QuickCheck_1_2_0_1;
  QuickCheck2 = self.QuickCheck_2_4_1_1;
  QuickCheck  = self.QuickCheck2;

  RangedSets = callPackage ../development/libraries/haskell/Ranged-sets {};

  random_1_0_0_2_newtime = callPackage ../development/libraries/haskell/random/1.0.0.2.nix {
    time = self.time_1_2_0_3;
  };
  random_1_0_0_3 = callPackage ../development/libraries/haskell/random/1.0.0.3.nix {};
  random_1_0_1_0 = callPackage ../development/libraries/haskell/random/1.0.1.0.nix {};
  random = null; # core package until ghc-7.2.1
  random_newtime = self.random_1_0_0_2_newtime;

  randomFu = callPackage ../development/libraries/haskell/random-fu {};

  randomSource = callPackage ../development/libraries/haskell/random-source {};

  randomShuffle = callPackage ../development/libraries/haskell/random-shuffle {};

  ranges = callPackage ../development/libraries/haskell/ranges {};

  rvar = callPackage ../development/libraries/haskell/rvar {};

  readline = callPackage ../development/libraries/haskell/readline {
    inherit (pkgs) readline ncurses;
  };

  recaptcha = callPackage ../development/libraries/haskell/recaptcha {};

  regexBase_0_72_0_2 = callPackage ../development/libraries/haskell/regex-base/0.72.0.2.nix {};
  regexBase_0_93_1   = callPackage ../development/libraries/haskell/regex-base/0.93.1.nix   {};
  regexBase_0_93_2   = callPackage ../development/libraries/haskell/regex-base/0.93.2.nix   {};
  regexBase = self.regexBase_0_72_0_2;

  regexCompat_0_71_0_1 = callPackage ../development/libraries/haskell/regex-compat/0.71.0.1.nix {};
  regexCompat_0_92     = callPackage ../development/libraries/haskell/regex-compat/0.92.nix     {};
  regexCompat_0_93_1   = callPackage ../development/libraries/haskell/regex-compat/0.93.1.nix   {};
  regexCompat_0_95_1   = callPackage ../development/libraries/haskell/regex-compat/0.95.1.nix   {
    regexPosix = self.regexPosix_0_95_1;
  };
  regexCompat = self.regexCompat_0_71_0_1;

  regexPosix_0_72_0_3 = callPackage ../development/libraries/haskell/regex-posix/0.72.0.3.nix {};
  regexPosix_0_94_1   = callPackage ../development/libraries/haskell/regex-posix/0.94.1.nix   {};
  regexPosix_0_94_2   = callPackage ../development/libraries/haskell/regex-posix/0.94.2.nix   {};
  regexPosix_0_94_4   = callPackage ../development/libraries/haskell/regex-posix/0.94.4.nix   {};
  regexPosix_0_95_1   = callPackage ../development/libraries/haskell/regex-posix/0.95.1.nix   {};
  regexPosix = self.regexPosix_0_72_0_3;

  regexTDFA = callPackage ../development/libraries/haskell/regex-tdfa {};
  regexTdfa = self.regexTDFA;

  regexPCRE = callPackage ../development/libraries/haskell/regex-pcre {};
  regexPcre = self.regexPCRE;

  regexPcreBuiltin = callPackage ../development/libraries/haskell/regex-pcre-builtin {};

  regexpr = callPackage ../development/libraries/haskell/regexpr {};

  regular = callPackage ../development/libraries/haskell/regular {};

  repa = callPackage ../development/libraries/haskell/repa {};

  repaAlgorithms = callPackage ../development/libraries/haskell/repa-algorithms {};

  repaBytestring = callPackage ../development/libraries/haskell/repa-bytestring {};

  repaExamples = callPackage ../development/libraries/haskell/repa-examples {};

  repaIo = callPackage ../development/libraries/haskell/repa-io {};

  RSA = callPackage ../development/libraries/haskell/RSA {};

  safe = callPackage ../development/libraries/haskell/safe {};

  sendfile = callPackage ../development/libraries/haskell/sendfile {};

  semigroups = callPackage ../development/libraries/haskell/semigroups {};

  simpleSendfile = callPackage ../development/libraries/haskell/simple-sendfile {};

  smallcheck = callPackage ../development/libraries/haskell/smallcheck {};

  snapCore = callPackage ../development/libraries/haskell/snap/core.nix {
    caseInsensitive = self.caseInsensitive_0_3;
  };

  snapServer = callPackage ../development/libraries/haskell/snap/server.nix {
    vectorAlgorithms = self.vectorAlgorithms_0_4;
    caseInsensitive = self.caseInsensitive_0_3;
  };

  stateref = callPackage ../development/libraries/haskell/stateref {};

  StateVar = callPackage ../development/libraries/haskell/StateVar {};

  statistics = callPackage ../development/libraries/haskell/statistics {};

  streamproc = callPackage ../development/libraries/haskell/streamproc {};

  strict = callPackage ../development/libraries/haskell/strict {};

  syb_0_2_2 = callPackage ../development/libraries/haskell/syb/0.2.2.nix {};
  syb_0_3   = callPackage ../development/libraries/haskell/syb/0.3.nix {};
  syb_0_3_3 = callPackage ../development/libraries/haskell/syb/0.3.3.nix {};
  syb02     = self.syb_0_2_2;
  syb03     = self.syb_0_3;
  syb       = null; # by default, we assume that syb ships with GHC, which is
                    # true for the older GHC versions

  sybWithClass = callPackage ../development/libraries/haskell/syb/syb-with-class.nix {};

  sybWithClassInstancesText = callPackage ../development/libraries/haskell/syb/syb-with-class-instances-text.nix {};

  SDLImage = callPackage ../development/libraries/haskell/SDL-image {
    inherit (pkgs) SDL_image;
  };

  SDLMixer = callPackage ../development/libraries/haskell/SDL-mixer {
    inherit (pkgs) SDL_mixer;
  };

  SDLTtf = callPackage ../development/libraries/haskell/SDL-ttf {
    inherit (pkgs) SDL_ttf;
  };

  SDL = callPackage ../development/libraries/haskell/SDL {
    inherit (pkgs) SDL;
  };

  SHA = callPackage ../development/libraries/haskell/SHA {};

  shakespeare = callPackage ../development/libraries/haskell/shakespeare {};

  shakespeareJs = callPackage ../development/libraries/haskell/shakespeare-js {};

  shakespeareCss = callPackage ../development/libraries/haskell/shakespeare-css {};

  Shellac = callPackage ../development/libraries/haskell/Shellac/Shellac.nix {};

  ShellacHaskeline = callPackage ../development/libraries/haskell/Shellac/Shellac-haskeline.nix {};

  ShellacReadline = callPackage ../development/libraries/haskell/Shellac/Shellac-readline.nix {};

  SMTPClient = callPackage ../development/libraries/haskell/SMTPClient {};

  split = callPackage ../development/libraries/haskell/split {};

  stbImage = callPackage ../development/libraries/haskell/stb-image {};

  stm_2_1_1_2 = callPackage ../development/libraries/haskell/stm/2.1.1.2.nix {};
  stm_2_1_2_1 = callPackage ../development/libraries/haskell/stm/2.1.2.1.nix {};
  stm_2_2_0_1 = callPackage ../development/libraries/haskell/stm/2.2.0.1.nix {};
  stm = self.stm_2_1_1_2;

  storableComplex = callPackage ../development/libraries/haskell/storable-complex {};

  storableRecord = callPackage ../development/libraries/haskell/storable-record {};

  strictConcurrency = callPackage ../development/libraries/haskell/strictConcurrency {};

  svgcairo = callPackage ../development/libraries/haskell/svgcairo {};

  tabular = callPackage ../development/libraries/haskell/tabular {};

  tagged = callPackage ../development/libraries/haskell/tagged {};

  tagsoup = callPackage ../development/libraries/haskell/tagsoup {};

  Tensor = callPackage ../development/libraries/haskell/Tensor {};

  terminfo = callPackage ../development/libraries/haskell/terminfo {
    inherit (pkgs) ncurses;
  };

  testFramework = callPackage ../development/libraries/haskell/test-framework {};

  testFrameworkHunit = callPackage ../development/libraries/haskell/test-framework-hunit {};

  testFrameworkQuickcheck = callPackage ../development/libraries/haskell/test-framework-quickcheck {
    QuickCheck = self.QuickCheck1;
  };

  testFrameworkQuickcheck2 = callPackage ../development/libraries/haskell/test-framework-quickcheck2 {};

  testFrameworkTh = callPackage ../development/libraries/haskell/test-framework-th {};

  testpack = callPackage ../development/libraries/haskell/testpack {};

  texmath_0_4 = callPackage ../development/libraries/haskell/texmath/0.4.nix {};
  texmath_0_5_0_1 = callPackage ../development/libraries/haskell/texmath/0.5.0.1.nix {};
  texmath = self.texmath_0_5_0_1;

  text_0_11_0_5 = callPackage ../development/libraries/haskell/text/0.11.0.5.nix {};
  text_0_11_0_6 = callPackage ../development/libraries/haskell/text/0.11.0.6.nix {};
  text_0_11_1_5 = callPackage ../development/libraries/haskell/text/0.11.1.5.nix {};
  text = self.text_0_11_1_5;

  thLift = callPackage ../development/libraries/haskell/th-lift {};

  threadmanager = callPackage ../development/libraries/haskell/threadmanager {};

  time_1_1_2_4 = callPackage ../development/libraries/haskell/time/1.1.2.4.nix {};
  time_1_1_3   = callPackage ../development/libraries/haskell/time/1.1.3.nix {};
  time_1_2_0_3 = callPackage ../development/libraries/haskell/time/1.2.0.3.nix {};
  time_1_2_0_5 = callPackage ../development/libraries/haskell/time/1.2.0.5.nix {};
  time_1_3 = callPackage ../development/libraries/haskell/time/1.3.nix {};
  # time is in the core package set. It should only be necessary to
  # pass it explicitly in rare circumstances.
  time = null;

  tls = callPackage ../development/libraries/haskell/tls {};

  tlsExtra = callPackage ../development/libraries/haskell/tls-extra {};

  transformers_0_2_2_0 = callPackage ../development/libraries/haskell/transformers/0.2.2.0.nix {};
  transformers = self.transformers_0_2_2_0;

  tuple = callPackage ../development/libraries/haskell/tuple {};

  uniplate = callPackage ../development/libraries/haskell/uniplate {};

  uniqueid = callPackage ../development/libraries/haskell/uniqueid {};

  unixCompat = callPackage ../development/libraries/haskell/unix-compat {};

  unorderedContainers = callPackage ../development/libraries/haskell/unordered-containers {};

  url = callPackage ../development/libraries/haskell/url {};

  utf8Light = callPackage ../development/libraries/haskell/utf8-light {};

  utf8String = callPackage ../development/libraries/haskell/utf8-string {};

  utilityHt = callPackage ../development/libraries/haskell/utility-ht {};

  uulib = callPackage ../development/libraries/haskell/uulib {};

  uuParsingLib = callPackage ../development/libraries/haskell/uu-parsinglib {};

  vacuum = callPackage ../development/libraries/haskell/vacuum {
    ghcPaths = self.ghcPaths_0_1_0_6;
  };

  vacuumCairo = callPackage ../development/libraries/haskell/vacuum-cairo {};

  Vec = callPackage ../development/libraries/haskell/Vec {};

  vector = callPackage ../development/libraries/haskell/vector {};

  vectorAlgorithms_0_4 = callPackage ../development/libraries/haskell/vector-algorithms/0.4.nix {};
  vectorAlgorithms_0_5_2 = callPackage ../development/libraries/haskell/vector-algorithms/0.5.2.nix {};
  vectorAlgorithms = self.vectorAlgorithms_0_5_2;

  vectorSpace = callPackage ../development/libraries/haskell/vector-space {};

  vty_4_6_0_4 = callPackage ../development/libraries/haskell/vty/4.6.0.4.nix {};
  vty_4_7_0_4 = callPackage ../development/libraries/haskell/vty/4.7.0.4.nix {};
  vty = self.vty_4_7_0_4;

  wai = callPackage ../development/libraries/haskell/wai {};

  waiAppStatic = callPackage ../development/libraries/haskell/wai-app-static {};

  waiExtra = callPackage ../development/libraries/haskell/wai-extra {};

  warp = callPackage ../development/libraries/haskell/warp {};

  WebBits = callPackage ../development/libraries/haskell/WebBits {
    parsec = self.parsec2;
  };

  WebBits_1_0 = callPackage ../development/libraries/haskell/WebBits/1.0.nix {
    parsec = self.parsec2;
  };

  WebBitsHtml = callPackage ../development/libraries/haskell/WebBits-Html {};

  webRoutes = callPackage ../development/libraries/haskell/web-routes {};

  webRoutesQuasi = callPackage ../development/libraries/haskell/web-routes-quasi {};

  CouchDB = callPackage ../development/libraries/haskell/CouchDB {};

  wlPprintText = callPackage ../development/libraries/haskell/wl-pprint-text {};

  wx = callPackage ../development/libraries/haskell/wxHaskell/wx.nix {};

  wxcore = callPackage ../development/libraries/haskell/wxHaskell/wxcore.nix {
    wxGTK = pkgs.wxGTK28;
    inherit (pkgs) mesa;
    inherit (pkgs.xlibs) libX11;
  };

  wxdirect = callPackage ../development/libraries/haskell/wxHaskell/wxdirect.nix {};

  X11 = callPackage ../development/libraries/haskell/X11 {
    inherit (pkgs.xlibs) libX11 libXinerama libXext;
    xineramaSupport = true;
  };

  X11Xft = callPackage ../development/libraries/haskell/X11-xft {
    inherit (pkgs) pkgconfig freetype fontconfig;
    inherit (pkgs.xlibs) libXft;
  };

  xhtml_3000_2_0_1 = callPackage ../development/libraries/haskell/xhtml/3000.2.0.1.nix {};
  xhtml_3000_2_0_2 = callPackage ../development/libraries/haskell/xhtml/3000.2.0.2.nix {};
  xhtml = self.xhtml_3000_2_0_1;

  xml = callPackage ../development/libraries/haskell/xml {};

  xmlEnumerator = callPackage ../development/libraries/haskell/xml-enumerator {};

  xmlTypes = callPackage ../development/libraries/haskell/xml-types {};

  xssSanitize_0_2_6 = callPackage ../development/libraries/haskell/xss-sanitize/0.2.6.nix {};
  xssSanitize_0_3_0_1 = callPackage ../development/libraries/haskell/xss-sanitize/0.3.0.1.nix {};
  xssSanitize = self.xssSanitize_0_3_0_1;

  yap = callPackage ../development/libraries/haskell/yap {};

  yesod = callPackage ../development/libraries/haskell/yesod {};

  yesodAuth = callPackage ../development/libraries/haskell/yesod-auth {};

  yesodCore = callPackage ../development/libraries/haskell/yesod-core {};

  yesodForm = callPackage ../development/libraries/haskell/yesod-form {};

  yesodJson = callPackage ../development/libraries/haskell/yesod-json {};

  yesodPersistent = callPackage ../development/libraries/haskell/yesod-persistent {};

  yesodStatic = callPackage ../development/libraries/haskell/yesod-static {};

  yst = callPackage ../development/libraries/haskell/yst {};

  zipArchive = callPackage ../development/libraries/haskell/zip-archive {};

  zipper = callPackage ../development/libraries/haskell/zipper {
    multirec = self.multirec_0_5_1;
  };

  zlib_0_5_0_0 = callPackage ../development/libraries/haskell/zlib/0.5.0.0.nix {
    inherit (pkgs) zlib;
  };

  zlib_0_5_2_0 = callPackage ../development/libraries/haskell/zlib/0.5.2.0.nix {
    inherit (pkgs) zlib;
  };

  zlib_0_5_3_1 = callPackage ../development/libraries/haskell/zlib/0.5.3.1.nix {
    inherit (pkgs) zlib;
  };

  zlib = self.zlib_0_5_0_0;

  zlibBindings = callPackage ../development/libraries/haskell/zlib-bindings {};

  zlibEnum = callPackage ../development/libraries/haskell/zlib-enum {};

  # Compilers.

  AgdaExecutable = callPackage ../development/compilers/Agda-executable {};

  ehc = callPackage ../development/compilers/ehc {
    inherit (pkgs) fetchsvn stdenv coreutils glibc m4 libtool llvm;
  };

  epic = callPackage ../development/compilers/epic {};

  flapjax = callPackage ../development/compilers/flapjax {
    WebBits = self.WebBits_1_0;
  };

  helium = callPackage ../development/compilers/helium {};

  idris = callPackage ../development/compilers/idris {};

  pakcs = callPackage ../development/compilers/pakcs {
    syb = self.syb02;
  };

  # Development tools.

  alex_2_3_1 = callPackage ../development/tools/parsing/alex/2.3.1.nix {};
  alex_2_3_2 = callPackage ../development/tools/parsing/alex/2.3.2.nix {};
  alex_2_3_3 = callPackage ../development/tools/parsing/alex/2.3.3.nix {};
  alex_2_3_5 = callPackage ../development/tools/parsing/alex/2.3.5.nix {};
  alex_3_0_1 = callPackage ../development/tools/parsing/alex/3.0.1.nix {};
  alex = self.alex_2_3_1;

  alexMeta = callPackage ../development/tools/haskell/alex-meta {};

  BNFC = callPackage ../development/tools/haskell/BNFC {};

  BNFCMeta = callPackage ../development/tools/haskell/BNFC-meta {};

  cpphs = callPackage ../development/tools/misc/cpphs {};

  frown = callPackage ../development/tools/parsing/frown {};

  haddock_2_4_2 = callPackage ../development/tools/documentation/haddock/2.4.2.nix {};
  haddock_2_7_2 = callPackage ../development/tools/documentation/haddock/2.7.2.nix {
    ghcPaths = self.ghcPaths_0_1_0_6;
  };
  haddock_2_9_2 = callPackage ../development/tools/documentation/haddock/2.9.2.nix {
    ghcPaths = self.ghcPaths_0_1_0_6;
  };
  haddock = self.haddock_2_7_2;

  happy_1_18_4 = callPackage ../development/tools/parsing/happy/1.18.4.nix {};
  happy_1_18_5 = callPackage ../development/tools/parsing/happy/1.18.5.nix {};
  happy_1_18_6 = callPackage ../development/tools/parsing/happy/1.18.6.nix {};
  happy = self.happy_1_18_4;

  happyMeta = callPackage ../development/tools/haskell/happy-meta {};

  HaRe = callPackage ../development/tools/haskell/HaRe {};

  hlint = callPackage ../development/tools/haskell/hlint {};

  hslogger = callPackage ../development/tools/haskell/hslogger {};

  tar = callPackage ../development/tools/haskell/tar {};

  threadscope = callPackage ../development/tools/haskell/threadscope {};

  uuagcBootstrap = callPackage ../development/tools/haskell/uuagc/bootstrap.nix {};
  uuagcCabal = callPackage ../development/tools/haskell/uuagc/cabal.nix {};
  uuagc = callPackage ../development/tools/haskell/uuagc {};

  # Applications.

  darcs = callPackage ../applications/version-management/darcs {
    inherit (pkgs) curl;
    parsec = self.parsec2;
  };

  leksah = callPackage ../applications/editors/leksah {};

  xmobar = callPackage ../applications/misc/xmobar {};

  xmonad = callPackage ../applications/window-managers/xmonad {
    inherit (pkgs.xlibs) xmessage;
  };

  xmonadContrib = callPackage ../applications/window-managers/xmonad/xmonad-contrib.nix {};

  xmonadExtras = callPackage ../applications/window-managers/xmonad/xmonad-extras.nix {};

  # Tools.

  cabal2nix = callPackage ../development/tools/haskell/cabal2nix {};

  cabalInstall_0_6_2  = callPackage ../tools/package-management/cabal-install/0.6.2.nix  {};
  cabalInstall_0_8_0  = callPackage ../tools/package-management/cabal-install/0.8.0.nix  {};
  cabalInstall_0_8_2  = callPackage ../tools/package-management/cabal-install/0.8.2.nix  {};
  cabalInstall_0_10_2 = callPackage ../tools/package-management/cabal-install/0.10.2.nix {};
  cabalInstall = self.cabalInstall_0_6_2;

  lhs2tex = callPackage ../tools/typesetting/lhs2tex {};

  myhasktags = callPackage ../tools/misc/myhasktags {};

  # Games.

  LambdaHack = callPackage ../games/LambdaHack {};

  MazesOfMonad = callPackage ../games/MazesOfMonad {};

# End of the main part of the file.

};

in result.final
