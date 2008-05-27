{stdenv, genericStdenv, gccWrapper}:

genericStdenv {
  name = "stdenv-darwin";
  preHook = ./prehook.sh;
  initialPath = "/usr/local /usr /";

  inherit stdenv;

  gcc = gccWrapper {
    name = "gcc-darwin";
    nativeTools = true;
    nativeLibc = true;
    nativePrefix = "/usr";
    inherit stdenv;
  };

  shell = "/bin/sh";

  fetchurlBoot = import ../../build-support/fetchurl {
    inherit stdenv;
    # Curl should be in /usr/bin or so.
    curl = null;
  };
}
