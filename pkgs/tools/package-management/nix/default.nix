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

  teams = [
    lib.teams.nix
    lib.teams.security-review
  ];

  # Disables tests that have been flaky due to the darwin sandbox and fork safety
  # with missing shebangs.
  # See:
  # - https://github.com/NixOS/nix/pull/14778
  # - https://github.com/NixOS/nixpkgs/issues/476794
  # - https://github.com/NixOS/nix/issues/13106
  patches_common = lib.optional (
    stdenv.system == "aarch64-darwin"
  ) ./patches/skip-flaky-darwin-tests.patch;

  # Lowdown 3.0 compatibility patch for nix 2.31–2.33; fetched from the
  # upstream backport (same diff on every maintenance branch after
  # fetchpatch strips metadata).  Nix 2.34.4+ and the git snapshot
  # already include the fix in their tagged source.
  lowdown30Patch = pkgs.fetchpatch {
    name = "nix-lowdown-3.0-support.patch";
    url = "https://github.com/NixOS/nix/commit/472c35c561bd9e8db1465e0677f1efe2cb88c568.patch";
    hash = "sha256-ZCQgI/euBN8t9rgdCsGRgrcEWG3T5MUc+bQc4tIcHuI=";
  };

  # Lowdown 3.0 compatibility patch for nix 2.28 and 2.30, which have a
  # different markdown.cc layout (no LOWDOWN_TERM_NORELLINK branch) and
  # never received an upstream backport.
  lowdown30PatchOld = ./patches/lowdown-3.0-compat-2.28-2.30.patch;
in
lib.makeExtensible (
  self:
  (
    {
      nix_2_28 = commonMeson {
        version = "2.28.6";
        hash = "sha256-jg2YDTFt8CY4kMg4ha3UK5C+mQY+Zg67nwNy+CmTk5w=";
        self_attribute_name = "nix_2_28";
        patches = patches_common ++ [
          lowdown30PatchOld
        ];
      };

      nixComponents_2_30 =
        (nixDependencies.callPackage ./modular/packages.nix rec {
          version = "2.30.4";
          inherit teams;
          otherSplices = generateSplicesForNixComponents "nixComponents_2_30";
          src = fetchFromGitHub {
            owner = "NixOS";
            repo = "nix";
            tag = version;
            hash = "sha256-cJ96IBZCYoX0Tdlo5Q7qDSAKfL6QcUq/4Kr1UplH50E=";
          };
        }).appendPatches
          (patches_common ++ [ lowdown30PatchOld ]);

      nix_2_30 = addTests "nix_2_30" self.nixComponents_2_30.nix-everything;

      nixComponents_2_31 =
        (nixDependencies.callPackage ./modular/packages.nix rec {
          version = "2.31.4";
          inherit teams;
          otherSplices = generateSplicesForNixComponents "nixComponents_2_31";
          src = fetchFromGitHub {
            owner = "NixOS";
            repo = "nix";
            tag = version;
            hash = "sha256-f/haYfcI+9IiYVH+g6cjhF8cK7QWHAFfcPtF+57ujZ0=";
          };
        }).appendPatches
          [ ];

      nix_2_31 = addTests "nix_2_31" self.nixComponents_2_31.nix-everything;

      nixComponents_2_34 =
        (nixDependencies.callPackage ./modular/packages.nix rec {
          version = "2.34.6";
          inherit teams;
          otherSplices = generateSplicesForNixComponents "nixComponents_2_34";
          src = fetchFromGitHub {
            owner = "NixOS";
            repo = "nix";
            tag = version;
            hash = "sha256-kHMyhuzhLtH3f+wAcNvAL62ct2kmwZOp2B54SHkMMo0=";
          };
        }).appendPatches
          patches_common;

      nix_2_34 = addTests "nix_2_34" self.nixComponents_2_34.nix-everything;

      nixComponents_git =
        (nixDependencies.callPackage ./modular/packages.nix rec {
          version = "2.35pre20260407_${lib.substring 0 8 src.rev}";
          inherit teams;
          otherSplices = generateSplicesForNixComponents "nixComponents_git";
          src = fetchFromGitHub {
            owner = "NixOS";
            repo = "nix";
            rev = "a37db9d249afd61a81ae26368696f60e065d6f61";
            hash = "sha256-RpfExg4DcWZ/SanVuwVbdijqPylsjvtMrHTQHemE+t8=";
          };
        }).appendPatches
          patches_common;

      git = addTests "git" self.nixComponents_git.nix-everything;

      latest = self.nix_2_34;

      # Read ./README.md before bumping a major release
      stable = addFallbackPathsCheck self.nix_2_34;
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
        nixComponents_2_32 = throw "nixComponents_2_32 has been removed. use nixComponents_2_34.";
        nixComponents_2_33 = throw "nixComponents_2_33 has been removed. use nixComponents_2_34.";
        nix_2_24 = throw "nix_2_24 has been removed. use nix_2_31.";
        nix_2_26 = throw "nix_2_26 has been removed. use nix_2_31.";
        nix_2_27 = throw "nix_2_27 has been removed. use nix_2_31.";
        nix_2_25 = throw "nix_2_25 has been removed. use nix_2_31.";
        nix_2_29 = throw "nix_2_29 has been removed. use nix_2_31.";
        nix_2_32 = throw "nix_2_32 has been removed. use nix_2_34.";
        nix_2_33 = throw "nix_2_33 has been removed. use nix_2_34.";

        minimum = throw "nixVersions.minimum has been removed. Use a specific version instead.";
        unstable = throw "nixVersions.unstable has been removed. use nixVersions.latest or the nix flake.";
      }
    )
  )
)
