{stdenv, glibc, pkgs, genericStdenv, gccWrapper}:

genericStdenv {
  name = "stdenv-nix-linux-static";
  preHook = ./prehook.sh;
  initialPath = (import ./path.nix) {pkgs = (import ./pkgs.nix) {stdenv = stdenv;};};

  inherit stdenv;

  gcc = gccWrapper {
    #name = pkgs.gcc.name;
    nativeTools = false;
    nativeGlibc = false;
    inherit (pkgs) binutils;
    gcc = (import ./gcc-static) {stdenv = stdenv;};
    inherit stdenv glibc;
    shell = pkgs.bash ~ /bin/sh;
  };

  shell = pkgs.bash ~ /bin/sh;

}
