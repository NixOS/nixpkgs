{pkgs, ghc}:

let ghcReal = pkgs.lowPrio ghc; in

rec {

  # ==> You're looking for a package but can't find it? Get hack-nix.
  # -> http://github.com/MarcWeber/hack-nix. Read its README file.
  # You can install (almost) all packages from hackage easily.

  inherit ghcReal;

  # In the remainder, `ghc' refers to the wrapper.  This is because
  # it's never useful to use the wrapped GHC (`ghcReal'), as the
  # wrapper provides essential functionality: the ability to find
  # Haskell packages in the buildInputs automatically.
  ghc = import ../development/compilers/ghc/wrapper.nix {
    inherit (pkgs) stdenv makeWrapper;
    ghc = ghcReal;
  };

  cabal = import ../development/libraries/haskell/cabal/cabal.nix {
    inherit (pkgs) stdenv fetchurl lib;
    inherit ghc;
  };


  # Haskell libraries.

  Agda = import ../development/libraries/haskell/Agda {
    inherit cabal binary haskeline haskellSrc mtl utf8String xhtml zlib
      happy alex;
    QuickCheck = QuickCheck2;
  };

  ansiTerminal = import ../development/libraries/haskell/ansi-terminal {
    inherit cabal;
  };

  ansiWLPprint = import ../development/libraries/haskell/ansi-wl-pprint {
    inherit cabal ansiTerminal;
  };

  AspectAG = import ../development/libraries/haskell/AspectAG {
    inherit cabal HList mtl;
  };

  benchpress = import ../development/libraries/haskell/benchpress {
    inherit cabal;
  };

  bimap = import ../development/libraries/haskell/bimap {
    inherit cabal;
  };

  binary = import ../development/libraries/haskell/binary {
    inherit cabal;
  };

  bytestring = import ../development/libraries/haskell/bytestring {
    inherit cabal;
  };

  networkBytestring = import ../development/libraries/haskell/network-bytestring {
    inherit cabal bytestring network;
  };

  cautiousFile = import ../development/libraries/haskell/cautious-file {
    inherit cabal;
  };

  cgi3001172 = import ../development/libraries/haskell/cgi/3001.1.7.2.nix {
    inherit cabal mtl parsec xhtml;
    network = network2217;
  };

  cgi = import ../development/libraries/haskell/cgi {
    inherit cabal mtl network parsec xhtml;
  };

  colorizeHaskell = import ../development/libraries/haskell/colorize-haskell {
    inherit cabal ansiTerminal haskellLexer;
  };

  ConfigFile = import ../development/libraries/haskell/ConfigFile {
    inherit cabal mtl parsec MissingH;
  };

  convertible = import ../development/libraries/haskell/convertible {
    inherit cabal mtl;
    time = time113;
  };

  Crypto = import ../development/libraries/haskell/Crypto {
    inherit cabal HUnit QuickCheck;
  };

  CS173Tourney = import ../development/libraries/haskell/CS173Tourney {
    inherit cabal ;
    inherit (pkgs) fetchgit ;
    inherit time hslogger Crypto base64string CouchDB WebServer WebServerExtras;
    json = json_036;
  };

  csv = import ../development/libraries/haskell/csv {
    inherit cabal parsec;
  };

  dataenc = import ../development/libraries/haskell/dataenc {
    inherit cabal;
  };

  dataReify = import ../development/libraries/haskell/data-reify {
    inherit cabal;
  };

  datetime = import ../development/libraries/haskell/datetime {
    inherit cabal QuickCheck time;
  };

  deepseq = import ../development/libraries/haskell/deepseq {
    inherit cabal;
  };

  Diff = import ../development/libraries/haskell/Diff {
    inherit cabal;
  };

  digest = import ../development/libraries/haskell/digest {
    inherit cabal;
    inherit (pkgs) zlib;
  };

  dotgen = import ../development/libraries/haskell/dotgen {
    inherit cabal;
  };

  editline = import ../development/libraries/haskell/editline {
    inherit (pkgs) libedit;
    inherit cabal;
  };

  filepath = import ../development/libraries/haskell/filepath {
    inherit cabal;
  };

  emgm = import ../development/libraries/haskell/emgm {
    inherit cabal;
  };

  extensibleExceptions = import ../development/libraries/haskell/extensible-exceptions {
    inherit cabal;
  };

  fclabels = import ../development/libraries/haskell/fclabels {
    inherit cabal monadsFd;
  };

  feed = import ../development/libraries/haskell/feed {
    inherit cabal utf8String xml;
  };

  filestore = import ../development/libraries/haskell/filestore {
    inherit cabal datetime parsec regexPosix split time utf8String xml Diff;
  };

  fgl = import ../development/libraries/haskell/fgl {
    inherit cabal mtl;
  };

  getOptions = import ../development/libraries/haskell/get-options {
    inherit (pkgs) fetchurl sourceFromHead;
    inherit cabal mtl;
  };

  ghcCore = import ../development/libraries/haskell/ghc-core {
    inherit cabal pcreLight colorizeHaskell;
  };

  ghcPaths0106 = import ../development/libraries/haskell/ghc-paths/0.1.0.6.nix {
    inherit cabal;
  };

  ghcPaths = import ../development/libraries/haskell/ghc-paths {
    inherit cabal;
  };

  ghcSyb = import ../development/libraries/haskell/ghc-syb {
    inherit (pkgs) fetchurl sourceFromHead;
    inherit cabal syb;
  };

  gitit = import ../development/libraries/haskell/gitit {
    inherit cabal happstackServer happstackUtil
      HStringTemplate SHA datetime
      filestore highlightingKate safe
      mtl pandoc parsec recaptcha
      utf8String xhtml zlib ConfigFile url
      cautiousFile feed;
    cgi = cgi3001172;
    HTTP = HTTP400009;
    network = network2217;
  };

  GLUT2121 = import ../development/libraries/haskell/GLUT/2.1.2.1.nix {
    inherit cabal;
    OpenGL = OpenGL2230;
    glut = pkgs.freeglut;
    inherit (pkgs) mesa;
    inherit (pkgs.xlibs) libSM libICE libXmu libXi;
  };
  
  GLUT = import ../development/libraries/haskell/GLUT {
    inherit cabal OpenGL;
    glut = pkgs.freeglut;
    inherit (pkgs) mesa;
    inherit (pkgs.xlibs) libSM libICE libXmu libXi;
  };
  
  gtk2hs = import ../development/libraries/haskell/gtk2hs {
    inherit ghc mtl;
    inherit (pkgs) stdenv fetchurl pkgconfig gnome cairo;
  };

  HAppSData = import ../development/libraries/haskell/HAppS/HAppS-Data.nix {
    inherit cabal mtl sybWithClass HaXml HAppSUtil bytestring binary;
  };

  HAppSIxSet = import ../development/libraries/haskell/HAppS/HAppS-IxSet.nix {
    inherit cabal mtl hslogger HAppSUtil HAppSState HAppSData sybWithClass;
  };

  HAppSUtil = import ../development/libraries/haskell/HAppS/HAppS-Util.nix {
    inherit cabal mtl hslogger bytestring;
  };

  HAppSServer = import ../development/libraries/haskell/HAppS/HAppS-Server.nix {
    inherit cabal HaXml parsec mtl network hslogger HAppSData HAppSUtil HAppSState HAppSIxSet HTTP xhtml html bytestring;
  };

  HAppSState = import ../development/libraries/haskell/HAppS/HAppS-State.nix {
    inherit cabal HaXml mtl network stm hslogger HAppSUtil HAppSData bytestring binary hspread;
  };

  /* cannot yet get this to work with 6.12.1 */
  happstackData = import ../development/libraries/haskell/happstack/happstack-data.nix {
    inherit cabal mtl sybWithClass HaXml happstackUtil binary;
  };

  happstackUtil = import ../development/libraries/haskell/happstack/happstack-util.nix {
    inherit cabal mtl hslogger QuickCheck HUnit strictConcurrency unixCompat SMTPClient;
  };

  happstackServer = import ../development/libraries/haskell/happstack/happstack-server.nix {
    inherit cabal HUnit HaXml MaybeT parsec sendfile utf8String mtl hslogger happstackData happstackUtil xhtml html zlib;
    network = network2217;
  };

  hashedStorage = import ../development/libraries/haskell/hashed-storage {
    inherit cabal mtl zlib mmap;
  };

  haskeline = import ../development/libraries/haskell/haskeline {
    inherit cabal extensibleExceptions mtl utf8String;
  };

  haskelineClass = import ../development/libraries/haskell/haskeline-class {
    inherit cabal haskeline mtl;
  };

  haskellLexer = import ../development/libraries/haskell/haskell-lexer {
    inherit cabal;
  };

  haskellSrc = import ../development/libraries/haskell/haskell-src {
    inherit cabal happy;
  };

  haskellSrcExts = import ../development/libraries/haskell/haskell-src-exts {
    inherit cabal cpphs happy;
  };

  haskellSrcMeta = import ../development/libraries/haskell/haskell-src-meta {
    inherit cabal haskellSrcExts;
  };
  
  haskellPlatform2010100 = import ../development/libraries/haskell/haskell-platform/2010.1.0.0.nix {
    inherit cabal ghc fgl
      haskellSrc html
      stm xhtml happy;
    cabalInstall = cabalInstall080;
    GLUT = GLUT2121;
    OpenGL = OpenGL2230;
    zlib = zlib0520;
    alex = alex232;
    cgi = cgi3001172;
    QuickCheck = QuickCheck2;
    HTTP = HTTP400009;
    HUnit = HUnit1221;
    network = network2217;
    parallel = parallel2201;
    regexBase = regexBase0931;
    regexCompat = regexCompat092;
    regexPosix = regexPosix0941;
    haddock = haddock272;
    inherit (pkgs) fetchurl;
  };

  haskellPlatform = import ../development/libraries/haskell/haskell-platform {
    inherit cabal ghc GLUT HTTP HUnit OpenGL QuickCheck cgi fgl editline
      haskellSrc html parallel regexBase regexCompat regexPosix
      stm time xhtml zlib cabalInstall alex happy haddock;
    inherit (pkgs) fetchurl;
  };

  HTTP400009 = import ../development/libraries/haskell/HTTP/4000.0.9.nix {
    inherit cabal mtl parsec;
    network = network2217;
  };

  HTTP = import ../development/libraries/haskell/HTTP {
    inherit cabal mtl network parsec;
  };

  HTTP_3001 = import ../development/libraries/haskell/HTTP/3001.nix {
    inherit cabal mtl network parsec;
  };

  haxr = import ../development/libraries/haskell/haxr {
    inherit cabal HaXml HTTP dataenc time;
  };

  haxr_th = import ../development/libraries/haskell/haxr-th {
    inherit cabal haxr HaXml HTTP;
  };

  HaXml = import ../development/libraries/haskell/HaXml {
    inherit cabal;
  };

  HDBC = import ../development/libraries/haskell/HDBC/HDBC.nix {
    inherit cabal HUnit QuickCheck mtl time utf8String convertible testpack;
  };

  HDBCPostgresql = import ../development/libraries/haskell/HDBC/HDBC-postgresql.nix {
    inherit cabal HDBC parsec;
    inherit (pkgs) postgresql;
  };

  HDBCSqlite = import ../development/libraries/haskell/HDBC/HDBC-sqlite3.nix {
    inherit cabal HDBC;
    inherit (pkgs) sqlite;
  };

  HGL = import ../development/libraries/haskell/HGL {
    inherit cabal X11;
  };

  highlightingKate = import ../development/libraries/haskell/highlighting-kate {
    inherit cabal parsec pcreLight xhtml;
  };

  Hipmunk = import ../development/libraries/haskell/Hipmunk {
    inherit cabal;
  };

  HList = import ../development/libraries/haskell/HList {
    inherit cabal ;
  };

  hscolour = import ../development/libraries/haskell/hscolour {
    inherit cabal;
  };

  hsemail = import ../development/libraries/haskell/hsemail {
    inherit cabal mtl parsec;
  };

  HStringTemplate = import ../development/libraries/haskell/HStringTemplate {
    inherit cabal parsec time text utf8String parallel;
  };

  hspread = import ../development/libraries/haskell/hspread {
    inherit cabal binary network;
  };

  hsloggerTemplate = import ../development/libraries/haskell/hslogger-template {
    inherit cabal hslogger mtl;
  };

  html = import ../development/libraries/haskell/html {
    inherit cabal;
  };

  httpdShed = import ../development/libraries/haskell/httpd-shed {
    inherit cabal network;
  };

  HUnit1221 = import ../development/libraries/haskell/HUnit/1.2.2.1.nix {
    inherit cabal;
  };

  HUnit = import ../development/libraries/haskell/HUnit {
    inherit cabal;
  };

  ivor = import ../development/libraries/haskell/ivor {
    inherit cabal mtl parsec;
  };

  jpeg = import ../development/libraries/haskell/jpeg {
    inherit cabal mtl;
  };

  json = import ../development/libraries/haskell/json {
    inherit cabal mtl;
  };

  json_036 = import ../development/libraries/haskell/json/0.3.6.nix {
    inherit cabal mtl;
  };

  maybench = import ../development/libraries/haskell/maybench {
    inherit cabal benchpress;
  };

  MaybeT = import ../development/libraries/haskell/MaybeT {
    inherit cabal mtl;
  };

  MaybeTTransformers = import ../development/libraries/haskell/MaybeT-transformers {
    inherit cabal transformers monadsFd;
  };

  MissingH = import ../development/libraries/haskell/MissingH {
    inherit cabal HUnit hslogger parsec regexCompat;
    network = network2217;
  };

  mmap = import ../development/libraries/haskell/mmap {
    inherit cabal;
  };

  monadlab = import ../development/libraries/haskell/monadlab {
    inherit cabal parsec;
  };

  MonadRandom = import ../development/libraries/haskell/MonadRandom {
    inherit cabal mtl;
  };

  monadsFd = import ../development/libraries/haskell/monads-fd {
    inherit cabal transformers;
  };

  mpppc = import ../development/libraries/haskell/mpppc {
    inherit cabal ansiTerminal split text;
  };

  mtl = import ../development/libraries/haskell/mtl {
    inherit cabal;
  };

  multirec = import ../development/libraries/haskell/multirec {
    inherit cabal;
  };

  multiset = import ../development/libraries/haskell/multiset {
    inherit cabal syb;
  };

  network2217 = import ../development/libraries/haskell/network/2.2.1.7.nix {
    inherit cabal parsec;
  };

  network = import ../development/libraries/haskell/network {
    inherit cabal parsec;
  };

  nonNegative = import ../development/libraries/haskell/non-negative {
    inherit cabal QuickCheck;
  };

  numericPrelude = import ../development/libraries/haskell/numeric-prelude {
    inherit cabal HUnit QuickCheck parsec nonNegative utilityHt;
  };

  OpenAL = import ../development/libraries/haskell/OpenAL {
    inherit cabal OpenGL;
    inherit (pkgs) openal;
  };

  OpenGL2230 = import ../development/libraries/haskell/OpenGL/2.2.3.0.nix {
    inherit cabal;
    inherit (pkgs) mesa;
    inherit (pkgs.xlibs) libX11;
  };

  OpenGL = import ../development/libraries/haskell/OpenGL {
    inherit cabal;
    inherit (pkgs) mesa;
    inherit (pkgs.xlibs) libX11;
  };

  pandoc = import ../development/libraries/haskell/pandoc {
    inherit cabal mtl parsec utf8String xhtml zipArchive
      xml texmath;
    HTTP = HTTP400009;
    network = network2217;
  };

  parallel2201 = import ../development/libraries/haskell/parallel/2.2.0.1.nix {
    inherit cabal deepseq;
  };

  parallel = import ../development/libraries/haskell/parallel {
    inherit cabal;
  };

  parseargs = import ../development/libraries/haskell/parseargs {
    inherit cabal;
  };

  parsec = import ../development/libraries/haskell/parsec {
    inherit cabal;
  };

  parsec3 = import ../development/libraries/haskell/parsec/3.nix {
    inherit cabal mtl;
  };

  parsimony = import ../development/libraries/haskell/parsimony {
    inherit cabal utf8String;
  };

  pcreLight = import ../development/libraries/haskell/pcre-light {
    inherit cabal;
    inherit (pkgs) pcre;
  };

  polyparse = import ../development/libraries/haskell/polyparse {
    inherit cabal;
  };

  pureMD5 = import ../development/libraries/haskell/pureMD5 {
    inherit cabal binary;
  };

  QuickCheck  = QuickCheck1;

  QuickCheck1 = import ../development/libraries/haskell/QuickCheck {
    inherit cabal;
  };

  QuickCheck2 = import ../development/libraries/haskell/QuickCheck/QuickCheck-2.nix {
    inherit cabal mtl;
  };

  readline = import ../development/libraries/haskell/readline {
    inherit cabal;
    inherit (pkgs) readline ncurses;
  };

  recaptcha = import ../development/libraries/haskell/recaptcha {
    inherit cabal xhtml;
    HTTP = HTTP400009;
    network = network2217;
  };

  regexBase0931 = import ../development/libraries/haskell/regex-base/0.93.1.nix {
    inherit cabal mtl;
  };

  regexBase = import ../development/libraries/haskell/regex-base {
    inherit cabal mtl;
  };

  regexCompat092 = import ../development/libraries/haskell/regex-compat/0.92.nix {
    inherit cabal;
    regexBase = regexBase0931;
    regexPosix = regexPosix0941;
  };

  regexCompat = import ../development/libraries/haskell/regex-compat {
    inherit cabal regexBase regexPosix;
  };

  regexPosix0941 = import ../development/libraries/haskell/regex-posix/0.94.1.nix {
    inherit cabal;
    regexBase = regexBase0931;
  };

  regexPosix = import ../development/libraries/haskell/regex-posix {
    inherit cabal regexBase;
  };

  regular = import ../development/libraries/haskell/regular {
    inherit cabal;
  };

  safe = import ../development/libraries/haskell/safe {
    inherit cabal;
  };

  salvia = import ../development/libraries/haskell/salvia {
    inherit cabal fclabels MaybeTTransformers monadsFd pureMD5
      safe salviaProtocol split text threadmanager transformers
      utf8String stm time;
    network = network2217;
  };

  salviaProtocol = import ../development/libraries/haskell/salvia-protocol {
    inherit cabal fclabels parsec safe split utf8String bimap;
  };

  scion = import ../development/libraries/haskell/scion {
    inherit cabal ghcPaths ghcSyb hslogger json multiset time uniplate;
  };

  sendfile = import ../development/libraries/haskell/sendfile {
    inherit cabal;
    network = network2217;
  };

  syb = import ../development/libraries/haskell/syb {
    inherit cabal;
  };

  sybWithClass = import ../development/libraries/haskell/syb/syb-with-class.nix {
    inherit cabal;
  };

  SDLImage = import ../development/libraries/haskell/SDL-image {
    inherit cabal SDL;
    inherit (pkgs) SDL_image;
  };

  SDLMixer = import ../development/libraries/haskell/SDL-mixer {
    inherit cabal SDL;
    inherit (pkgs) SDL_mixer;
  };

  SDLTtf = import ../development/libraries/haskell/SDL-ttf {
    inherit cabal SDL;
    inherit (pkgs) SDL_ttf;
  };

  SDL = import ../development/libraries/haskell/SDL {
    inherit cabal;
    inherit (pkgs) SDL;
  };

  SHA = import ../development/libraries/haskell/SHA {
    inherit cabal binary;
  };

  Shellac = import ../development/libraries/haskell/Shellac/Shellac.nix {
    inherit cabal mtl;
  };

  ShellacHaskeline = import ../development/libraries/haskell/Shellac/Shellac-haskeline.nix {
    inherit cabal Shellac haskeline;
  };

  ShellacReadline = import ../development/libraries/haskell/Shellac/Shellac-readline.nix {
    inherit cabal Shellac readline;
  };

  SMTPClient = import ../development/libraries/haskell/SMTPClient {
    inherit cabal hsemail;
    network = network2217;
  };

  split = import ../development/libraries/haskell/split {
    inherit cabal;
  };

  stm = import ../development/libraries/haskell/stm {
    inherit cabal;
  };

  storableComplex = import ../development/libraries/haskell/storable-complex {
    inherit cabal;
  };

  strictConcurrency = import ../development/libraries/haskell/strictConcurrency {
    inherit cabal parallel;
  };

  terminfo = import ../development/libraries/haskell/terminfo {
    inherit cabal extensibleExceptions /* only required for <= ghc6102  ?*/;
    inherit (pkgs) ncurses;
  };

  testpack = import ../development/libraries/haskell/testpack {
    inherit cabal HUnit QuickCheck mtl;
  };

  texmath = import ../development/libraries/haskell/texmath {
    inherit cabal json parsec xml;
    cgi = cgi3001172;
  };

  text = import ../development/libraries/haskell/text {
    inherit cabal deepseq;
  };

  threadmanager = import ../development/libraries/haskell/threadmanager {
    inherit cabal;
  };

  /* time is Haskell Platform default, time113 is more recent but incompatible */
  time = import ../development/libraries/haskell/time {
    inherit cabal;
  };

  time113 = import ../development/libraries/haskell/time/1.1.3.nix {
    inherit cabal;
  };

  transformers = import ../development/libraries/haskell/transformers {
    inherit cabal;
  };

  uniplate = import ../development/libraries/haskell/uniplate {
    inherit cabal mtl;
  };

  uniqueid = import ../development/libraries/haskell/uniqueid {
    inherit cabal;
  };

  unixCompat = import ../development/libraries/haskell/unix-compat {
    inherit cabal;
  };

  url = import ../development/libraries/haskell/url {
    inherit cabal utf8String;
  };

  utf8String = import ../development/libraries/haskell/utf8-string {
    inherit cabal;
  };

  utilityHt = import ../development/libraries/haskell/utility-ht {
    inherit cabal;
  };

  uulib = import ../development/libraries/haskell/uulib {
    inherit cabal;
  };

  uuParsingLib = import ../development/libraries/haskell/uu-parsinglib {
    inherit cabal;
  };

  vacuum = import ../development/libraries/haskell/vacuum {
    inherit cabal ghcPaths;
  };

  vacuumCairo = import ../development/libraries/haskell/vacuum-cairo {
    inherit cabal vacuum gtk2hs parallel strictConcurrency;
  };

  vty = import ../development/libraries/haskell/vty {
    inherit cabal utf8String terminfo;
  };

  WebServer = import ../development/libraries/haskell/WebServer {
    inherit cabal network mtl parsec;
    inherit (pkgs) fetchgit;
  };

  WebServerExtras = import ../development/libraries/haskell/WebServer-Extras {
    inherit cabal Crypto WebServer base64string hslogger mtl;
    json = json_036;
    inherit (pkgs) fetchgit;
  };

  CouchDB = import ../development/libraries/haskell/CouchDB {
    inherit cabal network mtl ;
    HTTP = HTTP_3001;
    json = json_036;
  };

  base64string = import ../development/libraries/haskell/base64-string {
    inherit cabal;
  };

  wx = import ../development/libraries/haskell/wxHaskell/wx.nix {
    inherit cabal stm wxcore;
  };

  wxcore = import ../development/libraries/haskell/wxHaskell/wxcore.nix {
    inherit cabal time parsec stm;
    wxGTK = pkgs.wxGTK28;
    inherit (pkgs) mesa;
    inherit (pkgs.xlibs) libX11;
  };

  X11 = import ../development/libraries/haskell/X11 {
    inherit cabal;
    inherit (pkgs.xlibs) libX11 libXinerama libXext;
    xineramaSupport = true;
  };

  X11_xft = import ../development/libraries/haskell/X11-xft {
    inherit ghc cabal X11 utf8String;
    inherit (pkgs) pkgconfig;
    inherit (pkgs.xlibs) libXft;
  };

  xhtml = import ../development/libraries/haskell/xhtml {
    inherit cabal;
  };

  xml = import ../development/libraries/haskell/xml {
    inherit cabal;
  };

  zipArchive = import ../development/libraries/haskell/zip-archive {
    inherit cabal binary mtl utf8String zlib digest;
  };

  zipper = import ../development/libraries/haskell/zipper {
    inherit cabal multirec;
  };

  zlib = import ../development/libraries/haskell/zlib {
    inherit cabal;
    inherit (pkgs) zlib;
  };

  zlib0520 = import ../development/libraries/haskell/zlib/0.5.2.0.nix {
    inherit cabal;
    inherit (pkgs) zlib;
  };

  # Compilers.

  ehc = import ../development/compilers/ehc {
    inherit ghc uulib uuagc;
    inherit (pkgs) fetchsvn stdenv coreutils m4 libtool llvm;
  };

  helium = import ../development/compilers/helium {
    inherit ghc;
    inherit (pkgs) fetchurl stdenv;
  };

  idris = import ../development/compilers/idris {
    inherit cabal mtl parsec readline ivor happy;
    inherit (pkgs) fetchdarcs;
  };


  # Development tools.

  alex = import ../development/tools/parsing/alex {
    inherit cabal;
    inherit (pkgs) perl;
  };

  alex232 = import ../development/tools/parsing/alex/2.3.2.nix {
    inherit cabal;
    inherit (pkgs) perl;
  };

  cpphs = import ../development/tools/misc/cpphs {
    inherit cabal;
  };

  frown = import ../development/tools/parsing/frown {
    inherit ghc;
    inherit (pkgs) fetchurl stdenv;
  };

  haddock = haddock242;

  # old version of haddock, still more stable than 2.0
  haddock09 = import ../development/tools/documentation/haddock/haddock-0.9.nix {
    inherit cabal;
  };

  # does not compile with ghc-6.8.3
  haddock210 = pkgs.stdenv.lib.lowPrio (import ../development/tools/documentation/haddock/haddock-2.1.0.nix {
    inherit cabal;
  });

  haddock242 = import ../development/tools/documentation/haddock/haddock-2.4.2.nix {
    inherit cabal ghcPaths;
    inherit (pkgs) libedit;
  };

  haddock272 = import ../development/tools/documentation/haddock/haddock-2.7.2.nix {
    inherit cabal;
    alex = alex232;
    happy = happy1184;
    ghcPaths = ghcPaths0106;
  };

  happy = happy1184;

  happy117 = import ../development/tools/parsing/happy/happy-1.17.nix {
    inherit cabal;
    inherit (pkgs) perl;
  };

  happy1184 = import ../development/tools/parsing/happy/happy-1.18.4.nix {
    inherit cabal mtl;
    inherit (pkgs) perl;
  };

  hlint = import ../development/tools/haskell/hlint {
    inherit cabal haskellSrcExts mtl uniplate hscolour parallel;
  };

  hslogger = import ../development/tools/haskell/hslogger {
    inherit cabal mtl time;
    network = network2217;
  };

  mkcabal = import ../development/tools/haskell/mkcabal {
    inherit cabal mtl pcreLight readline;
  };

  tar = import ../development/tools/haskell/tar {
    inherit cabal binary;
  };

  uuagc = import ../development/tools/haskell/uuagc {
    inherit cabal uulib;
  };

  # Applications.

  darcs = import ../applications/version-management/darcs/darcs-2.nix {
    inherit cabal html mtl parsec regexCompat haskeline hashedStorage;
    inherit (pkgs) curl;
  };

  leksah = import ../applications/editors/leksah {
    inherit cabal gtk2hs binary parsec regexPosix regexCompat utf8String;
    inherit (pkgs) libedit makeWrapper;
  };
  
  xmobar = import ../applications/misc/xmobar {
    inherit cabal X11 mtl parsec stm utf8String X11_xft;
  };

  xmonad = import ../applications/window-managers/xmonad {
    inherit cabal X11 mtl;
    inherit (pkgs.xlibs) xmessage;
  };

  xmonadContrib = import ../applications/window-managers/xmonad/xmonad-contrib.nix {
    inherit cabal xmonad X11 utf8String;
  };


  # Tools.

  cabalInstall080 = import ../tools/package-management/cabal-install/0.8.0.nix {
    inherit cabal;
    HTTP = HTTP400009;
    network = network2217;
    zlib = zlib0520;
  };

  cabalInstall = import ../tools/package-management/cabal-install {
    inherit cabal HTTP network zlib;
  };

  lhs2tex = import ../tools/typesetting/lhs2tex {
    inherit cabal regexCompat utf8String;
    inherit (pkgs) tetex polytable;
  };

  myhasktags = import ../tools/misc/myhasktags {
    inherit ghcReal;
    inherit (pkgs) stdenv fetchurl;
  };

  # Games.

  LambdaHack = import ../games/LambdaHack {
    inherit cabal binary mtl zlib vty;
  };

  MazesOfMonad = import ../games/MazesOfMonad {
    inherit cabal HUnit mtl regexPosix time;
  };

}
