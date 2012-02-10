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
  ghc704Prefs  = super : super // super.haskellPlatformDefaults_2011_4_0_0 super; # link
  ghc721Prefs  = super : super // super.haskellPlatformDefaults_future super;
  ghc722Prefs  = super : super // super.haskellPlatformDefaults_future super; #link
  ghc741Prefs  = super : super // super.haskellPlatformDefaults_HEAD super;
  ghcHEADPrefs = super : super // super.haskellPlatformDefaults_HEAD super;

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
    ghc = ghc; # refers to ghcPlain
  };

  # An experimental wrapper around ghcPlain that does not automatically
  # pick up packages from the profile, but instead has a fixed set of packages
  # in its global database. The set of packages can be specified as an
  # argument to this function.

  ghcWithPackages = pkgs : callPackage ../development/compilers/ghc/with-packages.nix {
    ghc = ghc; # refers to ghcPlain
    packages = pkgs self;
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

  # NOTE: 2011.4.0.0 is the current default.

  haskellPlatformArgs_future = self : {
    inherit (self) cabal ghc;
    cgi          = self.cgi_3001_1_7_4;         # 7.4.1 ok
    fgl          = self.fgl_5_4_2_4;            # 7.4.1 ok
    GLUT         = self.GLUT_2_3_0_0;           # 7.4.1 ok
    haskellSrc   = self.haskellSrc_1_0_1_5;     # 7.4.1 ok
    html         = self.html_1_0_1_2;           # 7.4.1 ok
    HUnit        = self.HUnit_1_2_2_3;          # 7.4.1 ok
    network      = self.network_2_3_0_10;       # 7.4.1 ok
    OpenGL       = self.OpenGL_2_5_0_0;         # 7.4.1 ok
    parallel     = self.parallel_3_2_0_2;       # 7.4.1 ok
    parsec       = self.parsec_3_1_2;           # 7.4.1 ok
    QuickCheck   = self.QuickCheck_2_4_2;       # 7.4.1 ok
    regexBase    = self.regexBase_0_93_2;       # 7.4.1 ok
    regexCompat  = self.regexCompat_0_93_1;     # 7.4.1 ok
    regexPosix   = self.regexPosix_0_95_1;      # 7.4.1 ok
    stm          = self.stm_2_2_0_1;            # 7.4.1 ok
    syb          = self.syb_0_3_6;              # 7.4.1 ok
    xhtml        = self.xhtml_3000_2_0_5;       # 7.4.1 ok
    zlib         = self.zlib_0_5_3_3;           # 7.4.1 ok
    HTTP         = self.HTTP_4000_2_2;          # 7.4.1 ok
    text         = self.text_0_11_1_13;         # 7.4.1 ok
    transformers = self.transformers_0_2_2_0;   # 7.4.1 ok
    mtl          = self.mtl_2_0_1_0;            # 7.4.1 ok
    random       = self.random_1_0_1_1;         # 7.4.1 ok
    cabalInstall = self.cabalInstall_0_10_2;    # 7.4.1 fails
    alex         = self.alex_3_0_1;             # 7.4.1 ok
    happy        = self.happy_1_18_9;           # 7.4.1 ok
    haddock      = self.haddock_2_9_2;          # 7.4.1 fails
  };

  haskellPlatformDefaults_future =
    self : self.haskellPlatformArgs_future self // {
      mtl1 = self.mtl_1_1_1_1; # 7.2 ok, 7.3 ok
    };

  haskellPlatformDefaults_HEAD =
    self : self.haskellPlatformDefaults_future self // {
    };

  haskellPlatformArgs_2011_4_0_0 = self : {
    inherit (self) cabal ghc;
    cgi          = self.cgi_3001_1_7_4;
    fgl          = self.fgl_5_4_2_4;
    GLUT         = self.GLUT_2_1_2_1;
    haskellSrc   = self.haskellSrc_1_0_1_4;
    html         = self.html_1_0_1_2;
    HUnit        = self.HUnit_1_2_4_2;
    network      = self.network_2_3_0_5;
    OpenGL       = self.OpenGL_2_2_3_0;
    parallel     = self.parallel_3_1_0_1;
    parsec       = self.parsec_3_1_1;
    QuickCheck   = self.QuickCheck_2_4_1_1;
    regexBase    = self.regexBase_0_93_2;
    regexCompat  = self.regexCompat_0_95_1;
    regexPosix   = self.regexPosix_0_95_1;
    stm          = self.stm_2_2_0_1;
    syb          = self.syb_0_3_3;
    xhtml        = self.xhtml_3000_2_0_4;
    zlib         = self.zlib_0_5_3_1;
    HTTP         = self.HTTP_4000_1_2;
    deepseq      = self.deepseq_1_1_0_2;
    text         = self.text_0_11_1_5;
    transformers = self.transformers_0_2_2_0;
    mtl          = self.mtl_2_0_1_0;
    cabalInstall = self.cabalInstall_0_10_2;
    alex         = self.alex_2_3_5;
    happy        = self.happy_1_18_6;
    haddock      = self.haddock_2_9_2;
  };

  haskellPlatformDefaults_2011_4_0_0 =
    self : self.haskellPlatformArgs_2011_4_0_0 self // {
      haskellPlatform = self.haskellPlatform_2011_4_0_0;
      mtl1 = self.mtl_1_1_1_1;
      repaExamples = null;      # don't pick this version of 'repa-examples' during nix-env -u
    };

  haskellPlatform_2011_4_0_0 =
    callPackage ../development/libraries/haskell/haskell-platform/2011.4.0.0.nix
      (self.haskellPlatformArgs_2011_4_0_0 self);

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
      repaExamples = null;      # don't pick this version of 'repa-examples' during nix-env -u
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
      repaExamples = null;      # don't pick this version of 'repa-examples' during nix-env -u
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
      repaExamples = null;      # don't pick this version of 'repa-examples' during nix-env -u
      deepseq = self.deepseq_1_1_0_2;
      # deviating from Haskell platform here, to make some packages (notably statistics) compile
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
    QuickCheck   = self.QuickCheck_2_1_1_1;
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
      repaExamples = null;      # don't pick this version of 'repa-examples' during nix-env -u
      deepseq = self.deepseq_1_1_0_2;
      # deviating from Haskell platform here, to make some packages (notably statistics) compile
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
      text = self.text_0_11_0_6;
      repaExamples = null;      # don't pick this version of 'repa-examples' during nix-env -u
      deepseq = self.deepseq_1_1_0_2;
      # deviating from Haskell platform here, to make some packages (notably statistics) compile
    };

  haskellPlatform_2009_2_0_2 =
    callPackage ../development/libraries/haskell/haskell-platform/2009.2.0.2.nix
      (self.haskellPlatformArgs_2009_2_0_2 self);

  # Haskell libraries.

  Agda = callPackage ../development/libraries/haskell/Agda {};

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

  attoparsecConduit = callPackage ../development/libraries/haskell/attoparsec-conduit {};

  attoparsecEnumerator = callPackage ../development/libraries/haskell/attoparsec/enumerator.nix {};

  authenticate = callPackage ../development/libraries/haskell/authenticate {};

  base16Bytestring = callPackage ../development/libraries/haskell/base16-bytestring {};

  base64String = callPackage ../development/libraries/haskell/base64-string {};

  base64Bytestring = callPackage ../development/libraries/haskell/base64-bytestring {};

  baseUnicodeSymbols = callPackage ../development/libraries/haskell/base-unicode-symbols {};

  benchpress = callPackage ../development/libraries/haskell/benchpress {
    time = self.time_1_1_3;
  };

  bimap = callPackage ../development/libraries/haskell/bimap {};

  binary = callPackage ../development/libraries/haskell/binary {};

  binaryShared = callPackage ../development/libraries/haskell/binary-shared {};

  bitarray = callPackage ../development/libraries/haskell/bitarray {};

  bitmap = callPackage ../development/libraries/haskell/bitmap {};

  bktrees = callPackage ../development/libraries/haskell/bktrees {};

  blazeBuilder = callPackage ../development/libraries/haskell/blaze-builder {};

  blazeBuilderConduit = callPackage ../development/libraries/haskell/blaze-builder-conduit {};

  blazeBuilderEnumerator = callPackage ../development/libraries/haskell/blaze-builder-enumerator {};

  blazeHtml = callPackage ../development/libraries/haskell/blaze-html {};

  blazeTextual = callPackage ../development/libraries/haskell/blaze-textual {};

  blazeTextualNative = callPackage ../development/libraries/haskell/blaze-textual-native {};

  bmp = callPackage ../development/libraries/haskell/bmp {};

  Boolean = callPackage ../development/libraries/haskell/Boolean {};

  bson = callPackage ../development/libraries/haskell/bson {};

  byteorder = callPackage ../development/libraries/haskell/byteorder {};

  bytestringNums = callPackage ../development/libraries/haskell/bytestring-nums {};

  bytestringLexing = callPackage ../development/libraries/haskell/bytestring-lexing {};

  bytestringMmap = callPackage ../development/libraries/haskell/bytestring-mmap {};

  bytestringTrie = callPackage ../development/libraries/haskell/bytestring-trie {};

  cabalFileTh = callPackage ../development/libraries/haskell/cabal-file-th {};

  cairo = callPackage ../development/libraries/haskell/cairo {
    inherit (pkgs) cairo zlib;
    libc = pkgs.stdenv.gcc.libc;
  };

  caseInsensitive = callPackage ../development/libraries/haskell/case-insensitive {};

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

  compactStringFix = callPackage ../development/libraries/haskell/compact-string-fix {};

  conduit = callPackage ../development/libraries/haskell/conduit {};

  ConfigFile = callPackage ../development/libraries/haskell/ConfigFile {};

  containersDeepseq = callPackage ../development/libraries/haskell/containers-deepseq {};

  controlMonadAttempt = callPackage ../development/libraries/haskell/control-monad-attempt {};

  convertible = callPackage ../development/libraries/haskell/convertible {
    time = self.time_1_1_3;
  };

  convertibleText = callPackage ../development/libraries/haskell/convertible-text {};

  continuedFractions = callPackage ../development/libraries/haskell/continued-fractions {};

  converge = callPackage ../development/libraries/haskell/converge {};

  cookie = callPackage ../development/libraries/haskell/cookie {};

  cprngAes = callPackage ../development/libraries/haskell/cprng-aes {};

  criterion = callPackage ../development/libraries/haskell/criterion {
    mtl = self.mtl2;
    parsec = self.parsec3;
  };

  Crypto = callPackage ../development/libraries/haskell/Crypto {};

  cryptoApi = callPackage ../development/libraries/haskell/crypto-api {};

  cryptocipher = callPackage ../development/libraries/haskell/cryptocipher {};

  cryptohash = callPackage ../development/libraries/haskell/cryptohash {};

  cryptoPubkeyTypes = callPackage ../development/libraries/haskell/crypto-pubkey-types {};

  csv = callPackage ../development/libraries/haskell/csv {};

  cssText = callPackage ../development/libraries/haskell/css-text {};

  curl = callPackage ../development/libraries/haskell/curl { curl = pkgs.curl; };

  dataAccessor = callPackage ../development/libraries/haskell/data-accessor/data-accessor.nix {};

  dataAccessorTemplate = callPackage ../development/libraries/haskell/data-accessor/data-accessor-template.nix {};

  dataBinaryIeee754 = callPackage ../development/libraries/haskell/data-binary-ieee754 {};

  dataDefault = callPackage ../development/libraries/haskell/data-default {};

  dataenc = callPackage ../development/libraries/haskell/dataenc {};

  dataObject = callPackage ../development/libraries/haskell/data-object {};

  dataObjectYaml = callPackage ../development/libraries/haskell/data-object-yaml {};

  dataReify = callPackage ../development/libraries/haskell/data-reify {};

  datetime = callPackage ../development/libraries/haskell/datetime {};

  deepseq_1_1_0_0 = callPackage ../development/libraries/haskell/deepseq/1.1.0.0.nix {};
  deepseq_1_1_0_2 = callPackage ../development/libraries/haskell/deepseq/1.1.0.2.nix {};
  deepseq_1_2_0_1 = callPackage ../development/libraries/haskell/deepseq/1.2.0.1.nix {};
  deepseq_1_3_0_0 = callPackage ../development/libraries/haskell/deepseq/1.3.0.0.nix {};
  deepseq = null; # a core package in recent GHCs

  deepseqTh = callPackage ../development/libraries/haskell/deepseq-th {};

  derive = callPackage ../development/libraries/haskell/derive {};

  derp = callPackage ../development/libraries/haskell/derp {};

  Diff = callPackage ../development/libraries/haskell/Diff {};

  digest = callPackage ../development/libraries/haskell/digest {
    inherit (pkgs) zlib;
  };

  dimensional = callPackage ../development/libraries/haskell/dimensional {};

  directoryTree = callPackage ../development/libraries/haskell/directory-tree {};

  dlist = callPackage ../development/libraries/haskell/dlist {};

  dotgen = callPackage ../development/libraries/haskell/dotgen {};

  doubleConversion = callPackage ../development/libraries/haskell/double-conversion {};

  download = callPackage ../development/libraries/haskell/download {};

  downloadCurl = callPackage ../development/libraries/haskell/download-curl { tagsoup = self.tagsoup_0_10_1; };

  DSH = callPackage ../development/libraries/haskell/DSH {};

  dstring = callPackage ../development/libraries/haskell/dstring {};

  editline = callPackage ../development/libraries/haskell/editline {};

  emailValidate = callPackage ../development/libraries/haskell/email-validate {};

  enumerator = callPackage ../development/libraries/haskell/enumerator {};

  entropy = callPackage ../development/libraries/haskell/entropy {};

  erf = callPackage ../development/libraries/haskell/erf {};

  explicitException = callPackage ../development/libraries/haskell/explicit-exception {};

  filepath = callPackage ../development/libraries/haskell/filepath {};

  extensibleExceptions_0_1_1_0 = callPackage ../development/libraries/haskell/extensible-exceptions/0.1.1.0.nix {};
  extensibleExceptions_0_1_1_2 = callPackage ../development/libraries/haskell/extensible-exceptions/0.1.1.2.nix {};
  extensibleExceptions_0_1_1_3 = callPackage ../development/libraries/haskell/extensible-exceptions/0.1.1.3.nix {};
  extensibleExceptions_0_1_1_4 = callPackage ../development/libraries/haskell/extensible-exceptions/0.1.1.4.nix {};
  extensibleExceptions = null; # a core package in recent GHCs

  failure = callPackage ../development/libraries/haskell/failure {};

  fastLogger = callPackage ../development/libraries/haskell/fast-logger {};

  fclabels = callPackage ../development/libraries/haskell/fclabels {};

  FerryCore = callPackage ../development/libraries/haskell/FerryCore {};

  funcmp = callPackage ../development/libraries/haskell/funcmp {};

  feed = callPackage ../development/libraries/haskell/feed {};

  fileEmbed = callPackage ../development/libraries/haskell/file-embed {};

  flexibleDefaults = callPackage ../development/libraries/haskell/flexible-defaults {};

  filestore = callPackage ../development/libraries/haskell/filestore {};

  fgl_5_4_2_2 = callPackage ../development/libraries/haskell/fgl/5.4.2.2.nix {};
  fgl_5_4_2_3 = callPackage ../development/libraries/haskell/fgl/5.4.2.3.nix {};
  fgl_5_4_2_4 = callPackage ../development/libraries/haskell/fgl/5.4.2.4.nix {};
  fgl = self.fgl_5_4_2_4;

  fingertree = callPackage ../development/libraries/haskell/fingertree {};

  gamma = callPackage ../development/libraries/haskell/gamma {};

  gd = callPackage ../development/libraries/haskell/gd {
    inherit (pkgs) gd zlib;
  };

  gdiff = callPackage ../development/libraries/haskell/gdiff {};

  genericDeriving = callPackage ../development/libraries/haskell/generic-deriving {};

  ghcCore = callPackage ../development/libraries/haskell/ghc-core {};

  ghcEvents = callPackage ../development/libraries/haskell/ghc-events {};

  ghcMod = callPackage ../development/libraries/haskell/ghc-mod {
    emacsPackages = pkgs.emacs23Packages;
  };

  ghcMtl = callPackage ../development/libraries/haskell/ghc-mtl {};

  ghcPaths = callPackage ../development/libraries/haskell/ghc-paths {};

  ghcSyb = callPackage ../development/libraries/haskell/ghc-syb {};

  ghcSybUtils = callPackage ../development/libraries/haskell/ghc-syb-utils {};

  gitit = callPackage ../development/libraries/haskell/gitit {};

  glade = callPackage ../development/libraries/haskell/glade {
    inherit (pkgs.gnome) libglade;
    gtkC = pkgs.gnome.gtk;
    libc = pkgs.stdenv.gcc.libc;
  };

  GLFW = callPackage ../development/libraries/haskell/GLFW {};

  glib = callPackage ../development/libraries/haskell/glib {
    glib = pkgs.glib;
    libc = pkgs.stdenv.gcc.libc;
  };

  GlomeVec = callPackage ../development/libraries/haskell/GlomeVec {};

  gloss = callPackage ../development/libraries/haskell/gloss {
    GLUT   = self.GLUT22;
    OpenGL = self.OpenGL24;
  };

  GLURaw = callPackage ../development/libraries/haskell/GLURaw {};

  GLUT_2_1_1_2 = callPackage ../development/libraries/haskell/GLUT/2.1.1.2.nix {};
  GLUT_2_1_2_1 = callPackage ../development/libraries/haskell/GLUT/2.1.2.1.nix {};
  GLUT_2_2_2_1 = callPackage ../development/libraries/haskell/GLUT/2.2.2.1.nix {
    OpenGL = self.OpenGL_2_4_0_2;
  };
  GLUT_2_3_0_0 = callPackage ../development/libraries/haskell/GLUT/2.3.0.0.nix {
    OpenGL = self.OpenGL_2_5_0_0;
  };
  GLUT22 = self.GLUT_2_2_2_1;
  GLUT = self.GLUT_2_3_0_0;

  gtk = callPackage ../development/libraries/haskell/gtk {
    inherit (pkgs.gtkLibs) gtk;
    libc = pkgs.stdenv.gcc.libc;
  };

  gtk2hsBuildtools = callPackage ../development/libraries/haskell/gtk2hs-buildtools {};
  gtk2hsC2hs = self.gtk2hsBuildtools;

  gtksourceview2 = callPackage ../development/libraries/haskell/gtksourceview2 {
    inherit (pkgs.gnome) gtksourceview;
    libc = pkgs.stdenv.gcc.libc;
  };

  Graphalyze = callPackage ../development/libraries/haskell/Graphalyze {};

  graphviz = callPackage ../development/libraries/haskell/graphviz {
    fgl = self.fgl_5_4_2_4;
  };

  hakyll = callPackage ../development/libraries/haskell/hakyll {};

  hamlet = callPackage ../development/libraries/haskell/hamlet {};

  happstackData = callPackage ../development/libraries/haskell/happstack/happstack-data.nix {};

  happstackUtil = callPackage ../development/libraries/haskell/happstack/happstack-util.nix {};

  happstackServer = callPackage ../development/libraries/haskell/happstack/happstack-server.nix {};

  happstackHamlet = callPackage ../development/libraries/haskell/happstack/happstack-hamlet.nix {};

  hashable = callPackage ../development/libraries/haskell/hashable {};

  hashedStorage = callPackage ../development/libraries/haskell/hashed-storage {};

  hashtables = callPackage ../development/libraries/haskell/hashtables {};

  haskeline = callPackage ../development/libraries/haskell/haskeline {};

  haskelineClass = callPackage ../development/libraries/haskell/haskeline-class {};

  haskellLexer = callPackage ../development/libraries/haskell/haskell-lexer {};

  haskellSrc_1_0_1_3 = callPackage ../development/libraries/haskell/haskell-src/1.0.1.3.nix {};
  haskellSrc_1_0_1_4 = callPackage ../development/libraries/haskell/haskell-src/1.0.1.4.nix {};
  haskellSrc_1_0_1_5 = callPackage ../development/libraries/haskell/haskell-src/1.0.1.5.nix {};
  haskellSrc = self.haskellSrc_1_0_1_5;

  haskellSrcExts = callPackage ../development/libraries/haskell/haskell-src-exts/default.nix {};

  haskellSrcMeta = callPackage ../development/libraries/haskell/haskell-src-meta {};

  hastache = callPackage ../development/libraries/haskell/hastache {};

  HTTP_4000_0_6 = callPackage ../development/libraries/haskell/HTTP/4000.0.6.nix {};
  HTTP_4000_0_9 = callPackage ../development/libraries/haskell/HTTP/4000.0.9.nix {};
  HTTP_4000_1_1 = callPackage ../development/libraries/haskell/HTTP/4000.1.1.nix {};
  HTTP_4000_1_2 = callPackage ../development/libraries/haskell/HTTP/4000.1.2.nix {};
  HTTP_4000_2_1 = callPackage ../development/libraries/haskell/HTTP/4000.2.1.nix {};
  HTTP_4000_2_2 = callPackage ../development/libraries/haskell/HTTP/4000.2.2.nix {};
  HTTP = self.HTTP_4000_2_2;

  hackageDb = callPackage ../development/libraries/haskell/hackage-db {};

  haskellForMaths = callPackage ../development/libraries/haskell/HaskellForMaths {};

  haxr = callPackage ../development/libraries/haskell/haxr {};

  haxr_th = callPackage ../development/libraries/haskell/haxr-th {};

  HaXml = callPackage ../development/libraries/haskell/HaXml {};

  HDBC = callPackage ../development/libraries/haskell/HDBC/HDBC.nix {};

  HDBCOdbc = callPackage ../development/libraries/haskell/HDBC/HDBC-odbc.nix {
    odbc = pkgs.unixODBC;
  };

  HDBCPostgresql = callPackage ../development/libraries/haskell/HDBC/HDBC-postgresql.nix {};

  HDBCSqlite = callPackage ../development/libraries/haskell/HDBC/HDBC-sqlite3.nix {};

  HFuse = callPackage ../development/libraries/haskell/hfuse {};

  HGL = callPackage ../development/libraries/haskell/HGL {};

  highlightingKate = callPackage ../development/libraries/haskell/highlighting-kate {};

  hint = callPackage ../development/libraries/haskell/hint {};

  Hipmunk = callPackage ../development/libraries/haskell/Hipmunk {};

  hjsmin = callPackage ../development/libraries/haskell/hjsmin {};

  hledger = callPackage ../development/libraries/haskell/hledger {};
  hledgerLib = callPackage ../development/libraries/haskell/hledger-lib {};
  #hledgerVty = callPackage ../development/libraries/haskell/hledger-vty {};
  #hledgerChart = callPackage ../development/libraries/haskell/hledger-chart {};
  hledgerInterest = callPackage ../applications/office/hledger-interest {};
  hledgerWeb = callPackage ../development/libraries/haskell/hledger-web {};

  HList = callPackage ../development/libraries/haskell/HList {};

  hmatrix = callPackage ../development/libraries/haskell/hmatrix {};

  hopenssl = callPackage ../development/libraries/haskell/hopenssl {};

  hostname = callPackage ../development/libraries/haskell/hostname {};

  hp2anyCore = callPackage ../development/libraries/haskell/hp2any-core {};

  hp2anyGraph = callPackage ../development/libraries/haskell/hp2any-graph {};

  hS3 = callPackage ../development/libraries/haskell/hS3 {};

  hsBibutils = callPackage ../development/libraries/haskell/hs-bibutils {};

  hscolour = callPackage ../development/libraries/haskell/hscolour {};

  hsdns = callPackage ../development/libraries/haskell/hsdns {};

  hsemail = callPackage ../development/libraries/haskell/hsemail {};

  HsSyck = callPackage ../development/libraries/haskell/HsSyck {};

  HsOpenSSL = callPackage ../development/libraries/haskell/HsOpenSSL {};

  HStringTemplate = callPackage ../development/libraries/haskell/HStringTemplate {};

  hspread = callPackage ../development/libraries/haskell/hspread {};

  hsloggerTemplate = callPackage ../development/libraries/haskell/hslogger-template {};

  hsyslog = callPackage ../development/libraries/haskell/hsyslog {};

  html_1_0_1_2 = callPackage ../development/libraries/haskell/html/1.0.1.2.nix {};
  html = self.html_1_0_1_2;

  httpConduit = callPackage ../development/libraries/haskell/http-conduit {};

  httpdShed = callPackage ../development/libraries/haskell/httpd-shed {};

  httpDate = callPackage ../development/libraries/haskell/http-date {};

  httpEnumerator = callPackage ../development/libraries/haskell/http-enumerator {};

  httpTypes = callPackage ../development/libraries/haskell/http-types {};

  HUnit_1_2_0_3 = callPackage ../development/libraries/haskell/HUnit/1.2.0.3.nix {};
  HUnit_1_2_2_1 = callPackage ../development/libraries/haskell/HUnit/1.2.2.1.nix {};
  HUnit_1_2_2_3 = callPackage ../development/libraries/haskell/HUnit/1.2.2.3.nix {};
  HUnit_1_2_4_2 = callPackage ../development/libraries/haskell/HUnit/1.2.4.2.nix {};
  HUnit = self.HUnit_1_2_0_3;

  hxt = callPackage ../development/libraries/haskell/hxt {};

  hxtCharproperties = callPackage ../development/libraries/haskell/hxt-charproperties {};

  hxtRegexXmlschema = callPackage ../development/libraries/haskell/hxt-regex-xmlschema {};

  hxtUnicode = callPackage ../development/libraries/haskell/hxt-unicode {};

  ieee754 = callPackage ../development/libraries/haskell/ieee754 {};

  instantGenerics = callPackage ../development/libraries/haskell/instant-generics {};

  ioStorage = callPackage ../development/libraries/haskell/io-storage {};

  irc = callPackage ../development/libraries/haskell/irc {
    parsec = self.parsec2;
  };

  iteratee = callPackage ../development/libraries/haskell/iteratee {};

  ivor = callPackage ../development/libraries/haskell/ivor {};

  jpeg = callPackage ../development/libraries/haskell/jpeg {};

  JsContracts = callPackage ../development/libraries/haskell/JsContracts {
    WebBits = self.WebBits_1_0;
    WebBitsHtml = self.WebBitsHtml_1_0_1;
  };

  json = callPackage ../development/libraries/haskell/json {};

  jsonEnumerator = callPackage ../development/libraries/haskell/jsonEnumerator {};

  jsonTypes = callPackage ../development/libraries/haskell/jsonTypes {};

  languageJavascript = callPackage ../development/libraries/haskell/language-javascript {
    alex = self.alex_3_0_1;
  };

  languageHaskellExtract = callPackage ../development/libraries/haskell/language-haskell-extract {};

  largeword = callPackage ../development/libraries/haskell/largeword {};

  leksahServer = callPackage ../development/libraries/haskell/leksah/leksah-server.nix {};

  libmpd = callPackage ../development/libraries/haskell/libmpd {};

  liftedBase = callPackage ../development/libraries/haskell/lifted-base {};

  ListLike = callPackage ../development/libraries/haskell/ListLike {};

  ltk = callPackage ../development/libraries/haskell/ltk {};

  logfloat = callPackage ../development/libraries/haskell/logfloat {};

  mathFunctions = callPackage ../development/libraries/haskell/math-functions {};

  maude = callPackage ../development/libraries/haskell/maude {
    parsec = self.parsec3;
  };

  MaybeT = callPackage ../development/libraries/haskell/MaybeT {};

  MemoTrie = callPackage ../development/libraries/haskell/MemoTrie {};

  mersenneRandomPure64 = callPackage ../development/libraries/haskell/mersenne-random-pure64 {};

  mimeMail = callPackage ../development/libraries/haskell/mime-mail {};

  MissingH = callPackage ../development/libraries/haskell/MissingH {};

  mmap = callPackage ../development/libraries/haskell/mmap {};

  MonadCatchIOMtl = callPackage ../development/libraries/haskell/MonadCatchIO-mtl {};

  MonadCatchIOTransformers = callPackage ../development/libraries/haskell/MonadCatchIO-transformers {};

  monadControl_0_2_0_3 = callPackage ../development/libraries/haskell/monad-control/0.2.0.3.nix {};
  monadControl_0_3_1 = callPackage ../development/libraries/haskell/monad-control/0.3.1.nix {};
  monadControl = self.monadControl_0_3_1;

  monadLoops = callPackage ../development/libraries/haskell/monad-loops {};

  monadPar = callPackage ../development/libraries/haskell/monad-par {};

  monadPeel = callPackage ../development/libraries/haskell/monad-peel {};

  MonadPrompt = callPackage ../development/libraries/haskell/MonadPrompt {};

  MonadRandom = callPackage ../development/libraries/haskell/MonadRandom {};

  mongoDB = callPackage ../development/libraries/haskell/mongoDB {
    monadControl = self.monadControl_0_2_0_3;
  };

  mpppc = callPackage ../development/libraries/haskell/mpppc {};

  mtl_1_1_0_2 = callPackage ../development/libraries/haskell/mtl/1.1.0.2.nix {};
  mtl_1_1_1_1 = callPackage ../development/libraries/haskell/mtl/1.1.1.1.nix {};
  mtl_2_0_1_0 = callPackage ../development/libraries/haskell/mtl/2.0.1.0.nix {};
  mtl1 = self.mtl_1_1_0_2;
  mtl2 = self.mtl_2_0_1_0;
  mtl  = self.mtl1;

  mtlparse = callPackage ../development/libraries/haskell/mtlparse {};

  multiarg = callPackage ../development/libraries/haskell/multiarg {};

  multiplate = callPackage ../development/libraries/haskell/multiplate {};

  multirec = callPackage ../development/libraries/haskell/multirec {};

  multiset = callPackage ../development/libraries/haskell/multiset {};

  murmurHash = callPackage ../development/libraries/haskell/murmur-hash {};

  mwcRandom_0_10_0_1 = callPackage ../development/libraries/haskell/mwc-random/0.10.0.1.nix {};
  mwcRandom_0_11_0_0 = callPackage ../development/libraries/haskell/mwc-random/0.11.0.0.nix {};
  mwcRandom = self.mwcRandom_0_11_0_0;

  NanoProlog = callPackage ../development/libraries/haskell/NanoProlog {};

  neither = callPackage ../development/libraries/haskell/neither {};

  network_2_2_1_4 = callPackage ../development/libraries/haskell/network/2.2.1.4.nix {};
  network_2_2_1_7 = callPackage ../development/libraries/haskell/network/2.2.1.7.nix {};
  network_2_3_0_2 = callPackage ../development/libraries/haskell/network/2.3.0.2.nix {};
  network_2_3_0_5 = callPackage ../development/libraries/haskell/network/2.3.0.5.nix {};
  network_2_3_0_8 = callPackage ../development/libraries/haskell/network/2.3.0.8.nix {};
  network_2_3_0_10 = callPackage ../development/libraries/haskell/network/2.3.0.10.nix {};
  network = self.network_2_3_0_10;

  nixosTypes = callPackage ../development/libraries/haskell/nixos-types {};

  nonNegative = callPackage ../development/libraries/haskell/non-negative {};

  numericPrelude = callPackage ../development/libraries/haskell/numeric-prelude {};

  NumInstances = callPackage ../development/libraries/haskell/NumInstances {};

  numtype = callPackage ../development/libraries/haskell/numtype {};

  OneTuple = callPackage ../development/libraries/haskell/OneTuple {};

  ObjectName = callPackage ../development/libraries/haskell/ObjectName {};

  OpenAL = callPackage ../development/libraries/haskell/OpenAL {};

  OpenGL_2_2_1_1 = callPackage ../development/libraries/haskell/OpenGL/2.2.1.1.nix {};
  OpenGL_2_2_3_0 = callPackage ../development/libraries/haskell/OpenGL/2.2.3.0.nix {};
  OpenGL_2_4_0_2 = callPackage ../development/libraries/haskell/OpenGL/2.4.0.2.nix {};
  OpenGL_2_5_0_0 = callPackage ../development/libraries/haskell/OpenGL/2.5.0.0.nix {};
  OpenGL24 = self.OpenGL_2_4_0_2;
  OpenGL = self.OpenGL_2_5_0_0;

  OpenGLRaw = callPackage ../development/libraries/haskell/OpenGLRaw {};

  pathPieces_0_0_0 = callPackage ../development/libraries/haskell/path-pieces/0.0.0.nix {};
  pathPieces_0_1_0 = callPackage ../development/libraries/haskell/path-pieces/0.1.0.nix {};
  pathPieces = self.pathPieces_0_1_0;

  pandoc = callPackage ../development/libraries/haskell/pandoc {};

  pandocTypes = callPackage ../development/libraries/haskell/pandoc-types {};

  pango = callPackage ../development/libraries/haskell/pango {
    inherit (pkgs.gtkLibs) pango;
    libc = pkgs.stdenv.gcc.libc;
  };

  parallel_1_1_0_1 = callPackage ../development/libraries/haskell/parallel/1.1.0.1.nix {};
  parallel_2_2_0_1 = callPackage ../development/libraries/haskell/parallel/2.2.0.1.nix {};
  parallel_3_1_0_1 = callPackage ../development/libraries/haskell/parallel/3.1.0.1.nix {};
  parallel_3_2_0_2 = callPackage ../development/libraries/haskell/parallel/3.2.0.2.nix {};
  parallel = self.parallel_3_2_0_2;

  parseargs = callPackage ../development/libraries/haskell/parseargs {};

  parsec_2_1_0_1 = callPackage ../development/libraries/haskell/parsec/2.1.0.1.nix {};
  parsec_3_1_1   = callPackage ../development/libraries/haskell/parsec/3.1.1.nix {};
  parsec_3_1_2   = callPackage ../development/libraries/haskell/parsec/3.1.2.nix {};
  parsec2 = self.parsec_2_1_0_1;
  parsec3 = self.parsec_3_1_2;
  parsec  = self.parsec3;

  parsimony = callPackage ../development/libraries/haskell/parsimony {};

  Pathfinder = callPackage ../development/libraries/haskell/Pathfinder {};

  pathtype = callPackage ../development/libraries/haskell/pathtype {};

  pcreLight = callPackage ../development/libraries/haskell/pcre-light {};

  persistent = callPackage ../development/libraries/haskell/persistent {
    pathPieces = self.pathPieces_0_0_0;
  };

  persistentSqlite = callPackage ../development/libraries/haskell/persistent-sqlite {};

  persistentTemplate = callPackage ../development/libraries/haskell/persistent-template {};

  polyparse = callPackage ../development/libraries/haskell/polyparse/default.nix {};

  pool = callPackage ../development/libraries/haskell/pool {};

  poolConduit = callPackage ../development/libraries/haskell/pool-conduit {};

  ppm = callPackage ../development/libraries/haskell/ppm {};

  prettyShow = callPackage ../development/libraries/haskell/pretty-show {};

  primitive = callPackage ../development/libraries/haskell/primitive {};

  processLeksah = callPackage ../development/libraries/haskell/leksah/process-leksah.nix {};

  prolog = callPackage ../development/libraries/haskell/prolog {};
  prologGraphLib = callPackage ../development/libraries/haskell/prolog-graph-lib {
    fgl = self.fgl_5_4_2_4;
  };
  prologGraph = callPackage ../development/libraries/haskell/prolog-graph {
    fgl = self.fgl_5_4_2_4;
  };

  PSQueue = callPackage ../development/libraries/haskell/PSQueue {};

  pureMD5 = callPackage ../development/libraries/haskell/pureMD5 {};

  pwstoreFast = callPackage ../development/libraries/haskell/pwstore-fast {};

  QuickCheck_1_2_0_0 = callPackage ../development/libraries/haskell/QuickCheck/1.2.0.0.nix {};
  QuickCheck_1_2_0_1 = callPackage ../development/libraries/haskell/QuickCheck/1.2.0.1.nix {};
  QuickCheck_2_1_1_1 = callPackage ../development/libraries/haskell/QuickCheck/2.1.1.1.nix {};
  QuickCheck_2_4_0_1 = callPackage ../development/libraries/haskell/QuickCheck/2.4.0.1.nix {};
  QuickCheck_2_4_1_1 = callPackage ../development/libraries/haskell/QuickCheck/2.4.1.1.nix {};
  QuickCheck_2_4_2 = callPackage ../development/libraries/haskell/QuickCheck/2.4.2.nix {};
  QuickCheck1 = self.QuickCheck_1_2_0_1;
  QuickCheck2 = self.QuickCheck_2_4_2;
  QuickCheck  = self.QuickCheck2;

  RangedSets = callPackage ../development/libraries/haskell/Ranged-sets {};

  random_1_0_1_1 = callPackage ../development/libraries/haskell/random/1.0.1.1.nix {};
  random = null; # core package until ghc-7.2.1

  randomFu = callPackage ../development/libraries/haskell/random-fu {};

  randomSource = callPackage ../development/libraries/haskell/random-source {};

  randomShuffle = callPackage ../development/libraries/haskell/random-shuffle {};

  ranges = callPackage ../development/libraries/haskell/ranges {};

  rvar = callPackage ../development/libraries/haskell/rvar {};

  readline = callPackage ../development/libraries/haskell/readline {
    inherit (pkgs) readline;
  };

  recaptcha = callPackage ../development/libraries/haskell/recaptcha {};

  regexBase_0_72_0_2 = callPackage ../development/libraries/haskell/regex-base/0.72.0.2.nix {};
  regexBase_0_93_1   = callPackage ../development/libraries/haskell/regex-base/0.93.1.nix   {};
  regexBase_0_93_2   = callPackage ../development/libraries/haskell/regex-base/0.93.2.nix   {};
  regexBase = self.regexBase_0_93_2;

  regexCompat_0_71_0_1 = callPackage ../development/libraries/haskell/regex-compat/0.71.0.1.nix {};
  regexCompat_0_92     = callPackage ../development/libraries/haskell/regex-compat/0.92.nix     {};
  regexCompat_0_93_1   = callPackage ../development/libraries/haskell/regex-compat/0.93.1.nix   {};
  regexCompat_0_95_1   = callPackage ../development/libraries/haskell/regex-compat/0.95.1.nix   {
    regexPosix = self.regexPosix_0_95_1;
  };
  regexCompat93 = self.regexCompat_0_93_1;
  regexCompat = self.regexCompat_0_71_0_1;

  regexPosix_0_72_0_3 = callPackage ../development/libraries/haskell/regex-posix/0.72.0.3.nix {};
  regexPosix_0_94_1 = callPackage ../development/libraries/haskell/regex-posix/0.94.1.nix {};
  regexPosix_0_94_2 = callPackage ../development/libraries/haskell/regex-posix/0.94.2.nix {};
  regexPosix_0_94_4 = callPackage ../development/libraries/haskell/regex-posix/0.94.4.nix {};
  regexPosix_0_95_1 = callPackage ../development/libraries/haskell/regex-posix/0.95.1.nix {
    regexBase = self.regexBase_0_93_2;
  };
  regexPosix = self.regexPosix_0_95_1;

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

  RepLib = callPackage ../development/libraries/haskell/RepLib {};

  repr = callPackage ../development/libraries/haskell/repr {};

  resourcePool = callPackage ../development/libraries/haskell/resource-pool {};

  RSA = callPackage ../development/libraries/haskell/RSA {};

  safe = callPackage ../development/libraries/haskell/safe {};

  sendfile = callPackage ../development/libraries/haskell/sendfile {};

  semigroups = callPackage ../development/libraries/haskell/semigroups {};

  simpleSendfile = callPackage ../development/libraries/haskell/simple-sendfile {};

  skein = callPackage ../development/libraries/haskell/skein {};

  smallcheck = callPackage ../development/libraries/haskell/smallcheck {};

  snapCore = callPackage ../development/libraries/haskell/snap/core.nix {
    mwcRandom = self.mwcRandom_0_10_0_1;
  };

  snapServer = callPackage ../development/libraries/haskell/snap/server.nix {};

  socks = callPackage ../development/libraries/haskell/socks {};

  stateref = callPackage ../development/libraries/haskell/stateref {};

  StateVar = callPackage ../development/libraries/haskell/StateVar {};

  statistics = callPackage ../development/libraries/haskell/statistics {};

  streamproc = callPackage ../development/libraries/haskell/streamproc {};

  strict = callPackage ../development/libraries/haskell/strict {};

  stringCombinators = callPackage ../development/libraries/haskell/string-combinators {};

  syb_0_2_2 = callPackage ../development/libraries/haskell/syb/0.2.2.nix {};
  syb_0_3   = callPackage ../development/libraries/haskell/syb/0.3.nix {};
  syb_0_3_3 = callPackage ../development/libraries/haskell/syb/0.3.3.nix {};
  syb_0_3_6 = callPackage ../development/libraries/haskell/syb/0.3.6.nix {};
  syb       = null; # by default, we assume that syb ships with GHC, which is
                    # true for the older GHC versions

  sybWithClass = callPackage ../development/libraries/haskell/syb/syb-with-class.nix {};

  sybWithClassInstancesText = callPackage ../development/libraries/haskell/syb/syb-with-class-instances-text.nix {};

  SDLImage = callPackage ../development/libraries/haskell/SDL-image {};

  SDLMixer = callPackage ../development/libraries/haskell/SDL-mixer {};

  SDLTtf = callPackage ../development/libraries/haskell/SDL-ttf {};

  SDL = callPackage ../development/libraries/haskell/SDL {
    inherit (pkgs) SDL;
  };

  SHA = callPackage ../development/libraries/haskell/SHA {};

  shakespeare = callPackage ../development/libraries/haskell/shakespeare {};

  shakespeareCss = callPackage ../development/libraries/haskell/shakespeare-css {};

  shakespeareI18n = callPackage ../development/libraries/haskell/shakespeare-i18n {};

  shakespeareJs = callPackage ../development/libraries/haskell/shakespeare-js {};

  shakespeareText = callPackage ../development/libraries/haskell/shakespeare-text {};

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

  svgcairo = callPackage ../development/libraries/haskell/svgcairo {
    libc = pkgs.stdenv.gcc.libc;
  };

  systemFilepath = callPackage ../development/libraries/haskell/system-filepath {};

  systemFileio = callPackage ../development/libraries/haskell/system-fileio {};

  TableAlgebra = callPackage ../development/libraries/haskell/TableAlgebra {};

  tabular = callPackage ../development/libraries/haskell/tabular {};

  tagged = callPackage ../development/libraries/haskell/tagged {};

  tagsoup = callPackage ../development/libraries/haskell/tagsoup {};

  tagsoup_0_10_1 = callPackage ../development/libraries/haskell/tagsoup/0.10.1nix {};

  temporary = callPackage ../development/libraries/haskell/temporary {};

  Tensor = callPackage ../development/libraries/haskell/Tensor {};

  terminfo = callPackage ../development/libraries/haskell/terminfo {};

  testFramework = callPackage ../development/libraries/haskell/test-framework {};

  testFrameworkHunit = callPackage ../development/libraries/haskell/test-framework-hunit {};

  testFrameworkQuickcheck = callPackage ../development/libraries/haskell/test-framework-quickcheck {
    QuickCheck = self.QuickCheck1;
  };

  testFrameworkQuickcheck2 = callPackage ../development/libraries/haskell/test-framework-quickcheck2 {};

  testFrameworkTh = callPackage ../development/libraries/haskell/test-framework-th {};

  testpack = callPackage ../development/libraries/haskell/testpack {};

  texmath = callPackage ../development/libraries/haskell/texmath {};

  text_0_11_0_5 = callPackage ../development/libraries/haskell/text/0.11.0.5.nix {};
  text_0_11_0_6 = callPackage ../development/libraries/haskell/text/0.11.0.6.nix {};
  text_0_11_1_5 = callPackage ../development/libraries/haskell/text/0.11.1.5.nix {};
  text_0_11_1_13 = callPackage ../development/libraries/haskell/text/0.11.1.13.nix {};
  text = self.text_0_11_1_13;

  thespian = callPackage ../development/libraries/haskell/thespian {};

  thExtras = callPackage ../development/libraries/haskell/th-extras {};

  thLift = callPackage ../development/libraries/haskell/th-lift {};

  threadmanager = callPackage ../development/libraries/haskell/threadmanager {};

  time_1_1_2_4 = callPackage ../development/libraries/haskell/time/1.1.2.4.nix {};
  time_1_1_3   = callPackage ../development/libraries/haskell/time/1.1.3.nix {};
  time_1_2_0_3 = callPackage ../development/libraries/haskell/time/1.2.0.3.nix {};
  time_1_2_0_5 = callPackage ../development/libraries/haskell/time/1.2.0.5.nix {};
  time_1_4_0_1 = callPackage ../development/libraries/haskell/time/1.4.0.1.nix {};
  # time is in the core package set. It should only be necessary to
  # pass it explicitly in rare circumstances.
  time = null;

  tls = callPackage ../development/libraries/haskell/tls {};

  tlsExtra = callPackage ../development/libraries/haskell/tls-extra {};

  transformers_0_2_2_0 = callPackage ../development/libraries/haskell/transformers/0.2.2.0.nix {};
  transformers = self.transformers_0_2_2_0;

  transformersBase = callPackage ../development/libraries/haskell/transformers-base {};

  tuple = callPackage ../development/libraries/haskell/tuple {};

  typeEquality = callPackage ../development/libraries/haskell/type-equality {};

  unbound = callPackage ../development/libraries/haskell/unbound {};

  uniplate = callPackage ../development/libraries/haskell/uniplate {};

  uniqueid = callPackage ../development/libraries/haskell/uniqueid {};

  unixCompat = callPackage ../development/libraries/haskell/unix-compat {};

  unorderedContainers = callPackage ../development/libraries/haskell/unordered-containers {};

  url = callPackage ../development/libraries/haskell/url {};

  utf8Light = callPackage ../development/libraries/haskell/utf8-light {};

  utf8String = callPackage ../development/libraries/haskell/utf8-string {};

  utilityHt = callPackage ../development/libraries/haskell/utility-ht {};

  uulib = callPackage ../development/libraries/haskell/uulib {};

  uuParsinglib = callPackage ../development/libraries/haskell/uu-parsinglib {};

  vacuum = callPackage ../development/libraries/haskell/vacuum {};

  vacuumCairo = callPackage ../development/libraries/haskell/vacuum-cairo {};

  vault = callPackage ../development/libraries/haskell/vault {};

  Vec = callPackage ../development/libraries/haskell/Vec {};

  vector = callPackage ../development/libraries/haskell/vector {};

  vectorAlgorithms = callPackage ../development/libraries/haskell/vector-algorithms {};

  vectorSpace = callPackage ../development/libraries/haskell/vector-space {};

  vty = callPackage ../development/libraries/haskell/vty {
    mtl = self.mtl2;
  };

  wai = callPackage ../development/libraries/haskell/wai {};

  waiAppStatic = callPackage ../development/libraries/haskell/wai-app-static {};

  waiExtra = callPackage ../development/libraries/haskell/wai-extra {};

  waiLogger = callPackage ../development/libraries/haskell/wai-logger {};

  warp = callPackage ../development/libraries/haskell/warp {};

  WebBits_1_0 = callPackage ../development/libraries/haskell/WebBits/1.0.nix {
    parsec = self.parsec2;
  };
  WebBits_2_0 = callPackage ../development/libraries/haskell/WebBits/2.0.nix {
    parsec = self.parsec2;
  };
  WebBits_2_1 = callPackage ../development/libraries/haskell/WebBits/2.1.nix {};
  WebBits = self.WebBits_2_1;

  WebBitsHtml_1_0_1 = callPackage ../development/libraries/haskell/WebBits-Html/1.0.1.nix {
    WebBits = self.WebBits_2_0;
  };
  WebBitsHtml_1_0_2 = callPackage ../development/libraries/haskell/WebBits-Html/1.0.2.nix {
    WebBits = self.WebBits_2_0;
  };
  WebBitsHtml = self.WebBitsHtml_1_0_2;

  webRoutes = callPackage ../development/libraries/haskell/web-routes {};

  webRoutesQuasi = callPackage ../development/libraries/haskell/web-routes-quasi {
    pathPieces = self.pathPieces_0_0_0;
  };

  CouchDB = callPackage ../development/libraries/haskell/CouchDB {};

  wlPprintText = callPackage ../development/libraries/haskell/wl-pprint-text {};

  wx = callPackage ../development/libraries/haskell/wxHaskell/wx.nix {};

  wxcore = callPackage ../development/libraries/haskell/wxHaskell/wxcore.nix {
    wxGTK = pkgs.wxGTK28;
  };

  wxdirect = callPackage ../development/libraries/haskell/wxHaskell/wxdirect.nix {};

  X11 = callPackage ../development/libraries/haskell/X11 {};

  X11Xft = callPackage ../development/libraries/haskell/X11-xft {};

  xhtml_3000_2_0_1 = callPackage ../development/libraries/haskell/xhtml/3000.2.0.1.nix {};
  xhtml_3000_2_0_4 = callPackage ../development/libraries/haskell/xhtml/3000.2.0.4.nix {};
  xhtml_3000_2_0_5 = callPackage ../development/libraries/haskell/xhtml/3000.2.0.5.nix {};
  xhtml = self.xhtml_3000_2_0_5;

  xml = callPackage ../development/libraries/haskell/xml {};

  xmlConduit = callPackage ../development/libraries/haskell/xml-conduit {};

  xmlEnumerator = callPackage ../development/libraries/haskell/xml-enumerator {};

  xmlTypes = callPackage ../development/libraries/haskell/xml-types {};

  xssSanitize = callPackage ../development/libraries/haskell/xss-sanitize {};

  yaml = callPackage ../development/libraries/haskell/yaml {};

  yap = callPackage ../development/libraries/haskell/yap {};

  yesod = callPackage ../development/libraries/haskell/yesod {};

  yesodAuth = callPackage ../development/libraries/haskell/yesod-auth {};

  yesodCore = callPackage ../development/libraries/haskell/yesod-core {
    pathPieces = self.pathPieces_0_0_0;
  };

  yesodDefault = callPackage ../development/libraries/haskell/yesod-default {};

  yesodForm = callPackage ../development/libraries/haskell/yesod-form {};

  yesodJson = callPackage ../development/libraries/haskell/yesod-json {};

  yesodPersistent = callPackage ../development/libraries/haskell/yesod-persistent {};

  yesodStatic = callPackage ../development/libraries/haskell/yesod-static {};

  yst = callPackage ../development/libraries/haskell/yst {};

  zeromqHaskell = callPackage ../development/libraries/haskell/zeromq-haskell {};

  zipArchive = callPackage ../development/libraries/haskell/zip-archive {};

  zipper = callPackage ../development/libraries/haskell/zipper {};

  zlib_0_5_0_0 = callPackage ../development/libraries/haskell/zlib/0.5.0.0.nix {
    inherit (pkgs) zlib;
  };
  zlib_0_5_2_0 = callPackage ../development/libraries/haskell/zlib/0.5.2.0.nix {
    inherit (pkgs) zlib;
  };
  zlib_0_5_3_1 = callPackage ../development/libraries/haskell/zlib/0.5.3.1.nix {
    inherit (pkgs) zlib;
  };
  zlib_0_5_3_3 = callPackage ../development/libraries/haskell/zlib/0.5.3.1.nix {
    inherit (pkgs) zlib;
  };
  zlib = self.zlib_0_5_3_3;

  zlibBindings = callPackage ../development/libraries/haskell/zlib-bindings {};

  zlibConduit = callPackage ../development/libraries/haskell/zlib-conduit {};

  zlibEnum = callPackage ../development/libraries/haskell/zlib-enum {};

  Zwaluw = callPackage ../development/libraries/haskell/Zwaluw {};

  # Compilers.

  AgdaExecutable = callPackage ../development/compilers/Agda-executable {};

  uhc = callPackage ../development/compilers/uhc {};

  epic = callPackage ../development/compilers/epic {};

  flapjax = callPackage ../development/compilers/flapjax {};

  idris = callPackage ../development/compilers/idris {};

  pakcs = callPackage ../development/compilers/pakcs {
    syb = self.syb_0_2_2;
  };

  # Development tools.

  alex_2_3_1 = callPackage ../development/tools/parsing/alex/2.3.1.nix {};
  alex_2_3_2 = callPackage ../development/tools/parsing/alex/2.3.2.nix {};
  alex_2_3_3 = callPackage ../development/tools/parsing/alex/2.3.3.nix {};
  alex_2_3_5 = callPackage ../development/tools/parsing/alex/2.3.5.nix {};
  alex_3_0_1 = callPackage ../development/tools/parsing/alex/3.0.1.nix {};
  alex = self.alex_3_0_1;

  alexMeta = callPackage ../development/tools/haskell/alex-meta {};

  BNFC = callPackage ../development/tools/haskell/BNFC {};

  BNFCMeta = callPackage ../development/tools/haskell/BNFC-meta {};

  cpphs = callPackage ../development/tools/misc/cpphs {};

  Ebnf2ps = callPackage ../development/tools/parsing/Ebnf2ps {};

  # 2012-02-09: Disabled because upstream site has disappeared. This tool is clearly
  #             unmaintained, and we should delete it unless anyone complains.
  # frown = callPackage ../development/tools/parsing/frown {};

  haddock_2_4_2 = callPackage ../development/tools/documentation/haddock/2.4.2.nix {};
  haddock_2_7_2 = callPackage ../development/tools/documentation/haddock/2.7.2.nix {};
  haddock_2_9_2 = callPackage ../development/tools/documentation/haddock/2.9.2.nix {};
  haddock_2_9_4 = callPackage ../development/tools/documentation/haddock/2.9.4.nix {};
  haddock = self.haddock_2_9_4;

  happy_1_18_4 = callPackage ../development/tools/parsing/happy/1.18.4.nix {};
  happy_1_18_5 = callPackage ../development/tools/parsing/happy/1.18.5.nix {};
  happy_1_18_6 = callPackage ../development/tools/parsing/happy/1.18.6.nix {};
  happy_1_18_8 = callPackage ../development/tools/parsing/happy/1.18.8.nix {};
  happy_1_18_9 = callPackage ../development/tools/parsing/happy/1.18.9.nix {};
  happy = self.happy_1_18_9;

  happyMeta = callPackage ../development/tools/haskell/happy-meta {};

  # 2012-02-09: Disabled because this package is clearly, and it won't compile with
  #             any recent version of GHC. We should delete it unless anyone
  #             complains.
  # HaRe = callPackage ../development/tools/haskell/HaRe {};

  hlint = callPackage ../development/tools/haskell/hlint {};

  hslogger = callPackage ../development/tools/haskell/hslogger {};

  SourceGraph = callPackage ../development/tools/haskell/SourceGraph {};

  tar = callPackage ../development/tools/haskell/tar {};

  threadscope = callPackage ../development/tools/haskell/threadscope {};

  uuagcBootstrap = callPackage ../development/tools/haskell/uuagc/bootstrap.nix {};
  uuagcCabal = callPackage ../development/tools/haskell/uuagc/cabal.nix {};
  uuagc = callPackage ../development/tools/haskell/uuagc {};

  # Applications.

  darcs = callPackage ../applications/version-management/darcs {
    regexCompat = self.regexCompat93;
  };

  leksah = callPackage ../applications/editors/leksah {};

  xmobar = callPackage ../applications/misc/xmobar {
    parsec = self.parsec3;
  };

  xmonad = callPackage ../applications/window-managers/xmonad {};

  xmonadContrib = callPackage ../applications/window-managers/xmonad/xmonad-contrib.nix {};

  xmonadExtras = callPackage ../applications/window-managers/xmonad/xmonad-extras.nix {};

  # Tools.

  cabal2nix = callPackage ../development/tools/haskell/cabal2nix {};

  cabalGhci = callPackage ../development/tools/haskell/cabal-ghci {};

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
