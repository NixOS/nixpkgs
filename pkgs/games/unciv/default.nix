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
    categories = "Game;";
  };

  envLibPath = lib.makeLibraryPath [
    libpulseaudio
    libXxf86vm
  ];

in
stdenv.mkDerivation rec {
  pname = "unciv";
  version = "3.12.13-patch1";

  src = fetchurl {
    url = "https://github.com/yairm210/Unciv/releases/download/${version}/Unciv.jar";
    sha256 = "sha256-OwS1rn5mfU6cA6pvpp7Q407Kw2wBGvpqWmqlajgHtCI=";
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
    license = licenses.mpl20;
    platforms = [ "x86_64-linux" ];
  };
}
