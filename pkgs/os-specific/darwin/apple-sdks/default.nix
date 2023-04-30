{
  callPackage,
  lib,
}: let
  builder = version: callPackage ./generic.nix {inherit version;};
  flatVersion = version: "${lib.versions.major version}_${lib.versions.minor version}";
  toAttrset = version: lib.nameValuePair "apple_sdk_${flatVersion version}" (builder version);
  versions = [
    "11.1.0"
    "11.3.0"
    "12.1.0"
    "12.3.0"
    "13.1.0"
    "13.3.0"
  ];
  appleSDKs = lib.pipe versions [
    (builtins.map toAttrset)
    builtins.listToAttrs
  ];
in
  appleSDKs
