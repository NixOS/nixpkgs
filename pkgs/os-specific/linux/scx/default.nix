{
  lib,
  callPackage,
}:

lib.mapAttrs (name: scheduler: callPackage scheduler { }) {
  cscheds = import ./scx_cscheds.nix;
  rustscheds = import ./scx_rustscheds.nix;
  full = import ./scx_full.nix;
}
