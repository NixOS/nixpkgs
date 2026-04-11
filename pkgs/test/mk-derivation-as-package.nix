{
  lib,
  pkgs,
  stdenv,
  stdenvNoCC,
  mkDerivationAsPackage,
}:

let
  src = ../build-support/package;

  # Build a trivial package with both interfaces and compare drvPath.
  pairs = {
    plain =
      let
        args = {
          pname = "compat-plain";
          version = "1.0";
          inherit src;
          dontUnpack = true;
          installPhase = "mkdir -p $out";
          passthru.marker = "plain";
          meta.description = "plain form";
        };
      in
      {
        a = mkDerivationAsPackage stdenv args;
        b = stdenv.mkDerivation args;
      };

    finalAttrs =
      let
        args = finalAttrs: {
          pname = "compat-fa";
          version = "2.3";
          inherit src;
          dontUnpack = true;
          installPhase = "mkdir -p $out; echo ${finalAttrs.version} > $out/v";
          passthru = {
            fullName = finalAttrs.finalPackage.name;
            selfVersion = finalAttrs.version;
          };
        };
      in
      {
        a = mkDerivationAsPackage stdenv args;
        b = stdenv.mkDerivation args;
      };

    nameOnly =
      let
        args = {
          name = "compat-noversion";
          inherit src;
          dontUnpack = true;
          installPhase = "mkdir -p $out";
        };
      in
      {
        a = mkDerivationAsPackage stdenv args;
        b = stdenv.mkDerivation args;
      };

    deps =
      let
        args = {
          pname = "compat-deps";
          version = "1.0";
          inherit src;
          dontUnpack = true;
          buildInputs = [ pkgs.zlib ];
          nativeBuildInputs = [ pkgs.pkg-config ];
          installPhase = "mkdir -p $out";
        };
      in
      {
        a = mkDerivationAsPackage stdenv args;
        b = stdenv.mkDerivation args;
      };

    # `env = { ... }` in non-structured-attrs mode: stdenv.mkDerivation
    # merges the attrset into the derivation top-level, and injects
    # NIX_MAIN_PROGRAM from meta.mainProgram. buildGoModule relies on
    # both, so this is also the regression test for the ghostunnel canary.
    envAndMainProgram =
      let
        args = {
          pname = "compat-env";
          version = "1.0";
          inherit src;
          dontUnpack = true;
          installPhase = "mkdir -p $out";
          env = {
            SOME_VAR = "hello";
            OTHER_VAR = "world";
          };
          meta.mainProgram = "compat-env";
        };
      in
      {
        a = mkDerivationAsPackage stdenv args;
        b = stdenv.mkDerivation args;
      };

    # `__structuredAttrs = true` changes how `env` is serialised:
    # in addition to the usual top-level merge, stdenv.mkDerivation
    # also keeps the env attrset nested under `structuredAttrs.env`.
    # The shim must mirror both behaviours to round-trip drvPaths.
    structuredAttrs =
      let
        args = {
          pname = "compat-sa";
          version = "1.0";
          inherit src;
          dontUnpack = true;
          installPhase = "mkdir -p $out";
          __structuredAttrs = true;
          env = {
            SOME_VAR = "hello";
            OTHER_VAR = "world";
          };
          meta.mainProgram = "compat-sa";
        };
      in
      {
        a = mkDerivationAsPackage stdenv args;
        b = stdenv.mkDerivation args;
      };

    # Fixed-output derivation: exercise the `outputHash` /
    # `outputHashAlgo` / `outputHashMode` path through both entry
    # points and assert drvPath parity. This is the shape that
    # fetchurl and friends produce, and it's the most commonly used
    # "non-standard" mkDerivation flavour.
    fixedOutput =
      let
        args = {
          name = "compat-fo";
          inherit src;
          outputHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          outputHashAlgo = "sha256";
          outputHashMode = "recursive";
          buildCommand = "cp -r $src $out";
        };
      in
      {
        a = mkDerivationAsPackage stdenv args;
        b = stdenv.mkDerivation args;
      };

    # Multi-output derivation: exercise `outputs = [ ... ]` through
    # both entry points. The shim's per-output wrapping (via
    # `layers.stdenvMkDerivation`'s `lib.genAttrs` over
    # `this.drvAttrs.outputs`) must produce attrsets indistinguishable
    # from what `stdenv.mkDerivation` yields for each output, including
    # matching `outputName` / `outPath` / `drvPath`.
    multiOutput =
      let
        args = {
          pname = "compat-mo";
          version = "1.0";
          inherit src;
          outputs = [
            "out"
            "dev"
            "man"
          ];
          dontUnpack = true;
          installPhase = "mkdir -p $out $dev $man";
        };
      in
      {
        a = mkDerivationAsPackage stdenv args;
        b = stdenv.mkDerivation args;
      };

    # `.overrideAttrs` must accept all three legacy shapes:
    #   - plain attrset
    #   - `prev: { ... }` (one arg)
    #   - `final: prev: { ... }` (two args, fixed-point)
    # Build identical base derivations via both entry points and apply
    # the same override with each shape, asserting drvPath parity.
    overrideAttrs =
      let
        args = {
          pname = "compat-oa";
          version = "1.0";
          inherit src;
          dontUnpack = true;
          installPhase = "mkdir -p $out";
          buildInputs = [ pkgs.zlib ];
        };
        a = mkDerivationAsPackage stdenv args;
        b = stdenv.mkDerivation args;

        plainOverride = {
          buildInputs = [
            pkgs.zlib
            pkgs.openssl
          ];
        };
        oneArg = old: { buildInputs = old.buildInputs ++ [ pkgs.openssl ]; };
        twoArg = final: prev: { buildInputs = prev.buildInputs ++ [ pkgs.openssl ]; };
      in
      {
        plain = {
          a = a.overrideAttrs plainOverride;
          b = b.overrideAttrs plainOverride;
        };
        oneArg = {
          a = a.overrideAttrs oneArg;
          b = b.overrideAttrs oneArg;
        };
        twoArg = {
          a = a.overrideAttrs twoArg;
          b = b.overrideAttrs twoArg;
        };
      };
  };

  # Probes for the env-validation helper shared with upstream
  # make-derivation.nix. Both should *fail* to evaluate, and each
  # should fail the same way through the shim as through the legacy
  # helper.
  envValidationProbes = {
    # `env` overlapping with a top-level derivation-arg key.
    overlap = {
      a = builtins.tryEval (
        (mkDerivationAsPackage stdenv {
          name = "compat-env-overlap";
          inherit src;
          dontUnpack = true;
          installPhase = "mkdir -p $out";
          env = {
            name = "whoops";
          };
        }).drvPath
      );
      b = builtins.tryEval (
        (stdenv.mkDerivation {
          name = "compat-env-overlap";
          inherit src;
          dontUnpack = true;
          installPhase = "mkdir -p $out";
          env = {
            name = "whoops";
          };
        }).drvPath
      );
    };
    # `env` value that isn't a scalar or derivation.
    badType = {
      a = builtins.tryEval (
        (mkDerivationAsPackage stdenv {
          name = "compat-env-badtype";
          inherit src;
          dontUnpack = true;
          installPhase = "mkdir -p $out";
          env = {
            FOO = [
              "a"
              "b"
            ];
          };
        }).drvPath
      );
      b = builtins.tryEval (
        (stdenv.mkDerivation {
          name = "compat-env-badtype";
          inherit src;
          dontUnpack = true;
          installPhase = "mkdir -p $out";
          env = {
            FOO = [
              "a"
              "b"
            ];
          };
        }).drvPath
      );
    };
  };

  # Build one with a nativeBuildInputs dependency to exercise the real build path.
  buildable = mkDerivationAsPackage stdenvNoCC {
    pname = "compat-buildable";
    version = "0.1";
    inherit src;
    dontUnpack = true;
    installPhase = "mkdir -p $out; echo hi > $out/greeting";
    meta.description = "build sanity";
  };

  tests = {
    test-plain-drvPath = {
      expr = pairs.plain.a.drvPath;
      expected = pairs.plain.b.drvPath;
    };
    test-plain-passthru-direct = {
      expr = pairs.plain.a.marker;
      expected = "plain";
    };
    test-plain-passthru-attr = {
      expr = pairs.plain.a.passthru.marker;
      expected = "plain";
    };
    test-plain-meta = {
      expr = pairs.plain.a.meta.description;
      expected = "plain form";
    };
    test-plain-name = {
      expr = pairs.plain.a.name;
      expected = "compat-plain-1.0";
    };

    test-finalAttrs-drvPath = {
      expr = pairs.finalAttrs.a.drvPath;
      expected = pairs.finalAttrs.b.drvPath;
    };
    test-finalAttrs-self-version = {
      expr = pairs.finalAttrs.a.selfVersion;
      expected = "2.3";
    };
    test-finalAttrs-finalPackage-name = {
      expr = pairs.finalAttrs.a.fullName;
      expected = "compat-fa-2.3";
    };

    test-nameOnly-drvPath = {
      expr = pairs.nameOnly.a.drvPath;
      expected = pairs.nameOnly.b.drvPath;
    };
    test-nameOnly-name = {
      expr = pairs.nameOnly.a.name;
      expected = "compat-noversion";
    };

    test-deps-drvPath = {
      expr = pairs.deps.a.drvPath;
      expected = pairs.deps.b.drvPath;
    };

    test-envAndMainProgram-drvPath = {
      expr = pairs.envAndMainProgram.a.drvPath;
      expected = pairs.envAndMainProgram.b.drvPath;
    };

    test-structuredAttrs-drvPath = {
      expr = pairs.structuredAttrs.a.drvPath;
      expected = pairs.structuredAttrs.b.drvPath;
    };

    test-fixedOutput-drvPath = {
      expr = pairs.fixedOutput.a.drvPath;
      expected = pairs.fixedOutput.b.drvPath;
    };

    test-multiOutput-drvPath = {
      expr = pairs.multiOutput.a.drvPath;
      expected = pairs.multiOutput.b.drvPath;
    };
    test-multiOutput-outputs = {
      expr = pairs.multiOutput.a.outputs;
      expected = pairs.multiOutput.b.outputs;
    };
    test-multiOutput-dev-outputName = {
      expr = pairs.multiOutput.a.dev.outputName;
      expected = "dev";
    };
    test-multiOutput-dev-outPath-matches-legacy = {
      expr = pairs.multiOutput.a.dev.outPath;
      expected = pairs.multiOutput.b.dev.outPath;
    };
    test-multiOutput-man-drvPath-matches-legacy = {
      expr = pairs.multiOutput.a.man.drvPath;
      expected = pairs.multiOutput.b.man.drvPath;
    };
    # `.all` is the list of per-output attrsets, matching what
    # `lib.customisation.extendDerivation` produces for the legacy path.
    test-multiOutput-all-length = {
      expr = builtins.length pairs.multiOutput.a.all;
      expected = builtins.length pairs.multiOutput.b.all;
    };
    test-multiOutput-all-outputNames = {
      expr = map (o: o.outputName) pairs.multiOutput.a.all;
      expected = map (o: o.outputName) pairs.multiOutput.b.all;
    };

    # `inputDerivation` is a build-time-deps-only derivation, meant for
    # `nix-build shell.nix -A inputDerivation`. Upstream's version and
    # the layer's version are generated by the same shared helper and
    # must produce bit-identical drvPaths, both for simple single-output
    # packages and for fixed-output ones (where fixed-output attrs
    # get stripped so the inputDerivation is not itself fixed-output).
    test-inputDerivation-plain-drvPath = {
      expr = pairs.plain.a.inputDerivation.drvPath;
      expected = pairs.plain.b.inputDerivation.drvPath;
    };
    test-inputDerivation-fixedOutput-drvPath = {
      expr = pairs.fixedOutput.a.inputDerivation.drvPath;
      expected = pairs.fixedOutput.b.inputDerivation.drvPath;
    };
    test-inputDerivation-fixedOutput-not-itself-fixed = {
      expr = pairs.fixedOutput.a.inputDerivation ? outputHash;
      expected = false;
    };

    test-overrideAttrs-plain-drvPath = {
      expr = pairs.overrideAttrs.plain.a.drvPath;
      expected = pairs.overrideAttrs.plain.b.drvPath;
    };
    test-overrideAttrs-oneArg-drvPath = {
      expr = pairs.overrideAttrs.oneArg.a.drvPath;
      expected = pairs.overrideAttrs.oneArg.b.drvPath;
    };
    test-overrideAttrs-twoArg-drvPath = {
      expr = pairs.overrideAttrs.twoArg.a.drvPath;
      expected = pairs.overrideAttrs.twoArg.b.drvPath;
    };

    # `env` overlapping with a derivation-arg key must fail to
    # evaluate through both mkDerivationAsPackage and stdenv.mkDerivation.
    test-env-overlap-rejects = {
      expr = envValidationProbes.overlap.a.success;
      expected = false;
    };
    test-env-overlap-rejects-matches-legacy = {
      expr = envValidationProbes.overlap.a.success == envValidationProbes.overlap.b.success;
      expected = true;
    };

    # `env` with a non-scalar value must likewise fail through both.
    test-env-badtype-rejects = {
      expr = envValidationProbes.badType.a.success;
      expected = false;
    };
    test-env-badtype-rejects-matches-legacy = {
      expr = envValidationProbes.badType.a.success == envValidationProbes.badType.b.success;
      expected = true;
    };

    test-buildable-name = {
      expr = buildable.name;
      expected = "compat-buildable-0.1";
    };
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  name = "test-mk-derivation-as-package";
  passthru = {
    inherit tests buildable;
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
      echo "ERROR: tests.mk-derivation-as-package: Encountering failed tests."
      for testName in "''${!testResults[@]}"; do
        if [[ -z "''${testResults[$testName]}" ]]; then
          echo "- $testName"
        fi
      done
      echo "To inspect the expected and actual result,"
      echo '  evaluate `tests.mk-derivation-as-package.passthru.tests.''${testName}`.'
    } >&2
    exit 1
  '';
})
