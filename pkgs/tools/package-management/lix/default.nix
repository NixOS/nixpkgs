{
  lib,
  aws-sdk-cpp,
  boehmgc,
  callPackage,
  fetchgit,
  fetchFromGitHub,
  fetchpatch,
  rustPlatform,
  Security,
  newScope,
  editline,
  ncurses,

  storeDir ? "/nix/store",
  stateDir ? "/nix/var",
  confDir ? "/etc",
}:
let
  makeLixScope =
    {
      lix,
      nix-eval-jobs,
    }:
    lib.makeScope newScope (self: {
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
        if lib.versionOlder lix.version "2.91" then
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

      editline = editline.overrideAttrs (prev: {
        patches = (prev.patches or [ ]) ++ [
          # Recognize `Alt-Left` and `Alt-Right` for navigating by words in more
          # terminals/shells/platforms.
          #
          # See: https://github.com/troglobit/editline/pull/70
          (fetchpatch {
            url = "https://github.com/troglobit/editline/commit/fb4d7268de024ed31ad2417f533cc0cbc2cd9b29.diff";
            hash = "sha256-5zMsmpU5zFoffRUwFhI/vP57pEhGotcMPgn9AfI1SNg=";
          })
        ];

        configureFlags = (prev.configureFlags or [ ]) ++ [
          # Enable SIGSTOP (Ctrl-Z) behavior.
          (lib.enableFeature true "sigstop")
          # Enable ANSI arrow keys.
          (lib.enableFeature true "arrow-keys")
          # Use termcap library to query terminal size.
          (lib.enableFeature true "termcap")
        ];

        propagatedBuildInputs = (prev.propagatedBuildInputs or [ ]) ++ [ ncurses ];
      });

      # NOTE: The `common-*.nix` helpers contain a top-level function which
      # takes the Lix source to build and version information. We use the
      # outer `callPackage` for that.
      #
      # That *returns* another function which takes the actual build
      # dependencies, and that uses the new scope's `self.callPackage` so
      # that `nix-eval-jobs` can be built against the correct `lix` version.
      lix = self.callPackage (callPackage ./common-lix.nix lix) { };

      # TODO: Should this be named `lix-eval-jobs`?
      nix-eval-jobs = self.callPackage (callPackage ./common-nix-eval-jobs.nix nix-eval-jobs) { };
    });

in
lib.makeExtensible (self: {
  makeLixScope = makeLixScope;

  lix_2_90 = self.makeLixScope {
    lix = rec {
      version = "2.90.0";

      src = fetchFromGitHub {
        owner = "lix-project";
        repo = "lix";
        rev = version;
        hash = "sha256-f8k+BezKdJfmE+k7zgBJiohtS3VkkriycdXYsKOm3sc=";
      };

      docSourceRoot = "lix-doc";

      docCargoDeps = rustPlatform.fetchCargoVendor {
        name = "lix-doc-${version}";
        inherit src;
        allowGitDependencies = false;
        sourceRoot = "${src.name or src}/${docSourceRoot}";
        hash = "sha256-VPcrf78gfLlkTRrcbLkPgLOk0o6lsOJBm6HYLvavpNU=";
      };
    };

    nix-eval-jobs = {
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
    lix = rec {
      version = "2.91.1";

      src = fetchFromGitHub {
        owner = "lix-project";
        repo = "lix";
        rev = version;
        hash = "sha256-hiGtfzxFkDc9TSYsb96Whg0vnqBVV7CUxyscZNhed0U=";
      };

      docSourceRoot = "lix-doc";

      docCargoDeps = rustPlatform.fetchCargoVendor {
        name = "lix-doc-${version}";
        inherit src;
        allowGitDependencies = false;
        sourceRoot = "${src.name or src}/${docSourceRoot}";
        hash = "sha256-U820gvcbQIBaFr2OWPidfFIDXycDFGgXX1NpWDDqENs=";
      };
    };

    nix-eval-jobs = {
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
    lix = rec {
      version = "2.92.0";

      src = fetchFromGitHub {
        owner = "lix-project";
        repo = "lix";
        rev = version;
        hash = "sha256-CCKIAE84dzkrnlxJCKFyffAxP3yfsOAbdvydUGqq24g=";
      };

      docSourceRoot = "lix/lix-doc";

      docCargoDeps = rustPlatform.fetchCargoVendor {
        name = "lix-doc-${version}";
        inherit src;
        allowGitDependencies = false;
        hash = "sha256-YMyNOXdlx0I30SkcmdW/6DU0BYc3ZOa2FMJSKMkr7I8=";
      };
    };

    nix-eval-jobs = rec {
      version = "2.92.0";
      src = fetchgit {
        url = "https://git.lix.systems/lix-project/nix-eval-jobs.git";
        rev = version;
        hash = "sha256-tPr61X9v/OMVt7VXOs1RRStciwN8gDGxEKx+h0/Fg48=";
      };
    };
  };

  latest = self.lix_2_92;
  stable = self.lix_2_92;
})
