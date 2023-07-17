{ pkgs ? import ../../../.. { }
}:
let
  lib = pkgs.lib;
  n = lib.mapAttrsToList (_: v: v.version) (
      lib.filterAttrs (k: v: builtins.match "nextcloud[0-9]+" k != null && (builtins.tryEval v.version).success)
    pkgs);

in

with pkgs;
mkShell {
  packages = [
    jq
    nc4nix
    gnused
  ];

  NEXTCLOUD_VERSIONS = lib.concatStringsSep "," n;
  SCRIPT_FOLDER=./.;
}
