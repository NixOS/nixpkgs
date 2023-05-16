# Source: https://git.helsinki.tools/helsinki-systems/wp4nix/-/blob/master/default.nix
# Licensed under: MIT
# Slightly modified

{ lib, pkgs, newScope, apps }:

let packages = self:
  let
    generatedJson = {
      inherit apps;
    };
<<<<<<< HEAD
    appBaseDefs = builtins.fromJSON (builtins.readFile ./nextcloud-apps.json);
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  in {
    # Create a derivation from the official Nextcloud apps.
    # This takes the data generated from the go tool.
<<<<<<< HEAD
    mkNextcloudDerivation = self.callPackage ({ }: { pname, data }:
      pkgs.fetchNextcloudApp {
        appName = pname;
        appVersion = data.version;
        license = appBaseDefs.${pname};
        inherit (data) url sha256 description homepage;
      }) {};

  } // lib.mapAttrs (type: pkgs:
    lib.makeExtensible (_: lib.mapAttrs (pname: data: self.mkNextcloudDerivation { inherit pname; inherit data; }) pkgs))
    generatedJson;
=======
    mkNextcloudDerivation = self.callPackage ({ }: { data }:
      pkgs.fetchNextcloudApp {
        inherit (data) url sha256;
      }) {};

  } // lib.mapAttrs (type: pkgs: lib.makeExtensible (_: lib.mapAttrs (pname: data: self.mkNextcloudDerivation { inherit data; }) pkgs)) generatedJson;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

in (lib.makeExtensible (_: (lib.makeScope newScope packages))).extend (selfNC: superNC: {})
