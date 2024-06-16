{ lib
, fetchurl
, stdenv
, undmg
}:

let
  snapshot = "20240601172844";
in
stdenv.mkDerivation {
  pname = "apparency";
  version = "2.0";

  src = fetchurl {
   # Use externally archived download URL because
   # upstream does not provide stable URLs for versioned releases
    url = "https://web.archive.org/web/${snapshot}/https://www.mothersruin.com/software/downloads/Apparency.dmg";
    hash = "sha256-XKxWxqfxy9AQneILLrN9XqLt4/k2N8yumZ5mrSvczFk=";
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
