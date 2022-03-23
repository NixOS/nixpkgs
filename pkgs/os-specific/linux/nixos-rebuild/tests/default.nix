{ pkgs, writers, nixos-rebuild }:

let
  writer = name: script:
    writers.makePythonWriter pkgs.python310 pkgs.python3Packages name {
      flakeIgnore = ["E201" "E202" "E231" "E302" "E305" "E501" "E999"];
    } script;

in
  writers.writeDash "foo" ''
    NIXOS_REBUILD_TEST_INSTRUMENTED=1 \
      ${nixos-rebuild}/bin/nixos-rebuild dry-build 2>&1 \
        | ${writer "nixos-rebuild-tests" ./nixos-rebuild-tests.py}
  ''
