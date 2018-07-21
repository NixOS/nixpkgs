{ appleDerivation }:

appleDerivation {
  installPhase = ''
    mkdir -p $out/include/
    cp removefile.h checkint.h $out/include/
  '';
}
