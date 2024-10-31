{ lib, appleDerivation', stdenvNoCC }:

appleDerivation' stdenvNoCC {
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/include
    cp MacTypes.h          $out/include
    cp ConditionalMacros.h $out/include

    substituteInPlace $out/include/MacTypes.h \
      --replace "CarbonCore/" ""
  '';

  meta = with lib; {
    maintainers = with maintainers; [ copumpkin ];
    platforms   = platforms.darwin;
    license     = licenses.apple-psl20;
  };
}
