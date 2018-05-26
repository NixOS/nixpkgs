{ stdenv, osx_private_sdk, CF }:

stdenv.mkDerivation {
  name = "${CF.name}-private";
  phases = [ "installPhase" "fixupPhase" ];
  installPhase = ''
    dest=$out/Library/Frameworks/CoreFoundation.framework/Headers
    mkdir -p $dest
    pushd $dest
      for file in ${CF}/Library/Frameworks/CoreFoundation.framework/Headers/*; do
        ln -sf $file
      done

      # Copy or overwrite private headers, some of these might already
      # exist in CF but the private versions have more information.
      cp -Lfv ${osx_private_sdk}/include/CoreFoundationPrivateHeaders/* $dest
    popd
  '';

  setupHook = ./setup-hook.sh;
}
