# Tests for nixpkgs config forwarding from NixOS modules.
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

  # Test helper
  evalNixos =
    modules:
    import (nixpkgsPath + "/nixos/lib/eval-config.nix") {
      modules = [ { nixpkgs.hostPlatform = "x86_64-linux"; } ] ++ modules;
    };
in
{
  # Basic: a single config option is forwarded correctly.
  testSingleConfigOption = {
    expr = (evalNixos [ { nixpkgs.config.allowUnfree = true; } ]).config.nixpkgs.config.allowUnfree;
    expected = true;
  };

  # Multiple config definitions from separate modules are merged.
  testMultipleModulesMerge = {
    expr =
      let
        eval = evalNixos [
          { nixpkgs.config.allowUnfree = true; }
          { nixpkgs.config.allowBroken = true; }
        ];
      in
      {
        inherit (eval.config.nixpkgs.config) allowUnfree allowBroken;
      };
    expected = {
      allowUnfree = true;
      allowBroken = true;
    };
  };

  # mkForce works. Also covers other properties
  testMkForce = {
    expr =
      (evalNixos [
        { nixpkgs.config.allowUnfree = true; }
        { nixpkgs.config.allowUnfree = lib.mkForce false; }
      ]).config.nixpkgs.config.allowUnfree;
    expected = false;
  };

  testDefaults = {
    expr = (evalNixos [ ]).config.nixpkgs.config.allowUnfree;
    expected = false;
  };

  # Standalone nixpkgs (i.e. import <nixpkgs> { ... })
  testStandaloneConfig = {
    expr = (import nixpkgsPath { config.allowUnfree = true; }).config.allowUnfree;
    expected = true;
  };

  # Standalone nixpkgs with a function (i.e. import <nixpkgs> ({pkgs, lib, ...}: { ... })
  testStandaloneConfigFunctionPkgs = {
    expr =
      (import nixpkgsPath {
        config =
          { pkgs, lib, ... }:
          {
            allowUnfree = lib.isAttrs pkgs;
          };
      }).config.allowUnfree;
    expected = true;
  };

  # NixOS module sets nixpkgs.config as a function
  testNixosConfigFunction = {
    expr =
      (evalNixos [
        {
          nixpkgs.config =
            { lib, ... }:
            {
              allowUnfree = lib.isFunction lib.id;
            };
        }
      ]).config.nixpkgs.config.allowUnfree;
    expected = true;
  };

  # Package set variants that override `config` must keep working when Nixpkgs
  # was instantiated by the NixOS module, which forwards the definitions via the
  # internal `_configDefinitions` argument.
  # Regression test for https://github.com/NixOS/nixpkgs/issues/550852
  testVariantOverridingConfig = {
    expr =
      let
        eval = evalNixos [
          { nixpkgs.config.allowUnfree = true; }
          { nixpkgs.config.allowBroken = true; }
          { nixpkgs.config.allowBroken = lib.mkForce false; }
        ];
      in
      {
        inherit (eval.pkgs.pkgsRocm.config)
          rocmSupport
          cudaSupport
          allowUnfree
          allowBroken
          ;
      };
    expected = {
      # Set by the variant itself.
      rocmSupport = true;
      cudaSupport = false;
      # Inherited from the NixOS modules, with properties already resolved.
      allowUnfree = true;
      allowBroken = false;
    };
  };

  # Variants that do not override `config` keep receiving the definitions, so
  # module system properties are still resolved by the new instance.
  testVariantInheritingConfig = {
    expr =
      (evalNixos [
        { nixpkgs.config.allowUnfree = true; }
        { nixpkgs.config.allowUnfree = lib.mkForce false; }
      ]).pkgs.pkgsCross.aarch64-multiplatform.config.allowUnfree;
    expected = false;
  };

  # Passing both config and _configDefinitions is not allowed
  testConfigAndDefinitionsMutuallyExclusive = {
    expr =
      (import nixpkgsPath {
        config = {
          allowUnfree = true;
        };
        _configDefinitions = [
          {
            file = "test";
            value = {
              allowBroken = true;
            };
          }
        ];
      }).config.allowUnfree;
    expectedError = {
      type = "ThrownError";
      msg = ".*_configDefinitions.*internal.*must not be combined.*";
    };
  };
}
