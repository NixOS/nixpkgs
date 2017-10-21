{ stdenv, osx_private_sdk, CF }:

let
  headers = [
    "CFAvailability.h"
    "CFAttributedString.h"
    "CFFileDescriptor.h"
    "CFFileSecurity.h"
    "CFNotificationCenter.h"
    "CFStringTokenizer.h"
    "CFURLEnumerator.h"
    "CFURL.h"
    "CoreFoundation.h"
  ];

in stdenv.mkDerivation {
  name = "${CF.name}-private";
  phases = [ "installPhase" "fixupPhase" ];
  installPhase = ''
    dest=$out/Library/Frameworks/CoreFoundation.framework/Headers
    mkdir -p $dest
    pushd $dest
    for file in ${CF}/Library/Frameworks/CoreFoundation.framework/Headers/*; do
      ln -s $file
    done
    popd

    install -m 0644 ${osx_private_sdk}/PrivateSDK10.10.sparse.sdk/System/Library/Frameworks/CoreFoundation.framework/Headers/{${stdenv.lib.concatStringsSep "," headers}} $dest
  '';

  setupHook = ./setup-hook.sh;
}
