{bootStdenv, pkgs, glibc}: (import ../generic) {
  name = "stdenv-nix-linux";
  system = bootStdenv.system;
  prehook = ./prehook.sh;
  posthook = ./posthook.sh;
  initialPath = (import ../nix/path.nix) {pkgs = pkgs;};
  param1 = pkgs.bash;
  param2 = pkgs.gcc;
  param3 = pkgs.binutils;
  param4 = glibc;
  param5 = "";
  noSysDirs = true;
}
