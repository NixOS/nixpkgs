{ stdenv
, lib
, fetchurl
, copyDesktopItems
, makeDesktopItem
, makeWrapper
, jre
, libpulseaudio
, libXxf86vm
}:
let
  desktopItem = makeDesktopItem {
    name = "unciv";
    exec = "unciv";
    comment = "An open-source Android/Desktop remake of Civ V";
    desktopName = "Unciv";
    categories = [ "Game" ];
  };

  envLibPath = lib.makeLibraryPath [
    libpulseaudio
    libXxf86vm
  ];

in
stdenv.mkDerivation rec {
  pname = "unciv";
  version = "4.6.4-patch2";

  src = fetchurl {
    url = "https://github.com/yairm210/Unciv/releases/download/${version}/Unciv.jar";
    hash = "sha256-LI0PfSQq90f4Ci4np5Z+JgfVgU2b380pSIqNIpm2UKQ=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ copyDesktopItems makeWrapper ];

  installPhase = ''
    runHook preInstall

    makeWrapper ${jre}/bin/java $out/bin/unciv \
      --prefix LD_LIBRARY_PATH : ${envLibPath} \
      --prefix PATH : ${lib.makeBinPath [ jre ]} \
      --add-flags "-jar ${src}"

    runHook postInstall
  '';

  desktopItems = [ desktopItem ];

  meta = with lib; {
    description = "An open-source Android/Desktop remake of Civ V";
    homepage = "https://github.com/yairm210/Unciv";
    maintainers = with maintainers; [ tex ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.mpl20;
    platforms = platforms.all;
  };
}
