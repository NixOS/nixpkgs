{ lib
, fetchurl
, stdenv
, undmg
}:

stdenv.mkDerivation {
  pname = "apparency";
  version = "1.5.1";

  src = fetchurl {
    url = "https://web.archive.org/web/20230815073821/https://www.mothersruin.com/software/downloads/Apparency.dmg";
    hash = "sha256-JpaBdlt8kTNFzK/yZVZ+ZFJ3DnPQbogJC7QBmtSVkoQ=";
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
