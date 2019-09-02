{ stdenv, fetchurl, makeWrapper, jre, makeDesktopItem, lib }:

  stdenv.mkDerivation rec {
  pname = "runelite";
  version = "1.6.0";

  src = fetchurl {
    url = "https://github.com/runelite/launcher/releases/download/${version}/RuneLite.jar";
    sha256 = "0q2xx0wrnlg5mrv8nnmnh300r8mqfm8k2p028m7mr09kn18xvkzx";
  };

  icon = fetchurl {
    url = "https://github.com/runelite/runelite/raw/master/runelite-client/src/main/resources/runelite.png";
    sha256 = "0fxzkpsin09giqp7h8z0plxznk5d5j60sv34v1lw61p7d5y2izvr";
  };

  desktop = makeDesktopItem {
    name = "RuneLite";
    type = "Application";
    exec = "runelite";
    icon = "${icon}";
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

  meta = {
    description = "Open source Old School RuneScape client";
    homepage = "https://runelite.net/";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.kmeakin ];
    platforms = lib.platforms.all;
  };
  }
