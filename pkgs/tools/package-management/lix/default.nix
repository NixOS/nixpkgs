{
  lib,
  config,
  stdenv,
  makeScopeWithSplicing',
  generateSplicesForMkScope,
  aws-sdk-cpp,
  boehmgc,
  callPackage,
  fetchgit,
  fetchFromGitHub,
  fetchFromGitea,
  fetchpatch2,
  fetchpatch,
  rustPlatform,
  editline,
  ncurses,
  clangStdenv,
  nixpkgs-review,
  nix-direnv,
  nix-fast-build,
  haskell,
  nix-serve-ng,
  colmena,
  nix-update,
  nix-init,

  storeDir ? "/nix/store",
  stateDir ? "/nix/var",
  confDir ? "/etc",
}:
let
  makeLixScope =
    {
      attrName,
      lix-args,
      # Starting with 2.93, `nix-eval-jobs` lives in the `lix` repository.
      nix-eval-jobs-args ? { inherit (lix-args) version src; },
    }:
    let
      # GCC 13.2 is known to miscompile Lix coroutines (introduced in 2.92).
      lixStdenv = if lib.versionAtLeast lix-args.version "2.92" then clangStdenv else stdenv;
    in
    makeScopeWithSplicing' {
      otherSplices = generateSplicesForMkScope [
        "lixPackageSets"
        attrName
      ];
      f =
        self:
        lib.recurseIntoAttrs {
          inherit
            storeDir
            stateDir
            confDir
            ;

          boehmgc =
            # TODO: Why is this called `boehmgc-nix_2_3`?
            let
              boehmgc-nix_2_3 = boehmgc.override {
                enableLargeConfig = true;
                initialMarkStackSize = 1048576;
              };
            in
            # Since Lix 2.91 does not use boost coroutines, it does not need boehmgc patches either.
            if lib.versionOlder lix-args.version "2.91" then
              boehmgc-nix_2_3.overrideAttrs (drv: {
                patches = (drv.patches or [ ]) ++ [
                  # Part of the GC solution in https://github.com/NixOS/nix/pull/4944
                  ../nix/patches/boehmgc-coroutine-sp-fallback.patch
                ];
              })
            else
              boehmgc-nix_2_3;

          aws-sdk-cpp =
            (aws-sdk-cpp.override {
              apis = [
                "s3"
                "transfer"
              ];
              customMemoryManagement = false;
            }).overrideAttrs
              {
                # only a stripped down version is build which takes a lot less resources to build
                requiredSystemFeatures = [ ];
              };

          editline = editline.override {
            inherit ncurses;
            enableTermcap = true;
          };

          # NOTE: The `common-*.nix` helpers contain a top-level function which
          # takes the Lix source to build and version information. We use the
          # outer `callPackage` for that.
          #
          # That *returns* another function which takes the actual build
          # dependencies, and that uses the new scope's `self.callPackage` so
          # that `nix-eval-jobs` can be built against the correct `lix` version.
          lix = self.callPackage (callPackage ./common-lix.nix lix-args) {
            stdenv = lixStdenv;
          };

          nixpkgs-review = nixpkgs-review.override {
            nix = self.lix;
          };

          nix-direnv = nix-direnv.override {
            nix = self.lix;
          };

          nix-eval-jobs = self.callPackage (callPackage ./common-nix-eval-jobs.nix nix-eval-jobs-args) {
            stdenv = lixStdenv;
          };

          nix-fast-build = nix-fast-build.override {
            inherit (self) nix-eval-jobs;
          };

          nix-serve-ng = lib.pipe (nix-serve-ng.override { nix = self.lix; }) [
            (haskell.lib.compose.enableCabalFlag "lix")
            (haskell.lib.compose.overrideCabal (drv: {
              # https://github.com/aristanetworks/nix-serve-ng/issues/46
              # Resetting (previous) broken flag since it may be related to C++ Nix
              broken = lib.versionAtLeast self.lix.version "2.93";
            }))
          ];

          colmena = colmena.override {
            nix = self.lix;
            inherit (self) nix-eval-jobs;
          };

          nix-update = nix-update.override {
            nix = self.lix;
            inherit (self) nixpkgs-review;
          };

          nix-init = nix-init.override {
            nix = self.lix;
          };
        };
    };

  removedMessage = version: ''
    Lix ${version} is now removed from this revision of Nixpkgs. Consider upgrading to stable or the latest version.

          If you notice a problem while upgrading disrupting your workflows which did not occur in version ${version}, please reach out to the Lix team.
  '';
