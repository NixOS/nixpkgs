{ inputs, ... }@flakeContext:
let
  config.netboot = {
    squashfsCompression = "gzip -Xcompression-level 1";
  };
  netboot = import ./xnode-common.nix;
in
inputs.nixos-generators.nixosGenerate {
  system = "x86_64-linux";
  customFormats = { "netboot" = import ./custom-formats/netboot.nix; };
  format = "netboot";
  modules = [
    netboot
  ];
}
