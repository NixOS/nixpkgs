{ stdenv, writeText, toolchainName, sdkName, xcbuild }:

let
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

stdenv.mkDerivation {
  name = "MacOSX${version}.sdk";
  inherit version;

  buildInputs = [ xcbuild ];

  buildCommand = ''
    mkdir -p $out/
    plutil -convert xml1 -o $out/SDKSettings.plist ${writeText "SDKSettings.json" (builtins.toJSON SDKSettings)}

    mkdir -p $out/System/Library/CoreServices/
    plutil -convert xml1 -o $out/System/Library/CoreServices/SystemVersion.plist ${writeText "SystemVersion.plist" (builtins.toJSON SystemVersion)}
  '';
}
