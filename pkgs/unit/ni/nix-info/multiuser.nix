let
  pkgs = import <nixpkgs> {};
in pkgs.runCommand "diagnostics-multiuser"
  {  }
  ''
    set -x
    # no cache: ${toString builtins.currentTime}
    # For reproducibility, nix always uses nixbld group:
    # https://github.com/NixOS/nix/blob/1dd29d7aebae706f3e90a18bbfae727f2ed03c70/src/libstore/build.cc#L1896-L1908
    test "$(groups)" == "nixbld"
    touch $out
  ''
