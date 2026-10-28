{
  lib,
  config,
  stdenv,
  nixDependencies,
  generateSplicesForMkScope,
  fetchFromGitHub,
  fetchpatch,
  runCommand,
  pkgs,
  pkgsi686Linux,
  pkgsStatic,
  nixosTests,
}:
let
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

  # Comment out functional tests from meson.build file
  # This is to prevent test list reordering between releases in `tests/functional/**/meson.build`
  # `tests` is a list of `{ file; test; }`
  removeFunctionalTests =
    tests: src:
    # empty implies noop
    if tests == [ ] then
      src
    else
      runCommand src.name { inherit src; } ''
        cp -r "$src" "$out"
        chmod -R u+w "$out"
        ${lib.concatMapStringsSep "\n" (
          { file, test }:
          ''substituteInPlace "$out/${file}" --replace-fail "'${test}'," "# '${test}',"''
        ) tests}
      '';

  # Disables tests that have been flaky due to the darwin sandbox and fork safety
  # with missing shebangs.
  # See:
  # - https://github.com/NixOS/nix/pull/14778
  # - https://github.com/NixOS/nixpkgs/issues/476794
  # - https://github.com/NixOS/nix/issues/13106
  commonDisabledTests = lib.optionals (stdenv.hostPlatform.system == "aarch64-darwin") [
    {
      file = "tests/functional/meson.build";
      test = "nix-shell.sh";
    }
    {
      file = "tests/functional/meson.build";
      test = "user-envs.sh";
    }
    {
      file = "tests/functional/ca/meson.build";
      test = "nix-shell.sh";
    }
    {
      file = "tests/functional/flakes/meson.build";
      test = "shebang.sh";
    }
  ];

  # `libutil` calls `NtCreateFile` and `RtlNtStatusToDosError` without linking
  # `ntdll`, so it only links with a toolchain that adds `-lntdll` implicitly.
  # Windows only, so that `nix` is not rebuilt for every other platform.
  #
  # Temporary: fixed in https://github.com/NixOS/nix/pull/16306 and backported,
  # but not yet released. Drop this from each version once its next release,
  # which will include the backport, is packaged:
  #
  # - 2.34: https://github.com/NixOS/nix/pull/16607
  # - 2.35: https://github.com/NixOS/nix/pull/16608
  windowsPatches = lib.optionals stdenv.hostPlatform.isWindows [
    (fetchpatch {
      name = "libutil-link-ntdll-on-windows.patch";
      url = "https://github.com/NixOS/nix/commit/4b247ec7f961686e60da6f012e4e128e30e8c82f.patch";
      hash = "sha256-WDx0xknyin7ayQUIA5Zafk2tEySVIVqUZ0RdsQKAN8Q=";
    })
  ];
in
lib.makeExtensible (
  self:
  (
    {
      nixComponents_2_34 =
        (nixDependencies.callPackage ./modular/packages.nix rec {
          version = "2.34.9";
          inherit teams;
          otherSplices = generateSplicesForNixComponents "nixComponents_2_34";
          src = removeFunctionalTests commonDisabledTests (fetchFromGitHub {
            owner = "NixOS";
            repo = "nix";
            tag = version;
            hash = "sha256-ZJwg/qG4M1Impy774HKMZ3Hsq7vlBJy7sXl1fI9QDXI=";
          });
        }).appendPatches
          windowsPatches;

      nix_2_34 = addTests "nix_2_34" self.nixComponents_2_34.nix-everything;

      nixComponents_2_35 =
        (nixDependencies.callPackage ./modular/packages.nix rec {
          version = "2.35.3";
          inherit teams;
          otherSplices = generateSplicesForNixComponents "nixComponents_2_35";
          src = removeFunctionalTests commonDisabledTests (fetchFromGitHub {
            owner = "NixOS";
            repo = "nix";
            tag = version;
            hash = "sha256-qtlx8ywd1qj2ToZTNBunXE7JUajLtw44ja3r7+d47D4=";
          });
        }).appendPatches
          windowsPatches;

      nix_2_35 = addTests "nix_2_35" self.nixComponents_2_35.nix-everything;

      nixComponents_git =
        let
          src = fetchFromGitHub {
            owner = "NixOS";
            repo = "nix";
            rev = "f3f184834895f45030d69f20a311b2eac99ebf1d";
            hash = "sha256-TyuLrhxjzHjIYWtpBgSHi8wdKw7ciLiyfrdfJe33uEc=";
          };
        in
        (nixDependencies.callPackage ./modular/packages.nix {
          version = "2.36pre20261020_${lib.substring 0 8 src.rev}";
          inherit teams;
          otherSplices = generateSplicesForNixComponents "nixComponents_git";
          src = removeFunctionalTests commonDisabledTests src;
        }).appendPatches
          [ ];

      git = addTests "git" self.nixComponents_git.nix-everything;

      latest = self.nix_2_35;

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
        nixComponents_2_27 = throw "nixComponents_2_27 has been removed. use nixComponents_2_34.";
        nixComponents_2_29 = throw "nixComponents_2_29 has been removed. use nixComponents_2_34.";
        nixComponents_2_30 = throw "nixComponents_2_30 has been removed. use nixComponents_2_34.";
        nixComponents_2_31 = throw "nixComponents_2_31 has been removed. use nixComponents_2_34.";
        nixComponents_2_32 = throw "nixComponents_2_32 has been removed. use nixComponents_2_34.";
        nixComponents_2_33 = throw "nixComponents_2_33 has been removed. use nixComponents_2_34.";
        nix_2_24 = throw "nix_2_24 has been removed. use nix_2_34.";
        nix_2_26 = throw "nix_2_26 has been removed. use nix_2_34.";
        nix_2_27 = throw "nix_2_27 has been removed. use nix_2_34.";
        nix_2_25 = throw "nix_2_25 has been removed. use nix_2_34.";
        nix_2_28 = throw "nix_2_28 has been removed. use nix_2_34.";
        nix_2_29 = throw "nix_2_29 has been removed. use nix_2_34.";
        nix_2_30 = throw "nix_2_30 has been removed. use nix_2_34.";
        nix_2_31 = throw "nix_2_31 has been removed. use nix_2_34.";
        nix_2_32 = throw "nix_2_32 has been removed. use nix_2_34.";
        nix_2_33 = throw "nix_2_33 has been removed. use nix_2_34.";

        minimum = throw "nixVersions.minimum has been removed. Use a specific version instead.";
        unstable = throw "nixVersions.unstable has been removed. use nixVersions.latest or the nix flake.";
      }
    )
  )
)
