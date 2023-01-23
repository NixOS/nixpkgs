{ lib, pkg-config, pkg-configPackages, runCommand }:
let
  inherit (lib.strings) escapeNixIdentifier;

  allTests = lib.mapAttrs (k: v: if v == null then null else makePkgConfigTestMaybe k v) pkg-configPackages;

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

    else makePkgConfigTest moduleName pkg;

  makePkgConfigTest = moduleName: pkg: runCommand "check-pkg-config-${moduleName}" {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ pkg ];
    inherit moduleName;
  } ''
    echo "checking pkg-config module $moduleName in $buildInputs"
    set +e
    version="$(pkg-config --modversion $moduleName)"
    r=$?
    set -e
    if [[ $r = 0 ]]; then
      echo "✅ pkg-config module $moduleName exists and has version $version"
      echo "$version" > $out
    else
      echo "These modules were available in the input propagation closure:"
      pkg-config --list-all
      echo "❌ pkg-config module $moduleName was not found"
      false
    fi
  '';
in
  allTests // { inherit tests-combined; }
