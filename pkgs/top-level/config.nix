# This file defines the structure of the `config` nixpkgs option.
{ lib, ... }:

with lib;

let
  mkMassRebuild = args: mkOption (builtins.removeAttrs args [ "feature" ] // {
    type = args.type or (types.uniq types.bool);
    default = args.default or false;
    description = (args.description or ''
      Whether to ${args.feature} while building nixpkgs packages.
    '') + ''
      Changing the default may cause a mass rebuild.
    '';
  });

  supportedTime = import ../../lib/maxtime.nix;
in

{
  options = {
    warnings = mkOption {
      type = types.listOf types.str;
      default = [];
      internal = true;
    };

    doCheckByDefault = mkMassRebuild {
      feature = "run <literal>checkPhase</literal> by default";
    };
  };

  config = {
    warnings = [
      (mkIf (builtins ? currentTime && builtins.currentTime > supportedTime) ''

        This version of Nixpkgs is no longer supported, please upgrade.

        Backporting of security fixes ended ${toString ((builtins.currentTime - supportedTime) / 86400)} days ago, this means all packages
        should be considered as potentially vulnerable and insecure. Even if they
        are not marked explicitly with knownVulnerabilities.
        '')
    ];
  };
}
