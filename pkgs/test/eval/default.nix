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
    # TODO
  ''
