{ stdenv, fetchurl, makeWrapper, jre, makeDesktopItem, lib }:

stdenv.mkDerivation rec {
  pname = "runelite";
  version = "2.0.0";

  src = fetchurl {
    url = "https://github.com/runelite/launcher/releases/download/${version}/RuneLite.jar";
    sha256 = "0q0x8g43ggkvp5fgnymgygx59xfhnyyrhpi6ha333gqg97rr0rvw";
  };

  icon = fetchurl {
    url = "https://github.com/runelite/launcher/raw/${version}/appimage/runelite.png";
    sha256 = "04fcjm7p546gr82g0jbh497j7rnh70lrvas0k171bff4v3knrjw1";
  };

  desktop = makeDesktopItem {
    name = "RuneLite";
    type = "Application";
    exec = "runelite";
    icon = icon;
    comment = "Open source Old School RuneScape client";
    terminal = "false";
    desktopName = "RuneLite";
    genericName = "Oldschool Runescape";
    categories = "Application;Game";
    startupNotify = null;
  };

  buildInputs = [ makeWrapper ];

  # colon is bash form of no-op (do nothing)
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/runelite
    mkdir -p $out/share/applications

    ln -s ${src} $out/share/runelite/RuneLite.jar
    ln -s ${desktop}/share/applications/* $out/share/applications

    makeWrapper ${jre}/bin/java $out/bin/runelite \
    --add-flags "-jar $out/share/runelite/RuneLite.jar"
  '';

  meta = with lib; {
    description = "Open source Old School RuneScape client";
    homepage = "https://runelite.net/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ kmeakin ];
    platforms = platforms.all;
  };
}
