# TODO check that no license information gets lost
{ callPackage, config, lib, vimUtils, vim, darwin, llvmPackages, pkgs, stdenv }:

let

  inherit (vimUtils.override {inherit vim;}) buildVimPluginFrom2Nix;

  nodePackages = callPackage ./composition.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
    nodejs = pkgs.nodejs-10_x;
  };

  plugins = callPackage ./generated.nix {
    inherit buildVimPluginFrom2Nix overrides;
  };

  # TL;DR
  # * Add your plugin to ./vim-plugin-names
  # * run ./update.py
  #
  # If additional modifications to the build process are required,
  # add to ./overrides.nix.
  overrides = callPackage ./overrides.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa CoreFoundation CoreServices;
    inherit buildVimPluginFrom2Nix llvmPackages nodePackages;

  };

  aliases = lib.optionalAttrs (config.allowAliases or true) (import ./aliases.nix lib plugins);

in

plugins // aliases
