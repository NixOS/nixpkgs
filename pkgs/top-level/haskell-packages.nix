{pkgs, ghc}:

let ghcReal = ghc; in

rec {

  inherit ghcReal;

  # In the remainder, `ghc' refers to the wrapper.  This is because
  # it's never useful to use the wrapped GHC (`ghcReal'), as the
  # wrapper provides essential functionality: the ability to find
  # Haskell packages in the buildInputs automatically.
  ghc = import ../development/compilers/ghc/wrapper.nix {
    inherit (pkgs) stdenv;
    ghc = ghcReal;
  };

  cabal = import ../development/libraries/haskell/cabal/cabal.nix {
    inherit (pkgs) stdenv fetchurl;
    inherit ghc;
  };


  # Haskell libraries.

  benchpress = import ../development/libraries/haskell/benchpress {
    inherit cabal;
  };

  binary = import ../development/libraries/haskell/binary {
    inherit cabal;
  };

  cgi = import ../development/libraries/haskell/cgi {
    inherit cabal mtl network parsec xhtml;
  };

  Crypto = import ../development/libraries/haskell/Crypto {
    inherit cabal;
  };

  editline = import ../development/libraries/haskell/editline {
    inherit (pkgs) libedit;
    inherit cabal;
  };

  fgl = import ../development/libraries/haskell/fgl {
    inherit cabal mtl;
  };
  
  gtk2hs = import ../development/libraries/haskell/gtk2hs {
    inherit (pkgs) pkgconfig stdenv fetchurl cairo ghc;
    inherit (pkgs.gnome) gtk glib GConf libglade libgtkhtml gtkhtml;
  };

  haskellSrc = import ../development/libraries/haskell/haskell-src {
    inherit cabal happy;
  };
  
  HTTP = import ../development/libraries/haskell/HTTP {
    inherit cabal;
  };

  haxr = import ../development/libraries/haskell/haxr {
    inherit cabal HaXml HTTP;
  };

  haxr_th = import ../development/libraries/haskell/haxr-th {
    inherit cabal haxr HaXml HTTP;
  };

  HaXml = import ../development/libraries/haskell/HaXml {
    inherit cabal;
  };

  HDBC = import ../development/libraries/haskell/HDBC/HDBC-1.1.4.nix {
    inherit cabal;
  };

  HDBCPostgresql = import ../development/libraries/haskell/HDBC/HDBC-postgresql-1.1.4.0.nix {
    inherit cabal HDBC;
    inherit (pkgs) postgresql;
  };

  HDBCSqlite = import ../development/libraries/haskell/HDBC/HDBC-sqlite3-1.1.4.0.nix {
    inherit cabal HDBC;
    inherit (pkgs) sqlite;
  };

  html = import ../development/libraries/haskell/html {
    inherit cabal;
  };

  HUnit = import ../development/libraries/haskell/HUnit {
    inherit cabal;
  };

  maybench = import ../development/libraries/haskell/maybench {
    inherit cabal benchpress;
  };

  monadlab = import ../development/libraries/haskell/monadlab {
    inherit cabal;
  };

  mtl = import ../development/libraries/haskell/mtl {
    inherit cabal;
  };

  network = import ../development/libraries/haskell/network {
    inherit cabal parsec;
  };

  parallel = import ../development/libraries/haskell/parallel {
    inherit cabal;
  };

  parsec = import ../development/libraries/haskell/parsec {
    inherit cabal;
  };

  pcreLight = import ../development/libraries/haskell/pcre-light {
    inherit cabal;
    inherit (pkgs) pcre;
  };

  QuickCheck = import ../development/libraries/haskell/QuickCheck {
    inherit cabal;
  };

  regexBase = import ../development/libraries/haskell/regex-base {
    inherit cabal mtl;
  };

  regexCompat = import ../development/libraries/haskell/regex-compat {
    inherit cabal regexBase regexPosix;
  };

  regexPosix = import ../development/libraries/haskell/regex-posix {
    inherit cabal regexBase;
  };

  stm = import ../development/libraries/haskell/stm {
    inherit cabal;
  };

  uuagc = import ../development/tools/haskell/uuagc {
    inherit cabal uulib;
  };

  uulib = import ../development/libraries/haskell/uulib {
    inherit cabal;
  };

  wxHaskell = import ../development/libraries/haskell/wxHaskell {
    inherit ghc;
    inherit (pkgs) stdenv fetchurl unzip wxGTK;
  };

  vty = import ../development/libraries/haskell/vty {
    inherit cabal;
  };

  X11 = import ../development/libraries/haskell/X11 {
    inherit cabal;
    inherit (pkgs.xlibs) libX11 libXinerama libXext;
    xineramaSupport = true;
  };

  xhtml = import ../development/libraries/haskell/xhtml {
    inherit cabal;
  };

  zlib = import ../development/libraries/haskell/zlib {
    inherit cabal zlib;
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


  # Development tools.

  alex = import ../development/tools/parsing/alex {
    inherit cabal;
    inherit (pkgs) perl;
  };

  frown = import ../development/tools/parsing/frown {
    inherit ghc;
    inherit (pkgs) fetchurl stdenv;
  };

  # old version of haddock, still more stable than 2.0
  haddock09 = import ../development/tools/documentation/haddock/haddock-0.9.nix {
    inherit cabal;
  };

  # does not compile with ghc-6.8.3
  haddock210 = pkgs.stdenv.lib.lowPrio (import ../development/tools/documentation/haddock/haddock-2.1.0.nix {
    inherit cabal;
  });

  happy = happy1182;

  happy117 = import ../development/tools/parsing/happy/happy-1.17.nix {
    inherit cabal;
    inherit (pkgs) perl;
  };

  happy1182 = import ../development/tools/parsing/happy/happy-1.18.2.nix {
    inherit cabal mtl;
    inherit (pkgs) perl;
  };

  # Applications.

  darcs = import ../applications/version-management/darcs/darcs-2.nix {
    inherit cabal html mtl parsec regexCompat;
    inherit (pkgs) zlib curl;
  };

  xmobar = import ../applications/misc/xmobar {
    inherit cabal;
    inherit (pkgs) X11;
  };

  xmonad = import ../applications/window-managers/xmonad {
    inherit cabal X11;
    inherit (pkgs.xlibs) xmessage;
  };

  xmonadContrib = import ../applications/window-managers/xmonad/xmonad-contrib.nix {
    inherit cabal xmonad X11;
  };


  # Tools.

  lhs2tex = import ../tools/typesetting/lhs2tex {
    inherit ghc;
    inherit (pkgs) fetchurl stdenv tetex polytable;
  };

}
