{bootStdenv, pkgs}: (import ../generic) {
  name = "stdenv-nix";
  system = bootStdenv.system;
  prehook = ./prehook.sh;
  posthook = ./posthook.sh;
  initialPath = (import ./path.nix) {pkgs = pkgs;};
  param1 = pkgs.bash;
  param2 = pkgs.gcc;
  param3 = pkgs.binutils;
  param4 = "";
  param5 = "";
  noSysDirs = false;
}
