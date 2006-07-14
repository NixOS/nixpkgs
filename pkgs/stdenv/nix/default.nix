{stdenv, pkgs, genericStdenv}:

genericStdenv {
  name = "stdenv-nix";
  preHook = ./prehook.sh;
  initialPath = (import ../common-path.nix) {pkgs = pkgs;};

  inherit stdenv;

  gcc = import ../../build-support/gcc-wrapper {
    nativeTools = false;
    nativeGlibc = true;
    inherit stdenv;
    inherit (pkgs) binutils;
    gcc = pkgs.gcc.gcc;
    shell = pkgs.bash ~ /bin/sh;
  };

  shell = pkgs.bash ~ /bin/sh;

  extraAttrs = {
    # Curl should be in /usr/bin or so.
    curl = null;
  };
}
