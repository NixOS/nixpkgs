# Source: https://git.helsinki.tools/helsinki-systems/wp4nix/-/blob/master/default.nix
# Licensed under: MIT
# Slightly modified

{ lib, pkgs, newScope, apps }:

let packages = self:
  let
    generatedJson = {
      inherit apps;
    };

  in {
    # Create a derivation from the official Nextcloud apps.
    # This takes the data generated from the go tool.
    mkNextcloudDerivation = self.callPackage ({ }: { data }:
      pkgs.fetchNextcloudApp {
        inherit (data) url sha256;
      }) {};

  } // lib.mapAttrs (type: pkgs: lib.makeExtensible (_: lib.mapAttrs (pname: data: self.mkNextcloudDerivation { inherit data; }) pkgs)) generatedJson;

in (lib.makeExtensible (_: (lib.makeScope newScope packages))).extend (selfNC: superNC: {})
