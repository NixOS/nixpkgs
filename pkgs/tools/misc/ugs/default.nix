{ stdenv
, lib
, copyDesktopItems
, makeDesktopItem
, makeWrapper
, jre
, fetchzip
}:
let
  desktopItem = makeDesktopItem {
    name = "ugs";
    exec = "ugs";
    comment = "A cross-platform G-Code sender for GRBL, Smoothieware, TinyG and G2core.";
    desktopName = "Universal-G-Code-Sender";
    categories = [ "Game" ];
  };

in
stdenv.mkDerivation rec {
  pname = "ugs";
  version = "2.1.7";

  src = fetchzip {
    url = "https://github.com/winder/Universal-G-Code-Sender/releases/download/v${version}/UniversalGcodeSender.zip";
    hash = "sha256-HxaFGa7UG7dWtVKTLDRbhY7UCWeA6E50txz45bjb5uE=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ copyDesktopItems makeWrapper ];

  installPhase = ''
    runHook preInstall

    makeWrapper ${jre}/bin/java $out/bin/ugs \
      --prefix PATH : ${lib.makeBinPath [ jre ]} \
      --add-flags "-jar ${src}/UniversalGcodeSender.jar"

    runHook postInstall
  '';

  desktopItems = [ desktopItem ];

  meta = with lib; {
    description = "A cross-platform G-Code sender for GRBL, Smoothieware, TinyG and G2core";
    homepage = "https://github.com/winder/Universal-G-Code-Sender";
    maintainers = with maintainers; [ matthewcroughan ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl3;
    platforms = platforms.all;
    mainProgram = "ugs";
  };
}
