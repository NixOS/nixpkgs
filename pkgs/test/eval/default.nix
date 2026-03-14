/**
  This derivation allows implementing more complex tests, such as those covering deprecated features that emit warnings.
  These tests can evaluate or instantiate nix expressions, capture output, make assertions, etc.
*/
{
  nix,
  path,
  runCommand,
  writableTmpDirAsHomeHook,
}:

runCommand "nixpkgs-pkgs-tests-eval"
  {
    env = {
      nixpkgs = "${path}";
      tests = "${path}/pkgs/test/eval";
      NIX_PATH = "nixpkgs=${path}";
      NIX_BUILD_HOOK = "";
      PAGER = "cat";
    };
    nativeBuildInputs = [
      nix
      writableTmpDirAsHomeHook
    ];
    strictDeps = true;
    meta = {
      # This test depends on the Nixpkgs tree itself,
      # so any change to Nixpkgs will cause a rebuild.
      hydraPlatforms = [ ];
    };
  }
  ''
    # Setup nix environment
    export TEST_ROOT="$PWD/test-tmp"
    export NIX_CONF_DIR="$TEST_ROOT/etc"
    export NIX_LOCALSTATE_DIR="$TEST_ROOT/var"
    export NIX_LOG_DIR="$TEST_ROOT/var/log/nix"
    export NIX_STATE_DIR="$TEST_ROOT/var/nix"
    export NIX_STORE_DIR="$TEST_ROOT/store"
    nix-store --init

    # Run tests
    mkdir $out

    echo "Assert python stdenv override is successful"
    override_test_cases=(
      overridePythonAttrs-stdenv-correct
      overridePythonAttrs-stdenv-deprecated
      overridePythonAttrs-override-clangStdenv-deprecated-nested
      buildPythonPackage-stdenv-deprecated
      buildPythonPackage-fp-args-stdenv-deprecated
    )

    for test in "''${override_test_cases[@]}"
    do
      nix-instantiate --eval \
        "$tests"/python-overriding.nix \
        --attr "$test" \
        1> "$out/$test.stdout" \
        2> "$out/$test.stderr"

      [ "$(cat "$out/$test.stdout")" = "true" ] || {
        echo "$test did not evaluate to 'true'"
        cat "$out/$test.stdout"
        exit 1
      }
    done

    expect_stdenv_warning=(
      overridePythonAttrs-stdenv-deprecated
      overridePythonAttrs-override-clangStdenv-deprecated-nested
      buildPythonPackage-stdenv-deprecated
    )
    expected_warning='evaluation warning: python-package-stub: Passing `stdenv` directly to `buildPythonPackage` or `buildPythonApplication` is deprecated.'

    for test in "''${expect_stdenv_warning[@]}"
    do
      grep -q "$expected_warning" "$out/$test.stderr" || {
        echo "$test missing expected eval warning"
        exit 1
      }
    done

    expect_no_warning=(
      overridePythonAttrs-stdenv-correct
    )
    for test in "''${expect_no_warning[@]}"
    do
      if [ -s "$out/$test.stderr" ]; then
        echo "$test unexpected eval warning:"
        cat "$out/$test.stderr"
        exit 1
      fi
    done
  ''
