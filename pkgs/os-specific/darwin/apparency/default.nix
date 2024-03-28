{ lib
, fetchurl
, stdenv
, undmg
}:

stdenv.mkDerivation {
  pname = "apparency";
  version = "1.8.1";

  src = fetchurl {
   # Use externally archived download URL because
   # upstream does not provide stable URLs for versioned releases
    url = "https://web.archive.org/web/20240304101835/https://www.mothersruin.com/software/downloads/Apparency.dmg";
    hash = "sha256-hxbAtIy7RdhDrsFIvm9CEr04uUTbWi4KmrzJIcU1YVA=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = "Apparency.app";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/Apparency.app $out/bin
    cp -R . $out/Applications/Apparency.app
    ln -s ../Applications/Apparency.app/Contents/MacOS/appy $out/bin

    runHook postInstall
  '';

  meta = {
    description = "The App That Opens Apps";
    homepage = "https://www.mothersruin.com/software/Apparency/";
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ Enzime ];
    mainProgram = "appy";
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
