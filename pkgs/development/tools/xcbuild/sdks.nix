{
  runCommand,
  lib,
  toolchainName,
  sdkName,
  writeText,
  xcodePlatform,
  sdkVer,
  productBuildVer,
}:

let
  inherit (lib.generators) toPlist toJSON;

  SDKSettings = {
    CanonicalName = sdkName;
    DisplayName = sdkName;
    Toolchains = [ toolchainName ];
    Version = sdkVer;
    MaximumDeploymentTarget = sdkVer;
    isBaseSDK = "YES";
  };

  SystemVersion =
    lib.optionalAttrs (productBuildVer != null) {
      ProductBuildVersion = productBuildVer;
    }
    // {
      ProductName = "Mac OS X";
      ProductVersion = sdkVer;
    };
in

runCommand "SDKs" { } ''
  sdk=$out/${sdkName}.sdk
  install -D ${writeText "SDKSettings.plist" (toPlist { } SDKSettings)} $sdk/SDKSettings.plist
  install -D ${writeText "SDKSettings.json" (toJSON { } SDKSettings)} $sdk/SDKSettings.json
  install -D ${
    writeText "SystemVersion.plist" (toPlist { } SystemVersion)
  } $sdk/System/Library/CoreServices/SystemVersion.plist
  ln -s $sdk $sdk/usr

  ln -s $sdk $out/${xcodePlatform}.sdk
''
