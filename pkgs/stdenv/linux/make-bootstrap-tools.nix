let

  pkgs = import ../../top-level/all-packages.nix {};

  
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
      coreutils findutils diffutils gnugrep
      gnutar gzip bzip2 gnumake bash patch;
      
    gnused = pkgsDiet.gnused412; # 4.1.5 gives "Memory exhausted" errors

    # patchelf is C++, won't work with dietlibc.
    inherit (pkgsStatic) patchelf;

    gawk = 
      # Dietlibc only provides sufficient math functions (fmod, sin,
      # cos, etc.) on i686.  On other platforms, use Glibc.
      if pkgs.stdenv.system == "i686-linux"
      then pkgsDiet.gawk
      else pkgsStatic.gawk;
      
    binutils = pkgsDiet.binutils217;
   
    gcc = import ../../development/compilers/gcc-static-4.1 {
      inherit (pkgs) fetchurl stdenv;
      profiledCompiler = false;
      langCC = false;
    };
  
    curl = pkgsDiet.realCurl;

    glibc = pkgs.glibc;

    # The result should not contain any references (store paths) so
    # that we can safely copy them out of the store and to other
    # locations in the store.
    allowedReferences = [];
  };

in generator
