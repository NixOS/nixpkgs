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

  tests-name = {
    testNameFromNameArg = {
      expr =
        (buildEnv {
          name = "test-env";
          paths = [ ];
        }).name;
      expected = "test-env";
    };

    testNameFromPnameVersion = {
      expr =
        (buildEnv {
          pname = "test-env";
          version = "1.0";
          paths = [ ];
        }).name;
      expected = "test-env-1.0";
    };

    testMissingNameThrows = testingThrow (buildEnv { paths = [ ]; }).drvPath;
  };

  tests-passthru-paths = {
    testPathsInPassthru = {
      expr =
        let
          env = buildEnv {
            name = "test-env";
            paths = [ pkgs.hello ];
          };
        in
        builtins.length env.paths > 0;
      expected = true;
    };

    testPassthruPathsOverridable = {
      expr =
        let
          env = buildEnv {
            name = "test-env";
            paths = [ pkgs.hello ];
          };
          overridden = env.overrideAttrs {
            passthru.paths = [ pkgs.figlet ];
          };
        in
        builtins.length overridden.paths == 1;
      expected = true;
    };
  };

  tests-finalAttrs = {
    testFinalAttrsSelfReference = {
      expr =
        let
          env = buildEnv (finalAttrs: {
            name = "test-env";
            paths = [ ];
            passthru.description = "An env named ${finalAttrs.name}";
          });
        in
        env.description;
      expected = "An env named test-env";
    };
  };

  tests = tests-name // tests-passthru-paths // tests-finalAttrs;
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
