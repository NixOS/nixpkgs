# TODO check that no license information gets lost
{ callPackage, config, lib, vimUtils, vim, darwin, llvmPackages }:

let

  inherit (vimUtils.override {inherit vim;}) buildVimPluginFrom2Nix;

  inherit (lib) extends;

  initialPackages = self: {};

  plugins = callPackage ./generated.nix {
    inherit buildVimPluginFrom2Nix;
  };

  # TL;DR
  # * Add your plugin to ./vim-plugin-names
  # * run ./update.py
  #
  # If additional modifications to the build process are required,
  # add to ./overrides.nix.
  overrides = callPackage ./overrides.nix {
    inherit (darwin.apple_sdk.frameworks) Cocoa CoreFoundation CoreServices;
    inherit buildVimPluginFrom2Nix;
    inherit llvmPackages;
  };

  aliases = if (config.allowAliases or true) then (import ./aliases.nix lib) else final: prev: {};

  extensible-self = lib.makeExtensible
    (extends aliases
      (extends overrides
        (extends plugins initialPackages)
      )
    );
in
  extensible-self
