let

  pkgs = import ../../top-level/all-packages.nix {};

  pkgsDiet = import ../../top-level/all-packages.nix {
    # Have to do removeAttrs to prevent all-packages from copying
    # stdenv-linux's dependencies, rather than building new ones with
    # dietlibc.
    bootStdenv = removeAttrs (pkgs.useDietLibC pkgs.stdenv)
      ["coreutils" "gnused" "gnutar" "gnugrep" "bzip2" "bash" "patch" "patchelf"];
  };

  generator = pkgs.stdenv.mkDerivation {
    name = "bootstrap-tools-generator";
    builder = ./make-bootstrap-tools.sh;
    inherit (pkgsDiet) coreutils gnused gnugrep gnutar bzip2 bash patch;
    curl = pkgsDiet.realCurl;

    # The result should not contain any references (store paths) so
    # that we can safely copy them out of the store and to other
    # locations in the store.
    allowedReferences = [];
  };

in generator
