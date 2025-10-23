{
  lib,
  config,
  stdenv,
  nixDependencies,
  generateSplicesForMkScope,
  fetchFromGitHub,
  runCommand,
  pkgs,
  pkgsi686Linux,
  pkgsStatic,
  nixosTests,

  storeDir ? "/nix/store",
  stateDir ? "/nix/var",
  confDir ? "/etc",
}:
let
  # Called for Nix == 2.28. Transitional until we always use
  # per-component packages.
  commonMeson =
    args:
    nixDependencies.callPackage (import ./common-meson.nix ({ inherit lib fetchFromGitHub; } // args)) {
      inherit
        storeDir
        stateDir
        confDir
        ;
    };

  # Intentionally does not support overrideAttrs etc
  # Use only for tests that are about the package relation to `pkgs` and/or NixOS.
  addTestsShallowly =
    tests: pkg:
    pkg
    // {
      tests = pkg.tests // tests;
      # In case someone reads the wrong attribute
      passthru.tests = pkg.tests // tests;
    };

  addFallbackPathsCheck =
    pkg:
    addTestsShallowly {
      nix-fallback-paths =
        runCommand "test-nix-fallback-paths-version-equals-nix-stable"
          {
            paths = lib.concatStringsSep "\n" (
              builtins.attrValues (import ../../../../nixos/modules/installer/tools/nix-fallback-paths.nix)
            );
          }
          ''
            # NOTE: name may contain cross compilation details between the pname
            #       and version this is permitted thanks to ([^-]*-)*
            if [[ "" != $(grep -vE 'nix-([^-]*-)*${
              lib.strings.replaceStrings [ "." ] [ "\\." ] pkg.version
            }$' <<< "$paths") ]]; then
              echo "nix-fallback-paths not up to date with nixVersions.stable (nix-${pkg.version})"
              echo "The following paths are not up to date:"
              grep -v 'nix-${pkg.version}$' <<< "$paths"
              echo
              echo "Fix it by running in nixpkgs:"
              echo
              echo "curl https://releases.nixos.org/nix/nix-${pkg.version}/fallback-paths.nix >nixos/modules/installer/tools/nix-fallback-paths.nix"
              echo
              exit 1
            else
              echo "nix-fallback-paths versions up to date"
              touch $out
            fi
          '';
    } pkg;

  # (meson based packaging)
  # Add passthru tests to the package, and re-expose package set overriding
  # functions. This will not incorporate the tests into the package set.
  # TODO (roberth): add package-set level overriding to the "everything" package.
  addTests =
    selfAttributeName: pkg:
    let
      tests =
        pkg.tests or { }
        // import ./tests.nix {
          inherit
            runCommand
            lib
            stdenv
            pkgs
            pkgsi686Linux
            pkgsStatic
            nixosTests
            ;
          inherit (pkg) version src;
          nix = pkg;
          self_attribute_name = selfAttributeName;
        };
    in
    # preserve old pkg, including overrideSource, etc
    pkg
    // {
      tests = pkg.tests or { } // tests;
      passthru = pkg.passthru or { } // {
        tests =
          lib.warn "nix.passthru.tests is deprecated. Use nix.tests instead." pkg.passthru.tests or { }
          // tests;
      };
    };

  # Factored out for when we have package sets for multiple versions of
  # Nix.
  #
  # `nixPackages_*` would be the most regular name, analogous to
  # `linuxPackages_*`, especially if we put other 3rd-party software in
  # here, but `nixPackages_*` would also be *very* confusing to humans!
  generateSplicesForNixComponents =
    nixComponentsAttributeName:
    generateSplicesForMkScope [
      "nixVersions"
      nixComponentsAttributeName
    ];

  maintainers = [
    lib.maintainers.artturin
    lib.maintainers.philiptaron
    lib.maintainers.lovesegfault
  ];
  teams = [ lib.teams.nix ];

