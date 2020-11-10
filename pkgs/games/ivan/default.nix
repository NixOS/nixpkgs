{ stdenv, fetchFromGitHub, cmake, pkgconfig, SDL2, SDL2_mixer, alsaLib, libpng
, pcre, makeDesktopItem }:

stdenv.mkDerivation rec {

  pname = "ivan";
  version = "058";

  src = fetchFromGitHub {
    owner = "Attnam";
    repo = "ivan";
    rev = "v${version}";
    sha256 = "04jzs8wad2b3g9hvnijr4r89iiw6b1i44zdzkg0dy447lrw6l6xc";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

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

  # Create appropriate directories. Copy icons and desktop item to these directories.
  postInstall = ''
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/16x16/apps
    mkdir -p $out/share/icons/hicolor/32x32/apps
    mkdir -p $out/share/icons/hicolor/128x128/apps
    mkdir -p $out/share/icons/hicolor/256x256/apps
    mkdir -p $out/share/icons/hicolor/512x512/apps
    cp $src/Graphics/icons/shadowless.iconset/icon_16x16.png $out/share/icons/hicolor/16x16/apps/ivan.png
    cp $src/Graphics/icons/shadowless.iconset/icon_32x32.png $out/share/icons/hicolor/32x32/apps/ivan.png
    cp $src/Graphics/icons/shadowless.iconset/icon_128x128.png $out/share/icons/hicolor/128x128/apps/ivan.png
    cp $src/Graphics/icons/shadowless.iconset/icon_256x256.png $out/share/icons/hicolor/256x256/apps/ivan.png
    cp $src/Graphics/icons/shadowless.iconset/icon_512x512.png $out/share/icons/hicolor/512x512/apps/ivan.png
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
    homepage = "https://attnam.com/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [freepotion];
  };
}
