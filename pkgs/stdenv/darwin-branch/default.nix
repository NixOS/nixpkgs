{stdenv, genericStdenv, gccWrapper}:

genericStdenv {
  name = "stdenv-darwin";
  preHook = ./prehook.sh;
  initialPath = "/usr/local /usr /";

  inherit stdenv;

  gcc = gccWrapper {
    name = "gcc-darwin";
    nativeTools = true;
    nativeGlibc = true;
    nativePrefix = "/usr";
    inherit stdenv;
  };

  shell = "/bin/bash";
}
