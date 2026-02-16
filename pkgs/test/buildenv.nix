{
  lib,
  pkgs,
  stdenvNoCC,
}:

let
  inherit (pkgs) buildEnv;

  testingThrow = expr: {
    expr = (builtins.tryEval (builtins.seq expr "didn't throw"));
    expected = {
      success = false;
      value = false;
    };
  };

  tests = { };
in

stdenvNoCC.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  name = "test-buildenv";
  passthru = {
    inherit tests;
    failures = lib.runTests finalAttrs.passthru.tests;
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
      echo "ERROR: tests.buildenv: Encountering failed tests."
      for testName in "''${!testResults[@]}"; do
        if [[ -z "''${testResults[$testName]}" ]]; then
          echo "- $testName"
        fi
      done
      echo "To inspect the expected and actual result, "
      echo '  evaluate `tests.buildenv.tests.''${testName}`.'
    } >&2
    exit 1
  '';
})
