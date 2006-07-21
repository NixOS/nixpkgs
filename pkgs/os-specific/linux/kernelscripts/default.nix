{ stdenv, coreutils, nix, findutils, module_init_tools }:

derivation {
  name = "kernelscripts";
  system = stdenv.system;
  builder = ./builder.sh;
  createModules = ./create-modules.sh;
  inherit stdenv coreutils nix findutils module_init_tools;
  kernelpkgs = ./kernel.nix;
}
