{ appleDerivation', stdenvNoCC }:

appleDerivation' stdenvNoCC {
  installPhase = ''
    mkdir -p $out/include
    cp notify.h      $out/include
    cp notify_keys.h $out/include
  '';
}
