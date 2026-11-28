let
  pkgs = import <nixpkgs> { };
in
pkgs.runCommandLocal "diagnostics-sandbox" { } ''
  set -x
  # no cache: ${toString builtins.currentTime}
  test -d "$(dirname "$out")/../var/nix"
  touch $out
''
