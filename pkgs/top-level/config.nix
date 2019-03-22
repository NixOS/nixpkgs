# This file defines the structure of the `config` nixpkgs option.

{ lib, config, ... }:

with lib;

let

  mkMeta = args: mkOption (builtins.removeAttrs args [ "feature" ] // {
    type = args.type or (types.uniq types.bool);
    default = args.default or false;
    description = args.description or ''
      Whether to ${args.feature} while evaluating nixpkgs.
    '' + ''
      Changing the default will not cause any rebuilds.
    '';
  });

  mkMassRebuild = args: mkOption (builtins.removeAttrs args [ "feature" ] // {
    type = args.type or (types.uniq types.bool);
    default = args.default or false;
    description = (args.description or ''
      Whether to ${args.feature} while building nixpkgs packages.
    '') + ''
      Changing the default may cause a mass rebuild.
    '';
  });

  options = {

    /* Internal stuff */

    warnings = mkOption {
      type = types.listOf types.str;
      default = [];
      internal = true;
    };

    /* Config options */

    doCheckByDefault = mkMassRebuild {
      feature = "run <literal>checkPhase</literal> by default";
    };

  };

in {

  inherit options;

}
