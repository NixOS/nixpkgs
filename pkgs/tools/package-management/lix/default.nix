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
              boehmgc-nix_2_3 = boehmgc.override { enableLargeConfig = true; };
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
      };
    };

    git = self.makeLixScope {
      attrName = "git";

      lix-args = rec {
        version = "2.94.0-pre-20250807_${builtins.substring 0 12 src.rev}";

        src = fetchFromGitea {
          domain = "git.lix.systems";
          owner = "lix-project";
          repo = "lix";
          rev = "8bbd5e1d0df9c31b4d86ba07bc85beb952e42ccb";
          hash = "sha256-P+WiN95OjCqHhfygglS/VOFTSj7qNdL5XQDo2wxhQqg=";
        };

        cargoDeps = rustPlatform.fetchCargoVendor {
          name = "lix-${version}";
          inherit src;
          hash = "sha256-APm8m6SVEAO17BBCka13u85/87Bj+LePP7Y3zHA3Mpg=";
        };
      };
    };

    latest = self.lix_2_93;

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
