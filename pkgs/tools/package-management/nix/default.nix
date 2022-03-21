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

  nix_2_4 = common {
    version = "2.4";
    sha256 = "sha256-op48CCDgLHK0qV1Batz4Ln5FqBiRjlE6qHTiZgt3b6k=";
    # https://github.com/NixOS/nix/pull/5537
    patches = [ ./patches/install-nlohmann_json-headers.patch ];
  };

  nix_2_5 = common {
    version = "2.5.1";
    sha256 = "sha256-GOsiqy9EaTwDn2PLZ4eFj1VkXcBUbqrqHehRE9GuGdU=";
    # https://github.com/NixOS/nix/pull/5536
    patches = [ ./patches/install-nlohmann_json-headers.patch ];
  };

  nix_2_6 = common {
    version = "2.6.1";
    sha256 = "sha256-E9iQ7f+9Z6xFcUvvfksTEfn8LsDfzmwrcRBC//5B3V0=";
  };

  nix_2_7 = common {
    version = "2.7.0";
    sha256 = "sha256-m8tqCS6uHveDon5GSro5yZor9H+sHeh+v/veF1IGw24=";
  };

  stable = self.nix_2_7;

  unstable = lib.lowPrio (common rec {
    version = "2.8";
    suffix = "pre20220311_${lib.substring 0 7 src.rev}";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "d5322698a2abbc6d141e1d244e17b0d226a2f18b";
      sha256 = "sha256-7rQSktGC8+DmeyGOnzFMy1QwAYnw4JJphv+lEwFCwfU=";
    };
  });
})
