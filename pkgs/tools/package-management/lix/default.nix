{
  lib,
  stdenv,
  makeScopeWithSplicing',
  generateSplicesForMkScope,
  aws-sdk-cpp,
  boehmgc,
  callPackage,
  fetchgit,
  fetchFromGitHub,
  fetchFromGitea,
  rustPlatform,
  editline,
  ncurses,
  clangStdenv,
  nixpkgs-review,
  nix-direnv,
  nix-fast-build,
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

          colmena = colmena.override {
            nix = self.lix;
            inherit (self) nix-eval-jobs;
          };
        };
    };
in
lib.makeExtensible (self: {
  inherit makeLixScope;

  lix_2_90 = self.makeLixScope {
    attrName = "lix_2_90";

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
        sourceRoot = "${src.name or src}/lix-doc";
        hash = "sha256-VPcrf78gfLlkTRrcbLkPgLOk0o6lsOJBm6HYLvavpNU=";
      };

      knownVulnerabilities = [
        "Lix 2.90 is vulnerable to CVE-2025-46415 and CVE-2025-46416 and will not receive updates."
      ];
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
    attrName = "lix_2_91";

    lix-args = rec {
      version = "2.91.3";

      src = fetchFromGitHub {
        owner = "lix-project";
        repo = "lix";
        rev = version;
        hash = "sha256-b5d+HnPcyHz0ZJW1+LZl4qm4LGTB/TiaDFQVlVL2xpE=";
      };

      docCargoDeps = rustPlatform.fetchCargoVendor {
        name = "lix-doc-${version}";
        inherit src;
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

  lix_2_92 = self.makeLixScope {
    attrName = "lix_2_92";

    lix-args = rec {
      version = "2.92.3";

      src = fetchFromGitHub {
        owner = "lix-project";
        repo = "lix";
        rev = version;
        hash = "sha256-iP2iUDxA99RcgQyZROs7bQw8pqxa1vFudRqjAIHg9Iw=";
      };

      cargoDeps = rustPlatform.fetchCargoVendor {
        name = "lix-${version}";
        inherit src;
        hash = "sha256-YMyNOXdlx0I30SkcmdW/6DU0BYc3ZOa2FMJSKMkr7I8=";
      };
    };

    nix-eval-jobs-args = rec {
      version = "2.92.0";
      src = fetchgit {
        url = "https://git.lix.systems/lix-project/nix-eval-jobs.git";
        rev = version;
        hash = "sha256-tPr61X9v/OMVt7VXOs1RRStciwN8gDGxEKx+h0/Fg48=";
      };
    };
  };

  lix_2_93 = self.makeLixScope {
    attrName = "lix_2_93";

    lix-args = rec {
      version = "2.93.2";

      src = fetchFromGitea {
        domain = "git.lix.systems";
        owner = "lix-project";
        repo = "lix";
        rev = version;
        hash = "sha256-J4ycLoXHPsoBoQtEXFCelL4xlq5pT8U9tNWNKm43+YI=";
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
      version = "2.94.0-pre-20250704_${builtins.substring 0 12 src.rev}";

      src = fetchFromGitea {
        domain = "git.lix.systems";
        owner = "lix-project";
        repo = "lix";
        rev = "362bfd827f522b57062e4ebcb465bb51941632a4";
        hash = "sha256-4CVRbeYExqIDpFH+QMZb5IeUGkP6kA/zHSuExYoZygk=";
      };

      cargoDeps = rustPlatform.fetchCargoVendor {
        name = "lix-${version}";
        inherit src;
        hash = "sha256-YMyNOXdlx0I30SkcmdW/6DU0BYc3ZOa2FMJSKMkr7I8=";
      };
    };
  };

  latest = self.lix_2_93;

  # Note: This is not yet 2.92 because of a non-deterministic `curl` error.
  # See: https://git.lix.systems/lix-project/lix/issues/662
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
