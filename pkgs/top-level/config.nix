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

  mkOverrides = args: mkMassRebuild ({
    type = types.functionTo (types.attrsOf (types.uniq types.unspecified));
    default = super: {};
  } // args);

  options = {

    /* Internal stuff */

    warnings = mkOption {
      type = types.listOf types.str;
      default = [];
      internal = true;
    };

    unknowns = mkOption {
      type = types.attrsOf (types.uniq types.unspecified);
      default = {};
      internal = true;
    };

    /* Config options */

    inHydra = mkMeta {
      internal = true;
      description = ''
        If we're in hydra, we can dispense with the more verbose error
        messages and make problems easier to spot.
      '';
    };

    allowBroken = mkMeta {
      default = builtins.getEnv "NIXPKGS_ALLOW_BROKEN" == "1";
      defaultText = ''builtins.getEnv "NIXPKGS_ALLOW_BROKEN" == "1"'';
      feature = "permit evaluation of broken packages";
    };

    allowUnsupportedSystem = mkMeta {
      default = builtins.getEnv "NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM" == "1";
      defaultText = ''builtins.getEnv "NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM" == "1"'';
      feature = "permit evaluation of packages not available for the current system";
    };

    allowUnfree = mkMeta {
      default = builtins.getEnv "NIXPKGS_ALLOW_UNFREE" == "1";
      defaultText = ''builtins.getEnv "NIXPKGS_ALLOW_UNFREE" == "1"'';
      feature = "permit evaluation of unfree packages";
    };

    permittedUnfreePackages = mkMeta {
      type = types.listOf types.str;
      default = [];
      description = "A list of permitted unfree packages.";
    };

    allowUnfreePredicate = mkMeta {
      type = types.unspecified;
      default = x: builtins.elem x.name config.permittedUnfreePackages;
      description = "A predicate permitting evaluation for some unfree packages.";
    };

    allowInsecure = mkMeta {
      default = builtins.getEnv "NIXPKGS_ALLOW_INSECURE" == "1";
      defaultText = ''builtins.getEnv "NIXPKGS_ALLOW_INSECURE" == "1"'';
      feature = "permit evaluation of packages marked as insecure";
    };

    permittedInsecurePackages = mkMeta {
      type = types.listOf types.str;
      default = [];
      description = "A list of permitted insecure packages.";
    };

    allowInsecurePredicate = mkMeta {
      type = types.unspecified;
      default = x: builtins.elem x.name config.permittedInsecurePackages;
      description = "A predicate for permitting evaluation for some insecure packages.";
    };

    whitelistedLicenses = mkMeta {
      type = types.listOf types.unspecified;
      default = [];
      description = "A list of whitelisted licenses.";
    };

    blacklistedLicenses = mkMeta {
      type = types.listOf types.unspecified;
      default = [];
      description = "A list of blacklisted licenses.";
    };

    /* Overlays */

    # It feels to me like if overlays really belong here.

    packageOverrides = mkOverrides {
      description = "Poor man's global overlay.";
    };

    haskellPackageOverrides = mkMassRebuild {
      type = types.uniq types.unspecified;
      default = self: super: {};
      description = "Haskell's overlay.";
    };

    perlPackageOverrides = mkOverrides {
      description = "Poor man's perl overlay.";
    };

    rPackageOverrides = mkOverrides {
      description = "Poor man's R overlay.";
    };

    # See discussion at https://github.com/NixOS/nixpkgs/pull/25304#issuecomment-298385426
    # for why this defaults to false, but I (@copumpkin) want to default it to true soon.
    checkMeta = mkMeta {
      feature = "check <literal>meta</literal> attributes of all the packages";
    };

    doCheckByDefault = mkMassRebuild {
      feature = "run <literal>checkPhase</literal> by default";
    };

  };

in {

  inherit options;

}
