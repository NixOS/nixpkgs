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
      version = "2.90.0-rc1";
      hash = "sha256-WY7BGnu5PnbK4O8cKKv9kvxwzZIGbIQUQLGPHFXitI0=";
      docCargoHash = "sha256-V/MEC2aRlVrt/IKozyYZvZTXENrtDS/wsV08/ao4TCw=";
    }
  );

  latest = self.lix_2_90;
  stable = self.lix_2_90;
}))
