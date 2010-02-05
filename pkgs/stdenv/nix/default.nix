{stdenv, pkgs}:

import ../generic {
  name = "stdenv-nix";
  preHook = ./prehook.sh;
  initialPath = (import ../common-path.nix) {pkgs = pkgs;};

  system = stdenv.system;

  gcc = import ../../build-support/gcc-wrapper {
    nativeTools = false;
    nativeLibc = true;
    inherit stdenv;
    binutils = 
      if stdenv.isDarwin then
        import ../../build-support/native-darwin-cctools-wrapper {inherit stdenv;}
      else
        pkgs.binutils;
    gcc = if stdenv.isDarwin then pkgs.gccApple.gcc else pkgs.gcc.gcc;
    coreutils = pkgs.coreutils;
    shell = pkgs.bash + "/bin/sh";
  };

  shell = pkgs.bash + "/bin/sh";

  fetchurlBoot = stdenv.fetchurlBoot;
}
