{stdenv, pkgs, genericStdenv, gccWrapper}:

genericStdenv {
  name = "stdenv-nix";
  preHook = ./prehook.sh;
  initialPath = (import ./path.nix) {pkgs = pkgs;};

  inherit stdenv;

  gcc = gccWrapper {
    name = pkgs.gcc.name;
    nativeTools = false;
    nativeGlibc = true;
    inherit (pkgs) gcc binutils;
    inherit stdenv;
    shell = pkgs.bash ~ /bin/sh;
  };

  shell = pkgs.bash ~ /bin/sh;
}
