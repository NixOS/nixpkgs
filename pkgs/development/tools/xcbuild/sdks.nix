{ runCommand, lib, toolchainName, sdkName, writeText, version, xcodePlatform }:

let
  inherit (lib.generators) toPlist;

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

runCommand "SDKs" {
  inherit version;
} ''
  sdk=$out/${sdkName}.sdk
  install -D ${writeText "SDKSettings.plist" (toPlist {} SDKSettings)} $sdk/SDKSettings.plist
  install -D ${writeText "SystemVersion.plist" (toPlist {} SystemVersion)} $sdk/System/Library/CoreServices/SystemVersion.plist
  ln -s $sdk $out/${xcodePlatform}.sdk
''
