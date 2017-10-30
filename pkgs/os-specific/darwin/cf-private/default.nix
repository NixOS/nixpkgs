{ stdenv, osx_private_sdk, CF }:

stdenv.mkDerivation {
  name = "${CF.name}-private";
  phases = [ "installPhase" "fixupPhase" ];
  installPhase = ''
    dest=$out/Library/Frameworks/CoreFoundation.framework/Headers
    mkdir -p $dest
    pushd $dest
      cp -Lv ${osx_private_sdk}/include/CoreFoundationPrivateHeaders/* $dest
      for file in ${CF}/Library/Frameworks/CoreFoundation.framework/Headers/*; do
        ln -sf $file 
      done
    popd

  '';

  setupHook = ./setup-hook.sh;
}
