{pkgs, newScope, ghc, enableLibraryProfiling ? false}:

let ghcReal = pkgs.lowPrio ghc; in

let result = let callPackage = newScope result; in

# Indentation deliberately broken at this point to keep the bulk
# of this file at a low indentation level.

rec {

  # ==> You're looking for a package but can't find it? Get hack-nix.
  # -> http://github.com/MarcWeber/hack-nix. Read its README file.
  # You can install (almost) all packages from hackage easily.

  inherit ghcReal;

  # In the remainder, `ghc' refers to the wrapper.  This is because
  # it's never useful to use the wrapped GHC (`ghcReal'), as the
  # wrapper provides essential functionality: the ability to find
  # Haskell packages in the buildInputs automatically.
  ghc = callPackage ../development/compilers/ghc/wrapper.nix {
    ghc = ghcReal;
  };

  cabal = callPackage ../development/libraries/haskell/cabal/cabal.nix {};


  # Haskell libraries.

  Agda = callPackage ../development/libraries/haskell/Agda {
    QuickCheck = QuickCheck_2;
  };

  ansiTerminal = callPackage ../development/libraries/haskell/ansi-terminal {};

  ansiWLPprint = callPackage ../development/libraries/haskell/ansi-wl-pprint {};

  AspectAG = callPackage ../development/libraries/haskell/AspectAG {};

  benchpress = callPackage ../development/libraries/haskell/benchpress {};

  bimap = callPackage ../development/libraries/haskell/bimap {};

  binary = callPackage ../development/libraries/haskell/binary {};

  bitmap = callPackage ../development/libraries/haskell/bitmap {};

  blazeHtml = callPackage ../development/libraries/haskell/blaze-html {};

  bytestring = callPackage ../development/libraries/haskell/bytestring {};

  networkBytestring = callPackage ../development/libraries/haskell/network-bytestring {};

  cairo = callPackage ../development/libraries/haskell/cairo {
    inherit (pkgs) cairo zlib;
  };

  cautiousFile = callPackage ../development/libraries/haskell/cautious-file {};

  cereal = callPackage ../development/libraries/haskell/cereal {};

  cgi_3001_1_7_2 = callPackage ../development/libraries/haskell/cgi/3001.1.7.2.nix {
    network = network_2_2_1_7;
  };

  cgi_3001_1_7_3 = callPackage ../development/libraries/haskell/cgi/3001.1.7.3.nix {
    network = network_2_2_1_7;
  };

  cgi = callPackage ../development/libraries/haskell/cgi {};

  cmdargs = callPackage ../development/libraries/haskell/cmdargs {};

  colorizeHaskell = callPackage ../development/libraries/haskell/colorize-haskell {};

  ConfigFile = callPackage ../development/libraries/haskell/ConfigFile {};

  convertible = callPackage ../development/libraries/haskell/convertible {
    time = time_1_1_3;
  };

  Crypto = callPackage ../development/libraries/haskell/Crypto {};

  CS173Tourney = callPackage ../development/libraries/haskell/CS173Tourney {
    inherit (pkgs) fetchgit;
    json = json_0_3_6;
  };

  csv = callPackage ../development/libraries/haskell/csv {};

  dataenc = callPackage ../development/libraries/haskell/dataenc {};

  dataReify = callPackage ../development/libraries/haskell/data-reify {};

  datetime = callPackage ../development/libraries/haskell/datetime {};

  deepseq = callPackage ../development/libraries/haskell/deepseq {};

  Diff = callPackage ../development/libraries/haskell/Diff {};

  digest = callPackage ../development/libraries/haskell/digest {
    inherit (pkgs) zlib;
  };

  dotgen = callPackage ../development/libraries/haskell/dotgen {};

  editline = callPackage ../development/libraries/haskell/editline {
    inherit (pkgs) libedit;
  };

  filepath = callPackage ../development/libraries/haskell/filepath {};

  emgm = callPackage ../development/libraries/haskell/emgm {};

  extensibleExceptions = callPackage ../development/libraries/haskell/extensible-exceptions {};

  fclabels = callPackage ../development/libraries/haskell/fclabels {};

  feed = callPackage ../development/libraries/haskell/feed {};

  filestore = callPackage ../development/libraries/haskell/filestore {};

  fgl = callPackage ../development/libraries/haskell/fgl {};

  fgl_5_4_2_3 = callPackage ../development/libraries/haskell/fgl/5.4.2.3.nix {};

  fingertree = callPackage ../development/libraries/haskell/fingertree {};

  gdiff = callPackage ../development/libraries/haskell/gdiff {};

  getOptions = callPackage ../development/libraries/haskell/get-options {};

  ghcCore = callPackage ../development/libraries/haskell/ghc-core {};

  ghcMtl = callPackage ../development/libraries/haskell/ghc-mtl {};

  ghcPaths_0_1_0_6 = callPackage ../development/libraries/haskell/ghc-paths/0.1.0.6.nix {};

  ghcPaths = callPackage ../development/libraries/haskell/ghc-paths {};

  ghcSyb = callPackage ../development/libraries/haskell/ghc-syb {};

  gitit = callPackage ../development/libraries/haskell/gitit {
    cgi = cgi_3001_1_7_2;
    HTTP = HTTP_4000_0_9;
    network = network_2_2_1_7;
  };

  GlomeVec = callPackage ../development/libraries/haskell/GlomeVec {};

  GLUT2121 = callPackage ../development/libraries/haskell/GLUT/2.1.2.1.nix {
    OpenGL = OpenGL_2_2_3_0;
    glut = pkgs.freeglut;
    inherit (pkgs) mesa;
    inherit (pkgs.xlibs) libSM libICE libXmu libXi;
  };

  GLUT = callPackage ../development/libraries/haskell/GLUT {
    glut = pkgs.freeglut;
    inherit (pkgs) mesa;
    inherit (pkgs.xlibs) libSM libICE libXmu libXi;
  };

  gtk2hs = callPackage ../development/libraries/haskell/gtk2hs {
    inherit (pkgs) pkgconfig gnome cairo;
  };

  gtk2hsBuildtools = callPackage ../development/libraries/haskell/gtk2hs-buildtools {
    alex = alex_2_3_3;
    happy = happy_1_18_5;
  };

  hamlet = callPackage ../development/libraries/haskell/hamlet {};

  HAppSData = callPackage ../development/libraries/haskell/HAppS/HAppS-Data.nix {};

  HAppSIxSet = callPackage ../development/libraries/haskell/HAppS/HAppS-IxSet.nix {};

  HAppSUtil = callPackage ../development/libraries/haskell/HAppS/HAppS-Util.nix {};

  HAppSServer = callPackage ../development/libraries/haskell/HAppS/HAppS-Server.nix {};

  HAppSState = callPackage ../development/libraries/haskell/HAppS/HAppS-State.nix {};

  /* cannot yet get this to work with 6.12.1 */
  happstackData = callPackage ../development/libraries/haskell/happstack/happstack-data.nix {};

  happstackUtil = callPackage ../development/libraries/haskell/happstack/happstack-util.nix {};

  happstackServer = callPackage ../development/libraries/haskell/happstack/happstack-server.nix {
    network = network_2_2_1_7;
  };

  hashedStorage = callPackage ../development/libraries/haskell/hashed-storage {};

  haskeline = callPackage ../development/libraries/haskell/haskeline {};

  haskelineClass = callPackage ../development/libraries/haskell/haskeline-class {};

  haskellLexer = callPackage ../development/libraries/haskell/haskell-lexer {};

  haskellSrc = callPackage ../development/libraries/haskell/haskell-src {};

  haskellSrc_P = callPackage ../development/libraries/haskell/haskell-src {
    happy = happy_1_18_5;
  };

  haskellSrcExts = callPackage ../development/libraries/haskell/haskell-src-exts {};

  haskellSrcMeta = callPackage ../development/libraries/haskell/haskell-src-meta {};

  haskellPlatform = haskellPlatform_2010_2_0_0;

  haskellPlatform_2010_2_0_0 = import ../development/libraries/haskell/haskell-platform/2010.2.0.0.nix {
    inherit cabal ghc
      html xhtml;
    haskellSrc = haskellSrc_P;
    fgl = fgl_5_4_2_3;
    cabalInstall = cabalInstall_0_8_2;
    GLUT = GLUT2121;
    OpenGL = OpenGL_2_2_3_0;
    zlib = zlib_0_5_2_0;
    alex = alex_2_3_3;
    cgi = cgi_3001_1_7_3;
    QuickCheck = QuickCheck_2;
    HTTP = HTTP_4000_0_9;
    HUnit = HUnit_1_2_2_1;
    network = network_2_2_1_7;
    parallel = parallel_2_2_0_1;
    regexBase = regexBase_0_93_2;
    regexCompat = regexCompat_0_93_1;
    regexPosix = regexPosix_0_94_2;
    stm = stm_2_1_2_1;
    haddock = haddock_2_7_2_P;
    happy = happy_1_18_5;
    inherit (pkgs) fetchurl;
  };

  haskellPlatform_2010_1_0_0 = pkgs.lowPrio (import ../development/libraries/haskell/haskell-platform/2010.1.0.0.nix {
    inherit cabal ghc fgl
      haskellSrc html
      stm xhtml;
    cabalInstall = cabalInstall_0_8_0;
    GLUT = GLUT2121;
    OpenGL = OpenGL_2_2_3_0;
    zlib = zlib_0_5_2_0;
    alex = alex_2_3_2;
    cgi = cgi_3001_1_7_2;
    QuickCheck = QuickCheck_2_1_0_3;
    HTTP = HTTP_4000_0_9;
    HUnit = HUnit_1_2_2_1;
    network = network_2_2_1_7;
    parallel = parallel_2_2_0_1;
    regexBase = regexBase_0_93_1;
    regexCompat = regexCompat_0_92;
    regexPosix = regexPosix_0_94_1;
    haddock = haddock_2_7_2;
    happy = happy_1_18_4;
    inherit (pkgs) fetchurl;
  });

  haskellPlatform_2009_2_0_2 = import ../development/libraries/haskell/haskell-platform/2009.2.0.2.nix {
    inherit cabal ghc GLUT HTTP HUnit OpenGL QuickCheck cgi fgl editline
      haskellSrc html parallel regexBase regexCompat regexPosix
      stm time xhtml zlib cabalInstall alex happy haddock;
    inherit (pkgs) fetchurl;
  };

  HTTP_4000_0_9 = callPackage ../development/libraries/haskell/HTTP/4000.0.9.nix {
    network = network_2_2_1_7;
  };

  HTTP = callPackage ../development/libraries/haskell/HTTP {};

  HTTP_3001 = callPackage ../development/libraries/haskell/HTTP/3001.nix {};

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

  HGL = callPackage ../development/libraries/haskell/HGL {};

  highlightingKate = callPackage ../development/libraries/haskell/highlighting-kate {};

  hint = callPackage ../development/libraries/haskell/hint {
    ghcPaths = ghcPaths_0_1_0_6;
  };

  Hipmunk = callPackage ../development/libraries/haskell/Hipmunk {};

  HList = callPackage ../development/libraries/haskell/HList {};

  hmatrix = callPackage ../development/libraries/haskell/hmatrix {
    inherit (pkgs) gsl liblapack/* lapack library */ blas;
  };

  hscolour = callPackage ../development/libraries/haskell/hscolour {};

  hsemail = callPackage ../development/libraries/haskell/hsemail {};

  HStringTemplate = callPackage ../development/libraries/haskell/HStringTemplate {};

  hspread = callPackage ../development/libraries/haskell/hspread {};

  hsloggerTemplate = callPackage ../development/libraries/haskell/hslogger-template {};

  html = callPackage ../development/libraries/haskell/html {};

  httpdShed = callPackage ../development/libraries/haskell/httpd-shed {
    network = network_2_2_1_7;
  };

  HUnit_1_2_2_1 = callPackage ../development/libraries/haskell/HUnit/1.2.2.1.nix {};

  HUnit = callPackage ../development/libraries/haskell/HUnit {};

  ivor = callPackage ../development/libraries/haskell/ivor {};

  jpeg = callPackage ../development/libraries/haskell/jpeg {};

  json = callPackage ../development/libraries/haskell/json {};

  json_0_3_6 = callPackage ../development/libraries/haskell/json/0.3.6.nix {};

  maybench = callPackage ../development/libraries/haskell/maybench {};

  MaybeT = callPackage ../development/libraries/haskell/MaybeT {};

  MaybeTTransformers = callPackage ../development/libraries/haskell/MaybeT-transformers {};

  MissingH = callPackage ../development/libraries/haskell/MissingH {
    network = network_2_2_1_7;
  };

  mmap = callPackage ../development/libraries/haskell/mmap {};

  MonadCatchIOMtl = callPackage ../development/libraries/haskell/MonadCatchIO-mtl {};

  MonadCatchIOTransformers = callPackage ../development/libraries/haskell/MonadCatchIO-transformers {};

  monadlab = callPackage ../development/libraries/haskell/monadlab {};

  MonadRandom = callPackage ../development/libraries/haskell/MonadRandom {};

  monadsFd = callPackage ../development/libraries/haskell/monads-fd {};

  mpppc = callPackage ../development/libraries/haskell/mpppc {};

  mtl = callPackage ../development/libraries/haskell/mtl {};

  multirec = callPackage ../development/libraries/haskell/multirec {};

  multiset = callPackage ../development/libraries/haskell/multiset {};

  network_2_2_1_7 = callPackage ../development/libraries/haskell/network/2.2.1.7.nix {};

  network = callPackage ../development/libraries/haskell/network {};

  nonNegative = callPackage ../development/libraries/haskell/non-negative {};

  numericPrelude = callPackage ../development/libraries/haskell/numeric-prelude {};

  OpenAL = callPackage ../development/libraries/haskell/OpenAL {
    inherit (pkgs) openal;
  };

  OpenGL_2_2_3_0 = callPackage ../development/libraries/haskell/OpenGL/2.2.3.0.nix {
    inherit (pkgs) mesa;
    inherit (pkgs.xlibs) libX11;
  };

  OpenGL = callPackage ../development/libraries/haskell/OpenGL {
    inherit (pkgs) mesa;
    inherit (pkgs.xlibs) libX11;
  };

  pandoc = callPackage ../development/libraries/haskell/pandoc {
    HTTP = HTTP_4000_0_9;
    network = network_2_2_1_7;
  };

  parallel_2_2_0_1 = callPackage ../development/libraries/haskell/parallel/2.2.0.1.nix {};

  parallel = callPackage ../development/libraries/haskell/parallel {};

  parseargs = callPackage ../development/libraries/haskell/parseargs {};

  parsec = callPackage ../development/libraries/haskell/parsec {};

  parsec_3 = callPackage ../development/libraries/haskell/parsec/3.nix {};

  parsimony = callPackage ../development/libraries/haskell/parsimony {};

  pcreLight = callPackage ../development/libraries/haskell/pcre-light {
    inherit (pkgs) pcre;
  };

  persistent = callPackage ../development/libraries/haskell/persistent {};

  polyparse = callPackage ../development/libraries/haskell/polyparse {};

  ppm = callPackage ../development/libraries/haskell/ppm {};

  pureMD5 = callPackage ../development/libraries/haskell/pureMD5 {};

  primitive = callPackage ../development/libraries/haskell/primitive {};

  QuickCheck  = QuickCheck_1;

  QuickCheck_1 = callPackage ../development/libraries/haskell/QuickCheck {};

  QuickCheck_2_1_0_3 = callPackage ../development/libraries/haskell/QuickCheck/2.1.0.3.nix {};

  QuickCheck_2 = callPackage ../development/libraries/haskell/QuickCheck/QuickCheck-2.nix {};

  RangedSets = callPackage ../development/libraries/haskell/Ranged-sets {};

  readline = callPackage ../development/libraries/haskell/readline {
    inherit (pkgs) readline ncurses;
  };

  recaptcha = callPackage ../development/libraries/haskell/recaptcha {
    HTTP = HTTP_4000_0_9;
    network = network_2_2_1_7;
  };

  regexBase_0_93_1 = callPackage ../development/libraries/haskell/regex-base/0.93.1.nix {};

  regexBase_0_93_2 = callPackage ../development/libraries/haskell/regex-base/0.93.2.nix {};

  regexBase = callPackage ../development/libraries/haskell/regex-base {};

  regexCompat_0_92 = callPackage ../development/libraries/haskell/regex-compat/0.92.nix {
    regexBase = regexBase_0_93_1;
    regexPosix = regexPosix_0_94_1;
  };

  regexCompat_0_93_1 = callPackage ../development/libraries/haskell/regex-compat/0.93.1.nix {
    regexBase = regexBase_0_93_2;
    regexPosix = regexPosix_0_94_2;
  };

  regexCompat = callPackage ../development/libraries/haskell/regex-compat {};

  regexPosix_0_94_1 = callPackage ../development/libraries/haskell/regex-posix/0.94.1.nix {
    regexBase = regexBase_0_93_1;
  };

  regexPosix_0_94_2 = callPackage ../development/libraries/haskell/regex-posix/0.94.2.nix {
    regexBase = regexBase_0_93_2;
  };

  regexPosix = callPackage ../development/libraries/haskell/regex-posix {
    inherit cabal regexBase;
  };

  regular = callPackage ../development/libraries/haskell/regular {};

  safe = callPackage ../development/libraries/haskell/safe {};

  salvia = callPackage ../development/libraries/haskell/salvia {
    network = network_2_2_1_7;
  };

  salviaProtocol = callPackage ../development/libraries/haskell/salvia-protocol {};

  scion = callPackage ../development/libraries/haskell/scion {};

  sendfile = callPackage ../development/libraries/haskell/sendfile {
    network = network_2_2_1_7;
  };

  syb = callPackage ../development/libraries/haskell/syb {};

  sybWithClass = callPackage ../development/libraries/haskell/syb/syb-with-class.nix {};

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

  Shellac = callPackage ../development/libraries/haskell/Shellac/Shellac.nix {};

  ShellacHaskeline = callPackage ../development/libraries/haskell/Shellac/Shellac-haskeline.nix {};

  ShellacReadline = callPackage ../development/libraries/haskell/Shellac/Shellac-readline.nix {};

  SMTPClient = callPackage ../development/libraries/haskell/SMTPClient {
    network = network_2_2_1_7;
  };

  split = callPackage ../development/libraries/haskell/split {};

  stbImage = callPackage ../development/libraries/haskell/stb-image {};

  stm = callPackage ../development/libraries/haskell/stm {};

  stm_2_1_2_1 = callPackage ../development/libraries/haskell/stm/2.1.2.1.nix {};

  storableComplex = callPackage ../development/libraries/haskell/storable-complex {};

  strictConcurrency = callPackage ../development/libraries/haskell/strictConcurrency {};

  terminfo = callPackage ../development/libraries/haskell/terminfo {
    inherit extensibleExceptions /* only required for <= ghc6102  ?*/;
    inherit (pkgs) ncurses;
  };

  testpack = callPackage ../development/libraries/haskell/testpack {};

  texmath = callPackage ../development/libraries/haskell/texmath {
    cgi = cgi_3001_1_7_2;
  };

  text = callPackage ../development/libraries/haskell/text {};

  threadmanager = callPackage ../development/libraries/haskell/threadmanager {};

  /* time is Haskell Platform default, time_1_1_3 is more recent but incompatible */
  time = callPackage ../development/libraries/haskell/time {};

  time_1_1_3 = callPackage ../development/libraries/haskell/time/1.1.3.nix {};

  transformers = callPackage ../development/libraries/haskell/transformers {};

  uniplate = callPackage ../development/libraries/haskell/uniplate {};

  uniqueid = callPackage ../development/libraries/haskell/uniqueid {};

  unixCompat = callPackage ../development/libraries/haskell/unix-compat {};

  url = callPackage ../development/libraries/haskell/url {};

  utf8String = callPackage ../development/libraries/haskell/utf8-string {};

  utilityHt = callPackage ../development/libraries/haskell/utility-ht {};

  uulib = callPackage ../development/libraries/haskell/uulib {};

  uuParsingLib = callPackage ../development/libraries/haskell/uu-parsinglib {};

  vacuum = callPackage ../development/libraries/haskell/vacuum {
    ghcPaths = ghcPaths_0_1_0_6;
  };

  vacuumCairo = callPackage ../development/libraries/haskell/vacuum-cairo {};

  Vec = callPackage ../development/libraries/haskell/Vec {};

  vector = callPackage ../development/libraries/haskell/vector {};

  vty = callPackage ../development/libraries/haskell/vty {};

  webRoutes = callPackage ../development/libraries/haskell/web-routes {
    network = network_2_2_1_7;
  };

  webRoutesQuasi = callPackage ../development/libraries/haskell/web-routes-quasi {};

  WebServer = callPackage ../development/libraries/haskell/WebServer {
    inherit (pkgs) fetchgit;
  };

  WebServerExtras = callPackage ../development/libraries/haskell/WebServer-Extras {
    json = json_0_3_6;
    inherit (pkgs) fetchgit;
  };

  CouchDB = callPackage ../development/libraries/haskell/CouchDB {
    HTTP = HTTP_3001;
    json = json_0_3_6;
  };

  base64string = callPackage ../development/libraries/haskell/base64-string {};

  wx = callPackage ../development/libraries/haskell/wxHaskell/wx.nix {};

  wxcore = callPackage ../development/libraries/haskell/wxHaskell/wxcore.nix {
    wxGTK = pkgs.wxGTK28;
    inherit (pkgs) mesa;
    inherit (pkgs.xlibs) libX11;
  };

  X11 = callPackage ../development/libraries/haskell/X11 {
    inherit (pkgs.xlibs) libX11 libXinerama libXext;
    xineramaSupport = true;
  };

  X11Xft = callPackage ../development/libraries/haskell/X11-xft {
    inherit (pkgs) pkgconfig;
    inherit (pkgs.xlibs) libXft;
  };

  xhtml = callPackage ../development/libraries/haskell/xhtml {};

  xml = callPackage ../development/libraries/haskell/xml {};

  zipArchive = callPackage ../development/libraries/haskell/zip-archive {};

  zipper = callPackage ../development/libraries/haskell/zipper {};

  zlib = callPackage ../development/libraries/haskell/zlib {
    inherit (pkgs) zlib;
  };

  zlib_0_5_2_0 = callPackage ../development/libraries/haskell/zlib/0.5.2.0.nix {
    inherit (pkgs) zlib;
  };

  # Compilers.

  ehc = callPackage ../development/compilers/ehc {
    inherit (pkgs) fetchsvn stdenv coreutils glibc m4 libtool llvm;
  };

  helium = callPackage ../development/compilers/helium {};

  idris = callPackage ../development/compilers/idris {};

  # Development tools.

  alex = callPackage ../development/tools/parsing/alex {};

  alex_2_3_2 = callPackage ../development/tools/parsing/alex/2.3.2.nix {};

  alex_2_3_3 = callPackage ../development/tools/parsing/alex/2.3.3.nix {};

  cpphs = callPackage ../development/tools/misc/cpphs {};

  frown = callPackage ../development/tools/parsing/frown {};

  haddock = haddock_2_4_2;

  haddock_2_4_2 = callPackage ../development/tools/documentation/haddock/haddock-2.4.2.nix {};

  haddock_2_7_2 = callPackage ../development/tools/documentation/haddock/haddock-2.7.2.nix {
    alex = alex_2_3_2;
    happy = happy_1_18_4;
    ghcPaths = ghcPaths_0_1_0_6;
  };

  haddock_2_7_2_P = callPackage ../development/tools/documentation/haddock/haddock-2.7.2.nix {
    alex = alex_2_3_3;
    happy = happy_1_18_5;
    ghcPaths = ghcPaths_0_1_0_6;
  };

  happy = happy_1_18_4;

  happy_1_17 = callPackage ../development/tools/parsing/happy/happy-1.17.nix {};

  happy_1_18_4 = callPackage ../development/tools/parsing/happy/happy-1.18.4.nix {};

  happy_1_18_5 = callPackage ../development/tools/parsing/happy/happy-1.18.5.nix {};

  HaRe = callPackage ../development/tools/haskell/HaRe {
    network = network_2_2_1_7;
  };

  hlint = callPackage ../development/tools/haskell/hlint {};

  hslogger = callPackage ../development/tools/haskell/hslogger {
    network = network_2_2_1_7;
  };

  mkcabal = callPackage ../development/tools/haskell/mkcabal {};

  tar = callPackage ../development/tools/haskell/tar {};

  uuagc = callPackage ../development/tools/haskell/uuagc {};

  # Applications.

  darcs = callPackage ../applications/version-management/darcs/darcs-2.nix {
    zlib = zlib_0_5_2_0;
    inherit (pkgs) curl;
  };

  leksah = callPackage ../applications/editors/leksah {
    inherit (pkgs) libedit makeWrapper;
  };

  xmobar = callPackage ../applications/misc/xmobar {};

  xmonad = callPackage ../applications/window-managers/xmonad {
    inherit (pkgs.xlibs) xmessage;
  };

  xmonadContrib = callPackage ../applications/window-managers/xmonad/xmonad-contrib.nix {};

  # Tools.

  cabalInstall_0_8_2 = callPackage ../tools/package-management/cabal-install/0.8.2.nix {
    HTTP = HTTP_4000_0_9;
    network = network_2_2_1_7;
    zlib = zlib_0_5_2_0;
  };

  cabalInstall_0_8_0 = callPackage ../tools/package-management/cabal-install/0.8.0.nix {
    HTTP = HTTP_4000_0_9;
    network = network_2_2_1_7;
    zlib = zlib_0_5_2_0;
  };

  cabalInstall = callPackage ../tools/package-management/cabal-install {};

  lhs2tex = callPackage ../tools/typesetting/lhs2tex {
    inherit (pkgs) tetex polytable;
  };

  myhasktags = callPackage ../tools/misc/myhasktags {};

  # Games.

  LambdaHack = callPackage ../games/LambdaHack {};

  MazesOfMonad = callPackage ../games/MazesOfMonad {};

# End of the main part of the file.

};

in result
