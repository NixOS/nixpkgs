{stdenv, pkgs}:

import ../generic {
  name = "stdenv-nix";
  preHook = ./prehook.sh;
  initialPath = (import ../common-path.nix) {pkgs = pkgs;};

  inherit stdenv;

  gcc = import ../../build-support/gcc-wrapper {
    nativeTools = false;
    nativeGlibc = true;
    inherit stdenv;
    binutils = 
      if stdenv.isDarwin then
        import ../../build-support/native-darwin-cctools-wrapper {inherit stdenv;}
      else
        pkgs.binutils;
    gcc = if stdenv.isDarwin then pkgs.gccApple.gcc else pkgs.gcc.gcc;
    shell = pkgs.bash ~ /bin/sh;
  };

  shell = pkgs.bash ~ /bin/sh;

  extraAttrs = {
    # Curl should be in /usr/bin or so.
    curl = null;
  };
}
