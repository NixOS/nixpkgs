{ appleDerivation', stdenvNoCC }:

appleDerivation' stdenvNoCC {
  installPhase = ''
    runHook preInstall

    mkdir -p $out/include/
    cp removefile.h checkint.h $out/include/

    runHook postInstall
  '';

  appleHeaders = ''
    checkint.h
    removefile.h
  '';
}
