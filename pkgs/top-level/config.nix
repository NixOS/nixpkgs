# This file defines the structure of the `config` nixpkgs option.

{ config, lib, ... }:

with lib;

let

  mkMassRebuild = args: mkOption (builtins.removeAttrs args [ "feature" ] // {
    type = args.type or (types.uniq types.bool);
    default = args.default or false;
    description = lib.mdDoc ((args.description or ''
      Whether to ${args.feature} while building nixpkgs packages.
    '') + ''
      Changing the default may cause a mass rebuild.
    '');
  });

  options = {

    /* Internal stuff */

    # Hide built-in module system options from docs.
    _module.args = mkOption {
      internal = true;
    };

    warnings = mkOption {
      type = types.listOf types.str;
      default = [];
      internal = true;
    };

    /* Config options */

    warnUndeclaredOptions = mkOption {
      description = lib.mdDoc "Whether to warn when `config` contains an unrecognized attribute.";
      type = types.bool;
      default = false;
    };

    doCheckByDefault = mkMassRebuild {
      feature = "run `checkPhase` by default";
    };

    strictDepsByDefault = mkMassRebuild {
      feature = "set `strictDeps` to true by default";
    };

    structuredAttrsByDefault = mkMassRebuild {
      feature = "set `__structuredAttrs` to true by default";
    };

    enableParallelBuildingByDefault = mkMassRebuild {
      feature = "set `enableParallelBuilding` to true by default";
    };

    configurePlatformsByDefault = mkMassRebuild {
      feature = "set `configurePlatforms` to `[\"build\" \"host\"]` by default";
    };

    contentAddressedByDefault = mkMassRebuild {
      feature = "set `__contentAddressed` to true by default";
    };

    allowAliases = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Whether to expose old attribute names for compatibility.

        The recommended setting is to enable this, as it
        improves backward compatibity, easing updates.

        The only reason to disable aliases is for continuous
        integration purposes. For instance, Nixpkgs should
        not depend on aliases in its internal code. Projects
        that aren't Nixpkgs should be cautious of instantly
        removing all usages of aliases, as migrating too soon
        can break compatibility with the stable Nixpkgs releases.
      '';
    };

    allowUnfree = mkOption {
      type = types.bool;
      default = false;
      # getEnv part is in check-meta.nix
      defaultText = literalExpression ''false || builtins.getEnv "NIXPKGS_ALLOW_UNFREE" == "1"'';
      description = lib.mdDoc ''
        Whether to allow unfree packages.

        See [Installing unfree packages](https://nixos.org/manual/nixpkgs/stable/#sec-allow-unfree) in the NixOS manual.
      '';
    };

    allowBroken = mkOption {
      type = types.bool;
      default = false;
      # getEnv part is in check-meta.nix
      defaultText = literalExpression ''false || builtins.getEnv "NIXPKGS_ALLOW_BROKEN" == "1"'';
      description = lib.mdDoc ''
        Whether to allow broken packages.

        See [Installing broken packages](https://nixos.org/manual/nixpkgs/stable/#sec-allow-broken) in the NixOS manual.
      '';
    };

    allowUnsupportedSystem = mkOption {
      type = types.bool;
      default = false;
      # getEnv part is in check-meta.nix
      defaultText = literalExpression ''false || builtins.getEnv "NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM" == "1"'';
      description = lib.mdDoc ''
        Whether to allow unsupported packages.

        See [Installing packages on unsupported systems](https://nixos.org/manual/nixpkgs/stable/#sec-allow-unsupported-system) in the NixOS manual.
      '';
    };

    showDerivationWarnings = mkOption {
      type = types.listOf (types.enum [ "maintainerless" ]);
      default = [];
      description = lib.mdDoc ''
        Which warnings to display for potentially dangerous
        or deprecated values passed into `stdenv.mkDerivation`.

        A list of warnings can be found in
        [/pkgs/stdenv/generic/check-meta.nix](https://github.com/NixOS/nixpkgs/blob/master/pkgs/stdenv/generic/check-meta.nix).

        This is not a stable interface; warnings may be added, changed
        or removed without prior notice.
      '';
    };

    checkMeta = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to check that the `meta` attribute of derivations are correct during evaluation time.
      '';
    };
  };

in {

  freeformType =
    let t = lib.types.lazyAttrsOf lib.types.raw;
    in t // {
      merge = loc: defs:
        let r = t.merge loc defs;
        in r // { _undeclared = r; };
    };

  inherit options;

  config = {
    warnings = lib.optionals config.warnUndeclaredOptions (
      lib.mapAttrsToList (k: v: "undeclared Nixpkgs option set: config.${k}") config._undeclared or {}
    );
  };

}
