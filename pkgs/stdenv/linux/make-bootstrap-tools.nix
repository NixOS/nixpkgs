let

  pkgs = import ../../top-level/all-packages.nix {};

  pkgsDiet = import ../../top-level/all-packages.nix {
    # Have to do removeAttrs to prevent all-packages from copying
    # stdenv-linux's dependencies, rather than building new ones with
    # dietlibc.
    bootStdenv = removeAttrs (pkgs.useDietLibC pkgs.stdenv)
      ["binutils" "gcc" "coreutils" "findutils" "gnused" "gnugrep" "gnutar" "gzip" "bzip2" "bash" "patch" "patchelf"];
  };

  generator = pkgs.stdenv.mkDerivation {
    name = "bootstrap-tools-generator";
    builder = ./make-bootstrap-tools.sh;
    
    inherit (pkgsDiet) coreutils findutils gnused gnugrep gnutar gzip bzip2 bash patch;
    binutils = pkgsDiet.binutils;
    
    gcc = import ../../development/compilers/gcc-static-4.1 {
      inherit (pkgs) fetchurl stdenv;
      profiledCompiler = false;
      langCC = false;
    };
  
    curl = pkgsDiet.realCurl;

    patchelf = import ../../development/tools/misc/patchelf/new.nix {
      inherit (pkgs) fetchurl;
      stdenv = pkgs.makeStaticBinaries pkgs.stdenv;
    };

    glibc = pkgs.glibc;

    # The result should not contain any references (store paths) so
    # that we can safely copy them out of the store and to other
    # locations in the store.
    allowedReferences = [];
  };

in generator
