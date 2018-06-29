{ runCommand, lib, toolchainName, sdkName, writeText }:

let
  inherit (lib.generators) toPlist;

  # TODO: expose MACOSX_DEPLOYMENT_TARGET in nix so we can use it here.
  version = "10.10";

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

runCommand "MacOSX${version}.sdk" {
  inherit version;
} ''
  install -D ${writeText "SDKSettings.plist" (toPlist {} SDKSettings)} $out/SDKSettings.plist
  install -D ${writeText "SystemVersion.plist" (toPlist {} SystemVersion)} $out/System/Library/CoreServices/SystemVersion.plist
''
