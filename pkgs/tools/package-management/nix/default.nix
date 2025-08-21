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

  # Called for Nix < 2.26
  commonAutoconf =
    args:
    nixDependencies.callPackage
      (import ./common-autoconf.nix ({ inherit lib fetchFromGitHub; } // args))
      {
        inherit
          storeDir
          stateDir
          confDir
          ;
        aws-sdk-cpp =
          if lib.versionAtLeast args.version "2.12pre" then
            nixDependencies.aws-sdk-cpp
          else
            nixDependencies.aws-sdk-cpp-old;
      };

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

  # https://github.com/NixOS/nix/pull/7585
  patch-monitorfdhup = fetchpatch2 {
    name = "nix-7585-monitor-fd-hup.patch";
    url = "https://github.com/NixOS/nix/commit/1df3d62c769dc68c279e89f68fdd3723ed3bcb5a.patch";
    hash = "sha256-f+F0fUO+bqyPXjt+IXJtISVr589hdc3y+Cdrxznb+Nk=";
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

in
lib.makeExtensible (
  self:
  (
    {
      nix_2_24 = commonAutoconf {
        version = "2.24.15";
        hash = "sha256-GHqFHLxvRID2IEPUwIfRMp8epYQMFcvG9ogLzfWRbPc=";
        self_attribute_name = "nix_2_24";
      };

      nix_2_28 = commonMeson {
        version = "2.28.4";
        hash = "sha256-V1tPrBkPteqF8VWUgpotNFYJ2Xm6WmB3aMPexuEHl9I=";
        self_attribute_name = "nix_2_28";
      };

      nixComponents_2_29 = nixDependencies.callPackage ./modular/packages.nix {
        version = "2.29.1";
        inherit (self.nix_2_24.meta) maintainers teams;
        otherSplices = generateSplicesForNixComponents "nixComponents_2_29";
        src = fetchFromGitHub {
          owner = "NixOS";
          repo = "nix";
          rev = "2.29.1";
          hash = "sha256-rCL3l4t20jtMeNjCq6fMaTzWvBKgj+qw1zglLrniRfY=";
        };
      };

      nix_2_29 = addTests "nix_2_29" self.nixComponents_2_29.nix-everything;

      nixComponents_2_30 = nixDependencies.callPackage ./modular/packages.nix rec {
        version = "2.30.2";
        inherit (self.nix_2_24.meta) maintainers teams;
        otherSplices = generateSplicesForNixComponents "nixComponents_2_30";
        src = fetchFromGitHub {
          owner = "NixOS";
          repo = "nix";
          tag = version;
          hash = "sha256-U46fAs+j2PfWWqP1zNi1odhnV4030SQ0RoEC8Eah1OQ=";
        };
      };

      nix_2_30 = addTests "nix_2_30" self.nixComponents_2_30.nix-everything;

      nixComponents_git = nixDependencies.callPackage ./modular/packages.nix rec {
        version = "2.31pre20250712_${lib.substring 0 8 src.rev}";
        inherit (self.nix_2_24.meta) maintainers teams;
        otherSplices = generateSplicesForNixComponents "nixComponents_git";
        src = fetchFromGitHub {
          owner = "NixOS";
          repo = "nix";
          rev = "b124512388378cd38c4e353ddb387905d296e877";
          hash = "sha256-asBUtSonedNfMO0/Z6HUi8RK/y/7I1qBDHv2UryichA=";
        };
      };

      git = addTests "git" self.nixComponents_git.nix-everything;

      latest = self.nix_2_30;

      # Read ./README.md before bumping a major release
      stable = addFallbackPathsCheck self.nix_2_28;
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
        nix_2_26 = throw "nix_2_26 has been removed. use nix_2_28.";
        nix_2_27 = throw "nix_2_27 has been removed. use nix_2_28.";
        nix_2_25 = throw "nix_2_25 has been removed. use nix_2_28.";

        minimum = throw "nixVersions.minimum has been removed. Use a specific version instead.";
        unstable = throw "nixVersions.unstable has been removed. use nixVersions.latest or the nix flake.";
      }
    )
  )
)
