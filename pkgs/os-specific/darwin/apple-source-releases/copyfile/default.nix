{ appleDerivation', stdenvNoCC }:

appleDerivation' stdenvNoCC {
  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/include/
    cp copyfile.h $out/include/

    runHook postInstall
  '';
}
