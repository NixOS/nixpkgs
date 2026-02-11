{
  lib,
  callPackage,
}:

lib.mapAttrs (name: scheduler: callPackage scheduler { }) {
  cscheds = import ./scx_cscheds.nix;
  full = import ./scx_full.nix;
  loader = import ./scx_loader.nix;
  rustscheds = import ./scx_rustscheds.nix;
}
