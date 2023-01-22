{ lib, stdenv, fetchFromGitHub, SDL, SDL_ttf, SDL_gfx, SDL_mixer, libpng
, glew, dejavu_fonts, makeDesktopItem }:

stdenv.mkDerivation rec {
  pname = "hyperrogue";
  version = "12.1h";

  src = fetchFromGitHub {
    owner = "zenorogue";
    repo = "hyperrogue";
    rev = "v${version}";
    sha256 = "sha256-9ChPO0YCsrAyQ81TAbKCMJSgSXoUtkvvNPMTPimPBUo=";
  };

  CXXFLAGS = [
    "-I${lib.getDev SDL}/include/SDL"
    "-DHYPERPATH='\"${placeholder "out"}/share/hyperrogue/\"'"
    "-DRESOURCEDESTDIR=HYPERPATH"
    "-DHYPERFONTPATH='\"${dejavu_fonts}/share/fonts/truetype/\"'"
  ];
  HYPERROGUE_USE_GLEW = 1;
  HYPERROGUE_USE_PNG = 1;

  buildInputs = [ SDL SDL_ttf SDL_gfx SDL_mixer libpng glew ];

  desktopItem = makeDesktopItem {
    name = "hyperrogue";
    desktopName = "HyperRogue";
    genericName = "HyperRogue";
    comment = meta.description;
    icon = "hyperrogue";
    exec = "hyperrogue";
    categories = [ "Game" "AdventureGame" ];
  };

  installPhase = ''
    install -d $out/share/hyperrogue/{sounds,music}

    install -m 555 -D hyperrogue $out/bin/hyperrogue
    install -m 444 -D hyperrogue-music.txt *.dat $out/share/hyperrogue
    install -m 444 -D music/* $out/share/hyperrogue/music
    install -m 444 -D sounds/* $out/share/hyperrogue/sounds

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

  meta = with lib; {
    homepage = "http://www.roguetemple.com/z/hyper/";
    description = "A roguelike game set in hyperbolic geometry";
    maintainers = with maintainers; [ rardiol ];
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
