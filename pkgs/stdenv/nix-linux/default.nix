{stdenv, glibc, pkgs}:

(import ../generic) {
  name = "stdenv-nix-linux";
  preHook = ./prehook.sh;
  initialPath = (import ../nix/path.nix) {pkgs = pkgs;};

  inherit stdenv;

  gcc = (import ../../build-support/gcc-wrapper) {
    name = "gcc-native";
    isNative = false;
    gcc = pkgs.gcc;
    binutils = pkgs.binutils;
    inherit stdenv glibc;
  };

  param1 = pkgs.bash;
}
