{stdenv}:

(import ../generic) {
  name = "stdenv-native";
  preHook = ./prehook.sh;
  initialPath = "/usr/local /usr /";

  inherit stdenv;

  gcc = (import ../../build-support/gcc-wrapper) {
    name = "gcc-native";
    isNative = true;
    nativePrefix = "/usr";
    inherit stdenv;
  };
}
