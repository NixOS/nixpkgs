/**
  Regression test for `mkPackage`'s `overrideLayers` / `overrideExternalDeps`
  sugar.

  `layers` is kept outside the regular `deps` fixpoint so layer code
  (which manipulates the same fixpoint) can't override its own
  implementation. A separate path via `overrideExternalDeps`, or the
  shorter `overrideLayers` sugar, exposes that ability to end users
  who need to swap a layer implementation in or out.

  The test builds a package whose layer list ends with `layers.noop`,
  then replaces `noop` with a layer that appends an environment
  variable. The drvPath must change to reflect the injected env var.
*/
{
  lib,
  pkgs,
  stdenvNoCC,
}:

let
  src = ../build-support/package;

  basePackage = pkgs.mkPackage (
    { layers, stdenv, ... }:
    [
      (layers.derivation { inherit stdenv; })
      (this: old: {
        name = "overridelayers-test";
        version = "0.1";
        meta = {
          description = "overrideLayers regression";
          platforms = lib.platforms.all;
        };
        stdenvArgs = {
          inherit src;
          dontUnpack = true;
          installPhase = "mkdir -p $out";
        };
      })
      layers.noop
    ]
  );

  overriddenPackage = basePackage.overrideLayers (old: {
    noop = _this: old_: {
      stdenvArgs = old_.stdenvArgs // {
        NIX_OVERLAY_MARKER = "hit";
      };
    };
  });

  overriddenViaExternalDeps = basePackage.overrideExternalDeps (old: {
    layers = old.layers // {
      noop = _this: old_: {
        stdenvArgs = old_.stdenvArgs // {
          NIX_OVERLAY_MARKER = "hit";
        };
      };
    };
  });

  tests = {
    test-base-has-overrideLayers = {
      expr = basePackage ? overrideLayers;
      expected = true;
    };
    test-base-has-overrideExternalDeps = {
      expr = basePackage ? overrideExternalDeps;
      expected = true;
    };
    test-overrideLayers-changes-drvPath = {
      expr = overriddenPackage.drvPath != basePackage.drvPath;
      expected = true;
    };
    test-overrideLayers-equivalent-to-overrideExternalDeps = {
      expr = overriddenPackage.drvPath == overriddenViaExternalDeps.drvPath;
      expected = true;
    };

    # baseLayer used to dereference `this.meta` unconditionally. Packages
    # that omit `meta` should evaluate cleanly: meta defaults to `{ }`
    # in baseLayer and the drvAttrs-dependent enrichment happens in
    # layers.derivation.
    test-no-meta-does-not-crash = {
      expr =
        (pkgs.mkPackage (
          { layers, stdenv, ... }:
          [
            (layers.derivation { inherit stdenv; })
            (this: old: {
              name = "no-meta-test";
              version = "0.1";
              stdenvArgs = {
                inherit src;
                dontUnpack = true;
                installPhase = "mkdir -p $out";
              };
            })
          ]
        )).name;
      expected = "no-meta-test";
    };
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  name = "test-mk-package-override-layers";
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
      echo "ERROR: tests.mk-package-override-layers: Encountering failed tests."
      for testName in "''${!testResults[@]}"; do
        if [[ -z "''${testResults[$testName]}" ]]; then
          echo "- $testName"
        fi
      done
      echo "To inspect the expected and actual result,"
      echo '  evaluate `tests.mk-package-override-layers.passthru.tests.''${testName}`.'
    } >&2
    exit 1
  '';
})
