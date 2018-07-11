{ configExpr, lib, pkgs }:

with lib;

let
  # Allow both:
  # { /* the config */ } and
  # { pkgs, ... } : { /* the config */ }
  config' = (if lib.isFunction configExpr
    then configExpr { inherit pkgs; }
    else configExpr);

  onlyLicenses = list:
    lib.lists.all (license:
      let l = lib.licenses.${license.shortName or "unknown"} or false; in
      if license == l then true else
        throw "${license.shortName or "unknown"} is not an attribute of lib.licenses"
    ) list;

  defaults = {
    allowUnfree = mkOption {
      default = (builtins.getEnv "NIXPKGS_ALLOW_UNFREE") == "1";
      type = types.bool;
      description = ''
        Allow unfree software to be evaluated.
      '';
    };

    # See discussion at
    # https://github.com/NixOS/nixpkgs/pull/25304#issuecomment-298385426
    # for why this defaults to false, but I (@copumpkin) want to
    # default it to true soon.
    checkMeta = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Should we check meta in derivations ahead of time.
      '';
    };

    whitelistedLicenses = mkOption {
      default = [];
      type = types.listOf types.attrs;
      description = ''
        List of licenses to allow to evaluate.
      '';
      apply = x:
        assert lib.mutuallyExclusive x (config'.blacklistedLicenses or []);
        assert onlyLicenses x; x;
    };

    blacklistedLicenses = mkOption {
      default = [];
      type = types.listOf types.attrs;
      description = ''
        List of license to prevent from evaluating.
      '';
      apply = x:
        assert lib.mutuallyExclusive x (config'.whitelistedLicenses or []);
        assert onlyLicenses x; x;
    };

    allowBroken = mkOption {
      default = (builtins.getEnv "NIXPKGS_ALLOW_BROKEN") == "1";
      type = types.bool;
      description = ''
        Should we allow broken packages to be evaluated.
      '';
    };

    allowUnsupportedSystem = mkOption {
      default = (builtins.getEnv "NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM") == "1";
      type = types.bool;
      description = ''
        Should we allow packages to evaluate on unsupported systems.
      '';
    };

    # Alow granular checks to allow only some unfree packages
    # Example:
    # {pkgs, ...}:
    # {
    #   allowUnfree = false;
    #   allowUnfreePredicate = (x: pkgs.lib.hasPrefix "flashplayer-" x.name);
    # }
    allowUnfreePredicate = mkOption {
      default = _: config.allowUnfree;
      # type = types.function;
      description = ''
        A function taking an unfree package that returns true if that
        package is okay to use.
      '';
    };

    allowInsecurePredicate = mkOption {
      default = x: elem x.name config.permittedInsecurePackages;
      # type = types.function;
      description = ''
        Function taking an insecure package that returns true if that
        package is okay to use.
      '';
    };

    permittedInsecurePackages = mkOption {
      default = [];
      type = types.listOf types.string;
      description = ''
        A list of insecure package names to allow to evaluate.
      '';
    };

    allowAliases = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to include aliases in Nixpkgs. These aliases are
        usually included for compatibility purposes. To prevent
        removed names from breaking user's configs, we provide aliases
        by default. However, their usage is still strongly discourages
        and may lead to evaluation issues for users with this set to
        false.
      '';
    };

    handleEvalIssue = mkOption {
      default = throw;
      # type = types.function;
      description = ''
        A function to run to handle an evaluation issue. The default
        is throw but set it to something else to ignore evaluation
        issues.
      '';
    };

    packageOverrides = mkOption {
      default = _: {};
      # type = types.function;
      description = ''
        A function returning an attribute set to override the
        top-level of Nixpkgs. The only argument is the previous
        package set before the override.
      '';
    };

    checkMetaRecursively = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to recursively check meta attributes.
      '';
    };

    doCheckByDefault = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to run tests by default in the default Nix builder.
      '';
    };
  };

  checkType = name: option: value:
    if hasAttr "type" option && isType option.type value then throw ''
      value, ${toString value}, for ${name} is not of correct type
      ${option.type.name}.
    '' else value;

  config = config' // (lib.mapAttrs (name: option:
    (checkType name option
      ((option.apply or id) (config'.${name} or option.default))))
    defaults);

in config
