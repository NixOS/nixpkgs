/*
This file returns a mocked version of Nixpkgs' default.nix for testing purposes.
It does not depend on Nixpkgs itself for the sake of simplicity.

It takes one attribute as an argument:
- `root`: The root of Nixpkgs to read other files from, including:
  - `./pkgs/by-name`: The `pkgs/by-name` directory to test
  - `./all-packages.nix`: A file containing an overlay to mirror the real `pkgs/top-level/all-packages.nix`.
    This allows adding overrides on top of the auto-called packages in `pkgs/by-name`.

It returns a Nixpkgs-like function that can be auto-called and evaluates to an attribute set.
*/
{
  root,
}:
# The arguments for the Nixpkgs function
{
  # Passed by the checker to modify `callPackage`
  overlays ? [],
  # Passed by the checker to make sure a real Nixpkgs isn't influenced by impurities
  config ? {},
  # Passed by the checker to make sure a real Nixpkgs isn't influenced by impurities
  system ? null,
}:
let

  # Simplified versions of lib functions
  lib = import <test-nixpkgs/lib>;

  # The base fixed-point function to populate the resulting attribute set
  pkgsFun = self: {
    inherit lib;
    newScope = extra: lib.callPackageWith (self // extra);
    callPackage = self.newScope { };
    callPackages = lib.callPackagesWith self;
    someDrv = { type = "derivation"; };
  };

  baseDirectory = root + "/pkgs/by-name";

  # Generates { <name> = <file>; } entries mapping package names to their `package.nix` files in `pkgs/by-name`.
  # Could be more efficient, but this is only for testing.
  autoCalledPackageFiles =
    let
      entries = builtins.readDir baseDirectory;

      namesForShard = shard:
        if entries.${shard} != "directory" then
          # Only README.md is allowed to be a file, but it's not this code's job to check for that
          { }
        else
          builtins.mapAttrs
            (name: _: baseDirectory + "/${shard}/${name}/package.nix")
            (builtins.readDir (baseDirectory + "/${shard}"));

    in
    builtins.foldl'
      (acc: el: acc // el)
      { }
      (map namesForShard (builtins.attrNames entries));

  # Turns autoCalledPackageFiles into an overlay that `callPackage`'s all of them
  autoCalledPackages = self: super:
    {
      # Needed to be able to detect empty arguments in all-packages.nix
      # See a more detailed description in pkgs/top-level/by-name-overlay.nix
      _internalCallByNamePackageFile = file: self.callPackage file { };
    }
    // builtins.mapAttrs
      (name: self._internalCallByNamePackageFile)
      autoCalledPackageFiles;

  # A list optionally containing the `all-packages.nix` file from the test case as an overlay
  optionalAllPackagesOverlay =
    if builtins.pathExists (root + "/all-packages.nix") then
      [ (import (root + "/all-packages.nix")) ]
    else
      [ ];

  # A list optionally containing the `aliases.nix` file from the test case as an overlay
  # But only if config.allowAliases is not false
  optionalAliasesOverlay =
    if (config.allowAliases or true) && builtins.pathExists (root + "/aliases.nix") then
      [ (import (root + "/aliases.nix")) ]
    else
      [ ];

  # All the overlays in the right order, including the user-supplied ones
  allOverlays =
    [
      autoCalledPackages
    ]
    ++ optionalAllPackagesOverlay
    ++ optionalAliasesOverlay
    ++ overlays;

  # Apply all the overlays in order to the base fixed-point function pkgsFun
  f = builtins.foldl' (f: overlay: lib.extends overlay f) pkgsFun allOverlays;
in
# Evaluate the fixed-point
lib.fix f
