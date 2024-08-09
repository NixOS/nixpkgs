{ lib, appleDerivation', stdenvNoCC }:

appleDerivation' stdenvNoCC {
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/include
    cp MacTypes.h          $out/include
    cp ConditionalMacros.h $out/include

    substituteInPlace $out/include/MacTypes.h \
      --replace "CarbonCore/" ""

    runHook postInstall
  '';

  meta = with lib; {
    maintainers = with maintainers; [ copumpkin ];
    platforms   = platforms.darwin;
    license     = licenses.apple-psl20;
  };
}
