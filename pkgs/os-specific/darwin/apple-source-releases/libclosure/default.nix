{ stdenv, appleDerivation }:

appleDerivation {
  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/include
    cp *.h $out/include/
  '';
}