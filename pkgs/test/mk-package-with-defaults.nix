/**
  Regression test for `mkPackageWithDefaults`.

  The sugar lets package authors write

      mkPackageWithDefaults {
        defaults = { postgresql_14, ... }: { postgresql = postgresql_14; };
        function = { stdenv, postgresql, ... }: [ ... ];
      }

  and have the package function reference the stable identifier
  `postgresql`, decoupling the default-version choice from the function
  itself and keeping it cleanly separable.

  The tests check three things:

  - a `defaults`-less call is a drop-in replacement for `mkPackage`
  - a stable identifier seeded via `defaults` is resolved at evaluation
    time (without the name being present in the ambient package set)
  - overriding the stable identifier via `.override` flows through the
    seed layer onto `this.deps`, producing a different drvPath
*/
{
  lib,
  pkgs,
  stdenvNoCC,
}:

let
  src = ../build-support/package;

  plain = pkgs.mkPackageWithDefaults {
    function =
      {
        layers,
        stdenv,
        ...
      }:
      [
        (layers.derivation { inherit stdenv; })
        (this: old: {
          name = "mpwd-plain";
          version = "0.1";
          meta = {
            description = "mkPackageWithDefaults plain";
            platforms = lib.platforms.all;
          };
          stdenvArgs = {
            inherit src;
            dontUnpack = true;
            installPhase = "mkdir -p $out";
          };
        })
      ];
  };

  # Equivalent plain mkPackage for drvPath comparison.
  plainViaMkPackage = pkgs.mkPackage (
    { layers, stdenv, ... }:
    [
      (layers.derivation { inherit stdenv; })
      (this: old: {
        name = "mpwd-plain";
        version = "0.1";
        meta = {
          description = "mkPackageWithDefaults plain";
          platforms = lib.platforms.all;
        };
        stdenvArgs = {
          inherit src;
          dontUnpack = true;
          installPhase = "mkdir -p $out";
        };
      })
    ]
  );

  # Stable-identifier form: `stableBoost` is not a nixpkgs attribute but
  # is seeded from the defaults. The function references it by its
  # stable name, so version bumps of the actual backing package only
  # touch the `defaults` line.
  withDefaults = pkgs.mkPackageWithDefaults {
    defaults =
      { boost, ... }:
      {
        stableBoost = boost;
      };
    function =
      {
        layers,
        stdenv,
        stableBoost,
        ...
      }:
      [
        (layers.derivation { inherit stdenv; })
        (this: old: {
          name = "mpwd-defaults";
          version = "0.1";
          meta = {
            description = "mkPackageWithDefaults with seeded defaults";
            platforms = lib.platforms.all;
          };
          stdenvArgs = {
            inherit src;
            dontUnpack = true;
            installPhase = "mkdir -p $out";
            buildInputs = [ stableBoost ];
          };
        })
      ];
  };

  overridden = withDefaults.override (old: {
    stableBoost = pkgs.hello;
  });

  tests = {
    test-plain-drvPath-matches-mkPackage = {
      expr = plain.drvPath;
      expected = plainViaMkPackage.drvPath;
    };

    test-defaults-seeded-stable-identifier-resolves = {
      # If the seed layer doesn't work, evaluating this would throw
      # `Dependency stableBoost went missing ...`, so just eval-forcing
      # the drvPath is the test.
      expr = lib.isString withDefaults.drvPath;
      expected = true;
    };

    test-override-stable-identifier-changes-drvPath = {
      expr = overridden.drvPath != withDefaults.drvPath;
      expected = true;
    };
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  name = "test-mk-package-with-defaults";
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
      echo "ERROR: tests.mk-package-with-defaults: Encountering failed tests."
      for testName in "''${!testResults[@]}"; do
        if [[ -z "''${testResults[$testName]}" ]]; then
          echo "- $testName"
        fi
      done
      echo "To inspect the expected and actual result,"
      echo '  evaluate `tests.mk-package-with-defaults.passthru.tests.''${testName}`.'
    } >&2
    exit 1
  '';
})
