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

    path = mkOption {
      type = types.path;
      default = ../..;
      defaultText = lib.literalDocBook "a path expression";
      internal = true;
      description = ''
        A reference to Nixpkgs' own sources.

        This is overridable in order to avoid copying sources unnecessarily,
        as a path expression that references a store path will not short-circuit
        to the store path itself, but copy the store path instead.
      '';
    };

  };

in {

  inherit options;

}
