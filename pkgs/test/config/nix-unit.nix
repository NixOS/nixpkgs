# Eval-only tests for nixpkgs-config
# exercised through entry points:
#
#   - `import <nixpkgs> { config = ...; }`
#   - `nixpkgs.config` in a NixOS module
#
# Run with:
#   nix-unit pkgs/test/config/nix-unit.nix
# or:
#   nix-build ci -A nixpkgs-config-tests
#
{
  nixpkgsPath ? ../../..,
  pkgs ? import nixpkgsPath { },
}:
let
  lib = pkgs.lib;
  system = "x86_64-linux";

  evalNixos =
    modules:
    import (nixpkgsPath + "/nixos/lib/eval-config.nix") {
      modules = [
        (nixpkgsPath + "/nixos/modules/profiles/minimal.nix")
        {
          # Just some version to silence the warnings
          system.stateVersion = "25.11";

          nixpkgs.hostPlatform = system;
          fileSystems."/" = {
            device = "/dev/sda1";
            fsType = "ext4";
          };
          boot.loader.grub.devices = [ "/dev/sda" ];
        }
      ]
      ++ modules;
    };

  # Externally created instance
  externalPkgs = import nixpkgsPath {
    inherit system;
    config.allowUnfree = true;
  };

  # A case must add {nixos, nixpkgs} precisely
  expand =
    name: case:
    assert case ? nixos && case ? nixpkgs;
    assert
      removeAttrs case [
        "nixos"
        "nixpkgs"
      ] == { };
    {
      "test_${name}_nixpkgs" = case.nixpkgs;
      "test_${name}_nixos" = case.nixos;
    };

  cases = {
    singleOption = {
      nixpkgs = {
        expr =
          (import nixpkgsPath {
            inherit system;
            config.allowUnfree = true;
          }).config.allowUnfree;
        expected = true;
      };
      nixos = {
        expr = (evalNixos [ { nixpkgs.config.allowUnfree = true; } ]).pkgs.config.allowUnfree;
        expected = true;
      };
    };

    disjointKeys = {
      nixpkgs = {
        expr =
          let
            config =
              (import nixpkgsPath {
                inherit system;
                config = lib.mkMerge [
                  { allowUnfree = true; }
                  { allowBroken = true; }
                ];
              }).config;
          in
          {
            inherit (config) allowUnfree allowBroken;
          };
        expected = {
          allowUnfree = true;
          allowBroken = true;
        };
      };
      nixos = {
        expr =
          let
            config =
              (evalNixos [
                { nixpkgs.config.allowUnfree = true; }
                { nixpkgs.config.allowBroken = true; }
              ]).pkgs.config;
          in
          {
            inherit (config) allowUnfree allowBroken;
          };
        expected = {
          allowUnfree = true;
          allowBroken = true;
        };
      };
    };

    # `pulseaudio` and below are freeform; they do not exist when unset.
    defaults = {
      nixpkgs = {
        expr = lib.filterAttrs (
          n: _:
          lib.elem n [
            "allowUnfree"
            "cudaSupport"
            "pulseaudio"
            "permittedInsecurePackages"
            "packageOverrides"
            "allowUnfreePredicate"
          ]
        ) (import nixpkgsPath { inherit system; }).config;
        expected = {
          allowUnfree = false;
          cudaSupport = false;
        };
      };
      nixos = {
        expr = lib.filterAttrs (
          n: _:
          lib.elem n [
            "allowUnfree"
            "cudaSupport"
            "pulseaudio"
            "permittedInsecurePackages"
            "packageOverrides"
            "allowUnfreePredicate"
          ]
        ) (evalNixos [ ]).pkgs.config;
        expected = {
          allowUnfree = false;
          cudaSupport = false;
        };
      };
    };

    equalOptionDefs = {
      nixpkgs = {
        expr =
          (import nixpkgsPath {
            inherit system;
            config = lib.mkMerge [
              { allowUnfree = true; }
              { allowUnfree = true; }
            ];
          }).config.allowUnfree;
        expected = true;
      };
      nixos = {
        expr =
          (evalNixos [
            { nixpkgs.config.allowUnfree = true; }
            { nixpkgs.config.allowUnfree = true; }
          ]).pkgs.config.allowUnfree;
        expected = true;
      };
    };

    # `cudaSupport` is declared with `types.uniq bool`, which rejects a second
    # definition even when it is equal.
    equalUniqBoolOptionDefs = {
      nixpkgs = {
        expr =
          (import nixpkgsPath {
            inherit system;
            config = lib.mkMerge [
              { cudaSupport = true; }
              { cudaSupport = true; }
            ];
          }).config.cudaSupport;
        # `cudaSupport' is defined multiple times
        expectedError.type = "ThrownError";
      };
      nixos = {
        expr =
          (evalNixos [
            { nixpkgs.config.cudaSupport = true; }
            { nixpkgs.config.cudaSupport = true; }
          ]).pkgs.config.cudaSupport;
        expected = true;
      };
    };
    # `fetchedSourceNameDefault` is declared with `types.uniq enum`
    equalUniqEnumOptionDefs = {
      nixpkgs = {
        expr =
          (import nixpkgsPath {
            inherit system;
            config = lib.mkMerge [
              { fetchedSourceNameDefault = "versioned"; }
              { fetchedSourceNameDefault = "full"; }
            ];
          }).config.fetchedSourceNameDefault;
        expectedError.type = "ThrownError";
      };
      nixos = {
        expr =
          (evalNixos [
            { nixpkgs.config.fetchedSourceNameDefault = "versioned"; }
            { nixpkgs.config.fetchedSourceNameDefault = "full"; }
          ]).pkgs.config.fetchedSourceNameDefault;
        expected = "versioned";
      };
    };

    # `allowNonSource` is freeform type.
    equalFreeformDefs = {
      nixpkgs = {
        expr =
          (import nixpkgsPath {
            inherit system;
            config = lib.mkMerge [
              { allowNonSource = false; }
              { allowNonSource = false; }
            ];
          }).config.allowNonSource;
        # `allowNonSource' is defined multiple times
        expectedError.type = "ThrownError";
      };
      nixos = {
        expr =
          (evalNixos [
            { nixpkgs.config.allowNonSource = false; }
            { nixpkgs.config.allowNonSource = false; }
          ]).pkgs.config.allowNonSource;
        expected = false;
      };
    };

    # The same function value, reached through two definitions.
    equalFunctionDefs = {
      nixpkgs = {
        expr =
          let
            predicate = p: lib.isAttrs p;
          in
          (import nixpkgsPath {
            inherit system;
            config = lib.mkMerge [
              { allowNonSourcePredicate = predicate; }
              { allowNonSourcePredicate = predicate; }
            ];
          }).config.allowNonSourcePredicate
            null;
        # `allowNonSourcePredicate' is defined multiple times
        expectedError.type = "ThrownError";
      };
      nixos = {
        expr =
          let
            predicate = p: lib.isAttrs p;
          in
          (evalNixos [
            { nixpkgs.config.allowNonSourcePredicate = predicate; }
            { nixpkgs.config.allowNonSourcePredicate = predicate; }
          ]).pkgs.config.allowNonSourcePredicate
            null;
        expected = false;
      };
    };

    conflictingOptionDefs = {
      nixpkgs = {
        expr =
          (import nixpkgsPath {
            inherit system;
            config = lib.mkMerge [
              { allowUnfree = false; }
              { allowUnfree = true; }
            ];
          }).config.allowUnfree;
        # `allowUnfree' is defined multiple times
        expectedError.type = "ThrownError";
      };
      nixos = {
        expr =
          (evalNixos [
            { nixpkgs.config.allowUnfree = false; }
            { nixpkgs.config.allowUnfree = true; }
          ]).pkgs.config.allowUnfree;
        # The first definition wins.
        expected = false;
      };
    };

    # Three definitions, so "the first one wins" is distinguishable from
    # "the order is reversed".
    conflictingFunctionDefs = {
      nixpkgs = {
        expr =
          (import nixpkgsPath {
            inherit system;
            config = lib.mkMerge [
              { allowUnfreePredicate = _: "A"; }
              { allowUnfreePredicate = _: "B"; }
              { allowUnfreePredicate = _: "C"; }
            ];
          }).config.allowUnfreePredicate
            null;
        # `allowUnfreePredicate' is defined multiple times
        expectedError.type = "ThrownError";
      };
      nixos = {
        expr =
          (evalNixos [
            { nixpkgs.config.allowUnfreePredicate = _: "A"; }
            { nixpkgs.config.allowUnfreePredicate = _: "B"; }
            { nixpkgs.config.allowUnfreePredicate = _: "C"; }
          ]).pkgs.config.allowUnfreePredicate
            null;
        expected = "A";
      };
    };

    # `mkForce` inside `nixpkgs.config` is invisible to `configType.merge`,
    # which folds the definitions without consulting their priority.
    mkForceInner = {
      nixpkgs = {
        expr =
          (import nixpkgsPath {
            inherit system;
            config = lib.mkMerge [
              { allowUnfreePredicate = _: false; }
              { allowUnfreePredicate = lib.mkForce (_: true); }
            ];
          }).config.allowUnfreePredicate
            null;
        expected = true;
      };
      nixos = {
        expr =
          (evalNixos [
            { nixpkgs.config.allowUnfreePredicate = _: false; }
            { nixpkgs.config.allowUnfreePredicate = lib.mkForce (_: true); }
          ]).pkgs.config.allowUnfreePredicate
            null;
        expected = false;
      };
    };

    # Applied to the whole attrset it is a definition-level property, which the
    # module system does understand.
    mkForceWholeConfig = {
      nixpkgs = {
        expr =
          (import nixpkgsPath {
            inherit system;
            config = lib.mkMerge [
              { allowUnfree = false; }
              (lib.mkForce { allowUnfree = true; })
            ];
          }).config.allowUnfree;
        expected = true;
      };
      nixos = {
        expr =
          (evalNixos [
            {
              nixpkgs.config = {
                allowUnfree = false;
              };
            }
            { nixpkgs.config = lib.mkForce { allowUnfree = true; }; }
          ]).pkgs.config.allowUnfree;
        expected = true;
      };
    };

    # Same cause as mkForceInner, opposite direction: the lowered definition
    # wins over a normal one because it happens to come first.
    mkDefaultInner = {
      nixpkgs = {
        expr =
          (import nixpkgsPath {
            inherit system;
            config = lib.mkMerge [
              { allowUnfree = lib.mkDefault false; }
              { allowUnfree = true; }
            ];
          }).config.allowUnfree;
        expected = true;
      };
      nixos = {
        expr =
          (evalNixos [
            { nixpkgs.config.allowUnfree = lib.mkDefault false; }
            { nixpkgs.config.allowUnfree = true; }
          ]).pkgs.config.allowUnfree;
        expected = false;
      };
    };

    attrsDeepMerge = {
      nixpkgs = {
        expr =
          (import nixpkgsPath {
            inherit system;
            config = lib.mkMerge [
              { mplayer.useUnfreeCodecs = true; }
              { mplayer.x11Support = true; }
            ];
          }).config.mplayer;
        # `mplayer' is defined multiple times
        expectedError.type = "ThrownError";
      };
      nixos = {
        expr =
          (evalNixos [
            { nixpkgs.config.mplayer.useUnfreeCodecs = true; }
            { nixpkgs.config.mplayer.x11Support = true; }
          ]).pkgs.config.mplayer;
        # `recursiveUpdate` merges the two key by key.
        expected = {
          useUnfreeCodecs = true;
          x11Support = true;
        };
      };
    };

    # See: https://github.com/NixOS/nixpkgs/issues/356739
    # and https://github.com/NixOS/nixpkgs/pull/368051
    freeformListDefs = {
      nixpkgs = {
        expr =
          (import nixpkgsPath {
            inherit system;
            config = lib.mkMerge [
              { permittedInsecurePackages = [ "FIRST" ]; }
              { permittedInsecurePackages = [ "SECOND" ]; }
            ];
          }).config.permittedInsecurePackages;
        # `permittedInsecurePackages' is defined multiple times
        expectedError.type = "ThrownError";
      };
      nixos = {
        expr =
          (evalNixos [
            { nixpkgs.config.permittedInsecurePackages = [ "FIRST" ]; }
            { nixpkgs.config.permittedInsecurePackages = [ "SECOND" ]; }
          ]).pkgs.config.permittedInsecurePackages;
        # The second definition is silently dropped
        expected = [ "FIRST" ];
      };
    };

    # `allowUnfreePackages` is one of three keys `mergeConfig` currently handles
    # differently. Three definitions, to pin the order and not just the
    # concatenation.
    unfreePackagesConcat = {
      nixpkgs = {
        expr =
          (import nixpkgsPath {
            inherit system;
            config = lib.mkMerge [
              { allowUnfreePackages = [ "A" ]; }
              { allowUnfreePackages = [ "B" ]; }
              { allowUnfreePackages = [ "C" ]; }
            ];
          }).config.allowUnfreePackages;
        expected = [
          "A"
          "B"
          "C"
        ];
      };
      nixos = {
        expr =
          (evalNixos [
            { nixpkgs.config.allowUnfreePackages = [ "A" ]; }
            { nixpkgs.config.allowUnfreePackages = [ "B" ]; }
            { nixpkgs.config.allowUnfreePackages = [ "C" ]; }
          ]).pkgs.config.allowUnfreePackages;
        # Nixos felt the need to implement a special foldr
        expected = [
          "C"
          "B"
          "A"
        ];
      };
    };

    # packageOverrides is special cased in nixos
    packageOverridesCompose = {
      nixpkgs = {
        expr = lib.attrNames (
          (import nixpkgsPath {
            inherit system;
            config = lib.mkMerge [
              { packageOverrides = _: { AAA = 1; }; }
              { packageOverrides = _: { BBB = 2; }; }
            ];
          }).config.packageOverrides
            { }
        );
        # `packageOverrides' is defined multiple times
        expectedError.type = "ThrownError";
      };
      nixos = {
        expr = lib.attrNames (
          (evalNixos [
            { nixpkgs.config.packageOverrides = _: { AAA = 1; }; }
            { nixpkgs.config.packageOverrides = _: { BBB = 2; }; }
          ]).pkgs.config.packageOverrides
            { }
        );
        expected = [
          "AAA"
          "BBB"
        ];
      };
    };

    # perlPackageOverrides is special cased in nixos
    perlPackageOverridesCompose = {
      nixpkgs = {
        expr = lib.attrNames (
          (import nixpkgsPath {
            inherit system;
            config = lib.mkMerge [
              { perlPackageOverrides = _: { AAA = 1; }; }
              { perlPackageOverrides = _: { BBB = 2; }; }
            ];
          }).config.perlPackageOverrides
            { }
        );
        # `perlPackageOverrides' is defined multiple times
        expectedError.type = "ThrownError";
      };
      nixos = {
        expr = lib.attrNames (
          (evalNixos [
            { nixpkgs.config.perlPackageOverrides = _: { AAA = 1; }; }
            { nixpkgs.config.perlPackageOverrides = _: { BBB = 2; }; }
          ]).pkgs.config.perlPackageOverrides
            { }
        );
        expected = [
          "AAA"
          "BBB"
        ];
      };
    };

    # TODO: Add one more test of xPackageOverrides that is not special cased today

    functionConfigGetsPkgs = {
      nixpkgs = {
        expr =
          (import nixpkgsPath {
            inherit system;
            config =
              { pkgs, lib, ... }:
              {
                allowUnfreePredicate = p: lib.getName p == pkgs.hello.pname;
              };
          }).config.allowUnfreePredicate
            {
              pname = "hello";
              name = "hello";
            };
        expected = true;
      };
      nixos = {
        expr =
          (evalNixos [
            {
              nixpkgs.config =
                { pkgs, lib, ... }:
                {
                  allowUnfreePredicate = p: lib.getName p == pkgs.hello.pname;
                };
            }
          ]).pkgs.config.allowUnfreePredicate
            {
              pname = "hello";
              name = "hello";
            };
        expected = true;
      };
    };

    warnUndeclaredOptions = {
      nixpkgs = {
        expr =
          (import nixpkgsPath {
            inherit system;
            config = lib.mkMerge [
              { warnUndeclaredOptions = true; }
              { notAnOpt = true; }
            ];
          }).config.warnings;
        expected = [ "undeclared Nixpkgs option set: config.notAnOpt" ];
      };
      nixos = {
        expr =
          (evalNixos [
            { nixpkgs.config.warnUndeclaredOptions = true; }
            { nixpkgs.config.notAnOpt = true; }
          ]).pkgs.config.warnings;
        expected = [ "undeclared Nixpkgs option set: config.notAnOpt" ];
      };
    };

    # `blacklistedLicenses` is a fallback for `blocklistedLicenses`;
    # `whitelistedLicenses` behaves the same way.
    # pkgs.hello is gpl3Plus so this should yield an error
    legacyLicenseAlias = {
      nixpkgs = {
        expr =
          (import nixpkgsPath {
            inherit system;
            config.blacklistedLicenses = [ lib.licenses.gpl3Plus ];
          }).hello;
        expectedError = {
          type = "ThrownError";
          msg = "Refusing to evaluate package.*";
        };
      };
      nixos = {
        expr =
          (evalNixos [
            { nixpkgs.config.blacklistedLicenses = [ lib.licenses.gpl3Plus ]; }
          ]).pkgs.hello;
        expectedError = {
          type = "ThrownError";
          msg = "Refusing to evaluate package.*";
        };
      };
    };

    blocklistedOverridesAlias = {
      nixpkgs = {
        expr =
          lib.isDerivation
            (import nixpkgsPath {
              inherit system;
              config = lib.mkMerge [
                { blacklistedLicenses = [ lib.licenses.gpl3Plus ]; }
                { blocklistedLicenses = [ ]; }
              ];
            }).hello;
        expected = true;
      };
      nixos = {
        expr =
          lib.isDerivation
            (evalNixos [
              { nixpkgs.config.blacklistedLicenses = [ lib.licenses.gpl3Plus ]; }
              { nixpkgs.config.blocklistedLicenses = [ ]; }
            ]).pkgs.hello;
        expected = true;
      };
    };

    # Variant sets re-enter nixpkgs through `nixpkgsFun`
    variantRocm = {
      nixpkgs = {
        expr =
          let
            variant =
              (import nixpkgsPath {
                inherit system;
                config.allowUnfree = true;
              }).pkgsRocm;
          in
          {
            inherit (variant.hello) pname;
            inherit (variant.config) allowUnfree;
          };
        expected = {
          pname = "hello";
          allowUnfree = true;
        };
      };
      nixos = {
        expr =
          let
            variant = (evalNixos [ { nixpkgs.config.allowUnfree = true; } ]).pkgs.pkgsRocm;
          in
          {
            inherit (variant.hello) pname;
            inherit (variant.config) allowUnfree;
          };
        expected = {
          pname = "hello";
          allowUnfree = true;
        };
      };
    };

    variantI686 = {
      nixpkgs = {
        expr =
          let
            variant =
              (import nixpkgsPath {
                inherit system;
                config.allowUnfree = true;
              }).pkgsi686Linux;
          in
          {
            inherit (variant.hello) pname;
            inherit (variant.config) allowUnfree;
          };
        expected = {
          pname = "hello";
          allowUnfree = true;
        };
      };
      nixos = {
        expr =
          let
            variant = (evalNixos [ { nixpkgs.config.allowUnfree = true; } ]).pkgs.pkgsi686Linux;
          in
          {
            inherit (variant.hello) pname;
            inherit (variant.config) allowUnfree;
          };
        expected = {
          pname = "hello";
          allowUnfree = true;
        };
      };
    };

    variantBuildPackages = {
      nixpkgs = {
        expr =
          let
            variant =
              (import nixpkgsPath {
                inherit system;
                config.allowUnfree = true;
              }).buildPackages;
          in
          {
            inherit (variant.hello) pname;
            inherit (variant.config) allowUnfree;
          };
        expected = {
          pname = "hello";
          allowUnfree = true;
        };
      };
      nixos = {
        expr =
          let
            variant = (evalNixos [ { nixpkgs.config.allowUnfree = true; } ]).pkgs.buildPackages;
          in
          {
            inherit (variant.hello) pname;
            inherit (variant.config) allowUnfree;
          };
        expected = {
          pname = "hello";
          allowUnfree = true;
        };
      };
    };

    variantCross = {
      nixpkgs = {
        expr =
          let
            variant =
              (import nixpkgsPath {
                inherit system;
                config.allowUnfree = true;
              }).pkgsCross.aarch64-multiplatform;
          in
          {
            inherit (variant.hello) pname;
            inherit (variant.config) allowUnfree;
          };
        expected = {
          pname = "hello";
          allowUnfree = true;
        };
      };
      nixos = {
        expr =
          let
            variant =
              (evalNixos [ { nixpkgs.config.allowUnfree = true; } ]).pkgs.pkgsCross.aarch64-multiplatform;
          in
          {
            inherit (variant.hello) pname;
            inherit (variant.config) allowUnfree;
          };
        expected = {
          pname = "hello";
          allowUnfree = true;
        };
      };
    };

    # `import <nixpkgs> { allowUnfree = true; }` does not have any effect
    # Though it looks like nixos: nixpkgs.config = { allowUnfree = true; }
    strayConfigKey = {
      nixpkgs = {
        expr =
          (import nixpkgsPath {
            inherit system;
            allowUnfree = true;
          }).config.allowUnfree;
        # Silently ignored.
        expected = false;
      };
      nixos = {
        expr = (evalNixos [ { nixpkgs.allowUnfree = true; } ]).pkgs.config.allowUnfree;
        # `nixpkgs.allowUnfree' does not exist.
        expectedError.type = "ThrownError";
      };
    };
  };

