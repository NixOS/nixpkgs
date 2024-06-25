{ inputs, ... }@flakeContext:
let
  isoModule = import ./xnode-common.nix;
in
inputs.nixos-generators.nixosGenerate {
  system = "x86_64-linux";
  format = "iso";
  modules = [
    isoModule
  ];
}
