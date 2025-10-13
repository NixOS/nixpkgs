# This file defines the structure of the `config` nixpkgs option.

# This file is tested in `pkgs/test/config.nix`.
# Run tests with:
#
#     nix-build -A tests.config
#

{ config, lib, ... }:

let
  inherit (lib)
    literalExpression
    mapAttrsToList
    mkOption
    optionals
    types
    ;

  mkMassRebuild =
    args:
    mkOption (
      builtins.removeAttrs args [ "feature" ]
      // {
        type = args.type or (types.uniq types.bool);
        default = args.default or false;
        description = (
          (args.description or ''
            Whether to ${args.feature} while building nixpkgs packages.
          ''
          )
          + ''
            Changing the default may cause a mass rebuild.
          ''
        );
      }
    );

  options = {

    # Internal stuff

    # Hide built-in module system options from docs.
    _module.args = mkOption {
      internal = true;
    };

    warnings = mkOption {
      type = types.listOf types.str;
      default = [ ];
      internal = true;
    };

    # Config options

    warnUndeclaredOptions = mkOption {
      description = "Whether to warn when `config` contains an unrecognized attribute.";
      type = types.bool;
      default = false;
    };

    fetchedSourceNameDefault = mkOption {
      type = types.uniq (
        types.enum [
          "source"
          "versioned"
          "full"
        ]
      );
      default = "source";
      description = ''
        This controls the default derivation `name` attribute set by the
        `fetch*` (`fetchzip`, `fetchFromGitHub`, etc) functions.

        Possible values and the resulting `.name`:

        - `"source"` -> `"source"`
        - `"versioned"` -> `"''${repo}-''${rev}-source"`
        - `"full"` -> `"''${repo}-''${rev}-''${fetcherName}-source"`

        The default `"source"` is the best choice for minimal rebuilds, it
        will ignore any non-hash changes (like branches being renamed, source
        URLs changing, etc) at the cost of `/nix/store` being easily
        cache-poisoned (see [NixOS/nix#969](https://github.com/NixOS/nix/issues/969)).

        Setting this to `"versioned"` greatly helps with discoverability of
        sources in `/nix/store` and makes cache-poisoning of `/nix/store` much
        harder, at the cost of a single mass-rebuild for all `src`
        derivations, and an occasional rebuild when a source changes some of
        its non-hash attributes.

        Setting this to `"full"` is similar to setting it to `"versioned"`,
        but the use of `fetcherName` in the derivation name will force a
        rebuild when `src` switches between `fetch*` functions, thus forcing
        `nix` to check new derivation's `outputHash`, which is useful for
        debugging.

        Also, `"full"` is useful for easy collection and tracking of
        statistics of where the packages you use are hosted.

        If you are a developer, you should probably set this to at
        least`"versioned"`.

        Changing the default will cause a mass rebuild.
      '';
    };

    gitConfig = mkOption {
      type = types.attrsOf (types.attrsOf types.anything);
      description = ''
        The default [git configuration](https://git-scm.com/docs/git-config#_variables) for all [`pkgs.fetchgit`](#fetchgit) calls.

        Among many other potential uses, this can be used to override URLs to point to local mirrors.

        Changing this will not cause any rebuilds because `pkgs.fetchgit` produces a [fixed-output derivation](https://nix.dev/manual/nix/stable/glossary.html?highlight=fixed-output%20derivation#gloss-fixed-output-derivation).

        To set the configuration file directly, use the [`gitConfigFile`](#opt-gitConfigFile) option instead.

        To set the configuration file for individual calls, use `fetchgit { gitConfigFile = "..."; }`.
      '';
      default = { };
      example = {
        url."https://my-github-mirror.local".insteadOf = [ "https://github.com" ];
      };
    };

    # A rendered version of gitConfig that can be reused by all pkgs.fetchgit calls
    gitConfigFile = mkOption {
      type = types.nullOr types.path;
      description = ''
        A path to a [git configuration](https://git-scm.com/docs/git-config#_variables) file, to be used for all [`pkgs.fetchgit`](#fetchgit) calls.

        This overrides the [`gitConfig`](#opt-gitConfig) option, see its documentation for more details.
      '';
      default =
        if config.gitConfig != { } then
          builtins.toFile "gitconfig" (lib.generators.toGitINI config.gitConfig)
        else
          null;
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
      description = ''
        Whether to expose old attribute names for compatibility.

        The recommended setting is to enable this, as it
        improves backward compatibility, easing updates.

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
      description = ''
        Whether to allow unfree packages.

        See [Installing unfree packages](https://nixos.org/manual/nixpkgs/stable/#sec-allow-unfree) in the NixOS manual.
      '';
    };

    allowBroken = mkOption {
      type = types.bool;
      default = false;
      # getEnv part is in check-meta.nix
      defaultText = literalExpression ''false || builtins.getEnv "NIXPKGS_ALLOW_BROKEN" == "1"'';
      description = ''
        Whether to allow broken packages.

        See [Installing broken packages](https://nixos.org/manual/nixpkgs/stable/#sec-allow-broken) in the NixOS manual.
      '';
    };

    allowUnsupportedSystem = mkOption {
      type = types.bool;
      default = false;
      # getEnv part is in check-meta.nix
      defaultText = literalExpression ''false || builtins.getEnv "NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM" == "1"'';
      description = ''
        Whether to allow unsupported packages.

        See [Installing packages on unsupported systems](https://nixos.org/manual/nixpkgs/stable/#sec-allow-unsupported-system) in the NixOS manual.
      '';
    };

    allowVariants = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to expose the nixpkgs variants.

        Variants are instances of the current nixpkgs instance with different stdenvs or other applied options.
        This allows for using different toolchains, libcs, or global build changes across nixpkgs.
        Disabling can ensure nixpkgs is only building for the platform which you specified.
      '';
    };

    cudaSupport = mkMassRebuild {
      feature = "build packages with CUDA support by default";
    };

    replaceBootstrapFiles = mkMassRebuild {
      type = types.functionTo (types.attrsOf types.package);
      default = lib.id;
      defaultText = literalExpression "lib.id";
      description = ''
        Use the bootstrap files returned instead of the default bootstrap
        files.
        The default bootstrap files are passed as an argument.
      '';
      example = literalExpression ''
        prevFiles:
        let
          replacements = {
            "sha256-YQlr088HPoVWBU2jpPhpIMyOyoEDZYDw1y60SGGbUM0=" = import <nix/fetchurl.nix> {
              url = "(custom glibc linux x86_64 bootstrap-tools.tar.xz)";
              hash = "(...)";
            };
            "sha256-QrTEnQTBM1Y/qV9odq8irZkQSD9uOMbs2Q5NgCvKCNQ=" = import <nix/fetchurl.nix> {
              url = "(custom glibc linux x86_64 busybox)";
              hash = "(...)";
              executable = true;
            };
          };
        in
        builtins.mapAttrs (name: prev: replacements.''${prev.outputHash} or prev) prevFiles
      '';
    };

    rocmSupport = mkMassRebuild {
      feature = "build packages with ROCm support by default";
    };

    showDerivationWarnings = mkOption {
      type = types.listOf (types.enum [ "maintainerless" ]);
      default = [ ];
      description = ''
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

    rewriteURL = mkOption {
      type = types.functionTo (types.nullOr types.str);
      description = ''
        A hook to rewrite/filter URLs before they are fetched.

        The function is passed the URL as a string, and is expected to return a new URL, or null if the given URL should not be attempted.

        This function is applied _prior_ to resolving mirror:// URLs.

        The intended use is to allow URL rewriting to insert company-internal mirrors, or work around company firewalls and similar network restrictions.
      '';
      default = lib.id;
      defaultText = literalExpression "(url: url)";
      example = literalExpression ''
        {
          # Use Nix like it's 2024! ;-)
          rewriteURL = url: "https://web.archive.org/web/2024/''${url}";
        }
      '';
    };

    microsoftVisualStudioLicenseAccepted = mkOption {
      type = types.bool;
      default = false;
      # getEnv part is in check-meta.nix
      defaultText = literalExpression ''false || builtins.getEnv "NIXPKGS_ALLOW_UNFREE" == "1"'';
      description = ''
        If the Microsoft Visual Studio license has been accepted.

        Please read https://www.visualstudio.com/license-terms/mt644918/ and enable this config if you accept.
      '';
    };
  };

in
{

  freeformType =
    let
      t = types.lazyAttrsOf types.raw;
    in
    t
    // {
      merge =
        loc: defs:
        let
          r = t.merge loc defs;
        in
        r // { _undeclared = r; };
    };

  inherit options;

  config = {
    warnings = optionals config.warnUndeclaredOptions (
      mapAttrsToList (k: v: "undeclared Nixpkgs option set: config.${k}") config._undeclared or { }
    );
  };

}
