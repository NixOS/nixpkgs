{ lib
, stdenvNoCC
, fetchurl
, undmg
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "caffeine";
  version = "1.1.3";

  src = fetchurl {
    url = "https://github.com/IntelliScape/caffeine/releases/download/${finalAttrs.version}/Caffeine.dmg";
    hash = "sha256-JA5auDKiXtCvQ67/0dZtxmPf6nwlJdkYwhTWEHmBoDs=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  meta = with lib; {
    description = "Don't let your Mac fall asleep";
    homepage = "https://intelliscapesolutions.com/apps/caffeine";
    license = licenses.mit;
    maintainers = with maintainers; [ emilytrau Enzime ];
    platforms = [ "x86_64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
