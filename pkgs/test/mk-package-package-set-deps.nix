/**
  Regression test for https://github.com/NixOS/nixpkgs/pull/296769#issuecomment-2435763707.

  The comment argues that a truly usable cross-compilation interface
  requires moving away from the "dependencies-as-function-arguments"
  style toward taking whole package sets as arguments, in the spirit of
  https://github.com/NixOS/nixpkgs/issues/227327.

  This test demonstrates (and locks in) that mkPackage already
  supports both styles, and that they produce bit-identical drvPaths in
  both native and cross-compilation configurations. Concretely:

    # Traditional splicing style
    mkPackage ({ layers, stdenv, pkg-config, zlib, ... }: [...])

    # Package-set style
    mkPackage ({ layers, stdenv, pkgsBuildHost, pkgsHostTarget, ... }: [
      (this: old: { stdenvArgs = {
        nativeBuildInputs = [ pkgsBuildHost.pkg-config ];
        buildInputs = [ pkgsHostTarget.zlib ];
        ...
      }; })
    ])

  Both shapes flow through the same `layers.derivation` and
  `stdenv.makeDerivationArgument`, so splicing does the right thing in
  either case. Regressions in mkPackage's `layers.withDeps` function-
  argument handling, or in callPackage splicing behavior when asked for
  `pkgsBuildHost` / `pkgsHostTarget`, will surface here.
*/
{
  lib,
  pkgs,
  stdenvNoCC,
}:

let
  src = ../build-support/package;

  mkPkgSet =
    p:
    p.mkPackage (
      {
        layers,
        stdenv,
        pkgsBuildHost,
        pkgsHostTarget,
        ...
      }:
      [
        (layers.derivation { inherit stdenv; })
        (this: old: {
          name = "mk-package-pkgset";
          version = "0.1";
          meta = {
            description = "package-set-style deps test";
            platforms = p.lib.platforms.all;
          };
          stdenvArgs = {
            inherit src;
            dontUnpack = true;
            installPhase = "mkdir -p $out";
            nativeBuildInputs = [ pkgsBuildHost.pkg-config ];
            buildInputs = [ pkgsHostTarget.zlib ];
          };
        })
      ]
    );

  mkTraditional =
    p:
    p.mkPackage (
      {
        layers,
        stdenv,
        pkg-config,
        zlib,
        ...
      }:
      [
        (layers.derivation { inherit stdenv; })
        (this: old: {
          name = "mk-package-pkgset";
          version = "0.1";
          meta = {
            description = "package-set-style deps test";
            platforms = p.lib.platforms.all;
          };
          stdenvArgs = {
            inherit src;
            dontUnpack = true;
            installPhase = "mkdir -p $out";
            nativeBuildInputs = [ pkg-config ];
            buildInputs = [ zlib ];
          };
        })
      ]
    );

  pkgsCross = pkgs.pkgsCross.aarch64-multiplatform;

  nativePkgSet = mkPkgSet pkgs;
  nativeTrad = mkTraditional pkgs;
  crossPkgSet = mkPkgSet pkgsCross;
  crossTrad = mkTraditional pkgsCross;

  # Override pkgsBuildHost wholesale and confirm the drvPath changes;
  # demonstrates that overriding works at the package-set granularity.
  overridden = nativePkgSet.override (
    old:
    old
    // {
      pkgsBuildHost = old.pkgsBuildHost // {
        pkg-config = pkgs.hello;
      };
    }
  );

  tests = {
    test-native-equivalence = {
      expr = nativePkgSet.drvPath;
      expected = nativeTrad.drvPath;
    };

    test-cross-equivalence = {
      expr = crossPkgSet.drvPath;
      expected = crossTrad.drvPath;
    };

    test-cross-changes-drvPath = {
      expr = nativePkgSet.drvPath != crossPkgSet.drvPath;
      expected = true;
    };

    test-override-pkgsBuildHost-changes-drvPath = {
      expr = overridden.drvPath != nativePkgSet.drvPath;
      expected = true;
    };
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  name = "test-mk-package-package-set-deps";
  passthru = {
    inherit tests;
    failures = lib.runTests (finalAttrs.passthru.tests // { tests = lib.attrNames tests; });
  };
  testResults = lib.mapAttrs (_: test: test.expr == test.expected) finalAttrs.passthru.tests;
  buildCommand = ''
    touch $out
    for testName in "''${!testResults[@]}"; do
      if [[ -n "''${testResults[$testName]}" ]]; then
        echo "$testName success"
      else
        echo "$testName fail"
      fi
    done
  ''
  + lib.optionalString (lib.any (v: !v) (lib.attrValues finalAttrs.testResults)) ''
    {
      echo "ERROR: tests.mk-package-package-set-deps: Encountering failed tests."
      for testName in "''${!testResults[@]}"; do
        if [[ -z "''${testResults[$testName]}" ]]; then
          echo "- $testName"
        fi
      done
      echo "To inspect the expected and actual result,"
      echo '  evaluate `tests.mk-package-package-set-deps.passthru.tests.''${testName}`.'
    } >&2
    exit 1
  '';
})
