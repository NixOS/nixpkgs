{stdenv, glibc}:

(import ../generic) {
  name = "stdenv-nix-linux-boot";
  preHook = ./prehook-boot.sh;
  initialPath = "/usr/local /usr /";

  inherit stdenv;

  gcc = (import ../../build-support/gcc-wrapper) {
    name = "gcc-native";
    nativeTools = true;
    nativeGlibc = false;
    nativePrefix = "/usr";
    inherit stdenv glibc;
  };
}
