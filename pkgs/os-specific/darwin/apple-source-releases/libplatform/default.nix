{ appleDerivation }:

appleDerivation {
  installPhase = ''
    mkdir $out
    cp -r include $out/include
  '';
}