in
lib.makeExtensible (
  self:
  {
    inherit makeLixScope;

    lix_2_93 = self.makeLixScope {
      attrName = "lix_2_93";

      lix-args = rec {
        version = "2.93.3";

        src = fetchFromGitea {
          domain = "git.lix.systems";
          owner = "lix-project";
          repo = "lix";
          rev = version;
          hash = "sha256-Oqw04eboDM8rrUgAXiT7w5F2uGrQdt8sGX+Mk6mVXZQ=";
        };

        cargoDeps = rustPlatform.fetchCargoVendor {
          name = "lix-${version}";
          inherit src;
          hash = "sha256-YMyNOXdlx0I30SkcmdW/6DU0BYc3ZOa2FMJSKMkr7I8=";
        };

        patches = [
          # Support for lowdown >= 1.4, https://gerrit.lix.systems/c/lix/+/3731
          (fetchpatch2 {
            name = "lix-lowdown-1.4.0.patch";
            url = "https://git.lix.systems/lix-project/lix/commit/858de5f47a1bfd33835ec97794ece339a88490f1.patch";
            hash = "sha256-FfLO2dFSWV1qwcupIg8dYEhCHir2XX6/Hs89eLwd+SY=";
          })

          # Support for toml11 >= 4.0, https://gerrit.lix.systems/c/lix/+/3953
          (fetchpatch {
            name = "lix-2.93-toml11-4-1.patch";
            url = "https://git.lix.systems/lix-project/lix/commit/96a39dc464165a3e503a6dc7bd44518a116fe846.patch";
            hash = "sha256-j1DOScY2IFvcouhoap9CQwIZf99MZ92HtY7CjInF/s4=";
          })
          (fetchpatch {
            name = "lix-2.93-toml11-4-2.patch";
            url = "https://git.lix.systems/lix-project/lix/commit/699d3a63a6351edfdbc8c05f814cc93d6c3637ca.patch";
            hash = "sha256-2iUynAdimxhe5ZSDB7DlzFG3tu1yWhq+lTvjf6+M0pM=";
          })
          (fetchpatch {
            name = "lix-2.93-toml11-4-3.patch";
            url = "https://git.lix.systems/lix-project/lix/commit/ad52cbde2faa677b711ec950dae74e4aede965a4.patch";
            hash = "sha256-ajQwafL3yZDJMVrR+D9eTGh7L0xbDbqhAUagRur4HDE=";
          })
          (fetchpatch {
            name = "lix-2.93-toml11-4-4.patch";
            url = "https://git.lix.systems/lix-project/lix/commit/e29a1ccf0af2e2890ec7b7fde82f0e53a1d0aad9.patch";
            hash = "sha256-sXqZxCUtZsO7uEVk2AZx3IkP8b8EPVghYboetcQTp2A=";
          })
          (fetchpatch {
            name = "lix-2.93-toml11-4-5.patch";
            url = "https://git.lix.systems/lix-project/lix/commit/176b834464b7285b74a72d35df7470a46362ce60.patch";
            hash = "sha256-/KIszfHf2XoB+GeVvXad2AV8pazffYdQRDtIXb9tbj8=";
          })
          (fetchpatch {
            name = "lix-2.93-toml11-4-6.patch";
            url = "https://git.lix.systems/lix-project/lix/commit/b6d5670bcffebdd43352ea79b36135e35a8148d9.patch";
            hash = "sha256-f4s0TR5MhNMNM5TYLOR7K2/1rtZ389KDjTCKFVK0OcE=";
          })
        ];
      };
    };

    lix_2_94 = self.makeLixScope {
      attrName = "lix_2_94";

      lix-args = rec {
        version = "2.94.0";

        src = fetchFromGitea {
          domain = "git.lix.systems";
          owner = "lix-project";
          repo = "lix";
          rev = version;
          hash = "sha256-X6X3NhgLnpkgWUbLs0nLjusNx/el3L1EkVm6OHqY2z8=";
        };

        cargoDeps = rustPlatform.fetchCargoVendor {
          name = "lix-${version}";
          inherit src;
          hash = "sha256-APm8m6SVEAO17BBCka13u85/87Bj+LePP7Y3zHA3Mpg=";
        };
      };
    };

    git = self.makeLixScope {
      attrName = "git";

      lix-args = rec {
        version = "2.95.0-pre-20251121_${builtins.substring 0 12 src.rev}";

        src = fetchFromGitea {
          domain = "git.lix.systems";
          owner = "lix-project";
          repo = "lix";
          rev = "b707403a308030739dfeacc5b0aaaeef8ba3f633";
          hash = "sha256-kas7FT2J86DVJlPH5dNNHM56OgdQQyfCE/dX/EOKDp8=";
        };

        cargoDeps = rustPlatform.fetchCargoVendor {
          name = "lix-${version}";
          inherit src;
          hash = "sha256-APm8m6SVEAO17BBCka13u85/87Bj+LePP7Y3zHA3Mpg=";
        };
      };
    };

    latest = self.lix_2_94;

    stable = self.lix_2_93;

    # Previously, `nix-eval-jobs` was not packaged here, so we export an
    # attribute with the previously-expected structure for compatibility. This
    # is also available (for now) as `pkgs.lixVersions`.
    renamedDeprecatedLixVersions =
      let
        mkAlias =
          version:
          lib.warnOnInstantiate "'lixVersions.${version}' has been renamed to 'lixPackageSets.${version}.lix'"
            self.${version}.lix;
      in
      lib.dontRecurseIntoAttrs {
        # NOTE: Do not add new versions of Lix here.
        stable = mkAlias "stable";
        latest = mkAlias "latest";
      }
      // lib.optionalAttrs config.allowAliases {
        # Legacy removed versions. We keep their aliases until the lixPackageSets one is dropped.
        lix_2_90 = mkAlias "lix_2_90";
        lix_2_91 = mkAlias "lix_2_91";
      };
  }
  // lib.optionalAttrs config.allowAliases {
    # Removed versions.
    # When removing a version, add an alias with a date attached to it so we can clean it up after a while.
    lix_2_90 = throw (removedMessage "2.90"); # added in 2025-09-11
    lix_2_91 = throw (removedMessage "2.91"); # added in 2025-09-11
    lix_2_92 = throw (removedMessage "2.92"); # added in 2025-09-11
  }
)
