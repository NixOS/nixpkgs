{
  lib,
  aws-sdk-cpp,
  boehmgc,
  callPackage,
  fetchgit,
  fetchFromGitHub,
  rustPlatform,
  Security,
  newScope,

  storeDir ? "/nix/store",
  stateDir ? "/nix/var",
  confDir ? "/etc",
}:
let
  makeLixScope =
    {
      lix-args,
      nix-eval-jobs-args,
    }:
    lib.makeScope newScope (
      self:
      lib.recurseIntoAttrs {
        inherit
          Security
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

        # NOTE: The `common-*.nix` helpers contain a top-level function which
        # takes the Lix source to build and version information. We use the
        # outer `callPackage` for that.
        #
        # That *returns* another function which takes the actual build
        # dependencies, and that uses the new scope's `self.callPackage` so
        # that `nix-eval-jobs` can be built against the correct `lix` version.
        lix = self.callPackage (callPackage ./common-lix.nix lix-args) { };

        nix-eval-jobs = self.callPackage (callPackage ./common-nix-eval-jobs.nix nix-eval-jobs-args) { };
      }
    );

in
lib.makeExtensible (self: {
  inherit makeLixScope;

  lix_2_90 = self.makeLixScope {
    lix-args = rec {
      version = "2.90.0";

      src = fetchFromGitHub {
        owner = "lix-project";
        repo = "lix";
        rev = version;
        hash = "sha256-f8k+BezKdJfmE+k7zgBJiohtS3VkkriycdXYsKOm3sc=";
      };

      docCargoDeps = rustPlatform.fetchCargoVendor {
        name = "lix-doc-${version}";
        inherit src;
        allowGitDependencies = false;
        sourceRoot = "${src.name or src}/lix-doc";
        hash = "sha256-VPcrf78gfLlkTRrcbLkPgLOk0o6lsOJBm6HYLvavpNU=";
      };
    };

    nix-eval-jobs-args = {
      version = "2.90.0";
      src = fetchgit {
        url = "https://git.lix.systems/lix-project/nix-eval-jobs.git";
        # https://git.lix.systems/lix-project/nix-eval-jobs/commits/branch/release-2.90
        rev = "9c23772cf25e0d891bef70b7bcb7df36239672a5";
        hash = "sha256-oT273pDmYzzI7ACAFUOcsxtT6y34V5KF7VBSqTza7j8=";
      };
    };
  };

  lix_2_91 = self.makeLixScope {
    lix-args = rec {
      version = "2.91.1";

      src = fetchFromGitHub {
        owner = "lix-project";
        repo = "lix";
        rev = version;
        hash = "sha256-hiGtfzxFkDc9TSYsb96Whg0vnqBVV7CUxyscZNhed0U=";
      };

      docCargoDeps = rustPlatform.fetchCargoVendor {
        name = "lix-doc-${version}";
        inherit src;
        allowGitDependencies = false;
        sourceRoot = "${src.name or src}/lix-doc";
        hash = "sha256-U820gvcbQIBaFr2OWPidfFIDXycDFGgXX1NpWDDqENs=";
      };
    };

    nix-eval-jobs-args = {
      version = "2.91.0";
      src = fetchgit {
        url = "https://git.lix.systems/lix-project/nix-eval-jobs.git";
        # https://git.lix.systems/lix-project/nix-eval-jobs/commits/branch/release-2.91
        rev = "1f98b0c016a6285f29ad278fa5cd82b8f470d66a";
        hash = "sha256-ZJKOC/iLuO8qjPi9/ql69Vgh3NIu0tU6CSI0vbiCrKA=";
      };
    };
  };

  latest = self.lix_2_91;
  stable = self.lix_2_91;

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
      lix_2_90 = mkAlias "lix_2_90";
      lix_2_91 = mkAlias "lix_2_91";
      # NOTE: Do not add new versions of Lix here.
      stable = mkAlias "stable";
      latest = mkAlias "latest";
    };
})
