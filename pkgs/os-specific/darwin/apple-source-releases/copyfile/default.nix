{ appleDerivation }:

appleDerivation {
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/include/
    cp copyfile.h $out/include/
  '';
}
