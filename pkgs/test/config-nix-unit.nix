# Tests for `nixpkgs.config` that inspect evaluation *error messages*.
#
# Everything that can be asserted on a value lives in `pkgs/test/config.nix`,
# where it runs at evaluation time and costs no build. These cases remain here
# because `builtins.tryEval` reports only whether an evaluation failed, never
# why, so the message can only be matched by a runner such as nix-unit.
#
# Run with:
#   nix-unit pkgs/test/config-nix-unit.nix
# or
#   nix-build -A tests.config-nix-unit
#
{
  nixpkgsPath ? ../..,
  pkgs ? import nixpkgsPath { },
}:
let
  lib = pkgs.lib;

  located = file: modules: map (lib.modules.setDefaultModuleLocation file) modules;
in
{
  # Nixpkgs reports the file a conflicting `config` definition came from.
  testConfigModuleLocations = {
    expr =
      (import nixpkgsPath {
        config = located "some-file.nix" [
          { fetchedSourceNameDefault = "versioned"; }
          { fetchedSourceNameDefault = "full"; }
        ];
      }).config.fetchedSourceNameDefault;
    expectedError = {
      type = "ThrownError";
      msg = ".*some-file.nix.*";
    };
  };

  # The NixOS module forwards definitions unevaluated, so a conflict points at
  # the NixOS module that defined it rather than at Nixpkgs internals.
  testNixosConfigConflictLocation = {
    expr =
      (import (nixpkgsPath + "/nixos/lib/eval-config.nix") {
        modules = [
          { nixpkgs.hostPlatform = "x86_64-linux"; }
        ]
        ++ located "my-nixos-module.nix" [
          { nixpkgs.config.fetchedSourceNameDefault = "versioned"; }
          { nixpkgs.config.fetchedSourceNameDefault = "full"; }
        ];
      }).pkgs.config.fetchedSourceNameDefault;
    expectedError = {
      type = "ThrownError";
      msg = ".*my-nixos-module.nix.*";
    };
  };
}
