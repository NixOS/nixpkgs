{ stdenv, writeText, toolchainName, sdkName, xcbuild }:

let

  SDKSettings = {
    CanonicalName = sdkName;
    DisplayName = sdkName;
    Toolchains = [ toolchainName ];
    Version = "10.10";
    MaximumDeploymentTarget = "10.10";
    isBaseSDK = "YES";
  };

  SystemVersion = {
    ProductName = "Mac OS X";
    ProductVersion = "10.10";
  };

in

stdenv.mkDerivation {
  name = "MacOSX.sdk";
  buildInputs = [ xcbuild ];
  buildCommand = ''
    mkdir -p $out/
    plutil -convert xml1 -o $out/SDKSettings.plist ${writeText "SDKSettings.json" (builtins.toJSON SDKSettings)}

    mkdir -p $out/System/Library/CoreServices/
    plutil -convert xml1 -o $out/System/Library/CoreServices/SystemVersion.plist ${writeText "SystemVersion.plist" (builtins.toJSON SystemVersion)}
  '';
}
