{
  lib,
  aws-sdk-cpp,
  boehmgc,
  callPackage,
  fetchFromGitHub,
  clangStdenv,
  stdenv,
  rustPlatform,
  Security,

  storeDir ? "/nix/store",
  stateDir ? "/nix/var",
  confDir ? "/etc",
}:
let
  boehmgc-nix_2_3 = boehmgc.override { enableLargeConfig = true; };

  boehmgc-nix = boehmgc-nix_2_3.overrideAttrs (drv: {
    patches = (drv.patches or [ ]) ++ [
      # Part of the GC solution in https://github.com/NixOS/nix/pull/4944
      ../nix/patches/boehmgc-coroutine-sp-fallback.patch
    ];
  });

  aws-sdk-cpp-nix =
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

  # Since Lix 2.91 does not use boost coroutines, it does not need boehmgc patches either.
  needsBoehmgcPatches = version: lib.versionOlder version "2.91";
  needsClang = version: lib.versionAtLeast version "2.92";

  common =
    args:
    callPackage (import ./common.nix ({ inherit lib; } // args)) {
      inherit
        Security
        storeDir
        stateDir
        confDir
        ;
      boehmgc = if needsBoehmgcPatches args.version then boehmgc-nix else boehmgc-nix_2_3;
      aws-sdk-cpp = aws-sdk-cpp-nix;
      stdenv = if (needsClang args.version) then clangStdenv else stdenv;
    };
in
lib.makeExtensible (self: {
  buildLix = common;

  lix_2_90 = (
    common rec {
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
    }
  );

  lix_2_91 = (
    common rec {
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
    }
  );

  lix_2_92 = (
    common rec {
      version = "2.92.0";
      src = fetchFromGitHub {
        owner = "lix-project";
        repo = "lix";
        rev = version;
        hash = "sha256-vm5Ddu2PFeu/zACE+M/xyT04sfZ4FApvyiUgrZ0BA84=";
      };

      cargoDeps = rustPlatform.fetchCargoVendor {
        name = "lix-${version}";
        inherit src;
        allowGitDependencies = false;
        hash = "sha256-YMyNOXdlx0I30SkcmdW/6DU0BYc3ZOa2FMJSKMkr7I8=";
      };
    }
  );

  latest = self.lix_2_92;
  stable = self.lix_2_92;
})
