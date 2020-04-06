{ appleDerivation }:

appleDerivation {
  installPhase = ''
    mkdir -p $out/include
    cp *.h $out/include/
  '';
}
