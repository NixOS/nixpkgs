{ stdenv, coreutils, nix, findutils}:

derivation {
  name = "kernelscripts";
  system = stdenv.system;
  builder = ./builder.sh;
  createModules = ./create-modules.sh;
  inherit stdenv coreutils nix findutils;
  kernelpkgs = ./kernel.nix;
}
