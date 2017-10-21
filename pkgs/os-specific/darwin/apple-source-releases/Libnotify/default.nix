{ stdenv, appleDerivation }:

appleDerivation {
  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/include
    cp notify.h      $out/include
    cp notify_keys.h $out/include
  '';
}
