# cd nixpkgs
# nix-build -A tests.pkg-config.defaultPkgConfigPackages
{ lib, pkg-config, defaultPkgConfigPackages, runCommand, testers }:
let
  inherit (lib.strings) escapeNixIdentifier;

  allTests = lib.mapAttrs (k: v: if v == null then null else makePkgConfigTestMaybe k v)
    (builtins.removeAttrs defaultPkgConfigPackages ["recurseForDerivations"]);

  # nix-build rejects attribute names with periods
  # This will build those regardless.
  tests-combined = runCommand "pkg-config-checks" {
    allTests = lib.attrValues allTests;
  } ''
    touch $out
  '';

  makePkgConfigTestMaybe = moduleName: pkg:
    if ! lib.isDerivation pkg
    then
      throw "pkg-config module `${escapeNixIdentifier moduleName}` is not defined to be a derivation. Please check the attribute value for `${escapeNixIdentifier moduleName}` in `pkgs/top-level/pkg-config-packages.nix` in Nixpkgs."

    else if ! pkg?meta.unsupported
    then
      throw "pkg-config module `${escapeNixIdentifier moduleName}` does not have a `meta.unsupported` attribute. This can't be right. Please check the attribute value for `${escapeNixIdentifier moduleName}` in `pkgs/top-level/pkg-config-packages.nix` in Nixpkgs."

    else if pkg.meta.unsupported
    then
      # We return `null` instead of doing a `filterAttrs`, because with
      # `filterAttrs` the evaluator would not be able to return the attribute
      # set without first evaluating all of the attribute _values_. This would
      # be rather expensive, and severly slow down the use case of getting a
      # single test, which we want to do in `passthru.tests`, or interactively.
      null

    else if ! pkg?meta.broken
    then
      throw "pkg-config module `${escapeNixIdentifier moduleName}` does not have a `meta.broken` attribute. This can't be right. Please check the attribute value for `${escapeNixIdentifier moduleName}` in `pkgs/top-level/pkg-config.packages.nix` in Nixpkgs."

    else if pkg.meta.broken
    then null

    else testers.hasPkgConfigModule { inherit moduleName; package = pkg; };

in
  lib.recurseIntoAttrs allTests // { inherit tests-combined; }
