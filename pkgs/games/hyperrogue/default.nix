{ stdenv, fetchFromGitHub, SDL, SDL_ttf, SDL_gfx, SDL_mixer, autoreconfHook,
  libpng, glew, makeDesktopItem }:

stdenv.mkDerivation rec {
  pname = "hyperrogue";
  version = "11.2d";

  src = fetchFromGitHub {
    owner = "zenorogue";
    repo = "hyperrogue";
    rev = stdenv.lib.strings.stringAsChars (x: if x == "." then "" else x) "v${version}";
    sha256 = "0aj4xy5xjdj32l5mk8796ldh9d7h8rx35kgc1vr7acb4fhpppb0f";
  };

  CPPFLAGS = "-I${SDL.dev}/include/SDL";

  buildInputs = [ autoreconfHook SDL SDL_ttf SDL_gfx SDL_mixer libpng glew ];

  desktopItem = makeDesktopItem {
    name = "hyperrogue";
    desktopName = "HyperRogue";
    genericName = "HyperRogue";
    comment = meta.description;
    icon = "hyperrogue";
    exec = "hyperrogue";
    categories = "Game;AdventureGame;";
  };

  postInstall = ''
    install -m 444 -D ${desktopItem}/share/applications/hyperrogue.desktop \
      $out/share/applications/hyperrogue.desktop
    install -m 444 -D hyperroid/app/src/main/res/drawable-ldpi/icon.png \
      $out/share/icons/hicolor/36x36/apps/hyperrogue.png
    install -m 444 -D hyperroid/app/src/main/res/drawable-mdpi/icon.png \
      $out/share/icons/hicolor/48x48/apps/hyperrogue.png
    install -m 444 -D hyperroid/app/src/main/res/drawable-hdpi/icon.png \
      $out/share/icons/hicolor/72x72/apps/hyperrogue.png
    install -m 444 -D hyperroid/app/src/main/res/drawable-xhdpi/icon.png \
      $out/share/icons/hicolor/96x96/apps/hyperrogue.png
    install -m 444 -D hyperroid/app/src/main/res/drawable-xxhdpi/icon.png \
      $out/share/icons/hicolor/144x144/apps/hyperrogue.png
    install -m 444 -D hyperroid/app/src/main/res/drawable-xxxhdpi/icon.png \
      $out/share/icons/hicolor/192x192/apps/hyperrogue.png
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.roguetemple.com/z/hyper/;
    description = "A roguelike game set in hyperbolic geometry";
    maintainers = with maintainers; [ rardiol ];
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
