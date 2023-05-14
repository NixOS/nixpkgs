/*
  A [module] for invoking Nixpkgs.

  This module is a public interface for use in third party module system
  applications, so that they can re-expose the Nixpkgs configuration logic to
  their users.

  It declares its options without a prefix like `nixpkgs.*`, so it is meant to
  be imported in a submodule.

  This module is based on the NixOS `misc/nixpkgs.nix` module, but it gets rid
  of legacy options. It may be used to replace that module after legacy options
  have been deprecated and removed.

  As this module declares an option named `config`, you're recommended to pass
  `shorthandOnlyDefinesConfig = true` to `types.submoduleWith`.

  module: https://nixos.org/manual/nixpkgs/unstable/#module-system
*/
{ lib, config, options, ... }:

let
  inherit (lib) mkOption types literalExpression;

  optDefaultPrio = (lib.mkOptionDefault null).priority;

  isCross = config.buildPlatform != config.hostPlatform;
  systemArgs =
    if isCross
    then {
      localSystem = config.buildPlatform;
      crossSystem = config.hostPlatform;
    }
    else {
      localSystem = config.hostPlatform;
    };

  pkgs =
      import ../default.nix ({
        inherit (config) config overlays;
      } // systemArgs);

  # TODO: write a better type that checks that the definition ordering is
  #       unambiguous under import order.
  overlayType = types.functionTo (types.functionTo types.raw);

in
{
  options = {
    hostPlatform = mkOption {
      type = types.coercedTo types.str lib.systems.elaborate types.attrs;
      description = lib.mdDoc ''
        Specifies the platform where the package will run.

        To cross-compile, also set the `buildPlatform` option.

        Ignored when the `pkgs` option is overridden.
      '';
    };
    buildPlatform = mkOption {
      type = types.coercedTo types.str lib.systems.elaborate types.attrs;
      description = lib.mdDoc ''
        Specifies the platform where the package will be built. This is
        optional; by default Nixpkgs will perform native compilation.

        Setting this option will cause NixOS to be cross-compiled.

        Ignored when the `pkgs` option is overridden.
      '';
      defaultText = literalExpression ''hostPlatform'';
      default = config.hostPlatform;
    };
    overlays = mkOption {
      default = [ ];
      example = literalExpression
        ''
          [
            (self: super: {
              openssh = super.openssh.override {
                hpnSupport = true;
                kerberos = self.libkrb5;
              };
            })
          ]
        '';
      type = types.listOf overlayType;
      description = lib.mdDoc ''
        List of overlays to use with Nixpkgs.
        (For details, see the Nixpkgs documentation.)  It allows
        you to override packages globally. Each function in the list
        takes as an argument the *original* Nixpkgs.
        The first argument should be used for finding dependencies, and
        the second should be used for overriding recipes.

        Ignored when `pkgs` option is overridden.
      '';
    };
    config = mkOption {
      default = { };
      example = literalExpression
        ''
          { allowBroken = true; allowUnfree = true; }
        '';
      # FIXME: use a mergeable type, like NixOS but not a hack
      type = types.unique { message = "nixpkgs/pkgs/top-level/module.nix: Merging is not supported for the Nixpkgs config option yet."; } types.attrs;
      description = lib.mdDoc ''
        The configuration of the Nix Packages collection.  (For
        details, see the Nixpkgs documentation.)  It allows you to set
        package configuration options.

        Ignored when the `pkgs` option is overridden.
      '';
    };
    pkgs = mkOption {
      type = types.pkgs;
      description = lib.mdDoc ''
        This option's value is initialized by its siblings `hostPlatform`, `overlays`, `config`, etc.

        It contains the Nixpkgs package set. [The package search on search.nixos.org](https://search.nixos.org/packages) lists virtually all packages in this set, although `overlays` can change and add packages.

        You could override the value if you have specific instantiation of Nixpkgs
        that you would like to use, but note that this will cause those sibling options
        to be ignored.
      '';
    };
  };
  config = {
    inherit pkgs;
  };
}
