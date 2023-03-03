{ appleDerivation', stdenvNoCC }:

appleDerivation' stdenvNoCC {
  installPhase = ''
    mkdir -p $out/include

    cp Source/Intel/math.h $out/include
    cp Source/Intel/fenv.h $out/include
    cp Source/complex.h    $out/include
  '';
}
