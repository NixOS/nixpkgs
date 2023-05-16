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
<<<<<<< HEAD
  version = "4.8.0";

  src = fetchurl {
    url = "https://github.com/yairm210/Unciv/releases/download/${version}/Unciv.jar";
    hash = "sha256-Mq6c8APLOYYKTIuBdkbscK43BSY5sWWqWlaR4KiXpwo=";
=======
  version = "4.6.8";

  src = fetchurl {
    url = "https://github.com/yairm210/Unciv/releases/download/${version}/Unciv.jar";
    hash = "sha256-ECj94r/0jEB9xzlX5A8q4jvOr92yRsTpD4IkxXMF2EM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
