{stdenv, pkgs, glibc}:

(import ../generic) {
  name = "stdenv-nix-linux-boot";
  preHook = ./prehook-boot.sh;
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
