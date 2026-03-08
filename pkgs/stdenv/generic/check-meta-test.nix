# Execute with
#   nix-build -A nixosTests.nixpkgs-config-allow-unfree-packages-and-predicate --show-trace
#
# This test exercises the interaction between:
#
#   - nixos/modules/misc/nixpkgs.nix  (config merging, esp. allowUnfreePackages)
#   - pkgs/stdenv/generic/check-meta.nix (allowUnfreePredicate logic)
#
# It checks how:
#
#   * config.allowUnfreePackages
#   * config.allowUnfreePredicate
#
# interact to determine whether unfree packages are allowed.
{
  lib,
  pkgs,
}:

let
  inherit (lib)
    assertMsg
    generators
    licenses
    recurseIntoAttrs
    ;

  mkUnfreePkg = name: {
    pname = name;
    version = "1.0";
    meta.license = licenses.unfree;
  };
  assertValidity =
    {
      nixpkgsConfig,
      pkg,
      expected ? true,
    }:
    let
      testPkgs = import ../../.. {
        system = pkgs.stdenv.hostPlatform.system;
        config = nixpkgsConfig;
      };
      checkMeta = testPkgs.callPackage ./check-meta.nix { };
      tryEval = expression: builtins.tryEval (builtins.deepSeq expression expression);
      actual = tryEval (
        checkMeta.assertValidity {
          meta = pkg.meta;
          attrs = pkg;
        }
      );
      toPretty = generators.toPretty { };
    in
    assertMsg (actual.success == expected) ''
      Expected validity of package ${lib.getName pkg} to be ${toPretty expected},
      but got ${toPretty actual} with config:
      ${toPretty nixpkgsConfig}
    '';

  runAssertions = assertions: lib.deepSeq assertions "";

in
recurseIntoAttrs {

  allowOnlyFreePackagesByDefault = assertValidity {
    nixpkgsConfig = { };
    pkg = mkUnfreePkg "forbidden";
    expected = false;
  };

  allowAllUnfreePackages = assertValidity {
    nixpkgsConfig = {
      allowUnfree = true;
    };
    pkg = mkUnfreePkg "allowed";
  };

  allowUnfreePackagesWithPredicate =
    let
      nixpkgsConfig = {
        allowUnfreePredicate = pkg: lib.getName pkg == "allowed-by-predicate";
      };
    in
    [
      (assertValidity {
        inherit nixpkgsConfig;
        pkg = mkUnfreePkg "allowed-by-predicate";
      })
      (assertValidity {
        inherit nixpkgsConfig;
        pkg = mkUnfreePkg "allowed-by-nothing";
        expected = false;
      })
    ];

  allowUnfreeWithPackages = runAssertions [
    (assertValidity {
      nixpkgsConfig = {
        allowUnfreePackages = [ "unfree" ];
      };
      pkg = mkUnfreePkg "unfree";
      expected = true;
    })
  ];

  allowUnfreePackagesOrPredicate =
    let
      nixpkgsConfig = {
        allowUnfreePackages = [ "allowed-by-packages" ];
        allowUnfreePredicate = pkg: lib.getName pkg == "allowed-by-predicate";
      };
    in
    runAssertions [
      (assertValidity {
        inherit nixpkgsConfig;
        pkg = mkUnfreePkg "allowed-by-packages";
      })
      (assertValidity {
        inherit nixpkgsConfig;
        pkg = mkUnfreePkg "allowed-by-predicate";
      })
      (assertValidity {
        inherit nixpkgsConfig;
        pkg = mkUnfreePkg "forbidden";
        expected = false;
      })
    ];
}
