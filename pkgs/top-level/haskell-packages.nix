# Haskell packages in Nixpkgs
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

{ pkgs, newScope, ghc, modifyPrio ? (x : x)
, enableLibraryProfiling ? false
, enableSharedLibraries ? pkgs.stdenv.lib.versionOlder "7.7" ghc.version
, enableSharedExecutables ? pkgs.stdenv.lib.versionOlder "7.7" ghc.version
, enableCheckPhase ? pkgs.stdenv.lib.versionOlder "7.4" ghc.version
, enableStaticLibraries ? true
}:

# We redefine callPackage to take into account the new scope. The optional
# modifyPrio argument can be set to lowPrio to make all Haskell packages have
# low priority.

self : let callPackage = x : y : modifyPrio (newScope self x y); in

# Indentation deliberately broken at this point to keep the bulk
# of this file at a low indentation level.

{
  inherit callPackage;

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
    ghc = ghc;                  # refers to ghcPlain
    packages = pkgs self;
    ignoreCollisions = false;
  };

  ghcWithPackagesOld = pkgs : (self.ghcWithPackages pkgs).override { ignoreCollisions = true; };

  # This is the Cabal builder, the function we use to build most Haskell
  # packages. It isn't the Cabal library, which is spelled "Cabal".

  cabal = callPackage ../build-support/cabal {
    Cabal = null;               # prefer the Cabal version shipped with the compiler
    hscolour = self.hscolourBootstrap;
    inherit enableLibraryProfiling enableCheckPhase
      enableStaticLibraries enableSharedLibraries enableSharedExecutables;
    glibcLocales = if pkgs.stdenv.isLinux then pkgs.glibcLocales else null;
    extension = self : super : {};
  };

  # A variant of the cabal build driver that disables unit testing.
  # Useful for breaking cycles, where the unit test of a package A
  # depends on package B, which has A as a regular build input.
  cabalNoTest = self.cabal.override { enableCheckPhase = false; };

  # Convenience helper function.
  disableTest = x: x.override { cabal = self.cabalNoTest; };

  # Haskell libraries.

  acidState = callPackage ../development/libraries/haskell/acid-state {};

  accelerate = callPackage ../development/libraries/haskell/accelerate {};

  accelerateCuda = callPackage ../development/libraries/haskell/accelerate-cuda {};

  accelerateExamples = callPackage ../development/libraries/haskell/accelerate-examples {};

  accelerateFft = callPackage ../development/libraries/haskell/accelerate-fft {};

  accelerateIo = callPackage ../development/libraries/haskell/accelerate-io {};

  acmeLookofdisapproval = callPackage ../development/libraries/haskell/acme-lookofdisapproval {};

  active = callPackage ../development/libraries/haskell/active {};

  ACVector = callPackage ../development/libraries/haskell/AC-Vector {};

  abstractDeque = callPackage ../development/libraries/haskell/abstract-deque {};

  abstractDequeTests = callPackage ../development/libraries/haskell/abstract-deque-tests {};

  abstractPar = callPackage ../development/libraries/haskell/abstract-par {};

  ad = callPackage ../development/libraries/haskell/ad {};

  adjunctions = callPackage ../development/libraries/haskell/adjunctions {};

  AES = callPackage ../development/libraries/haskell/AES {};

  aeson_0_7_0_4 = callPackage ../development/libraries/haskell/aeson/0.7.0.4.nix { blazeBuilder = null; };
  aeson_0_8_0_2 = callPackage ../development/libraries/haskell/aeson/0.8.0.2.nix { blazeBuilder = null; };
  aeson = self.aeson_0_8_0_2;

  aesonPretty = callPackage ../development/libraries/haskell/aeson-pretty {};

  aesonQq = callPackage ../development/libraries/haskell/aeson-qq {};

  aesonUtils = callPackage ../development/libraries/haskell/aeson-utils {};

  algebra = callPackage ../development/libraries/haskell/algebra {};

  alsaCore = callPackage ../development/libraries/haskell/alsa-core {};

  alsaMixer = callPackage ../development/libraries/haskell/alsa-mixer {};

  alsaPcm = callPackage ../development/libraries/haskell/alsa-pcm {};

  amqp = callPackage ../development/libraries/haskell/amqp {};

  annotatedWlPprint = callPackage ../development/libraries/haskell/annotated-wl-pprint {};

  appar = callPackage ../development/libraries/haskell/appar {};

  ansiTerminal = callPackage ../development/libraries/haskell/ansi-terminal {};

  ansiWlPprint = callPackage ../development/libraries/haskell/ansi-wl-pprint {};

  applicativeQuoters = callPackage ../development/libraries/haskell/applicative-quoters {};

  ariadne = callPackage ../development/libraries/haskell/ariadne {};

  arithmoi = callPackage ../development/libraries/haskell/arithmoi {};

  arrows = callPackage ../development/libraries/haskell/arrows {};

  assertFailure = callPackage ../development/libraries/haskell/assert-failure {};

  asn1Data = callPackage ../development/libraries/haskell/asn1-data {};

  asn1Encoding = callPackage ../development/libraries/haskell/asn1-encoding {};

  asn1Parse = callPackage ../development/libraries/haskell/asn1-parse {};

  asn1Types = callPackage ../development/libraries/haskell/asn1-types {};

  async_2_0_1_4 = callPackage ../development/libraries/haskell/async/2.0.1.4.nix {};
  async_2_0_1_6 = callPackage ../development/libraries/haskell/async/2.0.1.6.nix {};
  async = self.async_2_0_1_6;

  atomicPrimops = callPackage ../development/libraries/haskell/atomic-primops {};

  attempt = callPackage ../development/libraries/haskell/attempt {};

  attoLisp = callPackage ../development/libraries/haskell/atto-lisp {};

  attoparsec_0_10_4_0 = callPackage ../development/libraries/haskell/attoparsec/0.10.4.0.nix {};
  attoparsec_0_11_3_1 = callPackage ../development/libraries/haskell/attoparsec/0.11.3.1.nix {};
  attoparsec_0_12_1_2 = callPackage ../development/libraries/haskell/attoparsec/0.12.1.2.nix {};
  attoparsec = self.attoparsec_0_12_1_2;

  attoparsecBinary = callPackage ../development/libraries/haskell/attoparsec-binary {};

  attoparsecConduit = callPackage ../development/libraries/haskell/attoparsec-conduit {};

  attoparsecEnumerator = callPackage ../development/libraries/haskell/attoparsec-enumerator {};

  autoUpdate = callPackage ../development/libraries/haskell/auto-update {};

  aws = callPackage ../development/libraries/haskell/aws {};

  authenticate = callPackage ../development/libraries/haskell/authenticate {};

  authenticateOauth = callPackage ../development/libraries/haskell/authenticate-oauth {};

  base16Bytestring = callPackage ../development/libraries/haskell/base16-bytestring {};

  base32Bytestring = callPackage ../development/libraries/haskell/base32-bytestring {};

  base64String = callPackage ../development/libraries/haskell/base64-string {};

  base64Bytestring = callPackage ../development/libraries/haskell/base64-bytestring {};

  baseCompat = callPackage ../development/libraries/haskell/base-compat {};

  baseUnicodeSymbols = callPackage ../development/libraries/haskell/base-unicode-symbols {};

  basePrelude = callPackage ../development/libraries/haskell/base-prelude {};

  basicPrelude = callPackage ../development/libraries/haskell/basic-prelude {};

  benchpress = callPackage ../development/libraries/haskell/benchpress {};

  bencoding = callPackage ../development/libraries/haskell/bencoding {};

  bert = callPackage ../development/libraries/haskell/bert {};

  bifunctors = callPackage ../development/libraries/haskell/bifunctors {};

  bimap = callPackage ../development/libraries/haskell/bimap {};

  binary_0_7_2_2 = callPackage ../development/libraries/haskell/binary/0.7.2.2.nix {};
  binary = null;                # core package since ghc >= 7.2.x

  binaryConduit = callPackage ../development/libraries/haskell/binary-conduit {};

  binaryShared = callPackage ../development/libraries/haskell/binary-shared {};

  bindingsDSL = callPackage ../development/libraries/haskell/bindings-DSL {};

  bindingsGLFW = callPackage ../development/libraries/haskell/bindings-GLFW {};

  bindingsLibusb = callPackage ../development/libraries/haskell/bindings-libusb {
    libusb = pkgs.libusb1;
  };

  bindingsPosix = callPackage ../development/libraries/haskell/bindings-posix {};

  bitarray = callPackage ../development/libraries/haskell/bitarray {};

  bitmap = callPackage ../development/libraries/haskell/bitmap {};

  bitsAtomic = callPackage ../development/libraries/haskell/bits-atomic {};

  bitsExtras = callPackage ../development/libraries/haskell/bits-extras {};

  bitset = callPackage ../development/libraries/haskell/bitset {};

  bktrees = callPackage ../development/libraries/haskell/bktrees {};

  blankCanvas = callPackage ../development/libraries/haskell/blank-canvas {};

  blazeBuilder = callPackage ../development/libraries/haskell/blaze-builder {};

  blazeBuilderConduit = callPackage ../development/libraries/haskell/blaze-builder-conduit {};

  blazeBuilderEnumerator = callPackage ../development/libraries/haskell/blaze-builder-enumerator {};

  blazeFromHtml = callPackage ../development/libraries/haskell/blaze-from-html {};

  blazeHtml = callPackage ../development/libraries/haskell/blaze-html {};

  blazeMarkup = callPackage ../development/libraries/haskell/blaze-markup {};

  blazeSvg = callPackage ../development/libraries/haskell/blaze-svg {};

  blazeTextual = callPackage ../development/libraries/haskell/blaze-textual {};

  BlogLiterately = callPackage ../development/libraries/haskell/BlogLiterately {};

  bloomfilter = callPackage ../development/libraries/haskell/bloomfilter {};

  bmp = callPackage ../development/libraries/haskell/bmp {};

  Boolean = callPackage ../development/libraries/haskell/Boolean {};

  boolExtras = callPackage ../development/libraries/haskell/bool-extras {};

  boundingboxes = callPackage ../development/libraries/haskell/boundingboxes {};

  BoundedChan = callPackage ../development/libraries/haskell/BoundedChan {};

  boxes = callPackage ../development/libraries/haskell/boxes {};

  brainfuck = callPackage ../development/libraries/haskell/brainfuck {};

  bson = callPackage ../development/libraries/haskell/bson {};

  boomerang = callPackage ../development/libraries/haskell/boomerang {};

  bound = callPackage ../development/libraries/haskell/bound {};

  bv = callPackage ../development/libraries/haskell/bv {};

  byteable = callPackage ../development/libraries/haskell/byteable {};

  bytedump = callPackage ../development/libraries/haskell/bytedump {};

  byteorder = callPackage ../development/libraries/haskell/byteorder {};

  bytes = callPackage ../development/libraries/haskell/bytes {};

  bytestringNums = callPackage ../development/libraries/haskell/bytestring-nums {};

  bytestringLexing = callPackage ../development/libraries/haskell/bytestring-lexing {};

  bytestringMmap = callPackage ../development/libraries/haskell/bytestring-mmap {};

  bytestringShow = callPackage ../development/libraries/haskell/bytestring-show {};

  bytestringTrie = callPackage ../development/libraries/haskell/bytestring-trie {};

  bytestringProgress = callPackage ../development/libraries/haskell/bytestring-progress {};

  bzlib = callPackage ../development/libraries/haskell/bzlib {};

  c2hs = callPackage ../development/libraries/haskell/c2hs {};

  c2hsc = callPackage ../development/libraries/haskell/c2hsc {};

  Cabal_1_16_0_3 = callPackage ../development/libraries/haskell/Cabal/1.16.0.3.nix {};
  Cabal_1_18_1_3 = callPackage ../development/libraries/haskell/Cabal/1.18.1.3.nix {};
  Cabal_1_20_0_2 = callPackage ../development/libraries/haskell/Cabal/1.20.0.2.nix {};
  Cabal = null;                 # core package since forever

  cabalCargs = callPackage ../development/libraries/haskell/cabal-cargs {};

  cabalFileTh = callPackage ../development/libraries/haskell/cabal-file-th {};

  cabalLenses = callPackage ../development/libraries/haskell/cabal-lenses {};

  cabalMacosx = callPackage ../development/libraries/haskell/cabal-macosx {};

  cairo_0_12_5_3 = callPackage ../development/libraries/haskell/cairo/0.12.5.3.nix {
    inherit (pkgs) cairo zlib;
    libc = pkgs.stdenv.gcc.libc;
  };
  cairo_0_13_0_4 = callPackage ../development/libraries/haskell/cairo/0.13.0.4.nix {
    inherit (pkgs) cairo zlib;
    libc = pkgs.stdenv.gcc.libc;
  };
  cairo = self.cairo_0_13_0_4;

  carray = callPackage ../development/libraries/haskell/carray {};

  categories = callPackage ../development/libraries/haskell/categories {};

  cassava = callPackage ../development/libraries/haskell/cassava {};

  caseInsensitive_1_0_0_1 = callPackage ../development/libraries/haskell/case-insensitive/1.0.0.1.nix {};
  caseInsensitive_1_2_0_1 = callPackage ../development/libraries/haskell/case-insensitive/1.2.0.1.nix {};
  caseInsensitive = self.caseInsensitive_1_2_0_1;

  cautiousFile = callPackage ../development/libraries/haskell/cautious-file {};

  CCdelcont = callPackage ../development/libraries/haskell/CC-delcont {};

  cereal = callPackage ../development/libraries/haskell/cereal {};

  cerealConduit = callPackage ../development/libraries/haskell/cereal-conduit {};

  certificate = callPackage ../development/libraries/haskell/certificate {};

  cgi_3001_1_7_5 = callPackage ../development/libraries/haskell/cgi/3001.1.7.5.nix {};
  cgi_3001_2_0_0 = callPackage ../development/libraries/haskell/cgi/3001.2.0.0.nix {};
  cgi = self.cgi_3001_2_0_0;

  cgrep = callPackage ../development/libraries/haskell/cgrep {};

  charset = callPackage ../development/libraries/haskell/charset {};

  charsetdetectAe = callPackage ../development/libraries/haskell/charsetdetect-ae {};

  Chart = callPackage ../development/libraries/haskell/Chart {};
  ChartCairo = callPackage ../development/libraries/haskell/Chart-cairo {};
  ChartDiagrams = callPackage ../development/libraries/haskell/Chart-diagrams {};
  ChartGtk = callPackage ../development/libraries/haskell/Chart-gtk {};

  ChasingBottoms = callPackage ../development/libraries/haskell/ChasingBottoms {};

  cheapskate = callPackage ../development/libraries/haskell/cheapskate {};

  checkers = callPackage ../development/libraries/haskell/checkers {};

  chell = callPackage ../development/libraries/haskell/chell {};

  chellQuickcheck = callPackage ../development/libraries/haskell/chell-quickcheck {};

  chunkedData = callPackage ../development/libraries/haskell/chunked-data {};

  citeprocHs = callPackage ../development/libraries/haskell/citeproc-hs {};

  cipherAes = callPackage ../development/libraries/haskell/cipher-aes {};

  cipherAes128 = callPackage ../development/libraries/haskell/cipher-aes128 {};

  cipherBlowfish = callPackage ../development/libraries/haskell/cipher-blowfish {};

  cipherCamellia = callPackage ../development/libraries/haskell/cipher-camellia {};

  cipherDes = callPackage ../development/libraries/haskell/cipher-des {};

  cipherRc4 = callPackage ../development/libraries/haskell/cipher-rc4 {};

  circlePacking = callPackage ../development/libraries/haskell/circle-packing {};

  classyPrelude = callPackage ../development/libraries/haskell/classy-prelude {};

  classyPreludeConduit = callPackage ../development/libraries/haskell/classy-prelude-conduit {};

  clay = callPackage ../development/libraries/haskell/clay {};

  cleanUnions = callPackage ../development/libraries/haskell/clean-unions {};

  clientsession = callPackage ../development/libraries/haskell/clientsession {};

  clock = callPackage ../development/libraries/haskell/clock {};

  cmdargs = callPackage ../development/libraries/haskell/cmdargs {};

  cmdlib = callPackage ../development/libraries/haskell/cmdlib {};

  cmdtheline = callPackage ../development/libraries/haskell/cmdtheline {};

  codeBuilder = callPackage ../development/libraries/haskell/code-builder {};

  CodecImageDevIL = callPackage ../development/libraries/haskell/codec-image-devil {};

  colorizeHaskell = callPackage ../development/libraries/haskell/colorize-haskell {};

  colors = callPackage ../development/libraries/haskell/colors {};

  colour = callPackage ../development/libraries/haskell/colour {};

  comonad = callPackage ../development/libraries/haskell/comonad {};

  comonadsFd = callPackage ../development/libraries/haskell/comonads-fd {};

  comonadTransformers = callPackage ../development/libraries/haskell/comonad-transformers {};

  compactStringFix = callPackage ../development/libraries/haskell/compact-string-fix {};

  compdata = callPackage ../development/libraries/haskell/compdata {};

  compdataParam = callPackage ../development/libraries/haskell/compdata-param {};

  composition = callPackage ../development/libraries/haskell/composition {};

  compressed = callPackage ../development/libraries/haskell/compressed {};

  concatenative = callPackage ../development/libraries/haskell/concatenative {};

  concreteTyperep = callPackage ../development/libraries/haskell/concreteTyperep {};

  cond = callPackage ../development/libraries/haskell/cond {};

  conduit = callPackage ../development/libraries/haskell/conduit {};

  conduitCombinators = callPackage ../development/libraries/haskell/conduit-combinators {};

  conduitExtra = callPackage ../development/libraries/haskell/conduit-extra {};

  ConfigFile = callPackage ../development/libraries/haskell/ConfigFile {};

  configurator = callPackage ../development/libraries/haskell/configurator {};

  connection = callPackage ../development/libraries/haskell/connection {};

  constraints = callPackage ../development/libraries/haskell/constraints {};

  controlBool = callPackage ../development/libraries/haskell/control-bool {};

  controlMonadFree = callPackage ../development/libraries/haskell/control-monad-free {};

  controlMonadLoop = callPackage ../development/libraries/haskell/control-monad-loop {};

  convertible = callPackage ../development/libraries/haskell/convertible {};

  continuedFractions = callPackage ../development/libraries/haskell/continued-fractions {};

  contravariant = callPackage ../development/libraries/haskell/contravariant {};

  concurrentExtra = callPackage ../development/libraries/haskell/concurrent-extra {};

  converge = callPackage ../development/libraries/haskell/converge {};

  cookie = callPackage ../development/libraries/haskell/cookie {};

  coroutineObject = callPackage ../development/libraries/haskell/coroutine-object {};

  cprngAes = callPackage ../development/libraries/haskell/cprng-aes {};

  criterion = callPackage ../development/libraries/haskell/criterion {};

  Crypto = callPackage ../development/libraries/haskell/Crypto {};

  cryptoApi = callPackage ../development/libraries/haskell/crypto-api {};

  cryptocipher = callPackage ../development/libraries/haskell/cryptocipher {};

  cryptoCipherTests = callPackage ../development/libraries/haskell/crypto-cipher-tests {};

  cryptoCipherTypes = callPackage ../development/libraries/haskell/crypto-cipher-types {};

  cryptoConduit = callPackage ../development/libraries/haskell/crypto-conduit {};

  cryptohash = callPackage ../development/libraries/haskell/cryptohash {};

  cryptohashConduit = callPackage ../development/libraries/haskell/cryptohash-conduit {};

  cryptohashCryptoapi = callPackage ../development/libraries/haskell/cryptohash-cryptoapi {};

  cryptoNumbers = callPackage ../development/libraries/haskell/crypto-numbers {};

  cryptoPubkeyTypes = callPackage ../development/libraries/haskell/crypto-pubkey-types {};

  cryptoPubkey = callPackage ../development/libraries/haskell/crypto-pubkey {};

  cryptoRandom = callPackage ../development/libraries/haskell/crypto-random {};

  cryptoRandomApi = callPackage ../development/libraries/haskell/crypto-random-api {};

  cuda = callPackage ../development/libraries/haskell/cuda {
    inherit (pkgs.linuxPackages) nvidia_x11;
  };

  csv = callPackage ../development/libraries/haskell/csv {};

  cssText = callPackage ../development/libraries/haskell/css-text {};

  cufft = callPackage ../development/libraries/haskell/cufft {};

  curl = callPackage ../development/libraries/haskell/curl { curl = pkgs.curl; };

  cpu = callPackage ../development/libraries/haskell/cpu {};

  dataAccessor = callPackage ../development/libraries/haskell/data-accessor/data-accessor.nix {};

  dataAccessorTemplate = callPackage ../development/libraries/haskell/data-accessor/data-accessor-template.nix {};

  dataAccessorTransformers = callPackage ../development/libraries/haskell/data-accessor/data-accessor-transformers.nix {};

  dataAccessorMtl = callPackage ../development/libraries/haskell/data-accessor/data-accessor-mtl.nix {};

  dataBinaryIeee754 = callPackage ../development/libraries/haskell/data-binary-ieee754 {};

  dataDefault = callPackage ../development/libraries/haskell/data-default {};

  dataDefaultClass = callPackage ../development/libraries/haskell/data-default-class {};
  dataDefaultInstancesBase = callPackage ../development/libraries/haskell/data-default-instances-containers {};
  dataDefaultInstancesContainers = callPackage ../development/libraries/haskell/data-default-instances-base {};
  dataDefaultInstancesDlist = callPackage ../development/libraries/haskell/data-default-instances-dlist {};
  dataDefaultInstancesOldLocale = callPackage ../development/libraries/haskell/data-default-instances-old-locale {};

  dataenc = callPackage ../development/libraries/haskell/dataenc {};

  dataFin = callPackage ../development/libraries/haskell/data-fin {};

  dataFix = callPackage ../development/libraries/haskell/data-fix {};

  dataHash = callPackage ../development/libraries/haskell/data-hash {};

  dataInttrie = callPackage ../development/libraries/haskell/data-inttrie {};

  dataLens = callPackage ../development/libraries/haskell/data-lens {};

  dataLensFd = callPackage ../development/libraries/haskell/data-lens-fd {};

  dataLensLight = callPackage ../development/libraries/haskell/data-lens-light {};

  dataLensTemplate = callPackage ../development/libraries/haskell/data-lens-template {};

  dataMemocombinators = callPackage ../development/libraries/haskell/data-memocombinators {};

  dataOrdlist = callPackage ../development/libraries/haskell/data-ordlist {};

  dataPprint = callPackage ../development/libraries/haskell/data-pprint {};

  dataReify = callPackage ../development/libraries/haskell/data-reify {};

  dateCache = callPackage ../development/libraries/haskell/date-cache {};

  dataChecked = callPackage ../development/libraries/haskell/data-checked {};

  datetime = callPackage ../development/libraries/haskell/datetime {};

  DAV = callPackage ../development/libraries/haskell/DAV {};

  dbmigrations = callPackage ../development/libraries/haskell/dbmigrations {};

  dbus = callPackage ../development/libraries/haskell/dbus {};

  Decimal = callPackage ../development/libraries/haskell/Decimal {};

  deepseq_1_2_0_1 = callPackage ../development/libraries/haskell/deepseq/1.2.0.1.nix {};
  deepseq_1_3_0_2 = callPackage ../development/libraries/haskell/deepseq/1.3.0.2.nix {};
  deepseq = null;               # core package since ghc >= 7.4.x

  deepseqGenerics = callPackage ../development/libraries/haskell/deepseq-generics {};

  deepseqTh = callPackage ../development/libraries/haskell/deepseq-th {};

  derive = callPackage ../development/libraries/haskell/derive {};

  dependentMap = callPackage ../development/libraries/haskell/dependent-map {};

  dependentSum = callPackage ../development/libraries/haskell/dependent-sum {};

  dependentSumTemplate = callPackage ../development/libraries/haskell/dependent-sum-template {};

  derp = callPackage ../development/libraries/haskell/derp {};

  dice = callPackage ../development/libraries/haskell/dice {};

  diagrams = callPackage ../development/libraries/haskell/diagrams/diagrams.nix {};
  diagramsCairo = callPackage ../development/libraries/haskell/diagrams/cairo.nix {};
  diagramsCore = callPackage ../development/libraries/haskell/diagrams/core.nix {};
  diagramsContrib = callPackage ../development/libraries/haskell/diagrams/contrib.nix {};
  diagramsGtk = callPackage ../development/libraries/haskell/diagrams/gtk.nix {};
  diagramsLib = callPackage ../development/libraries/haskell/diagrams/lib.nix {};
  diagramsPostscript = callPackage ../development/libraries/haskell/diagrams/postscript.nix {};
  diagramsRasterific = callPackage ../development/libraries/haskell/diagrams/rasterific.nix {};
  diagramsSvg = callPackage ../development/libraries/haskell/diagrams/svg.nix {};

  Diff = callPackage ../development/libraries/haskell/Diff {};

  diff3 = callPackage ../development/libraries/haskell/diff3 {};

  digest = callPackage ../development/libraries/haskell/digest {
    inherit (pkgs) zlib;
  };

  digestiveFunctors = callPackage ../development/libraries/haskell/digestive-functors {};

  digestiveFunctorsAeson = callPackage ../development/libraries/haskell/digestive-functors-aeson {};

  digestiveFunctorsHeist = callPackage ../development/libraries/haskell/digestive-functors-heist {};

  digestiveFunctorsSnap = callPackage ../development/libraries/haskell/digestive-functors-snap {};

  digits = callPackage ../development/libraries/haskell/digits {};

  dimensional = callPackage ../development/libraries/haskell/dimensional {};

  dimensionalTf = callPackage ../development/libraries/haskell/dimensional-tf {};

  directSqlite = callPackage ../development/libraries/haskell/direct-sqlite {};

  directoryLayout = callPackage ../development/libraries/haskell/directory-layout {};

  directoryTree = callPackage ../development/libraries/haskell/directory-tree {};

  distributedStatic = callPackage ../development/libraries/haskell/distributed-static {};

  distributedProcess = callPackage ../development/libraries/haskell/distributed-process {};

  distributedProcessPlatform = callPackage ../development/libraries/haskell/distributed-process-platform {};

  distributive = callPackage ../development/libraries/haskell/distributive {};

  djinn = callPackage ../development/libraries/haskell/djinn {};

  djinnGhc = callPackage ../development/libraries/haskell/djinn-ghc {};

  djinnLib = callPackage ../development/libraries/haskell/djinn-lib {};

  dlist = callPackage ../development/libraries/haskell/dlist {};

  dlistInstances = callPackage ../development/libraries/haskell/dlist-instances {};

  dns = callPackage ../development/libraries/haskell/dns {};

  doctest = callPackage ../development/libraries/haskell/doctest {};

  doctestProp = callPackage ../development/libraries/haskell/doctest-prop {};

  domSelector = callPackage ../development/libraries/haskell/dom-selector {};

  dotgen = callPackage ../development/libraries/haskell/dotgen {};

  doubleConversion = callPackage ../development/libraries/haskell/double-conversion {};

  download = callPackage ../development/libraries/haskell/download {};

  downloadCurl = callPackage ../development/libraries/haskell/download-curl {};

  DRBG = callPackage ../development/libraries/haskell/DRBG {};

  dsp = callPackage ../development/libraries/haskell/dsp {};

  dstring = callPackage ../development/libraries/haskell/dstring {};

  dualTree = callPackage ../development/libraries/haskell/dual-tree {};

  dynamicCabal = callPackage ../development/libraries/haskell/dynamic-cabal {};

  dyre = callPackage ../development/libraries/haskell/dyre {};

  easyFile = callPackage ../development/libraries/haskell/easy-file {};

  editDistance = callPackage ../development/libraries/haskell/edit-distance {};

  editline = callPackage ../development/libraries/haskell/editline {};

  ekg = callPackage ../development/libraries/haskell/ekg {};
  ekgCarbon = callPackage ../development/libraries/haskell/ekg-carbon {};
  ekgCore = callPackage ../development/libraries/haskell/ekg-core {};

  elerea = callPackage ../development/libraries/haskell/elerea {};

  Elm = callPackage ../development/compilers/elm/elm.nix {};

  elmServer = callPackage ../development/compilers/elm/elm-server.nix {};

  elmRepl = callPackage ../development/compilers/elm/elm-repl.nix {};

  elmReactor = callPackage ../development/compilers/elm/elm-reactor.nix {};

  elmGet = callPackage ../development/compilers/elm/elm-get.nix {
    optparseApplicative = self.optparseApplicative_0_10_0;
  };

  emailValidate = callPackage ../development/libraries/haskell/email-validate {};

  enclosedExceptions = callPackage ../development/libraries/haskell/enclosed-exceptions {};

  encoding = callPackage ../development/libraries/haskell/encoding {};

  engineIo = callPackage ../development/libraries/haskell/engine-io {};
  engineIoSnap = callPackage ../development/libraries/haskell/engine-io-snap {};

  enumerator = callPackage ../development/libraries/haskell/enumerator {};

  enummapset = callPackage ../development/libraries/haskell/enummapset {};

  enummapsetTh = callPackage ../development/libraries/haskell/enummapset-th {};

  enumset = callPackage ../development/libraries/haskell/enumset {};

  entropy = callPackage ../development/libraries/haskell/entropy {};

  equationalReasoning = callPackage ../development/libraries/haskell/equational-reasoning {};

  equivalence = callPackage ../development/libraries/haskell/equivalence {};

  erf = callPackage ../development/libraries/haskell/erf {};

  errorcallEqInstance = callPackage ../development/libraries/haskell/errorcall-eq-instance {};

  errors = callPackage ../development/libraries/haskell/errors {};

  either = callPackage ../development/libraries/haskell/either {};

  EitherT = callPackage ../development/libraries/haskell/EitherT {};

  esqueleto = callPackage ../development/libraries/haskell/esqueleto {};

  eventList = callPackage ../development/libraries/haskell/event-list {};

  exPool = callPackage ../development/libraries/haskell/ex-pool {};

  exceptionMtl = callPackage ../development/libraries/haskell/exception-mtl {};

  exceptionTransformers = callPackage ../development/libraries/haskell/exception-transformers {};

  exceptions = callPackage ../development/libraries/haskell/exceptions {};

  explicitException = callPackage ../development/libraries/haskell/explicit-exception {};

  executablePath = callPackage ../development/libraries/haskell/executable-path {};

  Extra = callPackage ../development/libraries/haskell/Extra-lib {};

  fay = callPackage ../development/libraries/haskell/fay {};

  fayBase = callPackage ../development/libraries/haskell/fay-base {};

  fayText = callPackage ../development/libraries/haskell/fay-text {};

  fdoNotify = callPackage ../development/libraries/haskell/fdo-notify {};

  filepath = null;              # core package since forever

  fileLocation = callPackage ../development/libraries/haskell/file-location {};

  fixedVector = callPackage ../development/libraries/haskell/fixed-vector {};

  fmlist = callPackage ../development/libraries/haskell/fmlist {};

  ftphs = callPackage ../development/libraries/haskell/ftphs {};

  extensibleEffects = callPackage ../development/libraries/haskell/extensible-effects {};

  extensibleExceptions = callPackage ../development/libraries/haskell/extensible-exceptions {};

  extra = callPackage ../development/libraries/haskell/extra {};

  failure = callPackage ../development/libraries/haskell/failure {};

  fastcgi = callPackage ../development/libraries/haskell/fastcgi {};

  fastLogger = callPackage ../development/libraries/haskell/fast-logger {};

  fb = callPackage ../development/libraries/haskell/fb {};

  fclabels = callPackage ../development/libraries/haskell/fclabels {};

  FerryCore = callPackage ../development/libraries/haskell/FerryCore {};

  funcmp = callPackage ../development/libraries/haskell/funcmp {};

  feed = callPackage ../development/libraries/haskell/feed {};

  fileEmbed = callPackage ../development/libraries/haskell/file-embed {};

  filemanip = callPackage ../development/libraries/haskell/filemanip {};

  flexibleDefaults = callPackage ../development/libraries/haskell/flexible-defaults {};

  filestore = callPackage ../development/libraries/haskell/filestore {};

  filesystemConduit = callPackage ../development/libraries/haskell/filesystem-conduit {};

  final = callPackage ../development/libraries/haskell/final {};

  fgl = callPackage ../development/libraries/haskell/fgl {};

  fglVisualize = callPackage ../development/libraries/haskell/fgl-visualize {};

  fingertree = callPackage ../development/libraries/haskell/fingertree {};

  focus = callPackage ../development/libraries/haskell/focus {};

  foldl = callPackage ../development/libraries/haskell/foldl {};

  folds = callPackage ../development/libraries/haskell/folds {};

  FontyFruity = callPackage ../development/libraries/haskell/FontyFruity {};

  forceLayout = callPackage ../development/libraries/haskell/force-layout {};

  formatting = callPackage ../development/libraries/haskell/formatting {};

  free = callPackage ../development/libraries/haskell/free {};

  freeGame = callPackage ../development/libraries/haskell/free-game {};

  fsnotify = callPackage ../development/libraries/haskell/fsnotify {
    hinotify = if pkgs.stdenv.isLinux then self.hinotify else self.hfsevents;
  };

  freetype2 = callPackage ../development/libraries/haskell/freetype2 {};

  fuzzcheck = callPackage ../development/libraries/haskell/fuzzcheck {};

  functorInfix = callPackage ../development/libraries/haskell/functor-infix {};

  gamma = callPackage ../development/libraries/haskell/gamma {};

  geniplate = callPackage ../development/libraries/haskell/geniplate {};

  gd = callPackage ../development/libraries/haskell/gd {
    inherit (pkgs) gd zlib;
  };

  gdiff = callPackage ../development/libraries/haskell/gdiff {};

  genericAeson = callPackage ../development/libraries/haskell/generic-aeson {};

  genericDeriving = callPackage ../development/libraries/haskell/generic-deriving {};

  genericsSop = callPackage ../development/libraries/haskell/generics-sop {};

  ghcCore = callPackage ../development/libraries/haskell/ghc-core {};

  ghcEvents = callPackage ../development/libraries/haskell/ghc-events {};

  ghcEventsAnalyze = callPackage ../development/tools/haskell/ghc-events-analyze {};

  ghcGcTune = callPackage ../development/tools/haskell/ghc-gc-tune {};

  ghcHeapView = callPackage ../development/libraries/haskell/ghc-heap-view {
    cabal = self.cabal.override { enableLibraryProfiling = false; }; # pkg cannot be built with profiling enabled
  };

  ghcid = callPackage ../development/tools/haskell/ghcid {};

  ghcServer = callPackage ../development/libraries/haskell/ghc-server {};

  ghcjsDom = callPackage ../development/libraries/haskell/ghcjs-codemirror {};

  ghcjsCodemirror = callPackage ../development/libraries/haskell/ghcjs-codemirror {};

  ghcMod = callPackage ../development/libraries/haskell/ghc-mod { inherit (pkgs) emacs; };

  ghcMtl = callPackage ../development/libraries/haskell/ghc-mtl {};

  ghcPaths = callPackage ../development/libraries/haskell/ghc-paths {};

  ghcParser = callPackage ../development/libraries/haskell/ghc-parser {};

  ghcSyb = callPackage ../development/libraries/haskell/ghc-syb {};

  ghcSybUtils = callPackage ../development/libraries/haskell/ghc-syb-utils {};

  ghcVis = callPackage ../development/libraries/haskell/ghc-vis {
    cabal = self.cabal.override { enableLibraryProfiling = false; }; # pkg cannot be built with profiling enabled
  };

  gio = callPackage ../development/libraries/haskell/gio {};

  gitDate = callPackage ../development/libraries/haskell/git-date {};

  github = callPackage ../development/libraries/haskell/github {};

  gitit = callPackage ../development/libraries/haskell/gitit {};

  gitlib = callPackage ../development/libraries/haskell/gitlib {};

  gitlibLibgit2 = callPackage ../development/libraries/haskell/gitlib-libgit2 {};

  gitlibTest = callPackage ../development/libraries/haskell/gitlib-test {};

  glade = callPackage ../development/libraries/haskell/glade {
    inherit (pkgs.gnome) libglade;
    gtkC = pkgs.gtk;
    libc = pkgs.stdenv.gcc.libc;
  };

  GLFW = callPackage ../development/libraries/haskell/GLFW {};

  GLFWB = callPackage ../development/libraries/haskell/GLFW-b {};

  glib_0_12_5_4 = callPackage ../development/libraries/haskell/glib/0.12.5.4.nix {
    glib = pkgs.glib;
    libc = pkgs.stdenv.gcc.libc;
  };
  glib_0_13_0_5 = callPackage ../development/libraries/haskell/glib/0.13.0.5.nix {
    glib = pkgs.glib;
    libc = pkgs.stdenv.gcc.libc;
  };
  glib = self.glib_0_13_0_5;

  Glob = callPackage ../development/libraries/haskell/Glob {};

  GlomeVec = callPackage ../development/libraries/haskell/GlomeVec {};

  gloss = callPackage ../development/libraries/haskell/gloss {};

  glossBanana = callPackage ../development/libraries/haskell/gloss-banana {};

  glossAccelerate = callPackage ../development/libraries/haskell/gloss-accelerate {};

  glossRaster = callPackage ../development/libraries/haskell/gloss-raster {};

  glossRasterAccelerate = callPackage ../development/libraries/haskell/gloss-raster-accelerate {};

  glpkHs = callPackage ../development/libraries/haskell/glpk-hs {};

  GLURaw = callPackage ../development/libraries/haskell/GLURaw {};

  GLUT = callPackage ../development/libraries/haskell/GLUT {};

  GLUtil = callPackage ../development/libraries/haskell/GLUtil {};

  gnuidn = callPackage ../development/libraries/haskell/gnuidn {};

  gnuplot = callPackage ../development/libraries/haskell/gnuplot {};

  gnutls = callPackage ../development/libraries/haskell/gnutls { inherit (pkgs) gnutls; };

  gsasl = callPackage ../development/libraries/haskell/gsasl { inherit (pkgs) gsasl; };

  gtk_0_12_5_7 = callPackage ../development/libraries/haskell/gtk/0.12.5.7.nix {
    inherit (pkgs) gtk;
    libc = pkgs.stdenv.gcc.libc;
    glib = self.glib_0_12_5_4;
    cairo = self.cairo_0_12_5_3;
    pango = self.pango_0_12_5_3;
  };
  gtk_0_13_0_3 = callPackage ../development/libraries/haskell/gtk/0.13.0.3.nix {
    inherit (pkgs) gtk;
    libc = pkgs.stdenv.gcc.libc;
  };
  gtk = self.gtk_0_13_0_3;

  gtk3 = callPackage ../development/libraries/haskell/gtk3 {
    inherit (pkgs) gtk3;
  };

  gtkglext = callPackage ../development/libraries/haskell/gtkglext { gtkglext = pkgs.gnome2.gtkglext; };

  gtk2hsBuildtools = callPackage ../development/libraries/haskell/gtk2hs-buildtools {};

  gtksourceview2 = callPackage ../development/libraries/haskell/gtksourceview2 {
    inherit (pkgs.gnome) gtksourceview;
    libc = pkgs.stdenv.gcc.libc;
  };

  gtkTraymanager = callPackage ../development/libraries/haskell/gtk-traymanager {};

  Graphalyze = callPackage ../development/libraries/haskell/Graphalyze {};

  graphmod = callPackage ../development/tools/haskell/graphmod {};

  graphviz = callPackage ../development/libraries/haskell/graphviz { systemGraphviz = pkgs.graphviz; };

  graphSCC = callPackage ../development/libraries/haskell/graphscc {};

  graphWrapper = callPackage ../development/libraries/haskell/graph-wrapper {};

  groom = callPackage ../development/libraries/haskell/groom {};

  groups = callPackage ../development/libraries/haskell/groups {};

  groupoids = callPackage ../development/libraries/haskell/groupoids {};

  hakyll = callPackage ../development/libraries/haskell/hakyll {};

  hamlet = callPackage ../development/libraries/haskell/hamlet {};

  happstackServer = callPackage ../development/libraries/haskell/happstack/happstack-server.nix {};

  happstackHamlet = callPackage ../development/libraries/haskell/happstack/happstack-hamlet.nix {};

  happstackLite = callPackage ../development/libraries/haskell/happstack/happstack-lite.nix {};

  happstackFastCGI = callPackage ../development/libraries/haskell/happstack/happstack-fastcgi.nix {};

  hashable = callPackage ../development/libraries/haskell/hashable {};

  hashableExtras = callPackage ../development/libraries/haskell/hashable-extras {};

  hashedStorage = callPackage ../development/libraries/haskell/hashed-storage {};

  hashtables = callPackage ../development/libraries/haskell/hashtables {};

  haskelldb = callPackage ../development/libraries/haskell/haskelldb {};

  haskeline = callPackage ../development/libraries/haskell/haskeline {};

  haskelineClass = callPackage ../development/libraries/haskell/haskeline-class {};

  haskellGenerate = callPackage ../development/libraries/haskell/haskell-generate {};

  haskellLexer = callPackage ../development/libraries/haskell/haskell-lexer {};

  haskellMpi = callPackage ../development/libraries/haskell/haskell-mpi {
    mpi = pkgs.openmpi;
  };

  haskellNames = callPackage ../development/libraries/haskell/haskell-names {};

  HaskellNet = callPackage ../development/libraries/haskell/HaskellNet {};
  HaskellNetSSL = callPackage ../development/libraries/haskell/HaskellNet-SSL {};

  haskellPackages = callPackage ../development/libraries/haskell/haskell-packages {};

  haskellSrc = callPackage ../development/libraries/haskell/haskell-src {};

  haskellSrcExts_1_15_0_1 = callPackage ../development/libraries/haskell/haskell-src-exts/1.15.0.1.nix {};
  haskellSrcExts_1_16_0_1 = callPackage ../development/libraries/haskell/haskell-src-exts/1.16.0.1.nix {};
  haskellSrcExts = self.haskellSrcExts_1_16_0_1;

  haskellSrcMeta = callPackage ../development/libraries/haskell/haskell-src-meta {};

  haskintex = callPackage ../development/libraries/haskell/haskintex {};

  haskoin = callPackage ../development/libraries/haskell/haskoin {};

  haskore = callPackage ../development/libraries/haskell/haskore {};

  hastache = callPackage ../development/libraries/haskell/hastache {};

  hasteCompiler = callPackage ../development/libraries/haskell/haste-compiler {};

  hastePerch = callPackage ../development/libraries/haskell/haste-perch {};

  HaTeX = callPackage ../development/libraries/haskell/HaTeX {};

  hcltest = callPackage ../development/libraries/haskell/hcltest {};

  hedis = callPackage ../development/libraries/haskell/hedis {};

  heredoc = callPackage ../development/libraries/haskell/heredoc {};

  here = callPackage ../development/libraries/haskell/here {};

  hexpat = callPackage ../development/libraries/haskell/hexpat {};

  hex = callPackage ../development/libraries/haskell/hex {};

  hgal = callPackage ../development/libraries/haskell/hgal {};

  hourglass = callPackage ../development/libraries/haskell/hourglass {};

  hplayground = callPackage ../development/libraries/haskell/hplayground {};

  hseCpp = callPackage ../development/libraries/haskell/hse-cpp {};

  hsimport = callPackage ../development/libraries/haskell/hsimport {};

  HTF = callPackage ../development/libraries/haskell/HTF {};

  HTTP = callPackage ../development/libraries/haskell/HTTP {};

  httpAttoparsec = callPackage ../development/libraries/haskell/http-attoparsec {};

  httpClient = callPackage ../development/libraries/haskell/http-client {};

  httpClientConduit = callPackage ../development/libraries/haskell/http-client-conduit {};

  httpClientMultipart = callPackage ../development/libraries/haskell/http-client-multipart {};

  httpClientTls = callPackage ../development/libraries/haskell/http-client-tls {};

  httpCommon = callPackage ../development/libraries/haskell/http-common {};

  httpKit = callPackage ../development/libraries/haskell/http-kit {};

  httpReverseProxy = callPackage ../development/libraries/haskell/http-reverse-proxy {};

  hackageDb = callPackage ../development/libraries/haskell/hackage-db {};

  haskellForMaths = callPackage ../development/libraries/haskell/HaskellForMaths {};

  haxl = callPackage ../development/libraries/haskell/haxl {};

  haxr = callPackage ../development/libraries/haskell/haxr {};

  haxr_th = callPackage ../development/libraries/haskell/haxr-th {};

  HaXml = callPackage ../development/libraries/haskell/HaXml {};

  hdaemonize = callPackage ../development/libraries/haskell/hdaemonize {};

  HDBC = callPackage ../development/libraries/haskell/HDBC/HDBC.nix {};

  HDBCOdbc = callPackage ../development/libraries/haskell/HDBC/HDBC-odbc.nix {
    odbc = pkgs.unixODBC;
  };

  HDBCPostgresql = callPackage ../development/libraries/haskell/HDBC/HDBC-postgresql.nix {};

  HDBCSqlite3 = callPackage ../development/libraries/haskell/HDBC/HDBC-sqlite3.nix {};

  HPDF = callPackage ../development/libraries/haskell/HPDF {};

  heist = callPackage ../development/libraries/haskell/heist {};

  hflags = callPackage ../development/libraries/haskell/hflags {};

  hfsevents = callPackage ../development/libraries/haskell/hfsevents {};

  HFuse = callPackage ../development/libraries/haskell/HFuse {};

  highlightingKate = callPackage ../development/libraries/haskell/highlighting-kate {};

  hinotify = callPackage ../development/libraries/haskell/hinotify {};

  hi = callPackage ../development/libraries/haskell/hi {};

  hindent = callPackage ../development/libraries/haskell/hindent {
    haskellSrcExts = self.haskellSrcExts_1_15_0_1;
  };

  hint = callPackage ../development/libraries/haskell/hint {};

  hit = callPackage ../development/libraries/haskell/hit {};

  hjsmin = callPackage ../development/libraries/haskell/hjsmin {};

  hledger = callPackage ../development/libraries/haskell/hledger {};
  hledgerLib = callPackage ../development/libraries/haskell/hledger-lib {};
  hledgerInterest = callPackage ../applications/office/hledger-interest {};
  hledgerIrr = callPackage ../applications/office/hledger-irr {};
  hledgerWeb = callPackage ../development/libraries/haskell/hledger-web {};

  hlibgit2 = callPackage ../development/libraries/haskell/hlibgit2 {};

  HList = callPackage ../development/libraries/haskell/HList {};

  hmatrix = callPackage ../development/libraries/haskell/hmatrix {
    liblapack = pkgs.liblapack.override { shared = true; };
  };

  hmatrixGsl = callPackage ../development/libraries/haskell/hmatrix-gsl {};

  hmatrixSpecial = callPackage ../development/libraries/haskell/hmatrix-special {};

  hoauth = callPackage ../development/libraries/haskell/hoauth {};

  hoauth2 = callPackage ../development/libraries/haskell/hoauth2 {};

  hoodle = callPackage ../applications/graphics/hoodle {};

  hoodleBuilder = callPackage ../development/libraries/haskell/hoodle-builder {};

  hoodleCore = callPackage ../development/libraries/haskell/hoodle-core {};

  hoodleParser = callPackage ../development/libraries/haskell/hoodle-parser {};

  hoodleRender = callPackage ../development/libraries/haskell/hoodle-render {};

  hoodleTypes = callPackage ../development/libraries/haskell/hoodle-types {};

  hoogle_4_2_34 = callPackage ../development/libraries/haskell/hoogle/4.2.34.nix { haskellSrcExts = self.haskellSrcExts_1_15_0_1; };
  hoogle_4_2_36 = callPackage ../development/libraries/haskell/hoogle/4.2.36.nix {};
  hoogle = self.hoogle_4_2_36;

  hoogleLocal = callPackage ../development/libraries/haskell/hoogle/local.nix {};

  hopenssl = callPackage ../development/libraries/haskell/hopenssl {};

  hosc = callPackage ../development/libraries/haskell/hosc {
    binary = self.binary_0_7_2_2;
    dataBinaryIeee754 = self.dataBinaryIeee754.override { binary = self.binary_0_7_2_2; };
  };

  hostname = callPackage ../development/libraries/haskell/hostname {};

  hp2anyCore = callPackage ../development/libraries/haskell/hp2any-core {};

  hp2anyGraph = callPackage ../development/libraries/haskell/hp2any-graph {};

  hS3 = callPackage ../development/libraries/haskell/hS3 {};

  hsBibutils = callPackage ../development/libraries/haskell/hs-bibutils {};

  hsc3 = callPackage ../development/libraries/haskell/hsc3 {};

  hsc3Dot = callPackage ../development/libraries/haskell/hsc3-dot {};

  hsc3Process = callPackage ../development/libraries/haskell/hsc3-process {};

  hsc3Db = callPackage ../development/libraries/haskell/hsc3-db {};

  hsc3Lang = callPackage ../development/libraries/haskell/hsc3-lang {
    hmatrixSpecial = self.hmatrixSpecial.override {
      hmatrix = self.hmatrix.override { binary = self.binary_0_7_2_2; };
      hmatrixGsl = self.hmatrixGsl.override {
        hmatrix = self.hmatrix.override { binary = self.binary_0_7_2_2; };
      };
    };
  };

  hsc3Server = callPackage ../development/libraries/haskell/hsc3-server {};

  hsdns = callPackage ../development/libraries/haskell/hsdns {};

  hsemail = callPackage ../development/libraries/haskell/hsemail {};

  hslua = callPackage ../development/libraries/haskell/hslua {
    lua = pkgs.lua5_1;
  };

  HSH = callPackage ../development/libraries/haskell/HSH {};

  hsini = callPackage ../development/libraries/haskell/hsini {};

  HsSyck_0_51 = callPackage ../development/libraries/haskell/HsSyck/0.51.nix {};
  HsSyck_0_52 = callPackage ../development/libraries/haskell/HsSyck/0.52.nix {};
  HsSyck = self.HsSyck_0_52;

  HsOpenSSL = callPackage ../development/libraries/haskell/HsOpenSSL {};

  hsshellscript = callPackage ../development/libraries/haskell/hsshellscript {};

  HStringTemplate = callPackage ../development/libraries/haskell/HStringTemplate {};

  hspread = callPackage ../development/libraries/haskell/hspread {};

  hsloggerTemplate = callPackage ../development/libraries/haskell/hslogger-template {};

  hspec = callPackage ../development/libraries/haskell/hspec {};

  hspecAttoparsec = callPackage ../development/libraries/haskell/hspec-attoparsec {};

  hspecWai = callPackage ../development/libraries/haskell/hspec-wai {};

  hspec2 = callPackage ../development/libraries/haskell/hspec2 {};

  hspecExpectations = callPackage ../development/libraries/haskell/hspec-expectations {};

  hspecExpectationsLens = callPackage ../development/libraries/haskell/hspec-expectations-lens {};

  hspecMeta = callPackage ../development/libraries/haskell/hspec-meta {};

  hspecCheckers = callPackage ../development/libraries/haskell/hspec-checkers {};

  hstatsd = callPackage ../development/libraries/haskell/hstatsd {};

  hsyslog = callPackage ../development/libraries/haskell/hsyslog {};

  html = callPackage ../development/libraries/haskell/html {};

  htmlConduit = callPackage ../development/libraries/haskell/html-conduit {};

  httpConduit = callPackage ../development/libraries/haskell/http-conduit {};

  httpdShed = callPackage ../development/libraries/haskell/httpd-shed {};

  httpDate = callPackage ../development/libraries/haskell/http-date {};

  httpStreams = callPackage ../development/libraries/haskell/http-streams {};

  httpTypes = callPackage ../development/libraries/haskell/http-types {};

  holyProject = callPackage ../development/libraries/haskell/holy-project {};

  HUnit = callPackage ../development/libraries/haskell/HUnit {};

  HUnitApprox = callPackage ../development/libraries/haskell/HUnit-approx {};

  hweblib = callPackage ../development/libraries/haskell/hweblib/default.nix {};

  hxt = callPackage ../development/libraries/haskell/hxt {};

  hxtCharproperties = callPackage ../development/libraries/haskell/hxt-charproperties {};

  hxtHttp = callPackage ../development/libraries/haskell/hxt-http {};

  hxtPickleUtils = callPackage ../development/libraries/haskell/hxt-pickle-utils {};

  hxtRegexXmlschema = callPackage ../development/libraries/haskell/hxt-regex-xmlschema {};

  hxtTagsoup = callPackage ../development/libraries/haskell/hxt-tagsoup {};

  hxtUnicode = callPackage ../development/libraries/haskell/hxt-unicode {};

  hxtXpath = callPackage ../development/libraries/haskell/hxt-xpath {};

  hybridVectors = callPackage ../development/libraries/haskell/hybrid-vectors {};

  iCalendar = callPackage ../development/libraries/haskell/iCalendar {};

  idna = callPackage ../development/libraries/haskell/idna {};

  IfElse = callPackage ../development/libraries/haskell/IfElse {};

  ieee754 = callPackage ../development/libraries/haskell/ieee754 {};

  ihaskell = callPackage ../development/tools/haskell/ihaskell {};

  imm = callPackage ../development/libraries/haskell/imm {};

  implicit = callPackage ../development/libraries/haskell/implicit {};

  indents = callPackage ../development/libraries/haskell/indents {};

  indexed = callPackage ../development/libraries/haskell/indexed {};

  indexedFree = callPackage ../development/libraries/haskell/indexed-free {};

  instantGenerics = callPackage ../development/libraries/haskell/instant-generics {};

  interlude = callPackage ../development/libraries/haskell/interlude {};

  interpolate = callPackage ../development/libraries/haskell/interpolate {};

  interpolatedstringPerl6 = callPackage ../development/libraries/haskell/interpolatedstring-perl6 {};

  intervals = callPackage ../development/libraries/haskell/intervals {};

  IntervalMap = callPackage ../development/libraries/haskell/IntervalMap {};

  ioChoice = callPackage ../development/libraries/haskell/io-choice {};

  ioMemoize = callPackage ../development/libraries/haskell/io-memoize {};

  IORefCAS = callPackage ../development/libraries/haskell/IORefCAS {};

  IOSpec = callPackage ../development/libraries/haskell/IOSpec {};

  ioStorage = callPackage ../development/libraries/haskell/io-storage {};

  ioStreams = callPackage ../development/libraries/haskell/io-streams {};

  ipprint = callPackage ../development/libraries/haskell/ipprint {};

  iproute = callPackage ../development/libraries/haskell/iproute {};

  irc = callPackage ../development/libraries/haskell/irc {};

  iteratee = callPackage ../development/libraries/haskell/iteratee {};

  ivor = callPackage ../development/libraries/haskell/ivor {};

  ivory = callPackage ../development/libraries/haskell/ivory {};

  ixdopp = callPackage ../development/libraries/haskell/ixdopp {
    preprocessorTools = self.preprocessorTools_0_1_3;
  };

  ixset = callPackage ../development/libraries/haskell/ixset {};

  ixShapable = callPackage ../development/libraries/haskell/ix-shapable {};

  jack = callPackage ../development/libraries/haskell/jack {};

  JuicyPixels = callPackage ../development/libraries/haskell/JuicyPixels {};

  jmacro = callPackage ../development/libraries/haskell/jmacro {};
  jmacroRpc = callPackage ../development/libraries/haskell/jmacro-rpc {};
  jmacroRpcHappstack = callPackage ../development/libraries/haskell/jmacro-rpc-happstack {};
  jmacroRpcSnap = callPackage ../development/libraries/haskell/jmacro-rpc-snap {};

  jpeg = callPackage ../development/libraries/haskell/jpeg {};

  json = callPackage ../development/libraries/haskell/json {};

  jsonAssertions = callPackage ../development/libraries/haskell/json-assertions {};

  jsonRpc = callPackage ../development/libraries/haskell/json-rpc {};

  jsonSchema = callPackage ../development/libraries/haskell/json-schema {};

  jsonTypes = callPackage ../development/libraries/haskell/jsonTypes {};

  JuicyPixelsUtil = callPackage ../development/libraries/haskell/JuicyPixels-util {};

  jwt = callPackage ../development/libraries/haskell/jwt {};

  kanExtensions = callPackage ../development/libraries/haskell/kan-extensions {};

  kansasComet = callPackage ../development/libraries/haskell/kansas-comet {};

  kansasLava = callPackage ../development/libraries/haskell/kansas-lava {};

  keys = callPackage ../development/libraries/haskell/keys {};

  knob = callPackage ../development/libraries/haskell/knob {};

  languageC = callPackage ../development/libraries/haskell/language-c {};

  languageCInline = callPackage ../development/libraries/haskell/language-c-inline {};

  languageCQuote = callPackage ../development/libraries/haskell/language-c-quote {};

  languageEcmascript = callPackage ../development/libraries/haskell/language-ecmascript {};

  languageGlsl = callPackage ../development/libraries/haskell/language-glsl {};

  languageJava = callPackage ../development/libraries/haskell/language-java {};

  languageJavascript = callPackage ../development/libraries/haskell/language-javascript {};

  languageHaskellExtract = callPackage ../development/libraries/haskell/language-haskell-extract {};

  lambdabot = callPackage ../development/libraries/haskell/lambdabot {
    haskellSrcExts = self.haskellSrcExts_1_15_0_1;
    hoogle = self.hoogle_4_2_34.override {
      haskellSrcExts = self.haskellSrcExts_1_15_0_1;
    };
  };

  lambdabotWrapper = callPackage ../development/libraries/haskell/lambdabot/wrapper.nix {
    mueval = self.muevalWrapper.override {
      additionalPackages = [ self.lambdabot ];
    };
  };

  lambdabotUtils = callPackage ../development/libraries/haskell/lambdabot-utils {};

  lambdacubeEngine = callPackage ../development/libraries/haskell/lambdacube-engine {};

  largeword = callPackage ../development/libraries/haskell/largeword {};

  lazysmallcheck = callPackage ../development/libraries/haskell/lazysmallcheck {};

  lens = callPackage ../development/libraries/haskell/lens {};

  lensAeson = callPackage ../development/libraries/haskell/lens-aeson {};

  lensDatetime = callPackage ../development/libraries/haskell/lens-datetime {};

  lensFamilyCore = callPackage ../development/libraries/haskell/lens-family-core {};

  lensFamily = callPackage ../development/libraries/haskell/lens-family {};

  lensFamilyTh = callPackage ../development/libraries/haskell/lens-family-th {};

  lenses = callPackage ../development/libraries/haskell/lenses {};

  leveldbHaskell = callPackage ../development/libraries/haskell/leveldb-haskell {};

  libffi = callPackage ../development/libraries/haskell/libffi {
    libffi = pkgs.libffi;
  };

  libjenkins = callPackage ../development/libraries/haskell/libjenkins {};

  libmpd = callPackage ../development/libraries/haskell/libmpd {};

  liblastfm = callPackage ../development/libraries/haskell/liblastfm {};

  libsystemdJournal = callPackage ../development/libraries/haskell/libsystemd-journal {};

  libxmlSax = callPackage ../development/libraries/haskell/libxml-sax {};

  liftedAsync = callPackage ../development/libraries/haskell/lifted-async {};

  liftedBase = callPackage ../development/libraries/haskell/lifted-base {};

  linear = callPackage ../development/libraries/haskell/linear {};

  linuxInotify = callPackage ../development/libraries/haskell/linux-inotify {};

  List = callPackage ../development/libraries/haskell/List {};

  lists = callPackage ../development/libraries/haskell/lists {};

  listExtras = callPackage ../development/libraries/haskell/listExtras {};

  listTries = callPackage ../development/libraries/haskell/list-tries {};

  ListLike = callPackage ../development/libraries/haskell/ListLike {};

  ListZipper = callPackage ../development/libraries/haskell/ListZipper {};

  llvmGeneral = callPackage ../development/libraries/haskell/llvm-general { llvmConfig = pkgs.llvm; };

  llvmGeneralPure = callPackage ../development/libraries/haskell/llvm-general-pure {};

  lrucache = callPackage ../development/libraries/haskell/lrucache {};

  lochTh = callPackage ../development/libraries/haskell/loch-th {};

  lockfreeQueue = callPackage ../development/libraries/haskell/lockfree-queue {};

  logfloat = callPackage ../development/libraries/haskell/logfloat {};

  logging = callPackage ../development/libraries/haskell/logging {};

  logict = callPackage ../development/libraries/haskell/logict {};

  loop = callPackage ../development/libraries/haskell/loop {};

  lushtags = callPackage ../development/libraries/haskell/lushtags {};

  lzmaEnumerator = callPackage ../development/libraries/haskell/lzma-enumerator {};

  maccatcher = callPackage ../development/libraries/haskell/maccatcher {};

  machines = callPackage ../development/libraries/haskell/machines {};

  machinesDirectory = callPackage ../development/libraries/haskell/machines-directory {};

  machinesIo = callPackage ../development/libraries/haskell/machines-io {};

  managed = callPackage ../development/libraries/haskell/managed {};

  mapSyntax = callPackage ../development/libraries/haskell/map-syntax {};

  markdown = callPackage ../development/libraries/haskell/markdown {};

  markdownUnlit = callPackage ../development/libraries/haskell/markdown-unlit {};

  mathFunctions = callPackage ../development/libraries/haskell/math-functions {};

  mainlandPretty = callPackage ../development/libraries/haskell/mainland-pretty {};

  markovChain = callPackage ../development/libraries/haskell/markov-chain {};

  matrix = callPackage ../development/libraries/haskell/matrix {};

  maude = callPackage ../development/libraries/haskell/maude {};

  MaybeT = callPackage ../development/libraries/haskell/MaybeT {};

  meep = callPackage ../development/libraries/haskell/meep {};

  MemoTrie = callPackage ../development/libraries/haskell/MemoTrie {};

  mersenneRandom = callPackage ../development/libraries/haskell/mersenne-random {};

  mersenneRandomPure64 = callPackage ../development/libraries/haskell/mersenne-random-pure64 {};

  MFlow = callPackage ../development/libraries/haskell/MFlow {};

  midi = callPackage ../development/libraries/haskell/midi {};

  mime = callPackage ../development/libraries/haskell/mime {};

  minimorph = callPackage ../development/libraries/haskell/minimorph {};

  minioperational = callPackage ../development/libraries/haskell/minioperational {};

  miniutter = callPackage ../development/libraries/haskell/miniutter {
    binary = self.binary_0_7_2_2;
  };

  mimeMail = callPackage ../development/libraries/haskell/mime-mail {};

  mimeTypes = callPackage ../development/libraries/haskell/mime-types {};

  misfortune = callPackage ../development/libraries/haskell/misfortune {};

  missingForeign = callPackage ../development/libraries/haskell/missing-foreign {};

  MissingH = callPackage ../development/libraries/haskell/MissingH { testpack = null; };

  mmap = callPackage ../development/libraries/haskell/mmap {};

  modularArithmetic = callPackage ../development/libraries/haskell/modular-arithmetic {};

  MonadCatchIOMtl = callPackage ../development/libraries/haskell/MonadCatchIO-mtl {};

  MonadCatchIOTransformers = callPackage ../development/libraries/haskell/MonadCatchIO-transformers {};

  monadControl = callPackage ../development/libraries/haskell/monad-control {};

  monadCoroutine = callPackage ../development/libraries/haskell/monad-coroutine {};

  monadcryptorandom = callPackage ../development/libraries/haskell/monadcryptorandom {};

  monadExtras = callPackage ../development/libraries/haskell/monad-extras {};

  monadJournal = callPackage ../development/libraries/haskell/monad-journal {};

  monadLib = callPackage ../development/libraries/haskell/monadlib {};

  monadloc = callPackage ../development/libraries/haskell/monadloc {};

  monadlocPp = callPackage ../development/libraries/haskell/monadloc-pp {};

  monadLoops = callPackage ../development/libraries/haskell/monad-loops {};

  monadLogger = callPackage ../development/libraries/haskell/monad-logger {};

  monadPar_0_1_0_3 = callPackage ../development/libraries/haskell/monad-par/0.1.0.3.nix {};
  monadPar_0_3_4_6 = callPackage ../development/libraries/haskell/monad-par/0.3.4.6.nix {};
  monadPar = self.monadPar_0_3_4_6;

  monadParallel = callPackage ../development/libraries/haskell/monad-parallel {};

  monadParExtras = callPackage ../development/libraries/haskell/monad-par-extras {};

  monadPeel = callPackage ../development/libraries/haskell/monad-peel {};

  MonadPrompt = callPackage ../development/libraries/haskell/MonadPrompt {};

  MonadRandom_0_2_0_1 = callPackage ../development/libraries/haskell/MonadRandom/0.2.0.1.nix {};
  MonadRandom_0_3 = callPackage ../development/libraries/haskell/MonadRandom/0.3.nix {};
  MonadRandom = self.MonadRandom_0_3;

  monadStm = callPackage ../development/libraries/haskell/monad-stm {};

  monadSupply = callPackage ../development/libraries/haskell/monad-supply {};

  monadsTf = callPackage ../development/libraries/haskell/monads-tf {};

  monadUnify = callPackage ../development/libraries/haskell/monad-unify {};

  monoidExtras = callPackage ../development/libraries/haskell/monoid-extras {};

  monoidTransformer = callPackage ../development/libraries/haskell/monoid-transformer {};

  mongoDB = callPackage ../development/libraries/haskell/mongoDB {};

  monomorphic = callPackage ../development/libraries/haskell/monomorphic {};

  monoTraversable = callPackage ../development/libraries/haskell/mono-traversable {};

  mmorph = callPackage ../development/libraries/haskell/mmorph {};

  mpppc = callPackage ../development/libraries/haskell/mpppc {};

  msgpack = callPackage ../development/libraries/haskell/msgpack {};

  mtl_2_1_3_1 = callPackage ../development/libraries/haskell/mtl/2.1.3.1.nix {};
  mtl_2_2_1 = callPackage ../development/libraries/haskell/mtl/2.2.1.nix {};
  mtl = null; # tightly coupled with 'transformers' which is a core package

  mtlparse = callPackage ../development/libraries/haskell/mtlparse {};

  mueval = callPackage ../development/libraries/haskell/mueval {};

  muevalWrapper = callPackage ../development/libraries/haskell/mueval/wrapper.nix {};

  multiarg = callPackage ../development/libraries/haskell/multiarg {};

  multimap = callPackage ../development/libraries/haskell/multimap {};

  multipart = callPackage ../development/libraries/haskell/multipart {};

  multiplate = callPackage ../development/libraries/haskell/multiplate {};

  multirec = callPackage ../development/libraries/haskell/multirec {};

  multiset = callPackage ../development/libraries/haskell/multiset {};

  murmurHash = callPackage ../development/libraries/haskell/murmur-hash {};

  mwcRandom = callPackage ../development/libraries/haskell/mwc-random {};

  mysql = callPackage ../development/libraries/haskell/mysql {
    mysqlConfig = pkgs.mysql;
    inherit (pkgs) zlib;
  };

  mysqlSimple = callPackage ../development/libraries/haskell/mysql-simple {};

  nanospec = callPackage ../development/libraries/haskell/nanospec {};

  nat = callPackage ../development/libraries/haskell/nat {};

  nats = callPackage ../development/libraries/haskell/nats {};

  naturals = callPackage ../development/libraries/haskell/naturals {};

  ncurses = callPackage ../development/libraries/haskell/ncurses {
    inherit (pkgs) ncurses;
  };

  netlist = callPackage ../development/libraries/haskell/netlist {};

  netlistToVhdl = callPackage ../development/libraries/haskell/netlist-to-vhdl {};

  netwire = callPackage ../development/libraries/haskell/netwire {};

  network_2_2_1_7 = callPackage ../development/libraries/haskell/network/2.2.1.7.nix {};
  network_2_3_0_13 = callPackage ../development/libraries/haskell/network/2.3.0.13.nix {};
  network_2_5_0_0 = callPackage ../development/libraries/haskell/network/2.5.0.0.nix {};
  network_2_6_0_2 = callPackage ../development/libraries/haskell/network/2.6.0.2.nix {};
  network = self.network_2_6_0_2;

  networkCarbon = callPackage ../development/libraries/haskell/network-carbon {};

  networkConduit = callPackage ../development/libraries/haskell/network-conduit {};
  networkConduitTls = callPackage ../development/libraries/haskell/network-conduit-tls {};

  networkFancy = callPackage ../development/libraries/haskell/network-fancy {};

  networkInfo = callPackage ../development/libraries/haskell/network-info {};

  networkMetrics = callPackage ../development/libraries/haskell/network-metrics {};

  networkMulticast = callPackage ../development/libraries/haskell/network-multicast {};

  networkProtocolXmpp = callPackage ../development/libraries/haskell/network-protocol-xmpp {};

  networkSimple = callPackage ../development/libraries/haskell/network-simple {};

  networkTransport = callPackage ../development/libraries/haskell/network-transport {};

  networkTransportTcp = callPackage ../development/libraries/haskell/network-transport-tcp {};

  networkTransportTests = callPackage ../development/libraries/haskell/network-transport-tests {};

  networkUri = callPackage ../development/libraries/haskell/network-uri {};

  newtype = callPackage ../development/libraries/haskell/newtype {};

  nonNegative = callPackage ../development/libraries/haskell/non-negative {};

  numericExtras = callPackage ../development/libraries/haskell/numeric-extras {};

  numericPrelude = callPackage ../development/libraries/haskell/numeric-prelude {};

  NumInstances = callPackage ../development/libraries/haskell/NumInstances {};

  numbers = callPackage ../development/libraries/haskell/numbers {};

  numtype = callPackage ../development/libraries/haskell/numtype {};

  numtypeTf = callPackage ../development/libraries/haskell/numtype-tf {};

  OneTuple = callPackage ../development/libraries/haskell/OneTuple {};

  objective = callPackage ../development/libraries/haskell/objective {};

  ObjectName = callPackage ../development/libraries/haskell/ObjectName {};

  oeis = callPackage ../development/libraries/haskell/oeis {};

  OpenAL = callPackage ../development/libraries/haskell/OpenAL {};

  OpenGL = callPackage ../development/libraries/haskell/OpenGL {};

  OpenGLRaw = callPackage ../development/libraries/haskell/OpenGLRaw {};

  opensslStreams = callPackage ../development/libraries/haskell/openssl-streams {};

  operational = callPackage ../development/libraries/haskell/operational {};

  opml = callPackage ../development/libraries/haskell/opml {};

  options = callPackage ../development/libraries/haskell/options {};

  optparseApplicative_0_10_0 = callPackage ../development/libraries/haskell/optparse-applicative/0.10.0.nix {};
  optparseApplicative_0_11_0_1 = callPackage ../development/libraries/haskell/optparse-applicative/0.11.0.1.nix {};
  optparseApplicative = self.optparseApplicative_0_11_0_1;

  pathPieces = callPackage ../development/libraries/haskell/path-pieces {};

  patience = callPackage ../development/libraries/haskell/patience {};

  pandoc = callPackage ../development/libraries/haskell/pandoc {};

  pandocCiteproc = callPackage ../development/libraries/haskell/pandoc-citeproc {};

  pandocTypes = callPackage ../development/libraries/haskell/pandoc-types {};

  pango_0_12_5_3 = callPackage ../development/libraries/haskell/pango/0.12.5.3.nix {
    inherit (pkgs) pango;
    libc = pkgs.stdenv.gcc.libc;
    glib = self.glib_0_12_5_4;
    cairo = self.cairo_0_12_5_3;
  };
  pango_0_13_0_3 = callPackage ../development/libraries/haskell/pango/0.13.0.3.nix {
    inherit (pkgs) pango;
    libc = pkgs.stdenv.gcc.libc;
  };
  pango = self.pango_0_13_0_3;

  parallel_3_2_0_3 = callPackage ../development/libraries/haskell/parallel/3.2.0.3.nix {};
  parallel_3_2_0_4 = callPackage ../development/libraries/haskell/parallel/3.2.0.4.nix {};
  parallel = self.parallel_3_2_0_4;

  parallelIo = callPackage ../development/libraries/haskell/parallel-io {};

  parseargs = callPackage ../development/libraries/haskell/parseargs {};

  parsec = callPackage ../development/libraries/haskell/parsec {};

  parsers = callPackage ../development/libraries/haskell/parsers {};

  parsimony = callPackage ../development/libraries/haskell/parsimony {};

  PastePipe = callPackage ../development/tools/haskell/PastePipe {};

  pathtype = callPackage ../development/libraries/haskell/pathtype {};

  patternArrows = callPackage ../development/libraries/haskell/pattern-arrows {};

  pbkdf = callPackage ../development/libraries/haskell/pbkdf {};

  pcap = callPackage ../development/libraries/haskell/pcap {};

  pcapEnumerator = callPackage ../development/libraries/haskell/pcap-enumerator {};

  pcreLight = callPackage ../development/libraries/haskell/pcre-light {};

  pdfToolboxContent = callPackage ../development/libraries/haskell/pdf-toolbox-content {};

  pdfToolboxCore = callPackage ../development/libraries/haskell/pdf-toolbox-core {};

  pdfToolboxDocument = callPackage ../development/libraries/haskell/pdf-toolbox-document {};

  pem = callPackage ../development/libraries/haskell/pem {};

  permutation = callPackage ../development/libraries/haskell/permutation {};

  persistent = callPackage ../development/libraries/haskell/persistent {};

  persistentMysql = callPackage ../development/libraries/haskell/persistent-mysql {};

  persistentPostgresql = callPackage ../development/libraries/haskell/persistent-postgresql {};

  persistentSqlite = callPackage ../development/libraries/haskell/persistent-sqlite {};

  persistentTemplate = callPackage ../development/libraries/haskell/persistent-template {};

  pgm = callPackage ../development/libraries/haskell/pgm {};

  pipes = callPackage ../development/libraries/haskell/pipes {};

  pipesAeson = callPackage ../development/libraries/haskell/pipes-aeson {};

  pipesAttoparsec = callPackage ../development/libraries/haskell/pipes-attoparsec {};

  pipesBinary = callPackage ../development/libraries/haskell/pipes-binary {};

  pipesBytestring = callPackage ../development/libraries/haskell/pipes-bytestring {};

  pipesConcurrency = callPackage ../development/libraries/haskell/pipes-concurrency {};

  pipesCsv = callPackage ../development/libraries/haskell/pipes-csv {};

  pipesHttp = callPackage ../development/libraries/haskell/pipes-http {};

  pipesNetwork = callPackage ../development/libraries/haskell/pipes-network {};

  pipesGroup = callPackage ../development/libraries/haskell/pipes-group {};

  pipesParse = callPackage ../development/libraries/haskell/pipes-parse {};

  pipesPostgresqlSimple = callPackage ../development/libraries/haskell/pipes-postgresql-simple {};

  pipesSafe = callPackage ../development/libraries/haskell/pipes-safe {};

  pipesShell = callPackage ../development/libraries/haskell/pipes-shell {};

  pipesText = callPackage ../development/libraries/haskell/pipes-text {};

  pipesZlib = callPackage ../development/libraries/haskell/pipes-zlib {};

  placeholders = callPackage ../development/libraries/haskell/placeholders {};

  plugins= callPackage ../development/libraries/haskell/plugins {};

  polyparse = callPackage ../development/libraries/haskell/polyparse {};

  pointed = callPackage ../development/libraries/haskell/pointed {};

  pointedlist = callPackage ../development/libraries/haskell/pointedlist {};

  poolConduit = callPackage ../development/libraries/haskell/pool-conduit {};

  pop3client = callPackage ../development/libraries/haskell/pop3-client {};

  poppler = callPackage ../development/libraries/haskell/poppler {
    popplerGlib = pkgs.poppler.poppler_glib;
    libc = pkgs.stdenv.gcc.libc;
  };

  posixPaths = callPackage ../development/libraries/haskell/posix-paths {};

  postgresqlLibpq = callPackage ../development/libraries/haskell/postgresql-libpq {
    inherit (pkgs) postgresql;
  };

  postgresqlSimple = callPackage ../development/libraries/haskell/postgresql-simple {};

  ppm = callPackage ../development/libraries/haskell/ppm {};

  pqueue = callPackage ../development/libraries/haskell/pqueue {};

  process_1_2_0_0 = callPackage ../development/libraries/haskell/process/1.2.0.0.nix {};
  process = null;      # core package since forever

  profiteur = callPackage ../development/tools/haskell/profiteur {};

  preludeExtras = callPackage ../development/libraries/haskell/prelude-extras {};

  preludeSafeenum = callPackage ../development/libraries/haskell/prelude-safeenum {};

  preprocessorTools_0_1_3 = callPackage ../development/libraries/haskell/preprocessor-tools/0.1.3.nix {};
  preprocessorTools_1_0_1 = callPackage ../development/libraries/haskell/preprocessor-tools/1.0.1.nix {};
  preprocessorTools = self.preprocessorTools_1_0_1;

  presburger = callPackage ../development/libraries/haskell/presburger {};

  present = callPackage ../development/libraries/haskell/present {};

  prettyclass = callPackage ../development/libraries/haskell/prettyclass {};

  prettyShow = callPackage ../development/libraries/haskell/pretty-show {};

  punycode = callPackage ../development/libraries/haskell/punycode {};

  pureCdb = callPackage ../development/libraries/haskell/pure-cdb {};

  primitive_0_5_0_1 = callPackage ../development/libraries/haskell/primitive/0.5.0.1.nix {};
  primitive_0_5_3_0 = callPackage ../development/libraries/haskell/primitive/0.5.3.0.nix {};
  primitive_0_5_4_0 = callPackage ../development/libraries/haskell/primitive/0.5.4.0.nix {};
  primitive = self.primitive_0_5_4_0;

  probability = callPackage ../development/libraries/haskell/probability {};

  profunctors = callPackage ../development/libraries/haskell/profunctors {};

  projectTemplate = callPackage ../development/libraries/haskell/project-template {};

  processConduit = callPackage ../development/libraries/haskell/process-conduit {};

  processExtras = callPackage ../development/libraries/haskell/process-extras {};

  prolog = callPackage ../development/libraries/haskell/prolog {};
  prologGraphLib = callPackage ../development/libraries/haskell/prolog-graph-lib {};
  prologGraph = callPackage ../development/libraries/haskell/prolog-graph {};

  protobuf = callPackage ../development/libraries/haskell/protobuf {};

  protocolBuffers = callPackage ../development/libraries/haskell/protocol-buffers {};

  protocolBuffersDescriptor = callPackage ../development/libraries/haskell/protocol-buffers-descriptor {};

  PSQueue = callPackage ../development/libraries/haskell/PSQueue {};

  publicsuffixlist = callPackage ../development/libraries/haskell/publicsuffixlist {};

  pureMD5 = callPackage ../development/libraries/haskell/pureMD5 {};

  purescript = callPackage ../development/libraries/haskell/purescript {};

  pwstoreFast = callPackage ../development/libraries/haskell/pwstore-fast {};

  QuickCheck = callPackage ../development/libraries/haskell/QuickCheck {};

  quickcheckAssertions = callPackage ../development/libraries/haskell/quickcheck-assertions {};

  quickcheckInstances = callPackage ../development/libraries/haskell/quickcheck-instances {};

  quickcheckIo = callPackage ../development/libraries/haskell/quickcheck-io {};

  quickcheckPropertyMonad = callPackage ../development/libraries/haskell/quickcheck-property-monad {};

  qrencode = callPackage ../development/libraries/haskell/qrencode {
    inherit (pkgs) qrencode;
  };

  RangedSets = callPackage ../development/libraries/haskell/Ranged-sets {};

  random_1_0_1_1 = callPackage ../development/libraries/haskell/random/1.0.1.1.nix {};
  random_1_0_1_3 = callPackage ../development/libraries/haskell/random/1.0.1.3.nix {};
  random_1_1 = callPackage ../development/libraries/haskell/random/1.1.nix {};
  random = self.random_1_1;

  randomFu = callPackage ../development/libraries/haskell/random-fu {};

  randomSource = callPackage ../development/libraries/haskell/random-source {};

  randomShuffle = callPackage ../development/libraries/haskell/random-shuffle {};

  rank1dynamic = callPackage ../development/libraries/haskell/rank1dynamic {};

  ranges = callPackage ../development/libraries/haskell/ranges {};

  Rasterific = callPackage ../development/libraries/haskell/Rasterific {};

  rawStringsQq = callPackage ../development/libraries/haskell/rawStringsQq {};

  reserve = callPackage ../development/libraries/haskell/reserve {};

  rvar = callPackage ../development/libraries/haskell/rvar {};

  reactiveBanana = callPackage ../development/libraries/haskell/reactive-banana {};

  reactiveBananaWx = callPackage ../development/libraries/haskell/reactive-banana-wx {};

  ReadArgs = callPackage ../development/libraries/haskell/ReadArgs {};

  readline = callPackage ../development/libraries/haskell/readline {
    inherit (pkgs) readline ncurses;
  };

  recaptcha = callPackage ../development/libraries/haskell/recaptcha {};

  recursionSchemes = callPackage ../development/libraries/haskell/recursion-schemes {};

  reducers = callPackage ../development/libraries/haskell/reducers {};

  reflection = callPackage ../development/libraries/haskell/reflection {};

  RefSerialize = callPackage ../development/libraries/haskell/RefSerialize {};

  regexApplicative = callPackage ../development/libraries/haskell/regex-applicative {};

  regexBase = callPackage ../development/libraries/haskell/regex-base {};

  regexCompat = callPackage ../development/libraries/haskell/regex-compat {};

  regexCompatTdfa = callPackage ../development/libraries/haskell/regex-compat-tdfa {};

  regexPcreBuiltin = callPackage ../development/libraries/haskell/regex-pcre-builtin {};

  regexPosix = callPackage ../development/libraries/haskell/regex-posix {};

  regexTdfa = callPackage ../development/libraries/haskell/regex-tdfa {};

  regexTdfaRc = callPackage ../development/libraries/haskell/regex-tdfa-rc {};

  regexTdfaText = callPackage ../development/libraries/haskell/regex-tdfa-text {};

  regexPcre = callPackage ../development/libraries/haskell/regex-pcre {};

  regexpr = callPackage ../development/libraries/haskell/regexpr {};

  regular = callPackage ../development/libraries/haskell/regular {};

  regularXmlpickler = callPackage ../development/libraries/haskell/regular-xmlpickler {};

  rematch = callPackage ../development/libraries/haskell/rematch {};

  remote = callPackage ../development/libraries/haskell/remote {};

  repa = callPackage ../development/libraries/haskell/repa {};
  repaAlgorithms = callPackage ../development/libraries/haskell/repa-algorithms {};
  repaExamples = callPackage ../development/libraries/haskell/repa-examples {};
  repaIo = callPackage ../development/libraries/haskell/repa-io {};

  RepLib = callPackage ../development/libraries/haskell/RepLib {};

  repr = callPackage ../development/libraries/haskell/repr {};

  resourcePool = callPackage ../development/libraries/haskell/resource-pool {};

  resourcePoolCatchio = callPackage ../development/libraries/haskell/resource-pool-catchio {};

  resourcet = callPackage ../development/libraries/haskell/resourcet {};

  restClient = callPackage ../development/libraries/haskell/rest-client {};

  restCore = callPackage ../development/libraries/haskell/rest-core {};

  restGen = callPackage ../development/libraries/haskell/rest-gen {};

  restHappstack = callPackage ../development/libraries/haskell/rest-happstack {};

  restSnap = callPackage ../development/libraries/haskell/rest-snap {};

  restStringmap = callPackage ../development/libraries/haskell/rest-stringmap {};

  restTypes = callPackage ../development/libraries/haskell/rest-types {};

  restWai = callPackage ../development/libraries/haskell/rest-wai {};

  retry = callPackage ../development/libraries/haskell/retry {};

  rethinkdb = callPackage ../development/libraries/haskell/rethinkdb {};

  rex = callPackage ../development/libraries/haskell/rex {};

  rfc5051 = callPackage ../development/libraries/haskell/rfc5051 {};

  robotsTxt = callPackage ../development/libraries/haskell/robots-txt {};

  rope = callPackage ../development/libraries/haskell/rope {};

  rosezipper = callPackage ../development/libraries/haskell/rosezipper {};

  RSA = callPackage ../development/libraries/haskell/RSA {};

  saltine = callPackage ../development/libraries/haskell/saltine {};

  sampleFrame = callPackage ../development/libraries/haskell/sample-frame {};

  safe = callPackage ../development/libraries/haskell/safe {};

  safecopy = callPackage ../development/libraries/haskell/safecopy {};

  SafeSemaphore = callPackage ../development/libraries/haskell/SafeSemaphore {};

  sbv = callPackage ../development/libraries/haskell/sbv {};

  scientific_0_2_0_2 = callPackage ../development/libraries/haskell/scientific/0.2.0.2.nix {};
  scientific_0_3_3_2 = callPackage ../development/libraries/haskell/scientific/0.3.3.2.nix {};
  scientific = self.scientific_0_3_3_2;

  scotty = callPackage ../development/libraries/haskell/scotty {};

  scottyHastache = callPackage ../development/libraries/haskell/scotty-hastache {};

  scrypt = callPackage ../development/libraries/haskell/scrypt {};

  serialport = callPackage ../development/libraries/haskell/serialport {};

  securemem = callPackage ../development/libraries/haskell/securemem {};

  sendfile = callPackage ../development/libraries/haskell/sendfile {};

  semigroups = callPackage ../development/libraries/haskell/semigroups {};

  semigroupoids = callPackage ../development/libraries/haskell/semigroupoids {};

  semigroupoidExtras = callPackage ../development/libraries/haskell/semigroupoid-extras {};

  servant = callPackage ../development/libraries/haskell/servant {};

  servantPool = callPackage ../development/libraries/haskell/servant-pool {};

  servantPostgresql = callPackage ../development/libraries/haskell/servant-postgresql {};

  servantResponse = callPackage ../development/libraries/haskell/servant-response {};

  servantScotty = callPackage ../development/libraries/haskell/servant-scotty {};

  setenv = callPackage ../development/libraries/haskell/setenv {};

  setlocale = callPackage ../development/libraries/haskell/setlocale {};

  shellish = callPackage ../development/libraries/haskell/shellish {};

  shellmate = callPackage ../development/libraries/haskell/shellmate {};

  shelly = callPackage ../development/libraries/haskell/shelly {};

  shell-conduit = callPackage ../development/libraries/haskell/shell-conduit {};

  simpleConduit = callPackage ../development/libraries/haskell/simple-conduit {};

  simpleReflect = callPackage ../development/libraries/haskell/simple-reflect {};

  simpleSendfile = callPackage ../development/libraries/haskell/simple-sendfile {};

  simpleSqlParser = callPackage ../development/libraries/haskell/simple-sql-parser {};

  silently = callPackage ../development/libraries/haskell/silently {};

  sized = callPackage ../development/libraries/haskell/sized {};

  sizedTypes = callPackage ../development/libraries/haskell/sized-types {};

  skein = callPackage ../development/libraries/haskell/skein {};

  smallcheck = callPackage ../development/libraries/haskell/smallcheck {};

  smtLib = callPackage ../development/libraries/haskell/smtLib {};

  smtpMail = callPackage ../development/libraries/haskell/smtp-mail {};

  smtpsGmail = callPackage ../development/libraries/haskell/smtps-gmail {};

  snap = callPackage ../development/libraries/haskell/snap/snap.nix {};

  snapletAcidState = callPackage ../development/libraries/haskell/snaplet-acid-state {};

  snapletPostgresqlSimple = callPackage ../development/libraries/haskell/snaplet-postgresql-simple {};

  snapletRedis = callPackage ../development/libraries/haskell/snaplet-redis {};

  snapletStripe = callPackage ../development/libraries/haskell/snaplet-stripe {};

  snapBlaze = callPackage ../development/libraries/haskell/snap-blaze/default.nix {};

  snapCore = callPackage ../development/libraries/haskell/snap/core.nix {};

  snapCors = callPackage ../development/libraries/haskell/snap-cors {};

  snapLoaderDynamic = callPackage ../development/libraries/haskell/snap/loader-dynamic.nix {};

  snapLoaderStatic = callPackage ../development/libraries/haskell/snap/loader-static.nix {};

  snapServer = callPackage ../development/libraries/haskell/snap/server.nix {};

  snapWebRoutes = callPackage ../development/libraries/haskell/snap-web-routes {};

  snowball = callPackage ../development/libraries/haskell/snowball {};

  socks = callPackage ../development/libraries/haskell/socks {};

  socketIo = callPackage ../development/libraries/haskell/socket-io {};

  sodium = callPackage ../development/libraries/haskell/sodium {};

  sparse = callPackage ../development/libraries/haskell/sparse {};

  spawn = callPackage ../development/libraries/haskell/spawn {};

  speculation = callPackage ../development/libraries/haskell/speculation {};

  spoon = callPackage ../development/libraries/haskell/spoon {};

  srcloc = callPackage ../development/libraries/haskell/srcloc {};

  statePlus = callPackage ../development/libraries/haskell/state-plus {};

  stateref = callPackage ../development/libraries/haskell/stateref {};

  statestack = callPackage ../development/libraries/haskell/statestack {};

  StateVar = callPackage ../development/libraries/haskell/StateVar {};

  statistics = callPackage ../development/libraries/haskell/statistics {};

  statvfs = callPackage ../development/libraries/haskell/statvfs {};

  StrafunskiStrategyLib = callPackage ../development/libraries/haskell/Strafunski-StrategyLib {};

  streamingCommons = callPackage ../development/libraries/haskell/streaming-commons {};

  streamproc = callPackage ../development/libraries/haskell/streamproc {};

  strict = callPackage ../development/libraries/haskell/strict {};

  stringable = callPackage ../development/libraries/haskell/stringable {};

  stringCombinators = callPackage ../development/libraries/haskell/string-combinators {};

  stringConversions = callPackage ../development/libraries/haskell/string-conversions {};

  stringprep = callPackage ../development/libraries/haskell/stringprep {};

  stringQq = callPackage ../development/libraries/haskell/string-qq {};

  stringsearch = callPackage ../development/libraries/haskell/stringsearch {};

  strptime = callPackage ../development/libraries/haskell/strptime {};

  stylishHaskell = callPackage ../development/libraries/haskell/stylish-haskell {};

  syb_0_4_0 = callPackage ../development/libraries/haskell/syb/0.4.0.nix {};
  syb_0_4_2 = callPackage ../development/libraries/haskell/syb/0.4.2.nix {};
  syb = self.syb_0_4_2;

  sybWithClass = callPackage ../development/libraries/haskell/syb/syb-with-class.nix {};

  sybWithClassInstancesText = callPackage ../development/libraries/haskell/syb/syb-with-class-instances-text.nix {};

  syntactic = callPackage ../development/libraries/haskell/syntactic {};

  syz = callPackage ../development/libraries/haskell/syz {};

  SDLImage = callPackage ../development/libraries/haskell/SDL-image {};

  SDLMixer = callPackage ../development/libraries/haskell/SDL-mixer {};

  SDLTtf = callPackage ../development/libraries/haskell/SDL-ttf {};

  SDL = callPackage ../development/libraries/haskell/SDL {
    inherit (pkgs) SDL;
  };

  sdl2 = callPackage ../development/libraries/haskell/sdl2 {
    inherit (pkgs) SDL2;
  };

  SHA = callPackage ../development/libraries/haskell/SHA {};

  SHA2 = callPackage ../development/libraries/haskell/SHA2 {};

  shake = callPackage ../development/libraries/haskell/shake {};

  shakespeare = callPackage ../development/libraries/haskell/shakespeare {};

  shakespeareCss = callPackage ../development/libraries/haskell/shakespeare-css {};

  shakespeareI18n = callPackage ../development/libraries/haskell/shakespeare-i18n {};

  shakespeareJs = callPackage ../development/libraries/haskell/shakespeare-js {};

  shakespeareText = callPackage ../development/libraries/haskell/shakespeare-text {};

  Shellac = callPackage ../development/libraries/haskell/Shellac/Shellac.nix {};

  show = callPackage ../development/libraries/haskell/show {};

  singletons = callPackage ../development/libraries/haskell/singletons {};

  SMTPClient = callPackage ../development/libraries/haskell/SMTPClient {};

  socketActivation = callPackage ../development/libraries/haskell/socket-activation {};

  sourcemap = callPackage ../development/libraries/haskell/sourcemap {};

  split_0_1_4_3 = callPackage ../development/libraries/haskell/split/0.1.4.3.nix {};
  split_0_2_2 = callPackage ../development/libraries/haskell/split/0.2.2.nix {};
  split = self.split_0_2_2;

  sqliteSimple = callPackage ../development/libraries/haskell/sqlite-simple/default.nix {};

  stbImage = callPackage ../development/libraries/haskell/stb-image {};

  stm_2_4_2 = callPackage ../development/libraries/haskell/stm/2.4.2.nix {};
  stm_2_4_3 = callPackage ../development/libraries/haskell/stm/2.4.3.nix {};
  stm = self.stm_2_4_3;

  stmChans = callPackage ../development/libraries/haskell/stm-chans {};

  stmConduit = callPackage ../development/libraries/haskell/stm-conduit {};

  stmContainers = callPackage ../development/libraries/haskell/stm-containers {};

  STMonadTrans = callPackage ../development/libraries/haskell/STMonadTrans {};

  stmStats = callPackage ../development/libraries/haskell/stm-stats {};

  storableComplex = callPackage ../development/libraries/haskell/storable-complex {};

  storableEndian = callPackage ../development/libraries/haskell/storable-endian {};

  storableRecord = callPackage ../development/libraries/haskell/storable-record {};

  Stream = callPackage ../development/libraries/haskell/Stream {};

  strictConcurrency = callPackage ../development/libraries/haskell/strict-concurrency {};

  stringbuilder = callPackage ../development/libraries/haskell/stringbuilder {};

  stripe = callPackage ../development/libraries/haskell/stripe {};

  svgcairo = callPackage ../development/libraries/haskell/svgcairo {
    libc = pkgs.stdenv.gcc.libc;
  };

  SVGFonts = callPackage ../development/libraries/haskell/SVGFonts {};

  symbol = callPackage ../development/libraries/haskell/symbol {};

  systemArgv0 = callPackage ../development/libraries/haskell/system-argv0 {};

  systemFilepath = callPackage ../development/libraries/haskell/system-filepath {};

  systemFileio = callPackage ../development/libraries/haskell/system-fileio {};

  systemPosixRedirect = callPackage ../development/libraries/haskell/system-posix-redirect {};

  systemTimeMonotonic = callPackage ../development/libraries/haskell/system-time-monotonic {};

  TableAlgebra = callPackage ../development/libraries/haskell/TableAlgebra {};

  tables = callPackage ../development/libraries/haskell/tables {};

  tabular = callPackage ../development/libraries/haskell/tabular {};

  tagged = callPackage ../development/libraries/haskell/tagged {};

  taggedTransformer = callPackage ../development/libraries/haskell/tagged-transformer {};

  taggy = callPackage ../development/libraries/haskell/taggy {};

  taggyLens = callPackage ../development/libraries/haskell/taggy-lens {};

  tagshare = callPackage ../development/libraries/haskell/tagshare {};

  tagsoup = callPackage ../development/libraries/haskell/tagsoup {};

  tagstreamConduit = callPackage ../development/libraries/haskell/tagstream-conduit {};

  tasty = callPackage ../development/libraries/haskell/tasty {};

  tastyAntXml = callPackage ../development/libraries/haskell/tasty-ant-xml {};

  tastyGolden = callPackage ../development/libraries/haskell/tasty-golden {};

  tastyHspec = callPackage ../development/libraries/haskell/tasty-hspec {};

  tastyHunit = callPackage ../development/libraries/haskell/tasty-hunit {};

  tastyProgram = callPackage ../development/libraries/haskell/tasty-program {};

  tastyQuickcheck = callPackage ../development/libraries/haskell/tasty-quickcheck {};

  tastyRerun = callPackage ../development/libraries/haskell/tasty-rerun {};

  tastySmallcheck = callPackage ../development/libraries/haskell/tasty-smallcheck {};

  tastyTh = callPackage ../development/libraries/haskell/tasty-th {};

  TCache = callPackage ../development/libraries/haskell/TCache {};

  tcacheAWS = callPackage ../development/libraries/haskell/tcache-AWS {};

  template = callPackage ../development/libraries/haskell/template {};

  templateDefault = callPackage ../development/libraries/haskell/template-default {};

  temporary = callPackage ../development/libraries/haskell/temporary {};

  temporaryRc = callPackage ../development/libraries/haskell/temporary-rc {};

  Tensor = callPackage ../development/libraries/haskell/Tensor {};

  terminalProgressBar = callPackage ../development/libraries/haskell/terminal-progress-bar {};

  terminalSize = callPackage ../development/libraries/haskell/terminal-size {};

  terminfo = callPackage ../development/libraries/haskell/terminfo { inherit (pkgs) ncurses; };

  testFramework = callPackage ../development/libraries/haskell/test-framework {};

  testFrameworkHunit = callPackage ../development/libraries/haskell/test-framework-hunit {};

  testFrameworkQuickcheck2 = callPackage ../development/libraries/haskell/test-framework-quickcheck2 {};

  testFrameworkSmallcheck = callPackage ../development/libraries/haskell/test-framework-smallcheck {};

  testFrameworkTh = callPackage ../development/libraries/haskell/test-framework-th {};

  testFrameworkThPrime = callPackage ../development/libraries/haskell/test-framework-th-prime {};

  testingFeat = callPackage ../development/libraries/haskell/testing-feat {};

  testSimple = callPackage ../development/libraries/haskell/test-simple {};

  texmath = callPackage ../development/libraries/haskell/texmath {};

  text_0_11_2_3 = callPackage ../development/libraries/haskell/text/0.11.2.3.nix {};
  text_1_1_1_3 = callPackage ../development/libraries/haskell/text/1.1.1.3.nix {};
  text_1_2_0_0 = callPackage ../development/libraries/haskell/text/1.2.0.0.nix {};
  text = self.text_1_2_0_0;

  textBinary = callPackage ../development/libraries/haskell/text-binary {};

  textFormat = callPackage ../development/libraries/haskell/text-format {};

  textIcu = callPackage ../development/libraries/haskell/text-icu {};

  textStreamDecode = callPackage ../development/libraries/haskell/text-stream-decode {};

  tfRandom = callPackage ../development/libraries/haskell/tf-random {};

  these = callPackage ../development/libraries/haskell/these {};

  thespian = callPackage ../development/libraries/haskell/thespian {};

  thDesugar = callPackage ../development/libraries/haskell/th-desugar {};

  thExpandSyns = callPackage ../development/libraries/haskell/th-expand-syns {};

  thExtras = callPackage ../development/libraries/haskell/th-extras {};

  thLift = callPackage ../development/libraries/haskell/th-lift {};

  thLiftInstances = callPackage ../development/libraries/haskell/th-lift-instances {};

  thOrphans = callPackage ../development/libraries/haskell/th-orphans {};

  threadmanager = callPackage ../development/libraries/haskell/threadmanager {};

  threads = callPackage ../development/libraries/haskell/threads {};

  thReifyMany = callPackage ../development/libraries/haskell/th-reify-many {};

  Thrift = callPackage ../development/libraries/haskell/Thrift {};

  thyme = callPackage ../development/libraries/haskell/thyme {};

  threepennyGui = callPackage ../development/libraries/haskell/threepenny-gui {};

  time_1_1_2_4 = callPackage ../development/libraries/haskell/time/1.1.2.4.nix {};
  time_1_5 = callPackage ../development/libraries/haskell/time/1.5.nix {};
  time = null;                  # core package since ghc >= 6.12.x

  timerep = callPackage ../development/libraries/haskell/timerep {};

  timeparsers = callPackage ../development/libraries/haskell/timeparsers {};

  timeRecurrence = callPackage ../development/libraries/haskell/time-recurrence {};

  timezoneOlson = callPackage ../development/libraries/haskell/timezone-olson {};

  timezoneSeries = callPackage ../development/libraries/haskell/timezone-series {};

  timeCompat = callPackage ../development/libraries/haskell/time-compat {};

  tls = callPackage ../development/libraries/haskell/tls {};

  tostring = callPackage ../development/libraries/haskell/tostring {};

  transformers_0_3_0_0 = callPackage ../development/libraries/haskell/transformers/0.3.0.0.nix {};
  transformers_0_4_1_0 = callPackage ../development/libraries/haskell/transformers/0.4.1.0.nix {};
  transformers = null;          # core package since ghc >= 7.8.x

  transformersBase = callPackage ../development/libraries/haskell/transformers-base {};

  transformersCompat_0_3_3 = callPackage ../development/libraries/haskell/transformers-compat/0.3.3.nix {};
  transformersCompat_0_3_3_4 = callPackage ../development/libraries/haskell/transformers-compat/0.3.3.4.nix {};
  transformersCompat = self.transformersCompat_0_3_3_4;

  transformersFree = callPackage ../development/libraries/haskell/transformers-free {};

  traverseWithClass = callPackage ../development/libraries/haskell/traverse-with-class {};

  treeView = callPackage ../development/libraries/haskell/tree-view {};

  trifecta = callPackage ../development/libraries/haskell/trifecta {};

  trivia = callPackage ../development/libraries/haskell/trivia {};

  tuple = callPackage ../development/libraries/haskell/tuple {};

  twitterConduit = callPackage ../development/libraries/haskell/twitter-conduit {};

  twitterTypes = callPackage ../development/libraries/haskell/twitter-types {};

  TypeCompose = callPackage ../development/libraries/haskell/TypeCompose {};

  typeEq = callPackage ../development/libraries/haskell/type-eq {};

  typeEquality = callPackage ../development/libraries/haskell/type-equality {};

  typeNatural = callPackage ../development/libraries/haskell/type-natural {};

  typeLevelNaturalNumber = callPackage ../development/libraries/haskell/type-level-natural-number {};

  tz = callPackage ../development/libraries/haskell/tz {
    pkgs_tzdata = pkgs.tzdata;
  };

  tzdata = callPackage ../development/libraries/haskell/tzdata {};

  unbound = callPackage ../development/libraries/haskell/unbound {};

  unboundedDelays = callPackage ../development/libraries/haskell/unbounded-delays {};

  unificationFd = callPackage ../development/libraries/haskell/unification-fd {};

  unionFind = callPackage ../development/libraries/haskell/union-find {};

  uniplate = callPackage ../development/libraries/haskell/uniplate {};

  units = callPackage ../development/libraries/haskell/units {};

  uniqueid = callPackage ../development/libraries/haskell/uniqueid {};

  unixBytestring = callPackage ../development/libraries/haskell/unix-bytestring {};

  unixCompat = callPackage ../development/libraries/haskell/unix-compat {};

  unixMemory = callPackage ../development/libraries/haskell/unix-memory {};

  unixProcessConduit = callPackage ../development/libraries/haskell/unix-process-conduit {};

  unixTime = callPackage ../development/libraries/haskell/unix-time {};

  Unixutils = callPackage ../development/libraries/haskell/Unixutils {};

  unlambda = callPackage ../development/libraries/haskell/unlambda {};

  unorderedContainers = callPackage ../development/libraries/haskell/unordered-containers {};

  uri = callPackage ../development/libraries/haskell/uri {};

  uriEncode = callPackage ../development/libraries/haskell/uri-encode {};

  url = callPackage ../development/libraries/haskell/url {};

  urlencoded = callPackage ../development/libraries/haskell/urlencoded {};

  usb = callPackage ../development/libraries/haskell/usb {};

  utf8Light = callPackage ../development/libraries/haskell/utf8-light {};

  utf8String = callPackage ../development/libraries/haskell/utf8-string {};

  utilityHt = callPackage ../development/libraries/haskell/utility-ht {};

  uulib = callPackage ../development/libraries/haskell/uulib {};

  uuid = callPackage ../development/libraries/haskell/uuid {};

  uuOptions = callPackage ../development/libraries/haskell/uu-options {};

  uuInterleaved = callPackage ../development/libraries/haskell/uu-interleaved {};

  uuParsinglib = callPackage ../development/libraries/haskell/uu-parsinglib {};

  vacuum = callPackage ../development/libraries/haskell/vacuum {};

  vacuumCairo = callPackage ../development/libraries/haskell/vacuum-cairo {};

  vacuumGraphviz = callPackage ../development/libraries/haskell/vacuum-graphviz {};

  vado = callPackage ../development/libraries/haskell/vado {};

  vault = callPackage ../development/libraries/haskell/vault {};

  vcsgui = callPackage ../development/libraries/haskell/vcsgui {};

  vcsRevision = callPackage ../development/libraries/haskell/vcs-revision {};

  vcswrapper = callPackage ../development/libraries/haskell/vcswrapper {};

  Vec = callPackage ../development/libraries/haskell/Vec {};

  vect = callPackage ../development/libraries/haskell/vect {};

  vector_0_10_9_3  = callPackage ../development/libraries/haskell/vector/0.10.9.3.nix {};
  vector_0_10_12_1  = callPackage ../development/libraries/haskell/vector/0.10.12.1.nix {};
  vector = self.vector_0_10_12_1;

  vectorAlgorithms = callPackage ../development/libraries/haskell/vector-algorithms {};

  vectorBinaryInstances = callPackage ../development/libraries/haskell/vector-binary-instances {};

  vectorInstances = callPackage ../development/libraries/haskell/vector-instances {};

  vectorSpace = callPackage ../development/libraries/haskell/vector-space {};

  vectorSpacePoints = callPackage ../development/libraries/haskell/vector-space-points {};

  vectorThUnbox = callPackage ../development/libraries/haskell/vector-th-unbox {};

  vinyl = callPackage ../development/libraries/haskell/vinyl {};

  void = callPackage ../development/libraries/haskell/void {};

  vty = callPackage ../development/libraries/haskell/vty {};

  vtyUi = callPackage ../development/libraries/haskell/vty-ui {};

  wai = callPackage ../development/libraries/haskell/wai {};

  waiAppStatic = callPackage ../development/libraries/haskell/wai-app-static {};

  waiConduit = callPackage ../development/libraries/haskell/wai-conduit {};

  waiExtra = callPackage ../development/libraries/haskell/wai-extra {};

  waiHandlerLaunch = callPackage ../development/libraries/haskell/wai-handler-launch {};

  waiHandlerFastcgi = callPackage ../development/libraries/haskell/wai-handler-fastcgi { inherit (pkgs) fcgi; };

  waiLogger = callPackage ../development/libraries/haskell/wai-logger {};

  waiMiddlewareStatic = callPackage ../development/libraries/haskell/wai-middleware-static {};

  waiTest = callPackage ../development/libraries/haskell/wai-test {};

  waiWebsockets = callPackage ../development/libraries/haskell/wai-websockets {};

  warp = callPackage ../development/libraries/haskell/warp {};

  warpTls = callPackage ../development/libraries/haskell/warp-tls {};

  WAVE = callPackage ../development/libraries/haskell/WAVE {};

  wcwidth = callPackage ../development/libraries/haskell/wcwidth {};

  webdriver = callPackage ../development/libraries/haskell/webdriver {};

  webkit = callPackage ../development/libraries/haskell/webkit {
    webkit = pkgs.webkitgtk2;
  };

  webRoutes = callPackage ../development/libraries/haskell/web-routes {};

  webRoutesBoomerang = callPackage ../development/libraries/haskell/web-routes-boomerang {};

  websockets = callPackage ../development/libraries/haskell/websockets {};

  websocketsSnap = callPackage ../development/libraries/haskell/websockets-snap {};

  CouchDB = callPackage ../development/libraries/haskell/CouchDB {};

  wlPprint = callPackage ../development/libraries/haskell/wl-pprint {};

  wlPprintExtras = callPackage ../development/libraries/haskell/wl-pprint-extras {};

  wlPprintTerminfo = callPackage ../development/libraries/haskell/wl-pprint-terminfo {};

  wlPprintText = callPackage ../development/libraries/haskell/wl-pprint-text {};

  wizards = callPackage ../development/libraries/haskell/wizards {};

  word8 = callPackage ../development/libraries/haskell/word8 {};

  wordexp = callPackage ../development/libraries/haskell/wordexp {};

  Workflow = callPackage ../development/libraries/haskell/Workflow {};

  wreq = callPackage ../development/libraries/haskell/wreq {};

  wx = callPackage ../development/libraries/haskell/wxHaskell/wx.nix {};

  wxc = callPackage ../development/libraries/haskell/wxHaskell/wxc.nix {
    wxGTK = pkgs.wxGTK29;
  };

  wxcore = callPackage ../development/libraries/haskell/wxHaskell/wxcore.nix {
    wxGTK = pkgs.wxGTK29;
  };

  wxdirect = callPackage ../development/libraries/haskell/wxHaskell/wxdirect.nix {};

  x509 = callPackage ../development/libraries/haskell/x509 {};

  x509Store = callPackage ../development/libraries/haskell/x509-store {};

  x509System = callPackage ../development/libraries/haskell/x509-system {};

  x509Validation = callPackage ../development/libraries/haskell/x509-validation {};

  X11 = callPackage ../development/libraries/haskell/X11 {};

  X11Xft = callPackage ../development/libraries/haskell/X11-xft {};

  xdgBasedir = callPackage ../development/libraries/haskell/xdg-basedir {};

  xdot = callPackage ../development/libraries/haskell/xdot {};

  xhtml_3000_2_0_1 = callPackage ../development/libraries/haskell/xhtml/3000.2.0.1.nix {};
  xhtml_3000_2_0_4 = callPackage ../development/libraries/haskell/xhtml/3000.2.0.4.nix {};
  xhtml_3000_2_0_5 = callPackage ../development/libraries/haskell/xhtml/3000.2.0.5.nix {};
  xhtml_3000_2_1 = callPackage ../development/libraries/haskell/xhtml/3000.2.1.nix {};
  xhtml = self.xhtml_3000_2_1;

  xml = callPackage ../development/libraries/haskell/xml {};

  xmlConduit = callPackage ../development/libraries/haskell/xml-conduit {};

  xmlConduitWriter = callPackage ../development/libraries/haskell/xml-conduit-writer {};

  xmlgen = callPackage ../development/libraries/haskell/xmlgen {};

  xmlHamlet = callPackage ../development/libraries/haskell/xml-hamlet {};

  xmlhtml = callPackage ../development/libraries/haskell/xmlhtml {};

  xmlHtmlConduitLens = callPackage ../development/libraries/haskell/xml-html-conduit-lens {};

  xmlLens = callPackage ../development/libraries/haskell/xml-lens {};

  xmlTypes = callPackage ../development/libraries/haskell/xml-types {};

  xorshift = callPackage ../development/libraries/haskell/xorshift {};

  xournalParser = callPackage ../development/libraries/haskell/xournal-parser {};

  xournalTypes = callPackage ../development/libraries/haskell/xournal-types {};

  xtest = callPackage ../development/libraries/haskell/xtest {};

  xssSanitize = callPackage ../development/libraries/haskell/xss-sanitize {};

  Yampa = callPackage ../development/libraries/haskell/Yampa {};

  yaml = callPackage ../development/libraries/haskell/yaml {};

  yamlLight = callPackage ../development/libraries/haskell/yaml-light {};

  yap = callPackage ../development/libraries/haskell/yap {};

  yeganesh = callPackage ../applications/misc/yeganesh {};

  yesod = callPackage ../development/libraries/haskell/yesod {};

  yesodAuth = callPackage ../development/libraries/haskell/yesod-auth {};

  yesodAuthHashdb = callPackage ../development/libraries/haskell/yesod-auth-hashdb {};

  yesodBin = callPackage ../development/libraries/haskell/yesod-bin {};

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

  zeromq4Haskell = callPackage ../development/libraries/haskell/zeromq4-haskell { zeromq = pkgs.zeromq4; };

  zipArchive_0_2_2_1 = callPackage ../development/libraries/haskell/zip-archive/0.2.2.1.nix {};
  zipArchive_0_2_3_4 = callPackage ../development/libraries/haskell/zip-archive/0.2.3.4.nix {};
  zipArchive = self.zipArchive_0_2_3_4;

  zipper = callPackage ../development/libraries/haskell/zipper {};

  zippers = callPackage ../development/libraries/haskell/zippers {};

  zlib_0_5_0_0 = callPackage ../development/libraries/haskell/zlib/0.5.0.0.nix { inherit (pkgs) zlib; };
  zlib_0_5_2_0 = callPackage ../development/libraries/haskell/zlib/0.5.2.0.nix { inherit (pkgs) zlib; };
  zlib_0_5_3_1 = callPackage ../development/libraries/haskell/zlib/0.5.3.1.nix { inherit (pkgs) zlib; };
  zlib_0_5_3_3 = callPackage ../development/libraries/haskell/zlib/0.5.3.3.nix { inherit (pkgs) zlib; };
  zlib_0_5_4_0 = callPackage ../development/libraries/haskell/zlib/0.5.4.0.nix { inherit (pkgs) zlib; };
  zlib_0_5_4_1 = callPackage ../development/libraries/haskell/zlib/0.5.4.1.nix { inherit (pkgs) zlib;};
  zlib = self.zlib_0_5_4_1;

  zlibBindings = callPackage ../development/libraries/haskell/zlib-bindings {};

  zlibConduit = callPackage ../development/libraries/haskell/zlib-conduit {};

  zlibEnum = callPackage ../development/libraries/haskell/zlib-enum {};

  # Compilers.

  Agda = callPackage ../development/compilers/agda { haskellSrcExts = self.haskellSrcExts_1_15_0_1; };

  epic = callPackage ../development/compilers/epic {};

  pakcs = callPackage ../development/compilers/pakcs {};

  # Development tools.

  alex_2_3_5 = callPackage ../development/tools/parsing/alex/2.3.5.nix {};
  alex_3_1_3 = callPackage ../development/tools/parsing/alex/3.1.3.nix {};
  alex = self.alex_3_1_3;

  BNFC = callPackage ../development/tools/haskell/BNFC {};

  cake3 = callPackage ../development/tools/haskell/cake3 {};

  cpphs = callPackage ../development/tools/misc/cpphs {};

  DrIFT = callPackage ../development/tools/haskell/DrIFT {};

  haddock = callPackage ../development/tools/documentation/haddock {};

  haddockApi = callPackage ../development/libraries/haskell/haddock-api {};

  haddockLibrary = callPackage ../development/libraries/haskell/haddock-library {};

  HandsomeSoup = callPackage ../development/libraries/haskell/HandsomeSoup {};

  happy_1_18_4 = callPackage ../development/tools/parsing/happy/1.18.4.nix {};
  happy_1_18_5 = callPackage ../development/tools/parsing/happy/1.18.5.nix {};
  happy_1_18_6 = callPackage ../development/tools/parsing/happy/1.18.6.nix {};
  happy_1_18_9 = callPackage ../development/tools/parsing/happy/1.18.9.nix {};
  happy_1_18_10 = callPackage ../development/tools/parsing/happy/1.18.10.nix {};
  happy_1_19_4 = callPackage ../development/tools/parsing/happy/1.19.4.nix {};
  happy = self.happy_1_19_4;

  happyMeta = callPackage ../development/tools/haskell/happy-meta {};

  haskellDocs = callPackage ../development/tools/haskell/haskell-docs {};

  haskdogs = callPackage ../development/tools/haskell/haskdogs {};

  hasktags = callPackage ../development/tools/haskell/hasktags {};

  hdevtools = callPackage ../development/tools/haskell/hdevtools {};

  hlint = callPackage ../development/tools/haskell/hlint {};

  hp2anyManager = callPackage ../development/tools/haskell/hp2any-manager {};

  hsb2hs = callPackage ../development/tools/haskell/hsb2hs {};

  hscolour = callPackage ../development/tools/haskell/hscolour {};
  hscolourBootstrap = self.hscolour.override {
    cabal = self.cabal.override {
      extension = self : super : {
        hyperlinkSource = false;
        configureFlags = super.configureFlags or "" +
          pkgs.lib.optionalString (pkgs.stdenv.lib.versionOlder "6.12" ghc.version) " --ghc-option=-rtsopts";
      } // pkgs.stdenv.lib.optionalAttrs (pkgs.stdenv.lib.versionOlder "7.9" ghc.version) { noHaddock = true; };
    };
  };

  hscope = callPackage ../development/tools/haskell/hscope { };

  hslogger = callPackage ../development/tools/haskell/hslogger {};

  pointfree = callPackage ../development/tools/haskell/pointfree {};

  pointful = callPackage ../development/tools/haskell/pointful {};

  ShellCheck = callPackage ../development/tools/misc/ShellCheck {};

  SourceGraph = callPackage ../development/tools/haskell/SourceGraph {};

  tar = callPackage ../development/libraries/haskell/tar {};

  threadscope = callPackage ../development/tools/haskell/threadscope {
    gtk = self.gtk_0_12_5_7;
    glib = self.glib_0_12_5_4;
    cairo = self.cairo_0_12_5_3;
    pango = self.pango_0_12_5_3;
  };

  uuagcBootstrap = callPackage ../development/tools/haskell/uuagc/bootstrap.nix {};
  uuagcCabal = callPackage ../development/tools/haskell/uuagc/cabal.nix {};
  uuagc = callPackage ../development/tools/haskell/uuagc {};

  # Applications.

  arbtt = callPackage ../applications/misc/arbtt {};

  idris_plain = callPackage ../development/compilers/idris {};

  idris = callPackage ../development/compilers/idris/wrapper.nix {};

  nc-indicators = callPackage ../applications/misc/nc-indicators {};

  sloane = callPackage ../applications/science/math/sloane {};

  taffybar = callPackage ../applications/misc/taffybar {};

  validation = callPackage ../development/libraries/haskell/validation {};

  xlsx = callPackage ../development/libraries/haskell/xlsx {};

  xmobar = callPackage ../applications/misc/xmobar {};

  xmonad = callPackage ../applications/window-managers/xmonad {};

  xmonadContrib = callPackage ../applications/window-managers/xmonad/xmonad-contrib.nix {};

  xmonadExtras = callPackage ../applications/window-managers/xmonad/xmonad-extras.nix {};

  # Yi packages

  dynamicState = callPackage ../development/libraries/haskell/dynamic-state {};

  ooPrototypes = callPackage ../development/libraries/haskell/oo-prototypes {};

  wordTrie = callPackage ../development/libraries/haskell/word-trie {};

  # This is an unwrapped version of Yi, it will not behave well (no
  # M-x or reload). Use ‘yiCustom’ instead.
  yi = callPackage ../applications/editors/yi/yi.nix { };

  yiCustom = callPackage ../applications/editors/yi/yi-custom.nix {
    extraPackages = pkgs: [];
  };

  yiFuzzyOpen = callPackage ../development/libraries/haskell/yi-fuzzy-open {};

  yiMonokai = callPackage ../development/libraries/haskell/yi-monokai {};

  yiLanguage = callPackage ../development/libraries/haskell/yi-language {};

  yiRope = callPackage ../development/libraries/haskell/yi-rope {};

  yiSnippet = callPackage ../development/libraries/haskell/yi-snippet {};

  # Tools.

  cabalDb = callPackage ../development/tools/haskell/cabal-db {};

  cabal2nix = callPackage ../development/tools/haskell/cabal2nix {};

  # Build a cabal package given a local .cabal file
  buildLocalCabalWithArgs = { src
                            , name
                            , args ? {}
                            , cabalDrvArgs ? { jailbreak = true; }
                            # for import-from-derivation, want to use current system
                            , nativePkgs ? import pkgs.path {}
                            }: let
    cabalExpr = nativePkgs.stdenv.mkDerivation ({
      name = "${name}.nix";

      buildCommand = ''
      export HOME="$TMPDIR"
      ${nativePkgs.haskellPackages.cabal2nix}/bin/cabal2nix ${src} \
          | sed -e 's/licenses.proprietary/licenses.unfree/' > $out
      '';

    } // pkgs.lib.optionalAttrs nativePkgs.stdenv.isLinux {
      LANG = "en_US.UTF-8";
      LOCALE_ARCHIVE = "${nativePkgs.glibcLocales}/lib/locale/locale-archive";
    });
  in callPackage cabalExpr ({
    cabal = self.cabal.override {
      extension = eself: esuper: {
        buildDepends = [ self.cabalInstall ] ++ esuper.buildDepends;
      } // cabalDrvArgs;
    };
  } // args);

  buildLocalCabal = src: name: self.buildLocalCabalWithArgs { inherit src name; };

  cabalDelete = callPackage ../development/tools/haskell/cabal-delete {};

  cabalBounds = callPackage ../development/tools/haskell/cabal-bounds {
    Cabal = self.Cabal_1_20_0_2;
    cabalLenses = self.cabalLenses.override {
      Cabal = self.Cabal_1_20_0_2;
    };
  };

  cabalMeta = callPackage ../development/tools/haskell/cabal-meta {};

  cabal2Ghci = callPackage ../development/tools/haskell/cabal2ghci {};

  cabalGhci = callPackage ../development/tools/haskell/cabal-ghci {};

  cabalg = callPackage ../development/libraries/haskell/cabalg {};

  cabalInstall_0_6_2  = callPackage ../tools/package-management/cabal-install/0.6.2.nix {};
  cabalInstall_0_8_0  = callPackage ../tools/package-management/cabal-install/0.8.0.nix {};
  cabalInstall_0_8_2  = callPackage ../tools/package-management/cabal-install/0.8.2.nix {};
  cabalInstall_0_10_2 = callPackage ../tools/package-management/cabal-install/0.10.2.nix {};
  cabalInstall_0_14_0 = callPackage ../tools/package-management/cabal-install/0.14.0.nix {};
  cabalInstall_1_16_0_2 = callPackage ../tools/package-management/cabal-install/1.16.0.2.nix { Cabal = self.Cabal_1_16_0_3; };
  cabalInstall_1_18_0_3 = callPackage ../tools/package-management/cabal-install/1.18.0.3.nix { Cabal = self.Cabal_1_18_1_3; };
  cabalInstall_1_20_0_3 = callPackage ../tools/package-management/cabal-install/1.20.0.3.nix {
    HTTP = self.HTTP.override { network = self.network_2_5_0_0; };
    Cabal = self.Cabal_1_20_0_2;
  };
  cabalInstall = self.cabalInstall_1_20_0_3;

  codex = callPackage ../development/tools/haskell/codex {};

  commandQq = callPackage ../development/libraries/haskell/command-qq {};

  escoger = callPackage ../tools/misc/escoger { };

  gitAnnex = callPackage ../applications/version-management/git-and-tools/git-annex {
    cabal = self.cabal.override { extension = self : super : { enableSharedExecutables = false; }; };
    dbus = if pkgs.stdenv.isLinux then self.dbus else null;
    fdoNotify = if pkgs.stdenv.isLinux then self.fdoNotify else null;
    hinotify = if pkgs.stdenv.isLinux then self.hinotify else self.fsnotify;
  };

  githubBackup = callPackage ../applications/version-management/git-and-tools/github-backup {};

  hobbes = callPackage ../development/tools/haskell/hobbes {};

  jailbreakCabal = callPackage ../development/tools/haskell/jailbreak-cabal {};

  keter = callPackage ../development/tools/haskell/keter {};

  lhs2tex = callPackage ../tools/typesetting/lhs2tex {};

  packunused = callPackage ../development/tools/haskell/packunused {};

  rehoo = callPackage ../development/tools/haskell/rehoo {};

  sizes = callPackage ../tools/system/sizes {};

  splot = callPackage ../development/tools/haskell/splot {};

  timeplot = callPackage ../development/tools/haskell/timeplot {};

  una = callPackage ../development/tools/haskell/una {};

  # Games.

  LambdaHack = callPackage ../games/LambdaHack {
    vectorBinaryInstances = self.vectorBinaryInstances.override {
      binary = self.binary_0_7_2_2; # the miniutter build input requires this version
    };
  };

  Allure = callPackage ../games/Allure {};

# End of the main part of the file.

}
