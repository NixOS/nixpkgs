{
  lib,
  aws-sdk-cpp,
  boehmgc,
  callPackage,
  fetchFromGitHub,
  fetchpatch,
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

  common =
    args:
    callPackage (import ./common.nix ({ inherit lib fetchFromGitHub; } // args)) {
      inherit
        Security
        storeDir
        stateDir
        confDir
        ;
      boehmgc = if needsBoehmgcPatches args.version then boehmgc-nix else boehmgc-nix_2_3;
      aws-sdk-cpp = aws-sdk-cpp-nix;
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

  latest = self.lix_2_91;
  stable = self.lix_2_91;
})
