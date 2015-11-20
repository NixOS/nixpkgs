{ stdenv, appleDerivation }:

appleDerivation {
  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/include/dispatch $out/include/os

    cp -r dispatch/*.h $out/include/dispatch
    cp -r private/*.h  $out/include/dispatch
    cp -r os/object*.h  $out/include/os
  '';
}
