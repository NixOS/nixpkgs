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

  tests-overrideAttrs =
    let
      base = buildEnv {
        name = "test-env";
        paths = [ pkgs.hello ];
        passthru.custom = "original";
      };
      overridden = base.overrideAttrs (
        finalAttrs: prev: {
          passthru = prev.passthru // {
            custom = "modified";
          };
        }
      );
    in
    {
      testOverrideAttrsChangesPassthru = {
        expr = overridden.custom;
        expected = "modified";
      };

      testOverrideAttrsPreservesName = {
        expr = overridden.name;
        expected = "test-env";
      };

      testOverrideAttrsAffectsDrv = {
        expr =
          let
            withPostBuild = base.overrideAttrs { postBuild = "echo overridden"; };
          in
          base.drvPath != withPostBuild.drvPath;
        expected = true;
      };
    };

  tests-passthru-merging =
    let
      env = buildEnv {
        name = "test-env";
        paths = [ pkgs.hello ];
        derivationArgs.passthru.fromDerivationArgs = "a";
        passthru.fromPassthru = "b";
      };
    in
    {
      testPassthruMergingAutoPathsPresent = {
        expr = env ? paths;
        expected = true;
      };

      testPassthruMergingDerivationArgs = {
        expr = env.fromDerivationArgs;
        expected = "a";
      };

      testPassthruMergingDirectPassthru = {
        expr = env.fromPassthru;
        expected = "b";
      };

      # Direct passthru takes precedence over derivationArgs.passthru
      testPassthruMergingPrecedence = {
        expr =
          let
            env' = buildEnv {
              name = "test-env";
              paths = [ ];
              derivationArgs.passthru.key = "from-derivationArgs";
              passthru.key = "from-passthru";
            };
          in
          env'.key;
        expected = "from-passthru";
      };
    };

  tests-derivationArgs =
    let
      env = buildEnv {
        name = "test-env";
        paths = [ ];
        derivationArgs.allowSubstitutes = true;
      };
    in
    {
      # derivationArgs.allowSubstitutes overrides the default (false)
      testDerivationArgsForwarded = {
        expr = env.allowSubstitutes;
        expected = true;
      };

      # Backward compat: top-level nativeBuildInputs still works
      testCompatNativeBuildInputs = {
        expr =
          let
            env' = buildEnv {
              name = "test-env";
              paths = [ ];
              nativeBuildInputs = [ pkgs.hello ];
            };
          in
          builtins.length env'.nativeBuildInputs > 0;
        expected = true;
      };
    };

  # Build tests: derivations that build a buildEnv and verify its output.
  # These are exposed via passthru.buildTests and checked in buildCommand.
  buildTests = {
    basic-symlinking =
      pkgs.runCommand "test-buildenv-basic-symlinking"
        {
          testEnv = buildEnv {
            name = "test-env";
            paths = [ pkgs.hello ];
          };
        }
        ''
          # With a single package, buildEnv symlinks the directory itself
          test -L "$testEnv/bin" || { echo "FAIL: $testEnv/bin is not a symlink"; exit 1; }

          # The symlink should point into the store
          target=$(readlink "$testEnv/bin")
          case "$target" in
            /nix/store/*) ;;
            *) echo "FAIL: symlink target '$target' is not a store path"; exit 1 ;;
          esac

          # The binary should be accessible and executable through the symlink
          test -x "$testEnv/bin/hello" || { echo "FAIL: hello binary not executable"; exit 1; }
          "$testEnv/bin/hello" > /dev/null || { echo "FAIL: hello binary did not run"; exit 1; }

          touch $out
        '';

    pathsToLink =
      pkgs.runCommand "test-buildenv-pathsToLink"
        {
          testEnv = buildEnv {
            name = "test-env";
            paths = [ pkgs.hello ];
            pathsToLink = [ "/bin" ];
          };
        }
        ''
          # /bin should exist
          test -d "$testEnv/bin" || { echo "FAIL: $testEnv/bin missing"; exit 1; }

          # Other directories from hello (like /share) should NOT exist
          test ! -e "$testEnv/share" || { echo "FAIL: $testEnv/share should not exist with pathsToLink = [\"/bin\"]"; exit 1; }

          touch $out
        '';

    extraPrefix =
      pkgs.runCommand "test-buildenv-extraPrefix"
        {
          testEnv = buildEnv {
            name = "test-env";
            paths = [ pkgs.hello ];
            extraPrefix = "/myprefix";
          };
        }
        ''
          # Content should be under the extra prefix
          test -e "$testEnv/myprefix/bin/hello" || { echo "FAIL: $testEnv/myprefix/bin/hello missing"; exit 1; }
          test -x "$testEnv/myprefix/bin/hello" || { echo "FAIL: $testEnv/myprefix/bin/hello not executable"; exit 1; }

          # Content should NOT be at the top level
          test ! -e "$testEnv/bin" || { echo "FAIL: $testEnv/bin should not exist at top level with extraPrefix"; exit 1; }

          touch $out
        '';

    postBuild =
      pkgs.runCommand "test-buildenv-postBuild"
        {
          testEnv = buildEnv {
            name = "test-env";
            paths = [ ];
            postBuild = ''
              echo "postBuild was here" > $out/marker
            '';
          };
        }
        ''
          # postBuild should have created the marker file
          test -f "$testEnv/marker" || { echo "FAIL: $testEnv/marker missing; postBuild did not run"; exit 1; }
          content=$(cat "$testEnv/marker")
          test "$content" = "postBuild was here" || { echo "FAIL: marker content wrong: $content"; exit 1; }

          touch $out
        '';

    # buildEnv's builder.pl reads all inputs from environment variables,
    # which is incompatible with structuredAttrs (values go into a JSON file instead).
    # This test documents the known failure so it can be tracked.
    structuredAttrs-is-broken = pkgs.testers.testBuildFailure' {
      drv = buildEnv {
        name = "test-env-structuredAttrs";
        paths = [ pkgs.hello ];
        derivationArgs.__structuredAttrs = true;
      };
      expectedBuilderExitCode = 255; # Perl's `die` exits with code 255
      expectedBuilderLogEntries = [ "malformed JSON string" ];
    };

    ignoreCollisions =
      pkgs.runCommand "test-buildenv-ignoreCollisions"
        {
          # Two copies of hello with different priorities that collide
          testEnv = buildEnv {
            name = "test-env-ignore";
            paths = [
              pkgs.hello
              (lib.meta.setPrio 1 pkgs.hello)
            ];
            ignoreCollisions = true;
          };
        }
        ''
          # Should succeed because ignoreCollisions = true
          test -x "$testEnv/bin/hello" || { echo "FAIL: hello not present with ignoreCollisions"; exit 1; }

          touch $out
        '';
  };

  tests =
    tests-name
    // tests-passthru-paths
    // tests-finalAttrs
    // tests-overrideAttrs
    // tests-passthru-merging
    // tests-derivationArgs;
in

stdenvNoCC.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  name = "test-buildenv";
  passthru = {
    inherit tests buildTests;
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
