{ lib
, fetchFromGitHub
, makeDesktopItem
, makeWrapper
, maven
, jre
, xorg
, gitUpdater
, libGL
}:

maven.buildMavenPackage rec {
  pname = "runelite";
  version = "2.6.12";

  src = fetchFromGitHub {
    owner = "runelite";
    repo = "launcher";
    rev = version;
    hash = "sha256-lovDkEvzclZCBu/Ha8h0j595NZ4ejefEOX7lNmzb8I8=";
  };
  mvnHash = "sha256-bsJlsIXIIVzZyVgEF/SN+GgpZt6v0u800arO1c5QYHk=";

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
    mkdir -p $out/share/applications

    cp target/RuneLite.jar $out/share
    cp appimage/runelite.png $out/share/icons

    ln -s ${desktop}/share/applications/RuneLite.desktop $out/share/applications/RuneLite.desktop

    makeWrapper ${jre}/bin/java $out/bin/runelite \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ xorg.libXxf86vm libGL ]}" \
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
