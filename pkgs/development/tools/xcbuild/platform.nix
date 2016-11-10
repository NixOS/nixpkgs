{ stdenv, sdk, writeText, platformName, xcbuild }:

let

  Info = {
    CFBundleIdentifier = platformName;
    Type = "Platform";
    Name = "macosx";
  };

  Version = {
    ProjectName = "OSXPlatformSupport";
  };

in

stdenv.mkDerivation {
  name = "nixpkgs.platform";
  buildInputs = [ xcbuild ];
  buildCommand = ''
    mkdir -p $out/
    cd $out/

    plutil -convert xml1 -o Info.plist ${writeText "Info.plist" (builtins.toJSON Info)}
    plutil -convert xml1 -o version.plist ${writeText "version.plist" (builtins.toJSON Version)}

    mkdir -p $out/Developer/SDKs/
    cd $out/Developer/SDKs/
    ln -s ${sdk}
  '';
}
