{system ? builtins.currentSystem}:

let

  pkgs = import ../../top-level/all-packages.nix {inherit system;};

  
  # Have to do removeAttrs to prevent all-packages from copying
  # stdenv-linux's dependencies, rather than building new ones with
  # dietlibc.
  pkgsToRemove = 
    [ "binutils" "gcc" "coreutils" "findutils" "diffutils" "gnused" "gnugrep"
      "gawk" "gnutar" "gzip" "bzip2" "gnumake" "bash" "patch" "patchelf"
    ];

  pkgsDiet = import ../../top-level/all-packages.nix {
    bootStdenv = removeAttrs (pkgs.useDietLibC pkgs.stdenv) pkgsToRemove;
  };

  pkgsStatic = import ../../top-level/all-packages.nix {
    bootStdenv = removeAttrs (pkgs.makeStaticBinaries pkgs.stdenv) pkgsToRemove;
  };

  
  generator = pkgs.stdenv.mkDerivation {
    name = "bootstrap-tools-generator";
    builder = ./make-bootstrap-tools.sh;

    inherit (pkgsDiet)
      coreutils diffutils gnugrep
      gzip bzip2 gnumake bash patch binutils curl;

    findutils = pkgsDiet.findutils4227; # 4.2.28 is broken
      
    gnused = pkgsDiet.gnused412; # 4.1.5 gives "Memory exhausted" errors

    # patchelf is C++, won't work with dietlibc.
    inherit (pkgsStatic) patchelf;

    gnutar =
      # Tar seems to be broken on dietlibc on x86_64.
      if system != "x86_64-linux"
      then pkgsDiet.gnutar151 # 1.16 is broken
      else pkgsStatic.gnutar;

    gawk = 
      # Dietlibc only provides sufficient math functions (fmod, sin,
      # cos, etc.) on i686.  On other platforms, use Glibc.
      if system == "i686-linux"
      then pkgsDiet.gawk
      else pkgsStatic.gawk;
      
    gcc = import ../../development/compilers/gcc-4.2 {
      inherit (pkgs) fetchurl stdenv;
      noSysDirs = true;
      langCC = false;
      staticCompiler = true;
      profiledCompiler = true;
    };
  
    glibc = pkgs.glibc;

    # The result should not contain any references (store paths) so
    # that we can safely copy them out of the store and to other
    # locations in the store.
    allowedReferences = [];
  };

in generator
