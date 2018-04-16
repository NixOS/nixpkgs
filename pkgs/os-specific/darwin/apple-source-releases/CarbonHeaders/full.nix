{ stdenv, appleDerivation }:

appleDerivation {
  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/include
    cp MacTypes.h          $out/include
    cp ConditionalMacros.h $out/include
    cp MacErrors.h $out/include

    substituteInPlace $out/include/MacTypes.h \
      --replace "CarbonCore/" ""
  '';
}