in
lib.concatMapAttrs expand cases
// {

  testSameModuleTwice = {
    expr =
      let
        allowNonSourcePredicateMod =
          { lib, ... }:
          {
            allowNonSourcePredicate = p: lib.isAttrs p;
          };
      in
      (evalNixos [
        { nixpkgs.config = allowNonSourcePredicateMod; }
        { nixpkgs.config = allowNonSourcePredicateMod; }
      ]).pkgs.config.allowNonSourcePredicate
        null;
    expected = false;
  };

  # See: https://github.com/NixOS/nixpkgs/issues/550879
  testFunctionConfigGetsPkgsPlain = {
    expr =
      (import nixpkgsPath {
        system = "aarch64-darwin";
        config =
          { lib, pkgs }:
          {
            allowUnfree = lib.isAttrs pkgs;
          };
      }).config.allowUnfree;
    expected = true;
  };

  # Smoke test: `system.build.toplevel` with allowUnfree
  testPkgsPlumbingToplevel = {
    expr =
      lib.isString
        (evalNixos [
          { nixpkgs.config.allowUnfree = true; }
        ]).config.system.build.toplevel.drvPath;
    expected = true;
  };

  testExternalInstance = {
    expr = (evalNixos [ { nixpkgs.pkgs = externalPkgs; } ]).pkgs.config.allowUnfree;
    expected = true;
  };

  testExternalInstanceOverlaid = {
    expr =
      let
        result =
          (evalNixos [
            {
              nixpkgs.pkgs = externalPkgs;
              nixpkgs.overlays = [ (_: _: { sharingMarker = "overlaid"; }) ];
            }
          ]).pkgs;
      in
      {
        inherit (result) sharingMarker;
        inherit (result.config) allowUnfree;
      };
    expected = {
      sharingMarker = "overlaid";
      allowUnfree = true;
    };
  };
}
