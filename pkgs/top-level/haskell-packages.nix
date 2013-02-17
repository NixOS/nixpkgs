# Haskell packages in Nixpkgs
#
# If you have any questions about the packages defined here or how to
# contribute, please contact Andres Loeh.
#
# This file defines all packages that depend on GHC, the Glasgow Haskell
# compiler. They are usually distributed via Hackage, the central Haskell
# package repository. Since at least the libraries are incompatible between
# different compiler versions, the whole file is parameterized by the GHC
# that is being used. GHC itself is composed in haskell-defaults.nix.
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
  # packages. It isn't the Cabal library, which is spelled "Cabal".

  cabal = callPackage ../build-support/cabal {
    enableLibraryProfiling = enableLibraryProfiling;
  };

  # Haskell Platform
  #
  # We try to support several platform versions. For these, we set all
  # versions explicitly.
  #
  # DO NOT CHANGE THE VERSIONS LISTED HERE from the actual Haskell
  # Platform defaults. If you must update the defaults for a particular
  # GHC version, change the "preferences function" for that GHC version
  # in haskell-defaults.nix.

  # NOTE: 2012.4.0.0 is the current default.

  haskellPlatformArgs_future = self : {
    inherit (self) cabal ghc;
    async        = self.async_2_0_1_4;          # 7.6 ok
    cgi          = self.cgi_3001_1_8_3;         # 7.6 ok
    fgl          = self.fgl_5_4_2_4;            # 7.6 ok
    GLUT         = self.GLUT_2_3_1_0;           # 7.6 ok
    haskellSrc   = self.haskellSrc_1_0_1_5;     # 7.6 ok
    html         = self.html_1_0_1_2;           # 7.6 ok
    HTTP         = self.HTTP_4000_2_7;          # 7.6 ok
    HUnit        = self.HUnit_1_2_5_1;          # 7.6 ok
    mtl          = self.mtl_2_1_2;              # 7.6 ok
    network      = self.network_2_4_1_0;        # 7.6 ok
    OpenGL       = self.OpenGL_2_6_0_1;         # 7.6 ok
    parallel     = self.parallel_3_2_0_3;       # 7.6 ok
    parsec       = self.parsec_3_1_3;           # 7.6 ok
    QuickCheck   = self.QuickCheck_2_5_1_1;     # 7.6 ok
    random       = self.random_1_0_1_1;         # 7.6 ok
    regexBase    = self.regexBase_0_93_2;       # 7.6 ok
    regexCompat  = self.regexCompat_0_95_1;     # 7.6 ok
    regexPosix   = self.regexPosix_0_95_2;      # 7.6 ok
    split        = self.split_0_2_1_2;          # 7.6 ok
    stm          = self.stm_2_4_2;              # 7.6 ok
    syb          = self.syb_0_3_7;              # 7.6 ok
    text         = self.text_0_11_2_3;          # 7.6 ok
    transformers = self.transformers_0_3_0_0;   # 7.6 ok
    vector       = self.vector_0_10_0_1;        # 7.6 ok
    xhtml        = self.xhtml_3000_2_1;         # 7.6 ok
    zlib         = self.zlib_0_5_4_0;           # 7.6 ok
    cabalInstall = self.cabalInstall_1_16_0_2;  # 7.6 ok
    alex         = self.alex_3_0_2;             # 7.6 ok
    haddock      = self.haddock_2_13_1;         # 7.6 ok
    happy        = self.happy_1_18_10;          # 7.6 ok
    primitive    = self.primitive_0_5_0_1; # semi-official, but specified
  };

  haskellPlatformArgs_2012_4_0_0 = self : {
    inherit (self) cabal ghc;
    async        = self.async_2_0_1_3;
    cgi          = self.cgi_3001_1_7_4;
    fgl          = self.fgl_5_4_2_4;
    GLUT         = self.GLUT_2_1_2_1;
    haskellSrc   = self.haskellSrc_1_0_1_5;
    html         = self.html_1_0_1_2;
    HTTP         = self.HTTP_4000_2_5;
    HUnit        = self.HUnit_1_2_5_1;
    mtl          = self.mtl_2_1_2;
    network      = self.network_2_3_1_0;
    OpenGL       = self.OpenGL_2_2_3_1;
    parallel     = self.parallel_3_2_0_3;
    parsec       = self.parsec_3_1_3;
    QuickCheck   = self.QuickCheck_2_5_1_1;
    random       = self.random_1_0_1_1;
    regexBase    = self.regexBase_0_93_2;
    regexCompat  = self.regexCompat_0_95_1;
    regexPosix   = self.regexPosix_0_95_2;
    split        = self.split_0_2_1_1;
    stm          = self.stm_2_4;
    syb          = self.syb_0_3_7;
    text         = self.text_0_11_2_3;
    transformers = self.transformers_0_3_0_0;
    vector       = self.vector_0_10_0_1;
    xhtml        = self.xhtml_3000_2_1;
    zlib         = self.zlib_0_5_4_0;
    cabalInstall = self.cabalInstall_0_14_0;
    alex         = self.alex_3_0_2;
    haddock      = self.haddock_2_11_0;
    happy        = self.happy_1_18_10;
    primitive    = self.primitive_0_5_0_1; # semi-official, but specified
  };

  haskellPlatform_2012_4_0_0 =
    callPackage ../development/libraries/haskell/haskell-platform/2012.4.0.0.nix
      (self.haskellPlatformArgs_2012_4_0_0 self);

  haskellPlatformArgs_2012_2_0_0 = self : {
    inherit (self) cabal ghc;
    cgi          = self.cgi_3001_1_7_4;         # 7.4.1 ok
    fgl          = self.fgl_5_4_2_4;            # 7.4.1 ok
    GLUT         = self.GLUT_2_1_2_1;           # 7.4.1 ok
    haskellSrc   = self.haskellSrc_1_0_1_5;     # 7.4.1 ok
    html         = self.html_1_0_1_2;           # 7.4.1 ok
    HTTP         = self.HTTP_4000_2_3;          # 7.4.1 ok
    HUnit        = self.HUnit_1_2_4_2;          # 7.4.1 ok
    mtl          = self.mtl_2_1_1;              # 7.4.1 ok
    network      = self.network_2_3_0_13;       # 7.4.1 ok
    OpenGL       = self.OpenGL_2_2_3_1;         # 7.4.1 ok
    parallel     = self.parallel_3_2_0_2;       # 7.4.1 ok
    parsec       = self.parsec_3_1_2;           # 7.4.1 ok
    QuickCheck   = self.QuickCheck_2_4_2;       # 7.4.1 ok
    random       = self.random_1_0_1_1;         # 7.4.1 ok
    regexBase    = self.regexBase_0_93_2;       # 7.4.1 ok
    regexCompat  = self.regexCompat_0_95_1;     # 7.4.1 ok
    regexPosix   = self.regexPosix_0_95_1;      # 7.4.1 ok
    stm          = self.stm_2_3;                # 7.4.1 ok
    syb          = self.syb_0_3_6_1;            # 7.4.1 ok
    text         = self.text_0_11_2_0;          # 7.4.1 ok
    transformers = self.transformers_0_3_0_0;   # 7.4.1 ok
    xhtml        = self.xhtml_3000_2_1;         # 7.4.1 ok
    zlib         = self.zlib_0_5_3_3;           # 7.4.1 ok
    cabalInstall = self.cabalInstall_0_14_0;    # 7.4.1 ok
    alex         = self.alex_3_0_1;             # 7.4.1 ok
    haddock      = self.haddock_2_10_0;         # 7.4.1 ok
    happy        = self.happy_1_18_9;           # 7.4.1 ok
  };

  haskellPlatform_2012_2_0_0 =
    callPackage ../development/libraries/haskell/haskell-platform/2012.2.0.0.nix
      (self.haskellPlatformArgs_2012_2_0_0 self);

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

  haskellPlatform_2009_2_0_2 =
    callPackage ../development/libraries/haskell/haskell-platform/2009.2.0.2.nix
      (self.haskellPlatformArgs_2009_2_0_2 self);

  # Haskell libraries.

  Agda = callPackage ../development/libraries/haskell/Agda {};

  accelerate = callPackage ../development/libraries/haskell/accelerate {};

  accelerateCuda = callPackage ../development/libraries/haskell/accelerate-cuda {};

  accelerateExamples = callPackage ../development/libraries/haskell/accelerate-examples {};

  accelerateIo = callPackage ../development/libraries/haskell/accelerate-io {};

  active = callPackage ../development/libraries/haskell/active {};

  ACVector = callPackage ../development/libraries/haskell/AC-Vector {};

  abstractDeque = callPackage ../development/libraries/haskell/abstract-deque {};

  abstractPar = callPackage ../development/libraries/haskell/abstract-par {};

  aeson = callPackage ../development/libraries/haskell/aeson {};

  alternativeIo = callPackage ../development/libraries/haskell/alternative-io {};

  appar = callPackage ../development/libraries/haskell/appar {};

  ansiTerminal = callPackage ../development/libraries/haskell/ansi-terminal {};

  ansiWlPprint = callPackage ../development/libraries/haskell/ansi-wl-pprint {};

  arrows = callPackage ../development/libraries/haskell/arrows {};

  asn1Data = callPackage ../development/libraries/haskell/asn1-data {};

  AspectAG = callPackage ../development/libraries/haskell/AspectAG {};

  async_2_0_1_3 = callPackage ../development/libraries/haskell/async/2.0.1.3.nix {};
  async_2_0_1_4 = callPackage ../development/libraries/haskell/async/2.0.1.4.nix {};
  async = self.async_2_0_1_4;

  attempt = callPackage ../development/libraries/haskell/attempt {};

  attoparsec = callPackage ../development/libraries/haskell/attoparsec {};

  attoparsecBinary = callPackage ../development/libraries/haskell/attoparsec-binary {};

  attoparsecConduit = callPackage ../development/libraries/haskell/attoparsec-conduit {};

  attoparsecEnumerator = callPackage ../development/libraries/haskell/attoparsec/enumerator.nix {};

  authenticate = callPackage ../development/libraries/haskell/authenticate {};

  base16Bytestring = callPackage ../development/libraries/haskell/base16-bytestring {};

  base64String = callPackage ../development/libraries/haskell/base64-string {};

  base64Bytestring = callPackage ../development/libraries/haskell/base64-bytestring {};

  base64Conduit = callPackage ../development/libraries/haskell/base64-conduit {};

  baseUnicodeSymbols = callPackage ../development/libraries/haskell/base-unicode-symbols {};

  basicPrelude = callPackage ../development/libraries/haskell/basic-prelude {};

  benchpress = callPackage ../development/libraries/haskell/benchpress {};

  bifunctors = callPackage ../development/libraries/haskell/bifunctors {};

  bimap = callPackage ../development/libraries/haskell/bimap {};

  binary_hackage = callPackage ../development/libraries/haskell/binary {};
  binary = self.binary_hackage; # core package since ghc-7.2.1

  binaryShared = callPackage ../development/libraries/haskell/binary-shared {};

  bitarray = callPackage ../development/libraries/haskell/bitarray {};

  bitmap = callPackage ../development/libraries/haskell/bitmap {};

  bitsAtomic = callPackage ../development/libraries/haskell/bits-atomic {};

  bktrees = callPackage ../development/libraries/haskell/bktrees {};

  blazeBuilder = callPackage ../development/libraries/haskell/blaze-builder {};

  blazeBuilderConduit = callPackage ../development/libraries/haskell/blaze-builder-conduit {};

  blazeBuilderEnumerator = callPackage ../development/libraries/haskell/blaze-builder-enumerator {};

  blazeHtml = callPackage ../development/libraries/haskell/blaze-html {};

  blazeMarkup = callPackage ../development/libraries/haskell/blaze-markup {};

  blazeSvg = callPackage ../development/libraries/haskell/blaze-svg {};

  blazeTextual = callPackage ../development/libraries/haskell/blaze-textual {};

  bloomfilter = callPackage ../development/libraries/haskell/bloomfilter {};

  bmp_1_2_2_1 = callPackage ../development/libraries/haskell/bmp/1.2.2.1.nix {};
  bmp_1_2_3_4 = callPackage ../development/libraries/haskell/bmp/1.2.3.4.nix {};
  bmp = self.bmp_1_2_2_1;       # later versions work only with ghc 7.6 and beyond

  Boolean = callPackage ../development/libraries/haskell/Boolean {};

  brainfuck = callPackage ../development/libraries/haskell/brainfuck {};

  bson = callPackage ../development/libraries/haskell/bson {};

  boomerang = callPackage ../development/libraries/haskell/boomerang {};

  byteorder = callPackage ../development/libraries/haskell/byteorder {};

  bytestringNums = callPackage ../development/libraries/haskell/bytestring-nums {};

  bytestringLexing = callPackage ../development/libraries/haskell/bytestring-lexing {};

  bytestringMmap = callPackage ../development/libraries/haskell/bytestring-mmap {};

  bytestringTrie = callPackage ../development/libraries/haskell/bytestring-trie {};

  c2hs = callPackage ../development/libraries/haskell/c2hs {
    languageC = self.languageC_0_3_2_1;
  };

  Cabal_1_14_0 = callPackage ../development/libraries/haskell/Cabal/1.14.0.nix { cabal = self.cabal.override { Cabal = null; }; };
  Cabal_1_16_0_3 = callPackage ../development/libraries/haskell/Cabal/1.16.0.3.nix { cabal = self.cabal.override { Cabal = null; }; };
  Cabal = null; # core package in GHC

  cabalFileTh = callPackage ../development/libraries/haskell/cabal-file-th {};

  cabalMacosx = callPackage ../development/libraries/haskell/cabal-macosx {};

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
  cgi_3001_1_8_3 = callPackage ../development/libraries/haskell/cgi/3001.1.8.3.nix {};
  cgi = self.cgi_3001_1_8_3;

  Chart = callPackage ../development/libraries/haskell/Chart {};

  citeprocHs = callPackage ../development/libraries/haskell/citeproc-hs {};

  cipherAes = callPackage ../development/libraries/haskell/cipher-aes {};

  cipherRc4 = callPackage ../development/libraries/haskell/cipher-rc4 {};

  classyPrelude = callPackage ../development/libraries/haskell/classy-prelude {};

  classyPreludeConduit = callPackage ../development/libraries/haskell/classy-prelude-conduit {};

  clientsession = callPackage ../development/libraries/haskell/clientsession {};

  cmdargs = callPackage ../development/libraries/haskell/cmdargs {};

  cmdlib = callPackage ../development/libraries/haskell/cmdlib {};

  colorizeHaskell = callPackage ../development/libraries/haskell/colorize-haskell {};

  colour = callPackage ../development/libraries/haskell/colour {};

  comonad = callPackage ../development/libraries/haskell/comonad {};

  comonadsFd = callPackage ../development/libraries/haskell/comonads-fd {};

  comonadTransformers = callPackage ../development/libraries/haskell/comonad-transformers {};

  compactStringFix = callPackage ../development/libraries/haskell/compact-string-fix {};

  conduit = callPackage ../development/libraries/haskell/conduit {};

  ConfigFile = callPackage ../development/libraries/haskell/ConfigFile {};

  configurator = callPackage ../development/libraries/haskell/configurator {};

  convertible = callPackage ../development/libraries/haskell/convertible {};

  continuedFractions = callPackage ../development/libraries/haskell/continued-fractions {};

  contravariant = callPackage ../development/libraries/haskell/contravariant {};

  converge = callPackage ../development/libraries/haskell/converge {};

  cookie = callPackage ../development/libraries/haskell/cookie {};

  cprngAes = callPackage ../development/libraries/haskell/cprng-aes {};

  criterion = callPackage ../development/libraries/haskell/criterion {};

  Crypto = callPackage ../development/libraries/haskell/Crypto {};

  cryptoApi = callPackage ../development/libraries/haskell/crypto-api {};

  cryptocipher = callPackage ../development/libraries/haskell/cryptocipher {};

  cryptoConduit = callPackage ../development/libraries/haskell/crypto-conduit {};

  cryptohash = callPackage ../development/libraries/haskell/cryptohash {};

  cryptoNumbers = callPackage ../development/libraries/haskell/crypto-numbers {};

  cryptoPubkeyTypes = callPackage ../development/libraries/haskell/crypto-pubkey-types {};

  cryptoPubkey = callPackage ../development/libraries/haskell/crypto-pubkey {};

  cryptoRandomApi = callPackage ../development/libraries/haskell/crypto-random-api {};

  cuda = callPackage ../development/libraries/haskell/cuda {
    inherit (pkgs.linuxPackages) nvidia_x11;
  };

  csv = callPackage ../development/libraries/haskell/csv {};

  cssText = callPackage ../development/libraries/haskell/css-text {};

  curl = callPackage ../development/libraries/haskell/curl { curl = pkgs.curl; };

  cpu = callPackage ../development/libraries/haskell/cpu {};

  dataAccessor = callPackage ../development/libraries/haskell/data-accessor/data-accessor.nix {};

  dataAccessorTemplate = callPackage ../development/libraries/haskell/data-accessor/data-accessor-template.nix {};

  dataBinaryIeee754 = callPackage ../development/libraries/haskell/data-binary-ieee754 {};

  dataDefault = callPackage ../development/libraries/haskell/data-default {};

  dataenc = callPackage ../development/libraries/haskell/dataenc {};

  dataInttrie = callPackage ../development/libraries/haskell/data-inttrie {};

  dataLens = callPackage ../development/libraries/haskell/data-lens {};

  dataLensTemplate = callPackage ../development/libraries/haskell/data-lens-template {};

  dataMemocombinators = callPackage ../development/libraries/haskell/data-memocombinators {};

  dataReify = callPackage ../development/libraries/haskell/data-reify {};

  dateCache = callPackage ../development/libraries/haskell/date-cache {};

  datetime = callPackage ../development/libraries/haskell/datetime {};

  DAV = callPackage ../development/libraries/haskell/DAV {};

  dbus = callPackage ../development/libraries/haskell/dbus {};

  deepseq_1_1_0_0 = callPackage ../development/libraries/haskell/deepseq/1.1.0.0.nix {};
  deepseq_1_1_0_2 = callPackage ../development/libraries/haskell/deepseq/1.1.0.2.nix {};
  deepseq_1_2_0_1 = callPackage ../development/libraries/haskell/deepseq/1.2.0.1.nix {};
  deepseq_1_3_0_1 = callPackage ../development/libraries/haskell/deepseq/1.3.0.1.nix {};
  deepseq = null; # a core package in recent GHCs

  deepseqTh = callPackage ../development/libraries/haskell/deepseq-th {};

  derive = callPackage ../development/libraries/haskell/derive {};

  derp = callPackage ../development/libraries/haskell/derp {};

  diagrams = callPackage ../development/libraries/haskell/diagrams/diagrams.nix {};
  diagramsCairo = callPackage ../development/libraries/haskell/diagrams/cairo.nix {};
  diagramsCore = callPackage ../development/libraries/haskell/diagrams/core.nix {};
  diagramsContrib = callPackage ../development/libraries/haskell/diagrams/contrib.nix {};
  diagramsLib = callPackage ../development/libraries/haskell/diagrams/lib.nix {};
  diagramsSvg = callPackage ../development/libraries/haskell/diagrams/svg.nix {};

  Diff = callPackage ../development/libraries/haskell/Diff {};

  digest = callPackage ../development/libraries/haskell/digest {
    inherit (pkgs) zlib;
  };

  digestiveFunctors = callPackage ../development/libraries/haskell/digestive-functors {};

  digestiveFunctorsHeist = callPackage ../development/libraries/haskell/digestive-functors-heist {};

  digestiveFunctorsSnap = callPackage ../development/libraries/haskell/digestive-functors-snap {};

  dimensional = callPackage ../development/libraries/haskell/dimensional {};

  dimensionalTf = callPackage ../development/libraries/haskell/dimensional-tf {};

  directoryTree = callPackage ../development/libraries/haskell/directory-tree {};

  distributedProcess = callPackage ../development/libraries/haskell/distributed-process {};

  distributedProcessSimplelocalnet = callPackage ../development/libraries/haskell/distributed-process-simplelocalnet {};

  distributedStatic = callPackage ../development/libraries/haskell/distributed-static {};

  distributive = callPackage ../development/libraries/haskell/distributive {};

  dlist = callPackage ../development/libraries/haskell/dlist {};

  dns = callPackage ../development/libraries/haskell/dns {};

  doctest = callPackage ../development/libraries/haskell/doctest {};

  dotgen = callPackage ../development/libraries/haskell/dotgen {};

  doubleConversion = callPackage ../development/libraries/haskell/double-conversion {};

  download = callPackage ../development/libraries/haskell/download {};

  downloadCurl = callPackage ../development/libraries/haskell/download-curl {};

  DSH = callPackage ../development/libraries/haskell/DSH {};

  dstring = callPackage ../development/libraries/haskell/dstring {};

  dualTree = callPackage ../development/libraries/haskell/dual-tree {};

  editDistance = callPackage ../development/libraries/haskell/edit-distance {};

  editline = callPackage ../development/libraries/haskell/editline {};

  elerea = callPackage ../development/libraries/haskell/elerea {};

  emailValidate = callPackage ../development/libraries/haskell/email-validate {};

  enumerator = callPackage ../development/libraries/haskell/enumerator {};

  entropy = callPackage ../development/libraries/haskell/entropy {};

  erf = callPackage ../development/libraries/haskell/erf {};

  errors = callPackage ../development/libraries/haskell/errors {};

  either = callPackage ../development/libraries/haskell/either {};

  exceptionMtl = callPackage ../development/libraries/haskell/exception-mtl {};

  exceptionTransformers = callPackage ../development/libraries/haskell/exception-transformers {};

  explicitException = callPackage ../development/libraries/haskell/explicit-exception {};

  executablePath = callPackage ../development/libraries/haskell/executable-path {};

  filepath_1_3_0_0 = callPackage ../development/libraries/haskell/filepath {};
  filepath = null; # a core package in recent GHCs

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

  filesystemConduit = callPackage ../development/libraries/haskell/filesystem-conduit {};

  fgl_5_4_2_2 = callPackage ../development/libraries/haskell/fgl/5.4.2.2.nix {};
  fgl_5_4_2_3 = callPackage ../development/libraries/haskell/fgl/5.4.2.3.nix {};
  fgl_5_4_2_4 = callPackage ../development/libraries/haskell/fgl/5.4.2.4.nix {};
  fgl = self.fgl_5_4_2_4;

  fglVisualize = callPackage ../development/libraries/haskell/fgl-visualize {};

  fingertree = callPackage ../development/libraries/haskell/fingertree {};

  forceLayout = callPackage ../development/libraries/haskell/force-layout {};

  fsnotify = callPackage ../development/libraries/haskell/fsnotify {};

  gamma = callPackage ../development/libraries/haskell/gamma {};

  geniplate = callPackage ../development/libraries/haskell/geniplate {};

  gd = callPackage ../development/libraries/haskell/gd {
    inherit (pkgs) gd zlib;
  };

  gdiff = callPackage ../development/libraries/haskell/gdiff {};

  genericDeriving = callPackage ../development/libraries/haskell/generic-deriving {};

  ghcCore = callPackage ../development/libraries/haskell/ghc-core {};

  ghcEvents = callPackage ../development/libraries/haskell/ghc-events {};

  ghcHeapView = callPackage ../development/libraries/haskell/ghc-heap-view {
    cabal = self.cabal.override { enableLibraryProfiling = false; }; # pkg cannot be built with profiling enabled
  };

  ghcMod = callPackage ../development/libraries/haskell/ghc-mod {
    inherit (pkgs) emacs;
  };

  ghcMtl = callPackage ../development/libraries/haskell/ghc-mtl {};

  ghcPaths = callPackage ../development/libraries/haskell/ghc-paths {};

  ghcSyb = callPackage ../development/libraries/haskell/ghc-syb {};

  ghcSybUtils = callPackage ../development/libraries/haskell/ghc-syb-utils {};

  ghcVis = callPackage ../development/libraries/haskell/ghc-vis {
    cabal = self.cabal.override { enableLibraryProfiling = false; }; # pkg cannot be built with profiling enabled
  };

  gio = callPackage ../development/libraries/haskell/gio {};

  gitit = callPackage ../development/libraries/haskell/gitit {};

  glade = callPackage ../development/libraries/haskell/glade {
    inherit (pkgs.gnome) libglade;
    gtkC = pkgs.gtk;
    libc = pkgs.stdenv.gcc.libc;
  };

  GLFW = callPackage ../development/libraries/haskell/GLFW {};

  glib = callPackage ../development/libraries/haskell/glib {
    glib = pkgs.glib;
    libc = pkgs.stdenv.gcc.libc;
  };

  GlomeVec = callPackage ../development/libraries/haskell/GlomeVec {};

  gloss = callPackage ../development/libraries/haskell/gloss {
    OpenGL = self.OpenGL_2_6_0_1;
    GLUT   = self.GLUT_2_3_1_0;
  };

  glpkHs = callPackage ../development/libraries/haskell/glpk-hs {};

  GLURaw = callPackage ../development/libraries/haskell/GLURaw {};

  GLUT_2_1_1_2 = callPackage ../development/libraries/haskell/GLUT/2.1.1.2.nix {};
  GLUT_2_1_2_1 = callPackage ../development/libraries/haskell/GLUT/2.1.2.1.nix {};
  GLUT_2_1_2_2 = callPackage ../development/libraries/haskell/GLUT/2.1.2.2.nix {};
  GLUT_2_2_2_1 = callPackage ../development/libraries/haskell/GLUT/2.2.2.1.nix {
    OpenGL = self.OpenGL_2_4_0_2;
  };
  GLUT_2_3_1_0 = callPackage ../development/libraries/haskell/GLUT/2.3.1.0.nix {
    OpenGL = self.OpenGL_2_6_0_1;
  };
  GLUT = self.GLUT_2_3_1_0;

  gnuidn = callPackage ../development/libraries/haskell/gnuidn {};

  gnutls = callPackage ../development/libraries/haskell/gnutls { inherit (pkgs) gnutls; };

  gsasl = callPackage ../development/libraries/haskell/gsasl { inherit (pkgs) gsasl; };

  gtk = callPackage ../development/libraries/haskell/gtk {
    inherit (pkgs) gtk;
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
    polyparse = self.polyparse_1_7;
  };

  groupoids = callPackage ../development/libraries/haskell/groupoids {};

  hakyll = callPackage ../development/libraries/haskell/hakyll {};

  hamlet = callPackage ../development/libraries/haskell/hamlet {};

  happstackUtil = callPackage ../development/libraries/haskell/happstack/happstack-util.nix {};

  happstackServer = callPackage ../development/libraries/haskell/happstack/happstack-server.nix {};

  happstackHamlet = callPackage ../development/libraries/haskell/happstack/happstack-hamlet.nix {};

  hashable_1_1_2_5 = callPackage ../development/libraries/haskell/hashable/1.1.2.5.nix {};
  hashable_1_2_0_5 = callPackage ../development/libraries/haskell/hashable/1.2.0.5.nix {};
  hashable = self.hashable_1_1_2_5;

  hashedStorage = callPackage ../development/libraries/haskell/hashed-storage {};

  hashtables = callPackage ../development/libraries/haskell/hashtables {};

  haskeline_0_6_4_7 = callPackage ../development/libraries/haskell/haskeline/0.6.4.7.nix {};
  haskeline_0_7_0_3 = callPackage ../development/libraries/haskell/haskeline/0.7.0.3.nix {};
  haskeline = self.haskeline_0_7_0_3;

  haskelineClass = callPackage ../development/libraries/haskell/haskeline-class {};

  haskellLexer = callPackage ../development/libraries/haskell/haskell-lexer {};

  haskellMpi = callPackage ../development/libraries/haskell/haskell-mpi {
    mpi = pkgs.openmpi;
  };

  haskellSrc_1_0_1_3 = callPackage ../development/libraries/haskell/haskell-src/1.0.1.3.nix {};
  haskellSrc_1_0_1_4 = callPackage ../development/libraries/haskell/haskell-src/1.0.1.4.nix {};
  haskellSrc_1_0_1_5 = callPackage ../development/libraries/haskell/haskell-src/1.0.1.5.nix {};
  haskellSrc = self.haskellSrc_1_0_1_5;

  haskellSrcExts_1_11_1 = callPackage ../development/libraries/haskell/haskell-src-exts/1.11.1.nix {};
  haskellSrcExts_1_13_5 = callPackage ../development/libraries/haskell/haskell-src-exts/1.13.5.nix {};
  haskellSrcExts = self.haskellSrcExts_1_13_5;

  haskellSrcMeta = callPackage ../development/libraries/haskell/haskell-src-meta {};

  hastache = callPackage ../development/libraries/haskell/hastache {};

  hexpat = callPackage ../development/libraries/haskell/hexpat {};

  HTTP_4000_0_6 = callPackage ../development/libraries/haskell/HTTP/4000.0.6.nix {};
  HTTP_4000_0_9 = callPackage ../development/libraries/haskell/HTTP/4000.0.9.nix {};
  HTTP_4000_1_1 = callPackage ../development/libraries/haskell/HTTP/4000.1.1.nix {};
  HTTP_4000_1_2 = callPackage ../development/libraries/haskell/HTTP/4000.1.2.nix {};
  HTTP_4000_2_1 = callPackage ../development/libraries/haskell/HTTP/4000.2.1.nix {};
  HTTP_4000_2_2 = callPackage ../development/libraries/haskell/HTTP/4000.2.2.nix {};
  HTTP_4000_2_3 = callPackage ../development/libraries/haskell/HTTP/4000.2.3.nix {};
  HTTP_4000_2_5 = callPackage ../development/libraries/haskell/HTTP/4000.2.5.nix {};
  HTTP_4000_2_7 = callPackage ../development/libraries/haskell/HTTP/4000.2.7.nix {};
  HTTP = self.HTTP_4000_2_7;

  httpReverseProxy = callPackage ../development/libraries/haskell/http-reverse-proxy {};

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

  HDBCSqlite3 = callPackage ../development/libraries/haskell/HDBC/HDBC-sqlite3.nix {};

  heist = callPackage ../development/libraries/haskell/heist {};

  HFuse = callPackage ../development/libraries/haskell/hfuse {};

  HGL = callPackage ../development/libraries/haskell/HGL {};

  highlightingKate = callPackage ../development/libraries/haskell/highlighting-kate {};

  hinotify = callPackage ../development/libraries/haskell/hinotify {};

  hint = callPackage ../development/libraries/haskell/hint {};

  Hipmunk = callPackage ../development/libraries/haskell/Hipmunk {};

  hjsmin = callPackage ../development/libraries/haskell/hjsmin {};

  hledger = callPackage ../development/libraries/haskell/hledger {};
  hledgerLib = callPackage ../development/libraries/haskell/hledger-lib {};
  hledgerInterest = callPackage ../applications/office/hledger-interest {};
  hledgerWeb = callPackage ../development/libraries/haskell/hledger-web {};

  HList = callPackage ../development/libraries/haskell/HList {};

  hmatrix = callPackage ../development/libraries/haskell/hmatrix {};

  hoauth = callPackage ../development/libraries/haskell/hoauth {};

  hoogle = callPackage ../development/libraries/haskell/hoogle {};

  hopenssl = callPackage ../development/libraries/haskell/hopenssl {};

  hostname = callPackage ../development/libraries/haskell/hostname {};

  hp2anyCore = callPackage ../development/libraries/haskell/hp2any-core {};

  hp2anyGraph = callPackage ../development/libraries/haskell/hp2any-graph {};

  hS3 = callPackage ../development/libraries/haskell/hS3 {};

  hsBibutils = callPackage ../development/libraries/haskell/hs-bibutils {};

  hscolour = callPackage ../development/libraries/haskell/hscolour {};

  hsdns = callPackage ../development/libraries/haskell/hsdns {};

  hsemail = callPackage ../development/libraries/haskell/hsemail {};

  HSH = callPackage ../development/libraries/haskell/HSH {};

  HsSyck = callPackage ../development/libraries/haskell/HsSyck {};

  HsOpenSSL = callPackage ../development/libraries/haskell/HsOpenSSL {};

  HStringTemplate = callPackage ../development/libraries/haskell/HStringTemplate {};

  hspread = callPackage ../development/libraries/haskell/hspread {};

  hsloggerTemplate = callPackage ../development/libraries/haskell/hslogger-template {};

  hspec = callPackage ../development/libraries/haskell/hspec {};

  hspecExpectations = callPackage ../development/libraries/haskell/hspec-expectations {};

  hsyslog = callPackage ../development/libraries/haskell/hsyslog {};

  html_1_0_1_2 = callPackage ../development/libraries/haskell/html/1.0.1.2.nix {};
  html = self.html_1_0_1_2;

  htmlConduit = callPackage ../development/libraries/haskell/html-conduit {};

  httpConduit = callPackage ../development/libraries/haskell/http-conduit {};

  httpdShed = callPackage ../development/libraries/haskell/httpd-shed {};

  httpDate = callPackage ../development/libraries/haskell/http-date {};

  httpTypes = callPackage ../development/libraries/haskell/http-types {};

  HUnit_1_2_0_3 = callPackage ../development/libraries/haskell/HUnit/1.2.0.3.nix {};
  HUnit_1_2_2_1 = callPackage ../development/libraries/haskell/HUnit/1.2.2.1.nix {};
  HUnit_1_2_2_3 = callPackage ../development/libraries/haskell/HUnit/1.2.2.3.nix {};
  HUnit_1_2_4_2 = callPackage ../development/libraries/haskell/HUnit/1.2.4.2.nix {};
  HUnit_1_2_4_3 = callPackage ../development/libraries/haskell/HUnit/1.2.4.3.nix {};
  HUnit_1_2_5_1 = callPackage ../development/libraries/haskell/HUnit/1.2.5.1.nix {};
  HUnit = self.HUnit_1_2_5_1;

  hxt = callPackage ../development/libraries/haskell/hxt {};

  hxtCharproperties = callPackage ../development/libraries/haskell/hxt-charproperties {};

  hxtRegexXmlschema = callPackage ../development/libraries/haskell/hxt-regex-xmlschema {};

  hxtUnicode = callPackage ../development/libraries/haskell/hxt-unicode {};

  IfElse = callPackage ../development/libraries/haskell/IfElse {};

  ieee754 = callPackage ../development/libraries/haskell/ieee754 {};

  instantGenerics = callPackage ../development/libraries/haskell/instant-generics {};

  ioChoice = callPackage ../development/libraries/haskell/io-choice {};

  IORefCAS = callPackage ../development/libraries/haskell/IORefCAS {};

  IOSpec = callPackage ../development/libraries/haskell/IOSpec {};

  ioStorage = callPackage ../development/libraries/haskell/io-storage {};

  iproute = callPackage ../development/libraries/haskell/iproute {};

  irc = callPackage ../development/libraries/haskell/irc {
    parsec = self.parsec2;
  };

  iteratee = callPackage ../development/libraries/haskell/iteratee {};

  ivor = callPackage ../development/libraries/haskell/ivor {};

  JuicyPixels = callPackage ../development/libraries/haskell/JuicyPixels {};

  jpeg = callPackage ../development/libraries/haskell/jpeg {};

  JsContracts = callPackage ../development/libraries/haskell/JsContracts {
    WebBits = self.WebBits_1_0;
    WebBitsHtml = self.WebBitsHtml_1_0_1;
  };

  json = callPackage ../development/libraries/haskell/json {};

  jsonTypes = callPackage ../development/libraries/haskell/jsonTypes {};

  kansasLava = callPackage ../development/libraries/haskell/kansas-lava {};

  languageC_0_4_2   = callPackage ../development/libraries/haskell/language-c/0.4.2.nix {};
  languageC_0_3_2_1 = callPackage ../development/libraries/haskell/language-c/0.3.2.1.nix {};
  languageC = self.languageC_0_4_2;

  languageCQuote = callPackage ../development/libraries/haskell/language-c-quote/default.nix {};

  languageJavascript = callPackage ../development/libraries/haskell/language-javascript {};

  languageHaskellExtract = callPackage ../development/libraries/haskell/language-haskell-extract {};

  lambdabot = callPackage ../development/libraries/haskell/lambdabot {};

  lambdabotUtils = callPackage ../development/libraries/haskell/lambdabot-utils {};

  lambdacubeEngine = callPackage ../development/libraries/haskell/lambdacube-engine {};

  largeword = callPackage ../development/libraries/haskell/largeword {};

  lazysmallcheck = callPackage ../development/libraries/haskell/lazysmallcheck {};

  leksahServer = callPackage ../development/libraries/haskell/leksah/leksah-server.nix {};

  lens = callPackage ../development/libraries/haskell/lens {};

  libmpd = callPackage ../development/libraries/haskell/libmpd {};

  liblastfm = callPackage ../development/libraries/haskell/liblastfm {};

  libxmlSax = callPackage ../development/libraries/haskell/libxml-sax {};

  liftedBase = callPackage ../development/libraries/haskell/lifted-base {};

  List = callPackage ../development/libraries/haskell/List {};

  ListLike = callPackage ../development/libraries/haskell/ListLike {};

  ListZipper = callPackage ../development/libraries/haskell/ListZipper {};

  lrucache = callPackage ../development/libraries/haskell/lrucache {};

  ltk = callPackage ../development/libraries/haskell/ltk {};

  logfloat = callPackage ../development/libraries/haskell/logfloat {};

  logict = callPackage ../development/libraries/haskell/logict {};

  mathFunctions = callPackage ../development/libraries/haskell/math-functions {};

  mainlandPretty = callPackage ../development/libraries/haskell/mainland-pretty {};

  maude = callPackage ../development/libraries/haskell/maude {};

  MaybeT = callPackage ../development/libraries/haskell/MaybeT {};

  MemoTrie = callPackage ../development/libraries/haskell/MemoTrie {};

  mersenneRandomPure64 = callPackage ../development/libraries/haskell/mersenne-random-pure64 {};

  minimorph = callPackage ../development/libraries/haskell/minimorph {};

  miniutter = callPackage ../development/libraries/haskell/miniutter {};

  mimeMail = callPackage ../development/libraries/haskell/mime-mail {};

  mimeTypes = callPackage ../development/libraries/haskell/mime-types {};

  MissingH = callPackage ../development/libraries/haskell/MissingH {};

  mmap = callPackage ../development/libraries/haskell/mmap {};

  MonadCatchIOMtl = callPackage ../development/libraries/haskell/MonadCatchIO-mtl {};

  MonadCatchIOTransformers = callPackage ../development/libraries/haskell/MonadCatchIO-transformers {};

  monadControl = callPackage ../development/libraries/haskell/monad-control {};

  monadcryptorandom = callPackage ../development/libraries/haskell/monadcryptorandom {};

  monadLoops = callPackage ../development/libraries/haskell/monad-loops {};

  monadLogger = callPackage ../development/libraries/haskell/monad-logger {};

  monadPar_0_1_0_3 = callPackage ../development/libraries/haskell/monad-par/0.1.0.3.nix {};
  monadPar_0_3 = callPackage ../development/libraries/haskell/monad-par/0.3.nix {};
  monadPar = self.monadPar_0_3;

  monadParExtras = callPackage ../development/libraries/haskell/monad-par-extras {};

  monadPeel = callPackage ../development/libraries/haskell/monad-peel {};

  MonadPrompt = callPackage ../development/libraries/haskell/MonadPrompt {};

  MonadRandom = callPackage ../development/libraries/haskell/MonadRandom {};

  monadsTf = callPackage ../development/libraries/haskell/monads-tf {};

  monoidExtras = callPackage ../development/libraries/haskell/monoid-extras {};

  mongoDB = callPackage ../development/libraries/haskell/mongoDB {};

  mpppc = callPackage ../development/libraries/haskell/mpppc {};

  mtl_1_1_0_2 = callPackage ../development/libraries/haskell/mtl/1.1.0.2.nix {};
  mtl_1_1_1_1 = callPackage ../development/libraries/haskell/mtl/1.1.1.1.nix {};
  mtl_2_0_1_0 = callPackage ../development/libraries/haskell/mtl/2.0.1.0.nix {};
  mtl_2_1_1 = callPackage ../development/libraries/haskell/mtl/2.1.1.nix {
    transformers = self.transformers_0_3_0_0;
  };
  mtl_2_1_2 = callPackage ../development/libraries/haskell/mtl/2.1.2.nix {
    transformers = self.transformers_0_3_0_0;
  };
  mtl = self.mtl_2_1_2;

  mtlparse = callPackage ../development/libraries/haskell/mtlparse {};

  multiarg = callPackage ../development/libraries/haskell/multiarg {};

  multiplate = callPackage ../development/libraries/haskell/multiplate {};

  multirec = callPackage ../development/libraries/haskell/multirec {};

  multiset_0_2_1 = callPackage ../development/libraries/haskell/multiset/0.2.1.nix {};
  multiset_0_2_2 = callPackage ../development/libraries/haskell/multiset/0.2.2.nix {};
  multiset = self.multiset_0_2_1;   # later versions work only with ghc 7.6 and beyond

  murmurHash = callPackage ../development/libraries/haskell/murmur-hash {};

  mwcRandom = callPackage ../development/libraries/haskell/mwc-random {};

  NanoProlog = callPackage ../development/libraries/haskell/NanoProlog {};

  nat = callPackage ../development/libraries/haskell/nat {};

  nats = callPackage ../development/libraries/haskell/nats {};

  naturals = callPackage ../development/libraries/haskell/naturals {};

  netlist = callPackage ../development/libraries/haskell/netlist {};

  netlistToVhdl = callPackage ../development/libraries/haskell/netlist-to-vhdl {};

  network_2_2_1_4 = callPackage ../development/libraries/haskell/network/2.2.1.4.nix {};
  network_2_2_1_7 = callPackage ../development/libraries/haskell/network/2.2.1.7.nix {};
  network_2_3_0_2 = callPackage ../development/libraries/haskell/network/2.3.0.2.nix {};
  network_2_3_0_5 = callPackage ../development/libraries/haskell/network/2.3.0.5.nix {};
  network_2_3_0_13 = callPackage ../development/libraries/haskell/network/2.3.0.13.nix {};
  network_2_3_1_0 = callPackage ../development/libraries/haskell/network/2.3.1.0.nix {};
  network_2_4_1_0 = callPackage ../development/libraries/haskell/network/2.4.1.0.nix {};
  network = self.network_2_4_1_0;

  networkConduit = callPackage ../development/libraries/haskell/network-conduit {};

  networkInfo = callPackage ../development/libraries/haskell/network-info {};

  networkMulticast = callPackage ../development/libraries/haskell/network-multicast {};

  networkPprotocolXmpp = callPackage ../development/libraries/haskell/network-protocol-xmpp {};

  networkTransport = callPackage ../development/libraries/haskell/network-transport {};

  networkTransportTcp = callPackage ../development/libraries/haskell/network-transport-tcp {};

  newtype = callPackage ../development/libraries/haskell/newtype {};

  nonNegative = callPackage ../development/libraries/haskell/non-negative {};

  numericPrelude = callPackage ../development/libraries/haskell/numeric-prelude {};

  NumInstances = callPackage ../development/libraries/haskell/NumInstances {};

  numbers = callPackage ../development/libraries/haskell/numbers {};

  numtype = callPackage ../development/libraries/haskell/numtype {};

  numtypeTf = callPackage ../development/libraries/haskell/numtype-tf {};

  OneTuple = callPackage ../development/libraries/haskell/OneTuple {};

  ObjectName = callPackage ../development/libraries/haskell/ObjectName {};

  oeis = callPackage ../development/libraries/haskell/oeis {};

  OpenAL = callPackage ../development/libraries/haskell/OpenAL {};

  OpenGL_2_2_1_1 = callPackage ../development/libraries/haskell/OpenGL/2.2.1.1.nix {};
  OpenGL_2_2_3_0 = callPackage ../development/libraries/haskell/OpenGL/2.2.3.0.nix {};
  OpenGL_2_2_3_1 = callPackage ../development/libraries/haskell/OpenGL/2.2.3.1.nix {};
  OpenGL_2_4_0_2 = callPackage ../development/libraries/haskell/OpenGL/2.4.0.2.nix {};
  OpenGL_2_6_0_1 = callPackage ../development/libraries/haskell/OpenGL/2.6.0.1.nix {};
  OpenGL = self.OpenGL_2_6_0_1;

  OpenGLRaw = callPackage ../development/libraries/haskell/OpenGLRaw {};

  optparseApplicative = callPackage ../development/libraries/haskell/optparse-applicative {};

  pathPieces = callPackage ../development/libraries/haskell/path-pieces {};

  pandoc = callPackage ../development/libraries/haskell/pandoc {};

  pandocTypes = callPackage ../development/libraries/haskell/pandoc-types {};

  pango = callPackage ../development/libraries/haskell/pango {
    inherit (pkgs) pango;
    libc = pkgs.stdenv.gcc.libc;
  };

  parallel_1_1_0_1 = callPackage ../development/libraries/haskell/parallel/1.1.0.1.nix {};
  parallel_2_2_0_1 = callPackage ../development/libraries/haskell/parallel/2.2.0.1.nix {};
  parallel_3_1_0_1 = callPackage ../development/libraries/haskell/parallel/3.1.0.1.nix {};
  parallel_3_2_0_2 = callPackage ../development/libraries/haskell/parallel/3.2.0.2.nix {};
  parallel_3_2_0_3 = callPackage ../development/libraries/haskell/parallel/3.2.0.3.nix {};
  parallel = self.parallel_3_2_0_3;

  parallelIo = callPackage ../development/libraries/haskell/parallel-io {};

  parseargs = callPackage ../development/libraries/haskell/parseargs {};

  parsec_2_1_0_1 = callPackage ../development/libraries/haskell/parsec/2.1.0.1.nix {};
  parsec_3_1_1   = callPackage ../development/libraries/haskell/parsec/3.1.1.nix {};
  parsec_3_1_2   = callPackage ../development/libraries/haskell/parsec/3.1.2.nix {};
  parsec_3_1_3   = callPackage ../development/libraries/haskell/parsec/3.1.3.nix {};
  parsec2 = self.parsec_2_1_0_1;
  parsec3 = self.parsec_3_1_3;
  parsec  = self.parsec3;

  parsimony = callPackage ../development/libraries/haskell/parsimony {};

  Pathfinder = callPackage ../development/libraries/haskell/Pathfinder {};

  pathtype = callPackage ../development/libraries/haskell/pathtype {};

  pcreLight = callPackage ../development/libraries/haskell/pcre-light {};

  pem = callPackage ../development/libraries/haskell/pem {};

  permutation = callPackage ../development/libraries/haskell/permutation {};

  persistent = callPackage ../development/libraries/haskell/persistent {};

  persistentPostgresql = callPackage ../development/libraries/haskell/persistent-postgresql {};

  persistentSqlite = callPackage ../development/libraries/haskell/persistent-sqlite {};

  persistentTemplate = callPackage ../development/libraries/haskell/persistent-template {};

  pgm = callPackage ../development/libraries/haskell/pgm {};

  polyparse_1_7 = callPackage ../development/libraries/haskell/polyparse/1.7.nix {};
  polyparse_1_8 = callPackage ../development/libraries/haskell/polyparse/1.8.nix {};
  polyparse = self.polyparse_1_8;

  poolConduit = callPackage ../development/libraries/haskell/pool-conduit {};

  postgresqlLibpq = callPackage ../development/libraries/haskell/postgresql-libpq {
    postgresql = pkgs.postgresql91;
  };

  postgresqlSimple = callPackage ../development/libraries/haskell/postgresql-simple {};

  ppm = callPackage ../development/libraries/haskell/ppm {};

  prettyShow = callPackage ../development/libraries/haskell/pretty-show {};

  primitive_0_4_1 = callPackage ../development/libraries/haskell/primitive/0.4.1.nix {};
  primitive_0_5   = callPackage ../development/libraries/haskell/primitive/0.5.nix   {};
  primitive_0_5_0_1 = callPackage ../development/libraries/haskell/primitive/0.5.0.1.nix   {};
  primitive = self.primitive_0_5_0_1;

  profunctors = callPackage ../development/libraries/haskell/profunctors {};

  profunctorExtras = callPackage ../development/libraries/haskell/profunctor-extras {};

  projectTemplate = callPackage ../development/libraries/haskell/project-template {};

  processExtras = callPackage ../development/libraries/haskell/process-extras {};

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
  QuickCheck_2_5_1_1 = callPackage ../development/libraries/haskell/QuickCheck/2.5.1.1.nix {};
  QuickCheck1 = self.QuickCheck_1_2_0_1;
  QuickCheck2 = self.QuickCheck_2_5_1_1;
  QuickCheck  = self.QuickCheck2;

  RangedSets = callPackage ../development/libraries/haskell/Ranged-sets {};

  random_1_0_1_1 = callPackage ../development/libraries/haskell/random/1.0.1.1.nix {};
  random = null; # core package until ghc-7.2.1

  randomFu = callPackage ../development/libraries/haskell/random-fu {};

  randomSource = callPackage ../development/libraries/haskell/random-source {};

  randomShuffle = callPackage ../development/libraries/haskell/random-shuffle {};

  rank1dynamic = callPackage ../development/libraries/haskell/rank1dynamic {};

  ranges = callPackage ../development/libraries/haskell/ranges {};

  rvar = callPackage ../development/libraries/haskell/rvar {};

  reactiveBanana = callPackage ../development/libraries/haskell/reactive-banana {};

  reactiveBananaWx = callPackage ../development/libraries/haskell/reactive-banana-wx {};

  ReadArgs = callPackage ../development/libraries/haskell/ReadArgs {};

  readline = callPackage ../development/libraries/haskell/readline {
    inherit (pkgs) readline;
  };

  recaptcha = callPackage ../development/libraries/haskell/recaptcha {};

  reflection = callPackage ../development/libraries/haskell/reflection {};

  regexBase_0_72_0_2 = callPackage ../development/libraries/haskell/regex-base/0.72.0.2.nix {};
  regexBase_0_93_1   = callPackage ../development/libraries/haskell/regex-base/0.93.1.nix   {};
  regexBase_0_93_2   = callPackage ../development/libraries/haskell/regex-base/0.93.2.nix   {};
  regexBase = self.regexBase_0_93_2;

  regexCompat_0_71_0_1 = callPackage ../development/libraries/haskell/regex-compat/0.71.0.1.nix {};
  regexCompat_0_92     = callPackage ../development/libraries/haskell/regex-compat/0.92.nix     {};
  regexCompat_0_93_1   = callPackage ../development/libraries/haskell/regex-compat/0.93.1.nix   {};
  regexCompat_0_95_1   = callPackage ../development/libraries/haskell/regex-compat/0.95.1.nix   {};
  regexCompat93 = self.regexCompat_0_93_1;
  regexCompat = self.regexCompat_0_71_0_1;

  regexPosix_0_72_0_3 = callPackage ../development/libraries/haskell/regex-posix/0.72.0.3.nix {};
  regexPosix_0_94_1 = callPackage ../development/libraries/haskell/regex-posix/0.94.1.nix {};
  regexPosix_0_94_2 = callPackage ../development/libraries/haskell/regex-posix/0.94.2.nix {};
  regexPosix_0_94_4 = callPackage ../development/libraries/haskell/regex-posix/0.94.4.nix {};
  regexPosix_0_95_1 = callPackage ../development/libraries/haskell/regex-posix/0.95.1.nix {};
  regexPosix_0_95_2 = callPackage ../development/libraries/haskell/regex-posix/0.95.2.nix {};
  regexPosix = self.regexPosix_0_95_2;

  regexTDFA = callPackage ../development/libraries/haskell/regex-tdfa {};
  regexTdfa = self.regexTDFA;

  regexPCRE = callPackage ../development/libraries/haskell/regex-pcre {};
  regexPcre = self.regexPCRE;

  regexpr = callPackage ../development/libraries/haskell/regexpr {};

  regular = callPackage ../development/libraries/haskell/regular {};

  remote = callPackage ../development/libraries/haskell/remote {};

  repa = callPackage ../development/libraries/haskell/repa {};
  repaAlgorithms = callPackage ../development/libraries/haskell/repa-algorithms {};
  repaExamples = callPackage ../development/libraries/haskell/repa-examples {};
  repaIo = callPackage ../development/libraries/haskell/repa-io {};

  RepLib = callPackage ../development/libraries/haskell/RepLib {};

  repr = callPackage ../development/libraries/haskell/repr {};

  resourcePool = callPackage ../development/libraries/haskell/resource-pool {};

  resourcet = callPackage ../development/libraries/haskell/resourcet {};

  RSA = callPackage ../development/libraries/haskell/RSA {};

  safe = callPackage ../development/libraries/haskell/safe {};

  SafeSemaphore = callPackage ../development/libraries/haskell/SafeSemaphore {};

  sendfile = callPackage ../development/libraries/haskell/sendfile {};

  semigroups = callPackage ../development/libraries/haskell/semigroups {};

  semigroupoids = callPackage ../development/libraries/haskell/semigroupoids {};

  semigroupoidExtras = callPackage ../development/libraries/haskell/semigroupoid-extras {};

  setenv = callPackage ../development/libraries/haskell/setenv {};

  shelly = callPackage ../development/libraries/haskell/shelly {};

  simpleSendfile = callPackage ../development/libraries/haskell/simple-sendfile {};

  silently = callPackage ../development/libraries/haskell/silently {};

  sizedTypes = callPackage ../development/libraries/haskell/sized-types {};

  skein = callPackage ../development/libraries/haskell/skein {};

  smallcheck = callPackage ../development/libraries/haskell/smallcheck {};

  snap = callPackage ../development/libraries/haskell/snap/snap.nix {};

  snapCore = callPackage ../development/libraries/haskell/snap/core.nix {};

  snapLoaderDynamic = callPackage ../development/libraries/haskell/snap/loader-dynamic.nix {};

  snapLoaderStatic = callPackage ../development/libraries/haskell/snap/loader-static.nix {};

  snapServer = callPackage ../development/libraries/haskell/snap/server.nix {};

  socks = callPackage ../development/libraries/haskell/socks {};

  srcloc = callPackage ../development/libraries/haskell/srcloc {};

  stateref = callPackage ../development/libraries/haskell/stateref {};

  StateVar = callPackage ../development/libraries/haskell/StateVar {};

  statistics = callPackage ../development/libraries/haskell/statistics {};

  streamproc = callPackage ../development/libraries/haskell/streamproc {};

  strict = callPackage ../development/libraries/haskell/strict {};

  stringCombinators = callPackage ../development/libraries/haskell/string-combinators {};

  stringQq = callPackage ../development/libraries/haskell/string-qq {};

  stringsearch = callPackage ../development/libraries/haskell/stringsearch {};

  strptime = callPackage ../development/libraries/haskell/strptime {};

  stylishHaskell = callPackage ../development/libraries/haskell/stylish-haskell {};

  syb_0_2_2 = callPackage ../development/libraries/haskell/syb/0.2.2.nix {};
  syb_0_3 = callPackage ../development/libraries/haskell/syb/0.3.nix {};
  syb_0_3_3 = callPackage ../development/libraries/haskell/syb/0.3.3.nix {};
  syb_0_3_6_1 = callPackage ../development/libraries/haskell/syb/0.3.6.1.nix {};
  syb_0_3_6_2 = callPackage ../development/libraries/haskell/syb/0.3.6.2.nix {};
  syb_0_3_7 = callPackage ../development/libraries/haskell/syb/0.3.7.nix {};
  syb = null;  # by default, we assume that syb ships with GHC, which is
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

  show = callPackage ../development/libraries/haskell/show {};

  SMTPClient = callPackage ../development/libraries/haskell/SMTPClient {};

  split_0_2_1_1 = callPackage ../development/libraries/haskell/split/0.2.1.1.nix {};
  split_0_2_1_2 = callPackage ../development/libraries/haskell/split/0.2.1.2.nix {};
  split = self.split_0_2_1_2;

  stbImage = callPackage ../development/libraries/haskell/stb-image {};

  stm_2_1_1_2 = callPackage ../development/libraries/haskell/stm/2.1.1.2.nix {};
  stm_2_1_2_1 = callPackage ../development/libraries/haskell/stm/2.1.2.1.nix {};
  stm_2_2_0_1 = callPackage ../development/libraries/haskell/stm/2.2.0.1.nix {};
  stm_2_3 = callPackage ../development/libraries/haskell/stm/2.3.nix {};
  stm_2_4 = callPackage ../development/libraries/haskell/stm/2.4.nix {};
  stm_2_4_2 = callPackage ../development/libraries/haskell/stm/2.4.2.nix {};
  stm = self.stm_2_4_2;

  storableComplex = callPackage ../development/libraries/haskell/storable-complex {};

  storableRecord = callPackage ../development/libraries/haskell/storable-record {};

  Stream = callPackage ../development/libraries/haskell/Stream {};

  strictConcurrency = callPackage ../development/libraries/haskell/strictConcurrency {};

  svgcairo = callPackage ../development/libraries/haskell/svgcairo {
    libc = pkgs.stdenv.gcc.libc;
  };

  symbol = callPackage ../development/libraries/haskell/symbol {};

  systemFilepath = callPackage ../development/libraries/haskell/system-filepath {};

  systemFileio = callPackage ../development/libraries/haskell/system-fileio {};

  TableAlgebra = callPackage ../development/libraries/haskell/TableAlgebra {};

  tabular = callPackage ../development/libraries/haskell/tabular {};

  tagged = callPackage ../development/libraries/haskell/tagged {};

  tagsoup = callPackage ../development/libraries/haskell/tagsoup {};

  tagstreamConduit = callPackage ../development/libraries/haskell/tagstream-conduit {};

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

  testFrameworkThPrime = callPackage ../development/libraries/haskell/test-framework-th-prime {};

  testpack = callPackage ../development/libraries/haskell/testpack {};

  texmath = callPackage ../development/libraries/haskell/texmath {};

  text_0_11_0_5 = callPackage ../development/libraries/haskell/text/0.11.0.5.nix {};
  text_0_11_0_6 = callPackage ../development/libraries/haskell/text/0.11.0.6.nix {};
  text_0_11_1_5 = callPackage ../development/libraries/haskell/text/0.11.1.5.nix {};
  text_0_11_1_13 = callPackage ../development/libraries/haskell/text/0.11.1.13.nix {};
  text_0_11_2_0 = callPackage ../development/libraries/haskell/text/0.11.2.0.nix {};
  text_0_11_2_3 = callPackage ../development/libraries/haskell/text/0.11.2.3.nix {};
  text = self.text_0_11_2_3;

  thespian = callPackage ../development/libraries/haskell/thespian {};

  thExtras = callPackage ../development/libraries/haskell/th-extras {};

  thLift = callPackage ../development/libraries/haskell/th-lift {};

  thOrphans = callPackage ../development/libraries/haskell/th-orphans {};

  threadmanager = callPackage ../development/libraries/haskell/threadmanager {};

  threads = callPackage ../development/libraries/haskell/threads {};

  time_1_1_2_4 = callPackage ../development/libraries/haskell/time/1.1.2.4.nix {};
  time_1_4_0_2 = callPackage ../development/libraries/haskell/time/1.4.0.2.nix {};
  # time is in the core package set. It should only be necessary to
  # pass it explicitly in rare circumstances.
  time = null;

  timeCompat = callPackage ../development/libraries/haskell/time-compat {};

  tls = callPackage ../development/libraries/haskell/tls {};

  tlsExtra = callPackage ../development/libraries/haskell/tls-extra {};

  transformers_0_2_2_0 = callPackage ../development/libraries/haskell/transformers/0.2.2.0.nix {};
  transformers_0_3_0_0 = callPackage ../development/libraries/haskell/transformers/0.3.0.0.nix {};
  transformers = self.transformers_0_3_0_0;

  transformersBase = callPackage ../development/libraries/haskell/transformers-base {};

  transformersCompat = callPackage ../development/libraries/haskell/transformers-compat {};

  tuple = callPackage ../development/libraries/haskell/tuple {};

  typeEquality = callPackage ../development/libraries/haskell/type-equality {};

  typeLlevelNaturalNumber = callPackage ../development/libraries/haskell/type-level-natural-number {};

  unbound = callPackage ../development/libraries/haskell/unbound {};

  uniplate = callPackage ../development/libraries/haskell/uniplate {};

  uniqueid = callPackage ../development/libraries/haskell/uniqueid {};

  unixCompat = callPackage ../development/libraries/haskell/unix-compat {};

  unixTime = callPackage ../development/libraries/haskell/unix-time {};

  unlambda = callPackage ../development/libraries/haskell/unlambda {};

  unorderedContainers = callPackage ../development/libraries/haskell/unordered-containers {};

  url = callPackage ../development/libraries/haskell/url {};

  urlencoded = callPackage ../development/libraries/haskell/urlencoded {};

  utf8Light = callPackage ../development/libraries/haskell/utf8-light {};

  utf8String = callPackage ../development/libraries/haskell/utf8-string {};

  utilityHt = callPackage ../development/libraries/haskell/utility-ht {};

  uulib = callPackage ../development/libraries/haskell/uulib {};

  uuParsinglib = callPackage ../development/libraries/haskell/uu-parsinglib {};

  vacuum = callPackage ../development/libraries/haskell/vacuum {};

  vacuumCairo = callPackage ../development/libraries/haskell/vacuum-cairo {};

  vault = callPackage ../development/libraries/haskell/vault {};

  vcsRevision = callPackage ../development/libraries/haskell/vcs-revision {};

  Vec = callPackage ../development/libraries/haskell/Vec {};

  vect = callPackage ../development/libraries/haskell/vect {};

  vector_0_9_1 = callPackage ../development/libraries/haskell/vector/0.9.1.nix {};
  vector_0_10 = callPackage ../development/libraries/haskell/vector/0.10.nix  {};
  vector_0_10_0_1  = callPackage ../development/libraries/haskell/vector/0.10.0.1.nix  {};
  vector = self.vector_0_10_0_1;

  vectorAlgorithms = callPackage ../development/libraries/haskell/vector-algorithms {};

  vectorSpace = callPackage ../development/libraries/haskell/vector-space {};

  vectorSpacePoints = callPackage ../development/libraries/haskell/vector-space-points {};

  void = callPackage ../development/libraries/haskell/void {};

  vty = callPackage ../development/libraries/haskell/vty {};

  wai = callPackage ../development/libraries/haskell/wai {};

  waiAppStatic = callPackage ../development/libraries/haskell/wai-app-static {};

  waiExtra = callPackage ../development/libraries/haskell/wai-extra {};

  waiLogger = callPackage ../development/libraries/haskell/wai-logger {};

  waiTest = callPackage ../development/libraries/haskell/wai-test {};

  warp = callPackage ../development/libraries/haskell/warp {};

  WebBits_1_0 = callPackage ../development/libraries/haskell/WebBits/1.0.nix {
    parsec = self.parsec2;
  };
  WebBits_2_0 = callPackage ../development/libraries/haskell/WebBits/2.0.nix {
    parsec = self.parsec2;
  };
  WebBits_2_2 = callPackage ../development/libraries/haskell/WebBits/2.2.nix {};
  WebBits = self.WebBits_2_2;

  WebBitsHtml_1_0_1 = callPackage ../development/libraries/haskell/WebBits-Html/1.0.1.nix {
    WebBits = self.WebBits_2_0;
  };
  WebBitsHtml_1_0_2 = callPackage ../development/libraries/haskell/WebBits-Html/1.0.2.nix {
    WebBits = self.WebBits_2_0;
  };
  WebBitsHtml = self.WebBitsHtml_1_0_2;

  CouchDB = callPackage ../development/libraries/haskell/CouchDB {};

  wlPprintText = callPackage ../development/libraries/haskell/wl-pprint-text {};

  word8 = callPackage ../development/libraries/haskell/word8 {};

  wx = callPackage ../development/libraries/haskell/wxHaskell/wx.nix {};

  wxc = callPackage ../development/libraries/haskell/wxHaskell/wxc.nix {
    wxGTK = pkgs.wxGTK29;
  };

  wxcore = callPackage ../development/libraries/haskell/wxHaskell/wxcore.nix {
    wxGTK = pkgs.wxGTK29;
  };

  wxdirect = callPackage ../development/libraries/haskell/wxHaskell/wxdirect.nix {};

  X11 = callPackage ../development/libraries/haskell/X11 {};

  X11Xft = callPackage ../development/libraries/haskell/X11-xft {};

  xdot = callPackage ../development/libraries/haskell/xdot {
    polyparse = self.polyparse_1_7;
  };

  xhtml_3000_2_0_1 = callPackage ../development/libraries/haskell/xhtml/3000.2.0.1.nix {};
  xhtml_3000_2_0_4 = callPackage ../development/libraries/haskell/xhtml/3000.2.0.4.nix {};
  xhtml_3000_2_0_5 = callPackage ../development/libraries/haskell/xhtml/3000.2.0.5.nix {};
  xhtml_3000_2_1 = callPackage ../development/libraries/haskell/xhtml/3000.2.1.nix {};
  xhtml = self.xhtml_3000_2_1;

  xml = callPackage ../development/libraries/haskell/xml {};

  xmlConduit = callPackage ../development/libraries/haskell/xml-conduit {};

  xmlHamlet = callPackage ../development/libraries/haskell/xml-hamlet {};

  xmlhtml = callPackage ../development/libraries/haskell/xmlhtml {};

  xmlTypes = callPackage ../development/libraries/haskell/xml-types {};

  xssSanitize = callPackage ../development/libraries/haskell/xss-sanitize {};

  yaml = callPackage ../development/libraries/haskell/yaml {};

  yap = callPackage ../development/libraries/haskell/yap {};

  yesod = callPackage ../development/libraries/haskell/yesod {};

  yesodAuth = callPackage ../development/libraries/haskell/yesod-auth {};

  yesodCore = callPackage ../development/libraries/haskell/yesod-core {};

  yesodDefault = callPackage ../development/libraries/haskell/yesod-default {};

  yesodForm = callPackage ../development/libraries/haskell/yesod-form {};

  yesodJson = callPackage ../development/libraries/haskell/yesod-json {};

  yesodPersistent = callPackage ../development/libraries/haskell/yesod-persistent {};

  yesodRoutes = callPackage ../development/libraries/haskell/yesod-routes {};

  yesodStatic = callPackage ../development/libraries/haskell/yesod-static {};

  yesodTest = callPackage ../development/libraries/haskell/yesod-test {};

  yst = callPackage ../development/libraries/haskell/yst {};

  zeromqHaskell = callPackage ../development/libraries/haskell/zeromq-haskell { zeromq = pkgs.zeromq2; };

  zeromq3Haskell = callPackage ../development/libraries/haskell/zeromq3-haskell { zeromq = pkgs.zeromq3; };

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
  zlib_0_5_3_3 = callPackage ../development/libraries/haskell/zlib/0.5.3.3.nix {
    inherit (pkgs) zlib;
  };
  zlib_0_5_4_0 = callPackage ../development/libraries/haskell/zlib/0.5.4.0.nix {
    inherit (pkgs) zlib;
  };
  zlib = self.zlib_0_5_4_0;

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

  pakcs = callPackage ../development/compilers/pakcs {};

  # Development tools.

  alex_2_3_1 = callPackage ../development/tools/parsing/alex/2.3.1.nix {};
  alex_2_3_2 = callPackage ../development/tools/parsing/alex/2.3.2.nix {};
  alex_2_3_3 = callPackage ../development/tools/parsing/alex/2.3.3.nix {};
  alex_2_3_5 = callPackage ../development/tools/parsing/alex/2.3.5.nix {};
  alex_3_0_1 = callPackage ../development/tools/parsing/alex/3.0.1.nix {};
  alex_3_0_2 = callPackage ../development/tools/parsing/alex/3.0.2.nix {};
  alex = self.alex_3_0_2;

  alexMeta = callPackage ../development/tools/haskell/alex-meta {};

  BNFC = callPackage ../development/tools/haskell/BNFC {};

  BNFCMeta = callPackage ../development/tools/haskell/BNFC-meta {};

  cpphs = callPackage ../development/tools/misc/cpphs {};

  Ebnf2ps = callPackage ../development/tools/parsing/Ebnf2ps {};

  haddock_2_4_2 = callPackage ../development/tools/documentation/haddock/2.4.2.nix {};
  haddock_2_7_2 = callPackage ../development/tools/documentation/haddock/2.7.2.nix {};
  haddock_2_9_2 = callPackage ../development/tools/documentation/haddock/2.9.2.nix {};
  haddock_2_9_4 = callPackage ../development/tools/documentation/haddock/2.9.4.nix {};
  haddock_2_10_0 = callPackage ../development/tools/documentation/haddock/2.10.0.nix {};
  haddock_2_11_0 = callPackage ../development/tools/documentation/haddock/2.11.0.nix {};
  haddock_2_12_0 = callPackage ../development/tools/documentation/haddock/2.12.0.nix {};
  haddock_2_13_1 = callPackage ../development/tools/documentation/haddock/2.13.1.nix {};
  haddock = self.haddock_2_13_1;

  happy_1_18_4 = callPackage ../development/tools/parsing/happy/1.18.4.nix {};
  happy_1_18_5 = callPackage ../development/tools/parsing/happy/1.18.5.nix {};
  happy_1_18_6 = callPackage ../development/tools/parsing/happy/1.18.6.nix {};
  happy_1_18_8 = callPackage ../development/tools/parsing/happy/1.18.8.nix {};
  happy_1_18_9 = callPackage ../development/tools/parsing/happy/1.18.9.nix {};
  happy_1_18_10 = callPackage ../development/tools/parsing/happy/1.18.10.nix {};
  happy = self.happy_1_18_10;

  happyMeta = callPackage ../development/tools/haskell/happy-meta {};

  HaRe = callPackage ../development/tools/haskell/HaRe {};

  haskdogs = callPackage ../development/tools/haskell/haskdogs {};

  hasktags = callPackage ../development/tools/haskell/hasktags {};

  hlint = callPackage ../development/tools/haskell/hlint {};

  hslogger = callPackage ../development/tools/haskell/hslogger {};

  SourceGraph = callPackage ../development/tools/haskell/SourceGraph {
    haskellSrcExts = self.haskellSrcExts_1_11_1;
  };

  tar_0_3_2_0 = callPackage ../development/tools/haskell/tar/0.3.2.0.nix {};
  tar_0_4_0_1 = callPackage ../development/tools/haskell/tar/0.4.0.1.nix {};
  tar = self.tar_0_4_0_1;

  threadscope = callPackage ../development/tools/haskell/threadscope {};

  uuagcBootstrap = callPackage ../development/tools/haskell/uuagc/bootstrap.nix {};
  uuagcCabal = callPackage ../development/tools/haskell/uuagc/cabal.nix {};
  uuagc = callPackage ../development/tools/haskell/uuagc {};

  # Applications.

  darcs = callPackage ../applications/version-management/darcs {
    tar = self.tar_0_3_2_0;
    haskeline = self.haskeline_0_6_4_7;
  };

  leksah = callPackage ../applications/editors/leksah {
    QuickCheck = self.QuickCheck2;
  };

  xmobar = callPackage ../applications/misc/xmobar {
    stm = self.stm_2_3;
  };

  xmonad = callPackage ../applications/window-managers/xmonad {};

  xmonadContrib = callPackage ../applications/window-managers/xmonad/xmonad-contrib.nix {};

  xmonadExtras = callPackage ../applications/window-managers/xmonad/xmonad-extras.nix {};

  # Tools.

  cabal2nix = callPackage ../development/tools/haskell/cabal2nix {};

  cabalDev = callPackage ../development/tools/haskell/cabal-dev {
    mtl          = self.mtl_2_0_1_0.override { transformers = self.transformers_0_2_2_0; };
    transformers = self.transformers_0_2_2_0;
    tar          = self.tar_0_3_2_0;
  };

  cabalGhci = callPackage ../development/tools/haskell/cabal-ghci {};

  cabalInstall_0_6_2  = callPackage ../tools/package-management/cabal-install/0.6.2.nix  {};
  cabalInstall_0_8_0  = callPackage ../tools/package-management/cabal-install/0.8.0.nix  {};
  cabalInstall_0_8_2  = callPackage ../tools/package-management/cabal-install/0.8.2.nix  {};
  cabalInstall_0_10_2 = callPackage ../tools/package-management/cabal-install/0.10.2.nix {};
  cabalInstall_0_14_0 = callPackage ../tools/package-management/cabal-install/0.14.0.nix {};
  cabalInstall_1_16_0_2 = callPackage ../tools/package-management/cabal-install/1.16.0.2.nix {};
  cabalInstall = self.cabalInstall_1_16_0_2;

  jailbreakCabal = callPackage ../development/tools/haskell/jailbreak-cabal {};

  lhs2tex = callPackage ../tools/typesetting/lhs2tex {};

  myhasktags = callPackage ../tools/misc/myhasktags {};

  splot = callPackage ../development/tools/haskell/splot {};

  timeplot = callPackage ../development/tools/haskell/timeplot {};

  # Games.

  LambdaHack = callPackage ../games/LambdaHack {};

  MazesOfMonad = callPackage ../games/MazesOfMonad {};

# End of the main part of the file.

};

in result.final