in
lib.makeExtensible (
  self:
  (
    {
      nix_2_28 = commonMeson {
        version = "2.28.5";
        hash = "sha256-oIfAHxO+BCtHXJXLHBnsKkGl1Pw+Uuq1PwNxl+lZ+Oc=";
        self_attribute_name = "nix_2_28";
      };

      nixComponents_2_29 = nixDependencies.callPackage ./modular/packages.nix rec {
        version = "2.29.2";
        inherit maintainers teams;
        otherSplices = generateSplicesForNixComponents "nixComponents_2_29";
        src = fetchFromGitHub {
          owner = "NixOS";
          repo = "nix";
          tag = version;
          hash = "sha256-50p2sG2RFuRnlS1/Vr5et0Rt+QDgfpNE2C2WWRztnbQ=";
        };
      };

      nix_2_29 = addTests "nix_2_29" self.nixComponents_2_29.nix-everything;

      nixComponents_2_30 = nixDependencies.callPackage ./modular/packages.nix rec {
        version = "2.30.3";
        inherit maintainers teams;
        otherSplices = generateSplicesForNixComponents "nixComponents_2_30";
        src = fetchFromGitHub {
          owner = "NixOS";
          repo = "nix";
          tag = version;
          hash = "sha256-kBuwzMgIE9Tmve0Rpp+q+YCsE2mw9d62M/950ViWeJ0=";
        };
      };

      nix_2_30 = addTests "nix_2_30" self.nixComponents_2_30.nix-everything;

      nixComponents_2_31 = nixDependencies.callPackage ./modular/packages.nix rec {
        version = "2.31.2";
        inherit (self.nix_2_30.meta) maintainers teams;
        otherSplices = generateSplicesForNixComponents "nixComponents_2_31";
        src = fetchFromGitHub {
          owner = "NixOS";
          repo = "nix";
          tag = version;
          hash = "sha256-NLGXPLjENLeKVOg3OZgHXZ+1x6sPIKq9FHH8pxbCrDI=";
        };
      };

      nix_2_31 = addTests "nix_2_31" self.nixComponents_2_31.nix-everything;

      nixComponents_2_32 = nixDependencies.callPackage ./modular/packages.nix rec {
        version = "2.32.1";
        inherit (self.nix_2_31.meta) maintainers teams;
        otherSplices = generateSplicesForNixComponents "nixComponents_2_32";
        src = fetchFromGitHub {
          owner = "NixOS";
          repo = "nix";
          tag = version;
          hash = "sha256-pApD0gpaklYkgZ9oZCtuAcAcYeUxR9FUOAlOtflZr+Q=";
        };
      };

      nix_2_32 = addTests "nix_2_32" self.nixComponents_2_32.nix-everything;

      nixComponents_git = nixDependencies.callPackage ./modular/packages.nix rec {
        version = "2.32pre20250919_${lib.substring 0 8 src.rev}";
        inherit maintainers teams;
        otherSplices = generateSplicesForNixComponents "nixComponents_git";
        src = fetchFromGitHub {
          owner = "NixOS";
          repo = "nix";
          rev = "07b96c1d14ab8695e5071fb73e19049fce8f3b6b";
          hash = "sha256-9tR08zFwQ9JNohdfeb40wcLfRnicXpKrHF+FHFva/WA=";
        };
      };

      git = addTests "git" self.nixComponents_git.nix-everything;

      latest = self.nix_2_32;

      # Read ./README.md before bumping a major release
      stable = addFallbackPathsCheck self.nix_2_31;
    }
    // lib.optionalAttrs config.allowAliases (
      lib.listToAttrs (
        map (
          minor:
          let
            attr = "nix_2_${toString minor}";
          in
          lib.nameValuePair attr (throw "${attr} has been removed")
        ) (lib.range 4 23)
      )
      // {
        nixComponents_2_27 = throw "nixComponents_2_27 has been removed. use nixComponents_git.";
        nix_2_24 = throw "nix_2_24 has been removed. use nix_2_28.";
        nix_2_26 = throw "nix_2_26 has been removed. use nix_2_28.";
        nix_2_27 = throw "nix_2_27 has been removed. use nix_2_28.";
        nix_2_25 = throw "nix_2_25 has been removed. use nix_2_28.";

        minimum = throw "nixVersions.minimum has been removed. Use a specific version instead.";
        unstable = throw "nixVersions.unstable has been removed. use nixVersions.latest or the nix flake.";
      }
    )
  )
)
