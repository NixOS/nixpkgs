# This file defines the structure of the `config` nixpkgs option.

{ lib, options, config, ... }:

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

  optionsDef = {

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

    /* System options */

    platform = mkOption {
      type = types.uniq types.unspecified;
      description = "Local platform override";
    };

    localSystem = mkOption {
      type = types.attrs;
      # Allow setting the platform in the config file. This take precedence over
      # the inferred platform, but not over an explicitly passed-in one.
      apply = x: lib.systems.elaborate
        (x // lib.optionalAttrs options.platform.isDefined config.platform);
      description = "Local system";
    };

    # FIXME! NOTE: Not all functions are congruent in Nix, @oxij really hopes this is just a bug
    # > $ nix-instantiate --eval -E 'with import ./lib; let f = systems.elaborate; x = { system = "x86_64-linux"; }; in f x == f x'
    # > false
    # This means that we have to hack around this bug to assign (!) `crossSystem` to `config.localSystem` by default
    # else `crossSystem != localSystem` check in ../stdenv/default.nix will always be `true`,
    # which would in turn cause stdenv to try to cross compile to our own platform, stdenv was not made for that.
    # Hence we have to use the `apply` implementation below.
    crossSystem = mkOption {
      type = types.nullOr types.attrs;
      apply = x: if x == null then config.localSystem else lib.systems.elaborate x;
      description = "Cross system";
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

    /* callPackage scope */

    extraScope = mkOption {
      type = types.attrs;
      default = {};
      example = literalExample ''
        {
          openssl = libressl;
          libpulseaudio = libcardiacarrest;
        }
      '';
      description = ''
        Extra scope to supply to all <literal>callPackages</literal> calls.

        This mechanism is a cheap and simple alternative to overlays for when
        you don't want to touch the global scope of <literal>pkgs</literal> but
        you want to override scopes of all packages produced by
        <literal>callPackage</literal>.

        For instance:
        <itemizedlist>
          <listitem><para>
            you want to make all packages to depend on <literal>libressl</literal>
            instead of <literal>openssl</literal>, but you want to keep the
            vanilla <literal>openssl</literal> available as
            <literal>pkgs.openssl</literal>;
          </para></listitem>
          <listitem><para>
            you want to set the default value for some option like
            <literal>x11Support</literal> for all packages all at
            once.
          </para></listitem>
        </itemizedlist>

        Changing this to a non-default value will void your warranty! That is,
        at the very least, you will not be able to benefit from Hydra binary
        cache. It is also entirely possible (likely, even) that your system will
        not even build.
      '';
    };

  };

in {

  options = optionsDef;

}
