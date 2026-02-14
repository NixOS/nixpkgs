{
  lib,
  config,
  stdenv,
  nixDependencies,
  generateSplicesForMkScope,
  fetchFromGitHub,
  fetchpatch2,
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

  teams = [ lib.teams.nix ];

  # Disables tests that have been flaky due to the darwin sandbox and fork safety
  # with missing shebangs.
  # See:
  # - https://github.com/NixOS/nix/pull/14778
  # - https://github.com/NixOS/nixpkgs/issues/476794
  # - https://github.com/NixOS/nix/issues/13106
  patches_common = lib.optional (
    stdenv.system == "aarch64-darwin"
  ) ./patches/skip-flaky-darwin-tests.patch;
in
lib.makeExtensible (
  self:
  (
    {
      nix_2_28 = commonMeson {
        version = "2.28.5";
        hash = "sha256-oIfAHxO+BCtHXJXLHBnsKkGl1Pw+Uuq1PwNxl+lZ+Oc=";
        self_attribute_name = "nix_2_28";
        patches = patches_common ++ [
          (fetchpatch2 {
            name = "nix-2.28-14764-mdbook-0.5-support.patch";
            url = "https://github.com/NixOS/nix/commit/5a64138e862fe364e751c5c286e8db8c466aaee7.patch?full_index=1";
            hash = "sha256-vFv/D08x9urtoIE9wiC7Lln4Eq3sgNBwU7TBE1iyrfI=";
          })
        ];
      };

      nixComponents_2_30 =
        (nixDependencies.callPackage ./modular/packages.nix rec {
          version = "2.30.3";
          inherit teams;
          otherSplices = generateSplicesForNixComponents "nixComponents_2_30";
          src = fetchFromGitHub {
            owner = "NixOS";
            repo = "nix";
            tag = version;
            hash = "sha256-kBuwzMgIE9Tmve0Rpp+q+YCsE2mw9d62M/950ViWeJ0=";
          };
        }).appendPatches
          (
            patches_common
            ++ [
              (fetchpatch2 {
                name = "nix-2.30-14695-mdbook-0.5-support.patch";
                url = "https://github.com/NixOS/nix/commit/5cbd7856de0a9c13351f98e32a1e26d0854d87fd.patch?full_index=1";
                hash = "sha256-r2ZF1zBZDKMvyX6X4VsaTMrg0zdjn59Jf6Hqg56r29E=";
              })
            ]
          );

      nix_2_30 = addTests "nix_2_30" self.nixComponents_2_30.nix-everything;

      nixComponents_2_31 = nixDependencies.callPackage ./modular/packages.nix rec {
        version = "2.31.3";
        inherit (self.nix_2_30.meta) teams;
        otherSplices = generateSplicesForNixComponents "nixComponents_2_31";
        src = fetchFromGitHub {
          owner = "NixOS";
          repo = "nix";
          tag = version;
          hash = "sha256-oe0YWe8f+pwQH4aYD2XXLW5iEHyXNUddurqJ5CUVCIk=";
        };
      };

      nix_2_31 = addTests "nix_2_31" self.nixComponents_2_31.nix-everything;

      nixComponents_2_32 =
        (nixDependencies.callPackage ./modular/packages.nix rec {
          version = "2.32.5";
          inherit (self.nix_2_31.meta) teams;
          otherSplices = generateSplicesForNixComponents "nixComponents_2_32";
          src = fetchFromGitHub {
            owner = "NixOS";
            repo = "nix";
            tag = version;
            hash = "sha256-vnlVgJ5VXn2LVvdzf1HUZeGq0pqa6vII11C8u5Q/YgM=";
          };
        }).appendPatches
          patches_common;

      nix_2_32 = addTests "nix_2_32" self.nixComponents_2_32.nix-everything;

      nixComponents_2_33 =
        (nixDependencies.callPackage ./modular/packages.nix rec {
          version = "2.33.3";
          inherit (self.nix_2_32.meta) teams;
          otherSplices = generateSplicesForNixComponents "nixComponents_2_33";
          src = fetchFromGitHub {
            owner = "NixOS";
            repo = "nix";
            tag = version;
            hash = "sha256-2Mga4e9ZtOPLwYqF4+hcjdsTImcA7TKUvDDfaF7jqEo=";
          };
        }).appendPatches
          patches_common;

      nix_2_33 = addTests "nix_2_33" self.nixComponents_2_33.nix-everything;

      nixComponents_git =
        (nixDependencies.callPackage ./modular/packages.nix rec {
          version = "2.34pre20251217_${lib.substring 0 8 src.rev}";
          inherit teams;
          otherSplices = generateSplicesForNixComponents "nixComponents_git";
          src = fetchFromGitHub {
            owner = "NixOS";
            repo = "nix";
            rev = "b6add8dcc6f4f6feb1ce83aaffe4d7e660e6f616";
            hash = "sha256-2au7PdQ4HXSuktTPCtOJoD/LNjqMwbHIJmuzEYW1b7I=";
          };
        }).appendPatches
          patches_common;

      git = addTests "git" self.nixComponents_git.nix-everything;

      latest = self.nix_2_33;

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
        nixComponents_2_27 = throw "nixComponents_2_27 has been removed. use nixComponents_2_31.";
        nixComponents_2_29 = throw "nixComponents_2_29 has been removed. use nixComponents_2_31.";
        nix_2_24 = throw "nix_2_24 has been removed. use nix_2_31.";
        nix_2_26 = throw "nix_2_26 has been removed. use nix_2_31.";
        nix_2_27 = throw "nix_2_27 has been removed. use nix_2_31.";
        nix_2_25 = throw "nix_2_25 has been removed. use nix_2_31.";
        nix_2_29 = throw "nix_2_29 has been removed. use nix_2_31.";

        minimum = throw "nixVersions.minimum has been removed. Use a specific version instead.";
        unstable = throw "nixVersions.unstable has been removed. use nixVersions.latest or the nix flake.";
      }
    )
  )
)
