{ lib
, stdenvNoCC
, fetchurl
, unzip
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mousecape";
  version = "1813";

  src = fetchurl {
    url = "https://github.com/alexzielenski/Mousecape/releases/download/${finalAttrs.version}/Mousecape_${finalAttrs.version}.zip";
    hash = "sha256-lp7HFGr1J+iQCUWVDplF8rFcTrGf+DX4baYzLsUi/9I=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    mv Mousecape.app $out/Applications

    runHook postInstall
  '';

  meta = {
    description = "A cursor manager for macOS built using private, nonintrusive CoreGraphics APIs";
    homepage = "https://github.com/alexzielenski/Mousecape";
    license = with lib; licenses.free;
    maintainers = with lib; with maintainers; [ DontEatOreo ];
    platforms = with lib; platforms.darwin;
    sourceProvenance = with lib; with sourceTypes; [ binaryNativeCode ];
  };
})

