{ lib
, fetchurl
, stdenvNoCC
, unzip
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "itsycal";
  version = "0.15.3";

  src = fetchurl {
    url = "https://itsycal.s3.amazonaws.com/Itsycal-${finalAttrs.version}.zip";
    hash = "sha256-5aJzSuqq31B33jW4lV8vuU3eurpZBoyIW/AOC9/pxng=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    mv Itsycal.app $out/Applications

    runHook postInstall
  '';

  meta = {
    description = "Itsycal is a tiny menu bar calendar";
    homepage = "https://www.mowglii.com/itsycal/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ DontEatOreo ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
