{ inputs, ... }@flakeContext:
let
  kexec = import ./xnode-common.nix;
in
inputs.nixos-generators.nixosGenerate {
  system = "x86_64-linux";
  customFormats = { "kexec-nixos" = import ./custom-formats/kexec.nix; };
  format = "kexec-nixos";
  modules = [
    kexec
  ];
}
