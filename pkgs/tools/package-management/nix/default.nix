{ lib
, aws-sdk-cpp
, boehmgc
, curl
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
      (import ./common.nix ({ inherit lib fetchFromGitHub curl; } // args))
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

  nix_2_4 = throw "nixVersions.nix_2_4 has been removed";

  nix_2_5 = throw "nixVersions.nix_2_5 has been removed";

  nix_2_6 = throw "nixVersions.nix_2_6 has been removed";

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

  nix_2_9 = common {
    version = "2.9.2";
    sha256 = "sha256-uZCaBo9rdWRO/AlQMvVVjpAwzYijB2H5KKQqde6eHkg=";
  };

  nix_2_10 = common {
    version = "2.10.3";
    sha256 = "sha256-B9EyDUz/9tlcWwf24lwxCFmkxuPTVW7HFYvp0C4xGbc=";
    patches = [ ./patches/flaky-tests.patch ];
  };

  stable = self.nix_2_10;

  unstable = self.stable;
})
