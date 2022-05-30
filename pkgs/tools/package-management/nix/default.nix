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
    patches = [
      # remove when there's a 2.7.1 release
      # https://github.com/NixOS/nix/pull/6297
      # https://github.com/NixOS/nix/issues/6243
      # https://github.com/NixOS/nixpkgs/issues/163374
      (fetchpatch {
        url = "https://github.com/NixOS/nix/commit/c9afca59e87afe7d716101e6a75565b4f4b631f7.patch";
        sha256 = "sha256-xz7QnWVCI12lX1+K/Zr9UpB93b10t1HS9y/5n5FYf8Q=";
      })
    ];
  };

  nix_2_8 = common {
    version = "2.8.1";
    sha256 = "sha256-zldZ4SiwkISFXxrbY/UdwooIZ3Z/I6qKxtpc3zD0T/o=";
  };

  stable = self.nix_2_8;

  # remember to backport updates to the stable branch!
  unstable = lib.lowPrio (common rec {
    version = "2.8";
    suffix = "pre20220530_${lib.substring 0 7 src.rev}";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "af23d38019a47e5bb4cd6585a1678b37c957130c";
      sha256 = "sha256-RH77Y4IhbTofNYlLQSGKLL0fJAG9iHSwRNvMEZ4M0VQ=";
    };
  });
})
