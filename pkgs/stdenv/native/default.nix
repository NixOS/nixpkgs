{stdenv}:

(import ../generic) {
  name = "stdenv-native";
  preHook = ./prehook.sh;
  postHook = ./posthook.sh;
  initialPath = "/usr/local /usr /";

  inherit stdenv;

  gcc = (import ../../build-support/gcc-wrapper) {
    inherit stdenv;
    name = "gcc-native";
    isNative = true;
    gcc = "/usr";
  };
}
