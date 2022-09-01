# This file defines the structure of the `config` nixpkgs option.

{ config, lib, ... }:

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
      description = "Whether to warn when <literal>config</literal> contains an unrecognized attribute.";
      default = false;
    };

    doCheckByDefault = mkMassRebuild {
      feature = "run <literal>checkPhase</literal> by default";
    };

    strictDepsByDefault = mkMassRebuild {
      feature = "set <literal>strictDeps</literal> to true by default";
    };

    enableParallelBuildingByDefault = mkMassRebuild {
      feature = "set <literal>enableParallelBuilding</literal> to true by default";
    };

    configurePlatformsByDefault = mkMassRebuild {
      feature = "set <literal>configurePlatforms</literal> to <literal>[\"build\" \"host\"]</literal> by default";
    };

    contentAddressedByDefault = mkMassRebuild {
      feature = "set <literal>__contentAddressed</literal> to true by default";
    };

    allowAliases = mkOption {
      type = types.bool;
      default = true;
      description = ''
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

    allowInsecurePackages = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to allow packages with known security issues and vurnabilties.
      '';
    };

    allowUnfree = mkOption {
      type = types.bool;
      default = false;
      # getEnv part is in check-meta.nix
      defaultText = literalExpression ''false || builtins.getEnv "NIXPKGS_ALLOW_UNFREE" == "1"'';
      description = ''
        Whether to allow unfree packages.

        See <link xlink:href="https://nixos.org/manual/nixpkgs/stable/#sec-allow-unfree">Installing unfree packages</link> in the NixOS manual.
      '';
    };

    allowBroken = mkOption {
      type = types.bool;
      default = false;
      # getEnv part is in check-meta.nix
      defaultText = literalExpression ''false || builtins.getEnv "NIXPKGS_ALLOW_BROKEN" == "1"'';
      description = ''
        Whether to allow broken packages.

        See <link xlink:href="https://nixos.org/manual/nixpkgs/stable/#sec-allow-broken">Installing broken packages</link> in the NixOS manual.
      '';
    };

    allowUnsupportedSystem = mkOption {
      type = types.bool;
      default = false;
      # getEnv part is in check-meta.nix
      defaultText = literalExpression ''false || builtins.getEnv "NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM" == "1"'';
      description = ''
        Whether to allow unsupported packages.

        See <link xlink:href="https://nixos.org/manual/nixpkgs/stable/#sec-allow-unsupported-system">Installing packages on unsupported systems</link> in the NixOS manual.
      '';
    };

    showDerivationWarnings = mkOption {
      type = types.listOf (types.enum [ "maintainerless" ]);
      default = [];
      description = ''
        Which warnings to display for potentially dangerous
        or deprecated values passed into `stdenv.mkDerivation`.

        A list of warnings can be found in
        <link xlink:href="https://github.com/NixOS/nixpkgs/blob/master/pkgs/stdenv/generic/check-meta.nix">/pkgs/stdenv/generic/check-meta.nix</link>.

        This is not a stable interface; warnings may be added, changed
        or removed without prior notice.
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
