{stdenv, glibc, genericStdenv, gccWrapper}:

genericStdenv {
  name = "stdenv-nix-linux-boot";
  preHook = ./prehook-boot.sh;
  initialPath = "/usr/local /usr /";

  inherit stdenv;

  gcc = gccWrapper {
    name = "gcc-native";
    nativeTools = true;
    nativeGlibc = false;
    nativePrefix = "/usr";
    inherit stdenv glibc;
  };

  bash = "/bin/sh";
}
