# Source: https://git.helsinki.tools/helsinki-systems/wp4nix/-/blob/master/default.nix
# Licensed under: MIT
# Slightly modified

{
  lib,
  pkgs,
  newScope,
  apps,
  callPackage,
}:

let
  packages =
    self:
    let
      generatedJson = {
        inherit apps;
      };
      appBaseDefs = builtins.fromJSON (builtins.readFile ./nextcloud-apps.json);

    in
    {
      # Create a derivation from the official Nextcloud apps.
      # This takes the data generated from the go tool.
      mkNextcloudDerivation = self.callPackage (
        { }:
        { pname, data }:
        pkgs.fetchNextcloudApp {
          appName = pname;
          appVersion = data.version;
          license = appBaseDefs.${pname};
          inherit (data)
            url
            hash
            description
            homepage
            ;
        }
      ) { };

    }
    // lib.mapAttrs (
      type: pkgs:
      lib.makeExtensible (
        _:
        lib.mapAttrs (
          pname: data:
          self.mkNextcloudDerivation {
            inherit pname data;
          }
        ) pkgs
      )
    ) generatedJson;

in
(lib.makeExtensible (_: (lib.makeScope newScope packages))).extend (
  import ./thirdparty.nix
)
