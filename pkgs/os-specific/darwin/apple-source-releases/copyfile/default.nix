{ stdenv, appleDerivation }:

appleDerivation {
  installPhase = ''
    mkdir -p $out/include/
    cp copyfile.h $out/include/
  '';
}
