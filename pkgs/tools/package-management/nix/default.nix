{ lib
, aws-sdk-cpp
, boehmgc
, callPackage
, fetchFromGitHub
, fetchurl
, fetchpatch
, fetchpatch2
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

  # https://github.com/NixOS/nix/pull/7585
  patch-monitorfdhup = fetchpatch2 {
    name = "nix-7585-monitor-fd-hup.patch";
    url = "https://github.com/NixOS/nix/commit/1df3d62c769dc68c279e89f68fdd3723ed3bcb5a.patch";
    sha256 = "sha256-f+F0fUO+bqyPXjt+IXJtISVr589hdc3y+Cdrxznb+Nk=";
  };

  # https://github.com/NixOS/nix/pull/7473
  patch-sqlite-exception = fetchpatch2 {
    name = "nix-7473-sqlite-exception-add-message.patch";
    url = "https://github.com/hercules-ci/nix/commit/c965f35de71cc9d88f912f6b90fd7213601e6eb8.patch";
    sha256 = "sha256-tI5nKU7SZgsJrxiskJ5nHZyfrWf5aZyKYExM0792N80=";
  };

  patch-non-existing-output = fetchpatch {
    # https://github.com/NixOS/nix/pull/7283
    name = "fix-requires-non-existing-output.patch";
    url = "https://github.com/NixOS/nix/commit/3ade5f5d6026b825a80bdcc221058c4f14e10a27.patch";
    sha256 = "sha256-s1ybRFCjQaSGj7LKu0Z5g7UiHqdJGeD+iPoQL0vaiS0=";
  };

in lib.makeExtensible (self: {
  nix_2_3 = (common rec {
    version = "2.3.16";
    src = fetchurl {
      url = "https://nixos.org/releases/nix/nix-${version}/nix-${version}.tar.xz";
      sha256 = "sha256-fuaBtp8FtSVJLSAsO+3Nne4ZYLuBj2JpD2xEk7fCqrw=";
    };
    patches = [
      patch-monitorfdhup
    ];
  }).override { boehmgc = boehmgc-nix_2_3; };

  nix_2_4 = throw "nixVersions.nix_2_4 has been removed";

  nix_2_5 = throw "nixVersions.nix_2_5 has been removed";

  nix_2_6 = throw "nixVersions.nix_2_6 has been removed";

  nix_2_7 = throw "nixVersions.nix_2_7 has been removed";

  nix_2_8 = throw "nixVersions.nix_2_8 has been removed";

  nix_2_9 = throw "nixVersions.nix_2_9 has been removed";

  nix_2_10 = common {
    version = "2.10.3";
    sha256 = "sha256-B9EyDUz/9tlcWwf24lwxCFmkxuPTVW7HFYvp0C4xGbc=";
    patches = [
      ./patches/flaky-tests.patch
      patch-non-existing-output
      patch-monitorfdhup
      patch-sqlite-exception
    ];
  };

  nix_2_11 = common {
    version = "2.11.1";
    sha256 = "sha256-qCV65kw09AG+EkdchDPq7RoeBznX0Q6Qa4yzPqobdOk=";
    patches = [
      ./patches/flaky-tests.patch
      patch-non-existing-output
      patch-monitorfdhup
      patch-sqlite-exception
    ];
  };

  nix_2_12 = common {
    version = "2.12.1";
    sha256 = "sha256-GmHKhq0uFtdOiJnuBwj2YwlZjvh6YTkfQZgeu4e0dLU=";
    patches = [
      ./patches/flaky-tests.patch
      patch-monitorfdhup
      patch-sqlite-exception
    ];
  };

  nix_2_13 = common {
    version = "2.13.3";
    sha256 = "sha256-jUc2ccTR8f6MGY2pUKgujm+lxSPNGm/ZAP+toX+nMNc=";
  };

  nix_2_14 = common {
    version = "2.14.1";
    sha256 = "sha256-5aCmGZbsFcLIckCDfvnPD4clGPQI7qYAqHYlttN/Wkg=";
  };

  stable = self.nix_2_13;

  unstable = self.nix_2_14;
})
