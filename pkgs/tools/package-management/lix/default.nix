{
  lib,
  aws-sdk-cpp,
  boehmgc,
  callPackage,
  fetchFromGitHub,
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

  common =
    args:
    callPackage (import ./common.nix ({ inherit lib fetchFromGitHub; } // args)) {
      inherit
        Security
        storeDir
        stateDir
        confDir
        ;
      boehmgc = boehmgc-nix;
      aws-sdk-cpp = aws-sdk-cpp-nix;
    };
in
lib.makeExtensible (self: ({
  buildLix = common;

  lix_2_90 = (
    common {
      version = "2.90.0";
      hash = "sha256-f8k+BezKdJfmE+k7zgBJiohtS3VkkriycdXYsKOm3sc=";
      docCargoHash = "sha256-vSf9MyD2XzofZlbzsmh6NP69G+LiX72GX4Um9UJp3dc=";
    }
  );

  latest = self.lix_2_90;
  stable = self.lix_2_90;
}))
