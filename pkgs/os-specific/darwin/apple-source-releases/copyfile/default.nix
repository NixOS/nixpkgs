{ appleDerivation', stdenvNoCC }:

appleDerivation' stdenvNoCC {
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/include/
    cp copyfile.h $out/include/
  '';
}
