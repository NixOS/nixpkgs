{stdenv, genericStdenv, gccWrapper}:

genericStdenv {
  name = "stdenv-native";
  preHook = ./prehook.sh;
  initialPath = "/usr/local /usr /";

  inherit stdenv;

  gcc = gccWrapper {
    name = "gcc-native";
    nativeTools = true;
    nativeLibc = true;
    nativePrefix = "/usr";
    inherit stdenv;
  };

  shell = "/bin/bash";

  fetchurlBoot = import ../../build-support/fetchurl {
    inherit stdenv;
    # Curl should be in /usr/bin or so.
    curl = null;
  };
}
