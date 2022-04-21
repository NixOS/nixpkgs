{ lib
, aws-sdk-cpp
, boehmgc
, callPackage
, fetchFromGitHub
, fetchurl
, fetchpatch
, Security

, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
, confDir ? "/etc"
}:
let
  boehmgc-nix_2_3 = boehmgc.override { enableLargeConfig = true; };

  boehmgc-nix = boehmgc-nix_2_3.overrideAttrs (drv: {
    # Part of the GC solution in https://github.com/NixOS/nix/pull/4944
    patches = (drv.patches or [ ]) ++ [ ./patches/boehmgc-coroutine-sp-fallback.patch ];
  });

  aws-sdk-cpp-nix = (aws-sdk-cpp.override {
    apis = [ "s3" "transfer" ];
    customMemoryManagement = false;
  }).overrideDerivation (args: {
    patches = (args.patches or [ ]) ++ [ ./patches/aws-sdk-cpp-TransferManager-ContentEncoding.patch ];

    # only a stripped down version is build which takes a lot less resources to build
    requiredSystemFeatures = null;
  });

  common = args:
    callPackage
      (import ./common.nix ({ inherit lib fetchFromGitHub; } // args))
      {
        inherit Security storeDir stateDir confDir;
        boehmgc = boehmgc-nix;
        aws-sdk-cpp = aws-sdk-cpp-nix;
      };
in lib.makeExtensible (self: {
  nix_2_3 = (common rec {
    version = "2.3.16";
    src = fetchurl {
      url = "https://nixos.org/releases/nix/nix-${version}/nix-${version}.tar.xz";
      sha256 = "sha256-fuaBtp8FtSVJLSAsO+3Nne4ZYLuBj2JpD2xEk7fCqrw=";
    };
  }).override { boehmgc = boehmgc-nix_2_3; };

  nix_2_8 = common {
    version = "2.8.0";
    sha256 = "sha256-gWYNlEyleqkPfxtGXeq6ggjzJwcXJVdieJxA1Obly9s=";
  };

  stable = self.nix_2_8;
})
