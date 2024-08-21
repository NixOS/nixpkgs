{ appleDerivation', stdenvNoCC }:

appleDerivation' stdenvNoCC {
  installPhase = ''
    runHook preInstall

    mkdir -p $out/include
    cp *.h $out/include/

    runHook postInstall
  '';

  appleHeaders = ''
    Block.h
    Block_private.h
  '';
}
