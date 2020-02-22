{ stdenv, fetchFromGitHub, cmake, pkgconfig, SDL2, SDL2_mixer, alsaLib, libpng
, pcre, graphicsmagick, makeDesktopItem }:

stdenv.mkDerivation rec {

  pname = "ivan";
  version = "057";

  src = fetchFromGitHub {
    owner = "Attnam";
    repo = "ivan";
    rev = "v${version}";
    sha256 = "0mavmwikfsyr5sp65sl8dqknl1yz7c7ds53y1qkma24vsikz3k64";
  };

  nativeBuildInputs = [ cmake pkgconfig graphicsmagick ];

  buildInputs = [ SDL2 SDL2_mixer alsaLib libpng pcre ];

  hardeningDisable = ["all"];

  # Enable wizard mode
  cmakeFlags = ["-DCMAKE_CXX_FLAGS=-DWIZARD"];

  # Help CMake find SDL_mixer.h
  NIX_CFLAGS_COMPILE = "-I${SDL2_mixer}/include/SDL2";

  # Create "ivan.desktop" file
  ivanDesktop = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = "ivan.png";
    desktopName = "IVAN";
    genericName = pname;
    categories = "Game;AdventureGame;RolePlaying;";
    comment = meta.description;
  };

  # Create appropriate directories. Convert "Icon.bmp" to "ivan.png", then copy
  # it and "ivan.desktop" to these directories.
  postInstall = ''
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/32x32/apps
    gm convert $src/Graphics/Icon.bmp $out/share/icons/hicolor/32x32/apps/ivan.png
    cp ${ivanDesktop}/share/applications/* $out/share/applications
  '';

  meta = with stdenv.lib; {
    description = "Graphical roguelike game";
    longDescription = ''
      Iter Vehemens ad Necem (IVAN) is a graphical roguelike game, which currently
      runs in Windows, DOS, Linux, and OS X. It features advanced bodypart and
      material handling, multi-colored lighting and, above all, deep gameplay.

      This is a fan continuation of IVAN by members of Attnam.com
    '';
    homepage = https://attnam.com/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [freepotion];
  };
}
