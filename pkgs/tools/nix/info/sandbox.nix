let
  pkgs = import <nixpkgs> {};
in pkgs.runCommand "diagnostics-sandbox"
  { }
  ''
    set -x
    # no cache: ${toString builtins.currentTime}
    test -d "$(dirname "$out")/../var/nix"
    touch $out
  ''
