# TODO check that no license information gets lost
{ callPackage, config, lib, stdenv, vimUtils, vim, darwin, llvmPackages }:

let

  inherit (vimUtils.override {inherit vim;}) buildVimPluginFrom2Nix;

  generated = callPackage ./generated.nix {
    inherit buildVimPluginFrom2Nix;
  };

  # TL;DR
  # * Add your plugin to ./vim-plugin-names
  # * sort -udf ./vim-plugin-names > sorted && mv sorted vim-plugin-names
  # * run ./update.py
  #
  # If additional modifications to the build process are required,
  # add to ./overrides.nix.
  overrides = callPackage ./overrides.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa CoreFoundation CoreServices;
    inherit buildVimPluginFrom2Nix;
  };

  overriden = generated // (overrides generated);

  aliases = lib.optionalAttrs (config.allowAliases or true) (import ./aliases.nix lib overriden);

in

overriden // aliases
