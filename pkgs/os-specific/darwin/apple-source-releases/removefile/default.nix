{ appleDerivation', stdenvNoCC }:

appleDerivation' stdenvNoCC {
  installPhase = ''
    mkdir -p $out/include/
    cp removefile.h checkint.h $out/include/
  '';

  appleHeaders = ''
    checkint.h
    removefile.h
  '';
}
