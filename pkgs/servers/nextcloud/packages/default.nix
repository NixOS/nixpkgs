# Source: https://git.helsinki.tools/helsinki-systems/wp4nix/-/blob/master/default.nix
# Licensed under: MIT
# Slightly modified

{
  lib,
  pkgs,
  newScope,
  apps ? lib.importJSON (./. + "/${ncVersion}.json"), # Support out-of-tree overrides
  callPackage,
  ncVersion,
  nextcloud-notify_push,
}:

let
  packages =
    self:
    let
      generatedJson = {
        inherit apps;
      };
      licenseOverrides = builtins.fromJSON (builtins.readFile ./nextcloud-app-license-overrides.json);
      # Based on https://github.com/nextcloud/appstore/blob/894e050238abcf4ca5a0d5b037762564a4878b29/nextcloudappstore/api/v1/release/info.xsd#L374
      licenseMappings = {
        "AGPL-3.0-only" = lib.licenses.agpl3Only;
        "AGPL-3.0-or-later" = lib.licenses.agpl3Plus;
        "Apache-2.0" = lib.licenses.asl20;
        "GPL-3.0-only" = lib.licenses.gpl3Only;
        "GPL-3.0-or-later" = lib.licenses.gpl3Plus;
        "MIT" = lib.licenses.mit;
        "MPL-2.0" = lib.licenses.mpl20;

        # Deprecated non-SPDX identifiers
        "agpl" = lib.licenses.agpl3Only; # AGPL-3.0-only is a safe fallback for AGPL-3.0-or-later
        "mit" = lib.licenses.mit;
        "mpl" = lib.licenses.mpl20; # The only SPDX MPL version allowed is 2.0, so this means 2.0 as well
        "apache" = lib.licenses.asl20;
        "gpl3" = lib.licenses.gpl3Only; # GPL-3.0-only is a safe fallback for GPL-3.0-or-later
      };
    in
    {
      # Create a derivation from the official Nextcloud apps.
      # This takes the data generated from the go tool.
      mkNextcloudDerivation =
        { pname, data }:
        pkgs.fetchNextcloudApp {
          appName = pname;
          appVersion = data.version;
          license =
            if licenseOverrides ? pname then
              licenseOverrides.${pname}
            else
              (map (license: licenseMappings.${license}.shortName) data.licenses);
          teams = [ lib.teams.nextcloud ];
          inherit (data)
            url
            hash
            description
            homepage
            ;
        };

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
        // {
          notify_push = nextcloud-notify_push.app;
        }
      )
    ) generatedJson;

in
(lib.makeExtensible (_: (lib.makeScope newScope packages))).extend (
  import ./thirdparty.nix { inherit ncVersion; }
)
