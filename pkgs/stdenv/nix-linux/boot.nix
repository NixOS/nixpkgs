{stdenv, glibc}:

(import ../generic) {
  name = "stdenv-nix-linux-boot";
  preHook = ./prehook-boot.sh;
  initialPath = "/usr/local /usr /";

  inherit stdenv;

  gcc = (import ../../build-support/gcc-wrapper) {
    name = "gcc-native";
    isNative = true;
    nativePrefix = "/usr";
    inherit stdenv glibc;
  };
}
