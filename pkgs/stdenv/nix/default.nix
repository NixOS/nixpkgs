{stdenv, pkgs}:

(import ../generic) {
  name = "stdenv-nix";
  preHook = ./prehook.sh;
  initialPath = (import ./path.nix) {pkgs = pkgs;};

  inherit stdenv;

  gcc = (import ../../build-support/gcc-wrapper) {
    name = pkgs.gcc.name;
    nativeTools = false;
    nativeGlibc = true;
    inherit (pkgs) gcc binutils;
    inherit stdenv;
  };

  param1 = pkgs.bash;
}
