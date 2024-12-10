{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  makeWrapper,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "keka";
  version = "1.3.2";

  src = fetchurl {
    url = "https://github.com/aonez/Keka/releases/download/v${finalAttrs.version}/Keka-${finalAttrs.version}.zip";
    sha256 = "0id8j639kba5yc0z34lgvadzgv9z9s2573nn6dx9m6gd8qpnk2x7";
  };
  dontUnpack = true;

  nativeBuildInputs = [
    unzip
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications $out/bin
    unzip -d $out/Applications $src
    makeWrapper $out/Applications/Keka.app/Contents/MacOS/Keka $out/bin/keka \
      --add-flags "--cli"

    runHook postInstall
  '';

  meta = with lib; {
    description = "macOS file archiver";
    homepage = "https://www.keka.io";
    license = licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [
      emilytrau
      Enzime
    ];
    platforms = platforms.darwin;
  };
})
