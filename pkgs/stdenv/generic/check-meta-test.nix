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
    concatMapStringsSep
    generators
    isList
    licenses
    nameValuePair
    recurseIntoAttrs
    replaceString
    ;

  showLicense =
    license:
    if isList license then
      "[ ${concatMapStringsSep " " licenses.toSPDX license} ]"
    else
      licenses.toSPDX license;

  mkPkg = name: license: {
    pname = name;
    version = "1.0";
    meta.license = license;
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
        checkMeta.assertValidity pkgs.stdenv.hostPlatform {
          meta = pkg.meta;
          attrs = pkg;
        }
      );
      toPretty = generators.toPretty { };
    in
    assertMsg (actual.success == expected) ''
      Expected validity of package '${lib.getName pkg}' with unfree license
      '${showLicense pkg.meta.license}' to be ${toPretty expected}, but got
      ${toPretty actual}
      with config:
      ${toPretty nixpkgsConfig}
    '';

  runAssertions = assertions: lib.deepSeq assertions "";

  mkTests = mkUnfreePkg: {
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
  };

  unfreeLicenses = [
    licenses.unfree
    (licenses.AND [
      licenses.free
      licenses.unfree
    ])
    [
      licenses.free
      (licenses.AND [
        licenses.free
        licenses.unfree
      ])
    ]
  ];

  freeLicenses = [
    [
      licenses.free
      (licenses.WITH licenses.asl20 licenses.llvm-exception)
    ]
    [
      (licenses.OR [
        licenses.free
        licenses.unfree
      ])
    ]
  ];
in

recurseIntoAttrs (
  builtins.listToAttrs (
    map (
      license:
      nameValuePair (replaceString " " "-" (showLicense license)) (
        recurseIntoAttrs (mkTests (name: mkPkg name license))
      )
    ) unfreeLicenses
  )
  // {
    allowFreeLicenseLists = runAssertions (
      map (
        license:
        assertValidity {
          nixpkgsConfig = { };
          pkg = mkPkg "free" license;
        }
      ) freeLicenses
    );
  }
)
