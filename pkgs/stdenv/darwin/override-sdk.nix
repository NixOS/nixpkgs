# This is a compatibility shim with `overrideSDK`.
# Note: `overrideSDK` is deprecated. It will be added to `aliases.nix` after in-tree usage has been cleaned up.
{
  lib,
  stdenvNoCC,
  extendMkDerivationArgs,
  pkgsHostTarget,
}:

stdenv: sdkVersion:
let
  darwinSdkVersion =
    if lib.isAttrs sdkVersion then sdkVersion.darwinSdkVersion or "11.0" else sdkVersion;
in
assert lib.assertMsg (darwinSdkVersion == "11.0" || darwinSdkVersion == "12.3") ''
  `overrideSDK` and `darwin.apple_sdk_11_0.callPackage` are deprecated.
  Only the 11.0 and 12.3 SDKs are supported using them. Please use
  the versioned `apple-sdk` variants to use other SDK versions.

  See the stdenv documentation for how to use `apple-sdk`.
'';
stdenv.override (old: {
  mkDerivationFromStdenv = extendMkDerivationArgs old (args: {
    buildInputs =
      args.buildInputs or [ ]
      ++ lib.optional (darwinSdkVersion == "12.3") pkgsHostTarget.apple-sdk_12
      ++ lib.optional (sdkVersion ? darwinMinVersion) (
        pkgsHostTarget.darwinMinVersionHook sdkVersion.darwinMinVersion
      );
  });
})
