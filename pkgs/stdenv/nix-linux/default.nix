{stdenv, glibc, pkgs}:

(import ../generic) {
  name = "stdenv-nix-linux";
  preHook = ./prehook.sh;
  initialPath = (import ../nix/path.nix) {pkgs = pkgs;};

  inherit stdenv;

  gcc = (import ../../build-support/gcc-wrapper) {
    name = pkgs.gcc.name;
    nativeTools = false;
    nativeGlibc = false;
    inherit (pkgs) gcc binutils;
    inherit stdenv glibc;
  };

  param1 = pkgs.bash;
}
