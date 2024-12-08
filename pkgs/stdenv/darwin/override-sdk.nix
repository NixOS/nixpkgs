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
  newVersion = {
    inherit (stdenv.hostPlatform) darwinMinVersion darwinSdkVersion;
  } // (if lib.isAttrs sdkVersion then sdkVersion else { darwinSdkVersion = sdkVersion; });

  inherit (newVersion) darwinMinVersion darwinSdkVersion;

  sdkMapping = {
    "11.0" = pkgsHostTarget.apple-sdk_11;
    "12.3" = pkgsHostTarget.apple-sdk_12;
  };

  minVersionHook = pkgsHostTarget.darwinMinVersionHook darwinMinVersion;

  resolvedSdk =
    sdkMapping.${darwinSdkVersion} or (lib.throw ''
      `overrideSDK` and `darwin.apple_sdk_11_0.callPackage` are deprecated.
      Only the 11.0 and 12.3 SDKs are supported using them. Please use
      the versioned `apple-sdk` variants to use other SDK versions.

      See the stdenv documentation for how to use `apple-sdk`.
    '');
in
stdenv.override (old: {
  mkDerivationFromStdenv = extendMkDerivationArgs old (args: {
    buildInputs =
      args.buildInputs or [ ]
      ++ lib.optional (stdenv.hostPlatform.darwinMinVersion != darwinMinVersion) minVersionHook
      ++ lib.optional (stdenv.hostPlatform.darwinSdkVersion != darwinSdkVersion) resolvedSdk;
  });
})
