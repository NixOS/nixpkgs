{ lib, stdenv, fetchurl, SDL, ncurses, libtcod, makeDesktopItem }:

stdenv.mkDerivation rec {
  pname = "brogue";
  version = "1.7.5";

  src = fetchurl {
    url = "https://sites.google.com/site/broguegame/brogue-${version}-linux-amd64.tbz2";
    sha256 = "0i042zb3axjf0cpgpdh8hvfn66dbfizidyvw0iymjk2n760z2kx7";
  };

  prePatch = ''
    sed -i Makefile -e 's,LIBTCODDIR=.*,LIBTCODDIR=${libtcod},g' \
                    -e 's,sdl-config,${SDL.dev}/bin/sdl-config,g'
    sed -i src/platform/tcod-platform.c -e "s,fonts/font,$out/share/brogue/fonts/font,g"
    make clean
    rm -rf src/libtcod*
  '';

  buildInputs = [ SDL ncurses libtcod ];

  desktopItem = makeDesktopItem {
    name = "brogue";
    desktopName = "Brogue";
    genericName = "Roguelike";
    comment = "Brave the Dungeons of Doom!";
    icon = "brogue";
    exec = "brogue";
    categories = [ "Game" "AdventureGame" ];
  };

  installPhase = ''
    install -m 555 -D bin/brogue $out/bin/brogue
    install -m 444 -D ${desktopItem}/share/applications/brogue.desktop $out/share/applications/brogue.desktop
    install -m 444 -D bin/brogue-icon.png $out/share/icons/hicolor/256x256/apps/brogue.png
    mkdir -p $out/share/brogue
    cp -r bin/fonts $out/share/brogue/
  '';

  # fix crash; shouldn’t be a security risk because it’s an offline game
  hardeningDisable = [ "stackprotector" "fortify" ];

  meta = with lib; {
    description = "A roguelike game";
    homepage = "https://sites.google.com/site/broguegame/";
    license = licenses.agpl3;
    maintainers = [ maintainers.skeidel ];
    platforms = [ "x86_64-linux" ];
  };
}
