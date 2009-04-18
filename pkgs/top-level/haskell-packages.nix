{pkgs, ghc}:

let ghcOrig = ghc; in

rec {

  ghc = import ../development/compilers/ghc/wrapper.nix {
    inherit (pkgs) stdenv;
    ghc = ghcOrig;
  };

  cabal = import ../development/libraries/haskell/cabal/cabal.nix {
    inherit (pkgs) stdenv fetchurl;
    inherit ghc;
  };


  # Haskell libraries.

  benchpress = import ../development/libraries/haskell/benchpress {
    inherit cabal;
  };

  maybench = import ../development/libraries/haskell/maybench {
    inherit cabal benchpress;
  };

  binary = import ../development/libraries/haskell/binary {
    inherit cabal;
  };

  Crypto = import ../development/libraries/haskell/Crypto {
    inherit cabal;
  };

  editline = import ../development/libraries/haskell/editline {
    inherit (pkgs) libedit;
    inherit cabal;
  };
  
  gtk2hs = import ../development/libraries/haskell/gtk2hs {
    inherit (pkgs) pkgconfig stdenv fetchurl cairo ghc;
    inherit (pkgs.gnome) gtk glib GConf libglade libgtkhtml gtkhtml;
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

  monadlab = import ../development/libraries/haskell/monadlab {
    inherit cabal;
  };

  pcreLight = import ../development/libraries/haskell/pcre-light {
    inherit cabal;
    inherit (pkgs) pcre;
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

  X11 = import ../development/libraries/haskell/X11 {
    inherit cabal;
    inherit (pkgs.xlibs) libX11 libXinerama libXext;
    xineramaSupport = true;
  };

  vty = import ../development/libraries/haskell/vty {
    inherit cabal;
  };

  zlib = import ../development/libraries/haskell/zlib {
    inherit cabal zlib;
  };


  # Compilers.

  ehc = import ../development/compilers/ehc {
    inherit ghc;
    inherit (pkgs) fetchsvn stdenv coreutils m4 libtool uulib uuagc llvm;
  };


  # Development tools.

  alex = import ../development/tools/parsing/alex {
    inherit cabal;
    inherit (pkgs) perl;
  };

  # old version of haddock, still more stable than 2.0
  haddock09 = import ../development/tools/documentation/haddock/haddock-0.9.nix {
    inherit cabal;
  };

  # does not compile with ghc-6.8.3
  haddock210 = pkgs.stdenv.lib.lowPrio (import ../development/tools/documentation/haddock/haddock-2.1.0.nix {
    inherit cabal;
  });

  happy = import ../development/tools/parsing/happy/happy-1.17.nix {
    inherit cabal;
    inherit (pkgs) perl;
  };


  # Applications.

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

}
