{ runCommand, lib, toolchainName, sdkName
, writeText, version, xcodePlatform }:

let
  inherit (lib.generators) toPlist toJSON;

  SDKSettings = {
    CanonicalName = sdkName;
    DisplayName = sdkName;
    Toolchains = [ toolchainName ];
    Version = version;
    MaximumDeploymentTarget = version;
    isBaseSDK = "YES";
  };

  SystemVersion = {
    ProductName = "Mac OS X";
    ProductVersion = version;
  };
in

runCommand "SDKs" {} ''
  sdk=$out/${sdkName}.sdk
  install -D ${writeText "SDKSettings.plist" (toPlist {} SDKSettings)} $sdk/SDKSettings.plist
  install -D ${writeText "SDKSettings.json" (toJSON {} SDKSettings)} $sdk/SDKSettings.json
  install -D ${writeText "SystemVersion.plist" (toPlist {} SystemVersion)} $sdk/System/Library/CoreServices/SystemVersion.plist
  ln -s $sdk $sdk/usr

  ln -s $sdk $out/${xcodePlatform}.sdk
''
