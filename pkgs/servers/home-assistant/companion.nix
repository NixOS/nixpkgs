{ lib
, stdenvNoCC
, fetchurl
, unzip
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "home-assistant-companion";
  version = "2023.4-2023.460";

  src = fetchurl {
    url = "https://github.com/home-assistant/iOS/releases/download/release%2F${lib.replaceStrings ["-"] ["%2F"] finalAttrs.version}/home-assistant-mac.zip";
    sha256 = "1byxpjg9b06anl1wv8kl4rdnzzzhiisfcv1fpm54r70wwlls194n";
  };
  dontUnpack = true;

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    unzip -d $out/Applications $src

    runHook postInstall
  '';

  meta = with lib; {
    description = "Companion app for Home Assistant";
    homepage = "https://companion.home-assistant.io";
    license = licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ emilytrau Enzime ];
    platforms = platforms.darwin;
  };
})
