{ lib
, fetchFromGitHub
, makeDesktopItem
, makeWrapper
, maven
, jre
, xorg
, gitUpdater
}:

maven.buildMavenPackage rec {
  pname = "runelite";
  version = "2.6.9";

  src = fetchFromGitHub {
    owner = "runelite";
    repo = "launcher";
    rev = version;
    hash = "sha256-wU97uiotKZfui0ir7rmO1WLN3G6lTMxqF6vTyrlax1Q=";
  };
  mvnHash = "sha256-iGnoAZcJvaVoACi9ozG/f+A8tjvDuwn22bMRyuUU5Jg=";

  desktop = makeDesktopItem {
    name = "RuneLite";
    type = "Application";
    exec = "runelite";
    icon = "runelite";
    comment = "Open source Old School RuneScape client";
    desktopName = "RuneLite";
    genericName = "Oldschool Runescape";
    categories = [ "Game" ];
  };

  # tests require internet :(
  mvnParameters = "-Dmaven.test.skip";
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/share/icons

    cp target/RuneLite.jar $out/share
    cp appimage/runelite.png $out/share/icons

    makeWrapper ${jre}/bin/java $out/bin/runelite \
      --prefix LD_LIBRARY_PATH : "${xorg.libXxf86vm}/lib" \
      --add-flags "-jar $out/share/RuneLite.jar"
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Open source Old School RuneScape client";
    homepage = "https://runelite.net/";
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ kmeakin moody ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "runelite";
  };
}
