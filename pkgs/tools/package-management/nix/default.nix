{ lib
, config
, stdenv
, aws-sdk-cpp
, boehmgc
, libgit2
, callPackage
, fetchFromGitHub
, fetchpatch
, fetchpatch2
, runCommand
, overrideSDK
, buildPackages
, Security

, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
, confDir ? "/etc"
}:
let
  boehmgc-nix_2_3 = boehmgc.override { enableLargeConfig = true; };

  boehmgc-nix = boehmgc-nix_2_3.overrideAttrs (drv: {
    patches = (drv.patches or [ ]) ++ [
      # Part of the GC solution in https://github.com/NixOS/nix/pull/4944
      ./patches/boehmgc-coroutine-sp-fallback.patch
    ];
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

  libgit2-thin-packfile = libgit2.overrideAttrs (args: {
    nativeBuildInputs = args.nativeBuildInputs or []
      # gitMinimal does not build on Windows. See packbuilder patch.
      ++ lib.optionals (!stdenv.hostPlatform.isWindows) [
        # Needed for `git apply`; see `prePatch`
        buildPackages.gitMinimal
      ];
    # Only `git apply` can handle git binary patches
    prePatch = args.prePatch or ""
      + lib.optionalString (!stdenv.hostPlatform.isWindows) ''
        patch() {
          git apply
        }
      '';
    # taken from https://github.com/NixOS/nix/tree/master/packaging/patches
    patches = (args.patches or []) ++ [
      ./patches/libgit2-mempack-thin-packfile.patch
    ] ++ lib.optionals (!stdenv.hostPlatform.isWindows) [
      ./patches/libgit2-packbuilder-callback-interruptible.patch
    ];
  });

  common = args:
    callPackage
      (import ./common.nix ({ inherit lib fetchFromGitHub; } // args))
      {
        inherit Security storeDir stateDir confDir;
        boehmgc = boehmgc-nix;
        aws-sdk-cpp = if lib.versionAtLeast args.version "2.12pre" then aws-sdk-cpp-nix else aws-sdk-cpp-old-nix;
        libgit2 = if lib.versionAtLeast args.version "2.25.0" then libgit2-thin-packfile else libgit2;
      };

  # https://github.com/NixOS/nix/pull/7585
  patch-monitorfdhup = fetchpatch2 {
    name = "nix-7585-monitor-fd-hup.patch";
    url = "https://github.com/NixOS/nix/commit/1df3d62c769dc68c279e89f68fdd3723ed3bcb5a.patch";
    hash = "sha256-f+F0fUO+bqyPXjt+IXJtISVr589hdc3y+Cdrxznb+Nk=";
  };

  # Intentionally does not support overrideAttrs etc
  # Use only for tests that are about the package relation to `pkgs` and/or NixOS.
  addTestsShallowly = tests: pkg: pkg // {
    tests = pkg.tests // tests;
    # In case someone reads the wrong attribute
    passthru.tests = pkg.tests // tests;
  };

  addFallbackPathsCheck = pkg: addTestsShallowly
    { nix-fallback-paths =
        runCommand "test-nix-fallback-paths-version-equals-nix-stable" {
          paths = lib.concatStringsSep "\n" (builtins.attrValues (import ../../../../nixos/modules/installer/tools/nix-fallback-paths.nix));
        } ''
          if [[ "" != $(grep -v 'nix-${pkg.version}$' <<< "$paths") ]]; then
            echo "nix-fallback-paths not up to date with nixVersions.stable (nix-${pkg.version})"
            echo "The following paths are not up to date:"
            grep -v 'nix-${pkg.version}$' <<< "$paths"
            echo
            echo "Fix it by running in nixpkgs:"
            echo
            echo "curl https://releases.nixos.org/nix/nix-${pkg.version}/fallback-paths.nix >nixos/modules/installer/tools/nix-fallback-paths.nix"
            echo
            exit 1
          else
            echo "nix-fallback-paths versions up to date"
            touch $out
          fi
        '';
    }
    pkg;

in lib.makeExtensible (self: ({
  nix_2_3 = ((common {
    version = "2.3.18";
    hash = "sha256-jBz2Ub65eFYG+aWgSI3AJYvLSghio77fWQiIW1svA9U=";
    patches = [
      patch-monitorfdhup
    ];
    self_attribute_name = "nix_2_3";
    maintainers = with lib.maintainers; [ flokli ];
  }).override { boehmgc = boehmgc-nix_2_3; }).overrideAttrs {
    # https://github.com/NixOS/nix/issues/10222
    # spurious test/add.sh failures
    enableParallelChecking = false;
  };

  nix_2_18 = common {
    version = "2.18.8";
    hash = "sha256-0rHRifdjzzxMh/im8pRx6XoY62irDTDUes+Pn0CR65I=";
    self_attribute_name = "nix_2_18";
  };

  nix_2_19 = common {
    version = "2.19.6";
    hash = "sha256-XT5xiwOLgXf+TdyOjbJVOl992wu9mBO25WXHoyli/Tk=";
    self_attribute_name = "nix_2_19";
  };

  nix_2_20 = common {
    version = "2.20.8";
    hash = "sha256-M2tkMtjKi8LDdNLsKi3IvD8oY/i3rtarjMpvhybS3WY=";
    self_attribute_name = "nix_2_20";
  };

  nix_2_21 = common {
    version = "2.21.4";
    hash = "sha256-c6nVZ0pSrfhFX3eVKqayS+ioqyAGp3zG9ZPO5rkXFRQ=";
    self_attribute_name = "nix_2_21";
  };

  nix_2_22 = common {
    version = "2.22.3";
    hash = "sha256-l04csH5rTWsK7eXPWVxJBUVRPMZXllFoSkYFTq/i8WU=";
    self_attribute_name = "nix_2_22";
  };

  nix_2_23 = common {
    version = "2.23.3";
    hash = "sha256-lAoLGVIhRFrfgv7wcyduEkyc83QKrtsfsq4of+WrBeg=";
    self_attribute_name = "nix_2_23";
  };

  nix_2_24 = (common {
    version = "2.24.8";
    hash = "sha256-YPJA0stZucs13Y2DQr3JIL6JfakP//LDbYXNhic/rKk=";
    self_attribute_name = "nix_2_24";
  }).override (lib.optionalAttrs (stdenv.isDarwin && stdenv.isx86_64) {
    # Fix the following error with the default x86_64-darwin SDK:
    #
    #     error: aligned allocation function of type 'void *(std::size_t, std::align_val_t)' is only available on macOS 10.13 or newer
    #
    # Despite the use of the 10.13 deployment target here, the aligned
    # allocation function Clang uses with this setting actually works
    # all the way back to 10.6.
    stdenv = overrideSDK stdenv { darwinMinVersion = "10.13"; };
  });

  git = (common rec {
    version = "2.25.0";
    suffix = "pre20240920_${lib.substring 0 8 src.rev}";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "ca3fc1693b309ab6b8b0c09408a08d0055bf0363";
      hash = "sha256-Hp7dkx7zfB9a4l5QusXUob0b1T2qdZ23LFo5dcp3xrU=";
    };
    self_attribute_name = "git";
  }).override (lib.optionalAttrs (stdenv.isDarwin && stdenv.isx86_64) {
    # Fix the following error with the default x86_64-darwin SDK:
    #
    #     error: aligned allocation function of type 'void *(std::size_t, std::align_val_t)' is only available on macOS 10.13 or newer
    #
    # Despite the use of the 10.13 deployment target here, the aligned
    # allocation function Clang uses with this setting actually works
    # all the way back to 10.6.
    stdenv = overrideSDK stdenv { darwinMinVersion = "10.13"; };
  });

  latest = self.nix_2_24;

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

  stable = addFallbackPathsCheck self.nix_2_18;
} // lib.optionalAttrs config.allowAliases (
  lib.listToAttrs (map (
    minor:
    let
      attr = "nix_2_${toString minor}";
    in
    lib.nameValuePair attr (throw "${attr} has been removed")
  ) (lib.range 4 17))
  // {
    unstable = throw "nixVersions.unstable has been removed. For bleeding edge (Nix master, roughly weekly updated) use nixVersions.git, otherwise use nixVersions.latest.";
  }
)))
