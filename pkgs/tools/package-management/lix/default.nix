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
  nixpkgs-reviewFull,
  nil,
  nix-direnv,
  nix-du,
  nix-fast-build,
  nix-prefetch-github,
  haskell,
  nix-serve-ng,
  nixos-rebuild-ng,
  colmena,
  comma,
  nix-update,
  nix-init,
  nixos-option,
  nurl,

  storeDir ? "/nix/store",
  stateDir ? "/nix/var",
  confDir ? "/etc",
}:
let
  # Support for mdbook >= 0.5, https://git.lix.systems/lix-project/lix/issues/1051
  lixMdbookPatch = fetchpatch2 {
    name = "lix-mdbook-0.5-support.patch";
    url = "https://git.lix.systems/lix-project/lix/commit/54df89f601b3b4502a5c99173c9563495265d7e7.patch";
    excludes = [ "package.nix" ];
    hash = "sha256-uu/SIG8fgVVWhsGxmszTPHwe4SQtLgbxdShOMKbeg2w=";
  };

  lixLowdown30Patch = fetchpatch {
    name = "lix-lowdown-3.0-support.patch";
    url = "https://git.lix.systems/lix-project/lix/commit/af0390c27bdc401ece8f8192cb3024f0ff08e977.patch";
    excludes = [ "flake.nix" ];
    hash = "sha256-ZBkbgeZ/D7H2teX8bPy5NEG1aXbQVksTDV3aVBZdRPM=";
  };

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

          boehmgc = boehmgc.override {
            enableLargeConfig = true;
            initialMarkStackSize = 1048576;
          };

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

          # surprisingly nixpkgs-reviewFull.override { nix = self.lix; }
          # doesn't work, as the way nix-reviewFull is defined uses callPackage
          # which does it's own makeOverridable and hides the .override
          # from the derivation.
          nixpkgs-reviewFull = nixpkgs-reviewFull.override {
            nixpkgs-review = self.nixpkgs-review;
          };

          nil = nil.override {
            nix = self.lix;
          };

          nix-direnv = nix-direnv.override {
            nix = self.lix;
          };

          nix-du = nix-du.override {
            nix = self.lix;
          };

          nix-eval-jobs = self.callPackage (callPackage ./common-nix-eval-jobs.nix nix-eval-jobs-args) {
            stdenv = lixStdenv;
          };

          nix-fast-build = nix-fast-build.override {
            inherit (self) nix-eval-jobs;
          };

          nix-prefetch-github = nix-prefetch-github.override {
            nix = self.lix;
          };

          nix-serve-ng = lib.pipe (nix-serve-ng.override { nix = self.lix; }) [
            (haskell.lib.compose.enableCabalFlag "lix")
            (haskell.lib.compose.overrideCabal (drv: {
              # Resetting (previous) broken flag since it may be related to C++ Nix
              broken = false;
            }))
          ];

          nixos-rebuild-ng = nixos-rebuild-ng.override {
            nix = self.lix;
          };

          colmena = colmena.override {
            nix = self.lix;
            inherit (self) nix-eval-jobs;
          };

          comma = comma.override {
            nix = self.lix;
          };

          nix-update = nix-update.override {
            nix = self.lix;
            inherit (self) nixpkgs-review;
          };

          nix-init = nix-init.override {
            nix = self.lix;
            inherit (self) nurl;
          };

          nurl = nurl.override {
            nix = self.lix;
          };

          nixos-option = nixos-option.override {
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

    lix_2_94 = self.makeLixScope {
      attrName = "lix_2_94";

      lix-args = rec {
        version = "2.94.1";

        src = fetchFromGitea {
          domain = "git.lix.systems";
          owner = "lix-project";
          repo = "lix";
          rev = version;
          hash = "sha256-+VJmizrdZPygtffgS/yfMb4PkZUUK5JmyGGzn0GPsKc=";
        };

        cargoDeps = rustPlatform.fetchCargoVendor {
          name = "lix-${version}";
          inherit src;
          hash = "sha256-APm8m6SVEAO17BBCka13u85/87Bj+LePP7Y3zHA3Mpg=";
        };

        patches = [
          lixMdbookPatch
          lixLowdown30Patch
        ];
      };
    };

    lix_2_95 = self.makeLixScope {
      attrName = "lix_2_95";

      lix-args = rec {
        version = "2.95.1";

        src = fetchFromGitea {
          domain = "git.lix.systems";
          owner = "lix-project";
          repo = "lix";
          rev = version;
          hash = "sha256-eZEynXdDcrjDMjGVfDhFJJrU5ENal7wlx7bn/wkggTg=";
        };

        cargoDeps = rustPlatform.fetchCargoVendor {
          name = "lix-${version}";
          inherit src;
          hash = "sha256-a5XtutX+NS4wOqxeqbscWZMs99teKick5+cQfbCRGxQ=";
        };
      };
    };

    git = self.makeLixScope {
      attrName = "git";

      lix-args = rec {
        version = "2.96.0-pre-20260408_${builtins.substring 0 12 src.rev}";

        src = fetchFromGitea {
          domain = "git.lix.systems";
          owner = "lix-project";
          repo = "lix";
          rev = "bc9fb560ac2d36cd317a856ee96785ea2055fbff";
          hash = "sha256-bONRPjhk5OZdnkQZexZNJzlvwIPg31Gy7fNiwGoX3BQ=";
        };

        cargoDeps = rustPlatform.fetchCargoVendor {
          name = "lix-${version}";
          inherit src;
          hash = "sha256-a5XtutX+NS4wOqxeqbscWZMs99teKick5+cQfbCRGxQ=";
        };
      };
    };

    latest = self.lix_2_95;

    stable = self.lix_2_94;

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
    lix_2_93 = throw (removedMessage "2.93"); # added in 2026-04-19
  }
)
