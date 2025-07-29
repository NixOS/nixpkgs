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
