regular@{
  lib,
  boehmgc,
  aws-sdk-cpp,
  fetchFromGitHub,
  pkgs,
}:

{
  scopeFunction = scope: {
    boehmgc = regular.boehmgc.override { enableLargeConfig = true; };

    # old nix fails to build with newer aws-sdk-cpp and the patch doesn't apply
    aws-sdk-cpp-old =
      (regular.aws-sdk-cpp.override {
        apis = [
          "s3"
          "transfer"
        ];
        customMemoryManagement = false;
      }).overrideAttrs
        (args: rec {
          # intentionally overriding postPatch
          version = "1.9.294";

          src = fetchFromGitHub {
            owner = "aws";
            repo = "aws-sdk-cpp";
            rev = version;
            hash = "sha256-Z1eRKW+8nVD53GkNyYlZjCcT74MqFqqRMeMc33eIQ9g=";
          };
          postPatch =
            ''
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
            ''
            + lib.optionalString aws-sdk-cpp.stdenv.hostPlatform.isi686 ''
              # EPSILON is exceeded
              rm aws-cpp-sdk-core-tests/aws/client/AdaptiveRetryStrategyTest.cpp
            '';

          patches = (args.patches or [ ]) ++ [ ./patches/aws-sdk-cpp-TransferManager-ContentEncoding.patch ];

          # only a stripped down version is build which takes a lot less resources to build
          requiredSystemFeatures = [ ];
        });

    aws-sdk-cpp =
      (regular.aws-sdk-cpp.override {
        apis = [
          "identity-management"
          "s3"
          "transfer"
        ];
        customMemoryManagement = false;
      }).overrideAttrs
        {
          # only a stripped down version is build which takes a lot less resources to build
          requiredSystemFeatures = [ ];
        };
  };
}
