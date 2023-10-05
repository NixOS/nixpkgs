{ lib
, config
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

  # old nix fails to build with newer aws-sdk-cpp and the patch doesn't apply
  aws-sdk-cpp-old-nix = (aws-sdk-cpp.override {
    apis = [ "s3" "transfer" ];
    customMemoryManagement = false;
  }).overrideAttrs (args: rec {
    # intentionally overriding postPatch
    version = "1.9.294";

    src = fetchFromGitHub {
      owner = "aws";
      repo = "aws-sdk-cpp";
      rev = version;
      hash = "sha256-Z1eRKW+8nVD53GkNyYlZjCcT74MqFqqRMeMc33eIQ9g=";
    };
    postPatch = ''
      # Avoid blanket -Werror to evade build failures on less
      # tested compilers.
      substituteInPlace cmake/compiler_settings.cmake \
        --replace '"-Werror"' ' '

      # Missing includes for GCC11
      sed '5i#include <thread>' -i \
        aws-cpp-sdk-cloudfront-integration-tests/CloudfrontOperationTest.cpp \
        aws-cpp-sdk-cognitoidentity-integration-tests/IdentityPoolOperationTest.cpp \
        aws-cpp-sdk-dynamodb-integration-tests/TableOperationTest.cpp \
        aws-cpp-sdk-elasticfilesystem-integration-tests/ElasticFileSystemTest.cpp \
        aws-cpp-sdk-lambda-integration-tests/FunctionTest.cpp \
        aws-cpp-sdk-mediastore-data-integration-tests/MediaStoreDataTest.cpp \
        aws-cpp-sdk-queues/source/sqs/SQSQueue.cpp \
        aws-cpp-sdk-redshift-integration-tests/RedshiftClientTest.cpp \
        aws-cpp-sdk-s3-crt-integration-tests/BucketAndObjectOperationTest.cpp \
        aws-cpp-sdk-s3-integration-tests/BucketAndObjectOperationTest.cpp \
        aws-cpp-sdk-s3control-integration-tests/S3ControlTest.cpp \
        aws-cpp-sdk-sqs-integration-tests/QueueOperationTest.cpp \
        aws-cpp-sdk-transfer-tests/TransferTests.cpp
      # Flaky on Hydra
      rm aws-cpp-sdk-core-tests/aws/auth/AWSCredentialsProviderTest.cpp
      # Includes aws-c-auth private headers, so only works with submodule build
      rm aws-cpp-sdk-core-tests/aws/auth/AWSAuthSignerTest.cpp
      # TestRandomURLMultiThreaded fails
      rm aws-cpp-sdk-core-tests/http/HttpClientTest.cpp
    '' + lib.optionalString aws-sdk-cpp.stdenv.isi686 ''
      # EPSILON is exceeded
      rm aws-cpp-sdk-core-tests/aws/client/AdaptiveRetryStrategyTest.cpp
    '';

    patches = (args.patches or [ ]) ++ [ ./patches/aws-sdk-cpp-TransferManager-ContentEncoding.patch ];

    # only a stripped down version is build which takes a lot less resources to build
    requiredSystemFeatures = [ ];
  });

  aws-sdk-cpp-nix = (aws-sdk-cpp.override {
    apis = [ "s3" "transfer" ];
    customMemoryManagement = false;
  }).overrideAttrs {
    # only a stripped down version is build which takes a lot less resources to build
    requiredSystemFeatures = [ ];
  };


  common = args:
    callPackage
      (import ./common.nix ({ inherit lib fetchFromGitHub; } // args))
      {
        inherit Security storeDir stateDir confDir;
        boehmgc = boehmgc-nix;
        aws-sdk-cpp = if lib.versionAtLeast args.version "2.12pre" then aws-sdk-cpp-nix else aws-sdk-cpp-old-nix;
      };

  # https://github.com/NixOS/nix/pull/7585
  patch-monitorfdhup = fetchpatch2 {
    name = "nix-7585-monitor-fd-hup.patch";
    url = "https://github.com/NixOS/nix/commit/1df3d62c769dc68c279e89f68fdd3723ed3bcb5a.patch";
    hash = "sha256-f+F0fUO+bqyPXjt+IXJtISVr589hdc3y+Cdrxznb+Nk=";
  };

  # https://github.com/NixOS/nix/pull/7473
  patch-sqlite-exception = fetchpatch2 {
    name = "nix-7473-sqlite-exception-add-message.patch";
    url = "https://github.com/hercules-ci/nix/commit/c965f35de71cc9d88f912f6b90fd7213601e6eb8.patch";
    hash = "sha256-tI5nKU7SZgsJrxiskJ5nHZyfrWf5aZyKYExM0792N80=";
  };

  patch-non-existing-output = fetchpatch {
    # https://github.com/NixOS/nix/pull/7283
    name = "fix-requires-non-existing-output.patch";
    url = "https://github.com/NixOS/nix/commit/3ade5f5d6026b825a80bdcc221058c4f14e10a27.patch";
    hash = "sha256-s1ybRFCjQaSGj7LKu0Z5g7UiHqdJGeD+iPoQL0vaiS0=";
  };

  patch-fix-aarch64-darwin-static = fetchpatch {
    # https://github.com/NixOS/nix/pull/8068
    name = "fix-aarch64-darwin-static.patch";
    url = "https://github.com/NixOS/nix/commit/220aa8e0ac9d17de2c9f356a68be43b673d851a1.patch";
    hash = "sha256-YrmFkVpwPreiig1/BsP+DInpTdQrPmS7bEY0WUGpw+c=";
  };

in lib.makeExtensible (self: ({
  nix_2_3 = (common rec {
    version = "2.3.16";
    src = fetchurl {
      url = "https://nixos.org/releases/nix/nix-${version}/nix-${version}.tar.xz";
      hash = "sha256-fuaBtp8FtSVJLSAsO+3Nne4ZYLuBj2JpD2xEk7fCqrw=";
    };
    patches = [
      patch-monitorfdhup
    ];
  }).override { boehmgc = boehmgc-nix_2_3; };

  nix_2_10 = common {
    version = "2.10.3";
    hash = "sha256-B9EyDUz/9tlcWwf24lwxCFmkxuPTVW7HFYvp0C4xGbc=";
    patches = [
      ./patches/flaky-tests.patch
      patch-non-existing-output
      patch-monitorfdhup
      patch-sqlite-exception
    ];
  };

  nix_2_11 = common {
    version = "2.11.1";
    hash = "sha256-qCV65kw09AG+EkdchDPq7RoeBznX0Q6Qa4yzPqobdOk=";
    patches = [
      ./patches/flaky-tests.patch
      patch-non-existing-output
      patch-monitorfdhup
      patch-sqlite-exception
    ];
  };

  nix_2_12 = common {
    version = "2.12.1";
    hash = "sha256-GmHKhq0uFtdOiJnuBwj2YwlZjvh6YTkfQZgeu4e0dLU=";
    patches = [
      ./patches/flaky-tests.patch
      patch-monitorfdhup
      patch-sqlite-exception
    ];
  };

  nix_2_13 = common {
    version = "2.13.5";
    hash = "sha256-yHZMgMs/6/aQUwfMwmPUQov17JMGS7squLJsjmucnLc=";
    patches = [
      patch-fix-aarch64-darwin-static
    ];
  };

  nix_2_14 = common {
    version = "2.14.1";
    hash = "sha256-5aCmGZbsFcLIckCDfvnPD4clGPQI7qYAqHYlttN/Wkg=";
  };

  nix_2_15 = common {
    version = "2.15.2";
    hash = "sha256-0BxVsvp4JfliYu4EdpZ/zPYOt9Qn5w9Ix5r0sagZZ7o=";
  };

  nix_2_16 = common {
    version = "2.16.1";
    hash = "sha256-/XCWa2osNFIpPC5MkxlX6qTZf/DaTLwS3LWN0SRFiuU=";
  };

  nix_2_17 = common {
    version = "2.17.0";
    hash = "sha256-QMYAkdtU+g9HlZKtoJ+AI6TbWzzovKGnPZJHfZdclc8=";
  };

  nix_2_18 = common {
    version = "2.18.1";
    hash = "sha256-WNmifcTsN9aG1ONkv+l2BC4sHZZxtNKy0keqBHXXQ7w=";
  };

  # The minimum Nix version supported by Nixpkgs
  # Note that some functionality *might* have been backported into this Nix version,
  # making this package an inaccurate representation of what features are available
  # in the actual lowest minver.nix *patch* version.
  minimum =
    let
      minver = import ../../../../lib/minver.nix;
      major = lib.versions.major minver;
      minor = lib.versions.minor minver;
      attribute = "nix_${major}_${minor}";
      nix = self.${attribute};
    in
    if ! self ? ${attribute} then
      throw "The minimum supported Nix version is ${minver} (declared in lib/minver.nix), but pkgs.nixVersions.${attribute} does not exist."
    else
      nix;

  stable = self.nix_2_17;

  unstable = self.stable;
} // lib.optionalAttrs config.allowAliases {
  nix_2_4 = throw "nixVersions.nix_2_4 has been removed";

  nix_2_5 = throw "nixVersions.nix_2_5 has been removed";

  nix_2_6 = throw "nixVersions.nix_2_6 has been removed";

  nix_2_7 = throw "nixVersions.nix_2_7 has been removed";

  nix_2_8 = throw "nixVersions.nix_2_8 has been removed";

  nix_2_9 = throw "nixVersions.nix_2_9 has been removed";
}))
