{stdenv, pkgs}:

import ../generic {
  name = "stdenv-nix";
  
  preHook =
    ''
      export NIX_ENFORCE_PURITY=1
      export NIX_IGNORE_LD_THROUGH_GCC=1

      if [ "$system" = "i686-darwin" -o "$system" = "powerpc-darwin" -o "$system" = "x86_64-darwin" ]; then
        export NIX_DONT_SET_RPATH=1
        export NIX_NO_SELF_RPATH=1
        dontFixLibtool=1
        stripAllFlags=" " # the Darwin "strip" command doesn't know "-s" 
        xargsFlags=" "
      fi
    '';

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
