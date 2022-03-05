{ lib, stdenv
, fetchsvn
# jdk8 is needed for building, but the game runs on newer jres as well
, jdk8
, jre
, ant
, makeWrapper
, makeDesktopItem
, nixosTests
}:

let
  desktopItem = makeDesktopItem {
    name = "domination";
    desktopName = "Domination";
    exec = "domination";
    icon = "domination";
  };
  editorDesktopItem = makeDesktopItem {
    name = "domination-map-editor";
    desktopName = "Domination Map Editor";
    exec = "domination-map-editor";
    icon = "domination";
  };

in stdenv.mkDerivation {
  pname = "domination";
  version = "1.2.4";

  # The .zip releases do not contain the build.xml file
  src = fetchsvn {
    url = "https://svn.code.sf.net/p/domination/code/Domination";
    # There are no tags in the repository.
    # Look for commits like "new version x.y.z info on website"
    # or "website update for x.y.z".
    rev = "2109";
    sha256 = "sha256-awTaEkv0zUXgrKVKuFzi5sgHgrfiNmAFMODO5U0DL6I=";
  };

  nativeBuildInputs = [
    jdk8
    ant
    makeWrapper
  ];

  buildPhase = ''
    cd swingUI
    ant
  '';

  installPhase = ''
    # Remove unnecessary files and launchers (they'd need to be wrapped anyway)
    rm -r \
      build/game/src.zip \
      build/game/*.sh \
      build/game/*.cmd \
      build/game/*.exe \
      build/game/*.app

    mkdir -p $out/share/domination
    cp -r build/game/* $out/share/domination/

    # Reimplement the two launchers mentioned in Unix_shortcutSpec.xml with makeWrapper
    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/domination \
      --run "cd $out/share/domination" \
      --add-flags "-jar $out/share/domination/Domination.jar"
    makeWrapper ${jre}/bin/java $out/bin/domination-map-editor \
      --run "cd $out/share/domination" \
      --add-flags "-cp $out/share/domination/Domination.jar net.yura.domination.ui.swinggui.SwingGUIFrame"

    install -Dm644 \
      ${desktopItem}/share/applications/Domination.desktop \
      $out/share/applications/Domination.desktop
    install -Dm644 \
      "${editorDesktopItem}/share/applications/Domination Map Editor.desktop" \
      "$out/share/applications/Domination Map Editor.desktop"
    install -Dm644 build/game/resources/icon.png $out/share/pixmaps/domination.png
  '';

  passthru.tests = {
    domination-starts = nixosTests.domination;
  };

  meta = with lib; {
    homepage = "http://domination.sourceforge.net/";
    downloadPage = "http://domination.sourceforge.net/download.shtml";
    description = "A game that is a bit like the board game Risk or RisiKo";
    longDescription = ''
      Domination is a game that is a bit like the well known board game of Risk
      or RisiKo. It has many game options and includes many maps.
      It includes a map editor, a simple map format, multiplayer network play,
      single player, hotseat, 5 user interfaces and many more features.
    '';
    license = licenses.gpl3;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}
