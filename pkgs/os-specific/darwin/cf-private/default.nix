{ stdenv, osx_private_sdk, CF }:

let
  headers = [
    "CFAttributedString.h"
    "CFNotificationCenter.h"
    "CoreFoundation.h"
  ];

in stdenv.mkDerivation {
  name = "${CF.name}-private";
  unpackPhase = ":";
  buildPhase = ":";
  installPhase = ''
    mkdir -p $out/include/CoreFoundation
    install -m 0644 ${osx_private_sdk}/PrivateSDK10.10.sparse.sdk/System/Library/Frameworks/CoreFoundation.framework/Headers/{${stdenv.lib.concatStringsSep "," headers}} $out/include/CoreFoundation
  '';
}
