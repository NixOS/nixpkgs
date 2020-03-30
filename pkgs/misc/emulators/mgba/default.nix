{ stdenv, fetchFromGitHub, makeDesktopItem, wrapQtAppsHook, pkgconfig
, cmake, epoxy, libzip, libelf, libedit, ffmpeg, SDL2, imagemagick
, qtbase, qtmultimedia, qttools, minizip }:

let
  desktopItem = makeDesktopItem {
    name = "mgba";
    exec = "mgba-qt";
    icon = "mgba";
    comment = "A Game Boy Advance Emulator";
    desktopName = "mgba";
    genericName = "Game Boy Advance Emulator";
    categories = "Game;Emulator;";
    startupNotify = "false";
  };
in stdenv.mkDerivation rec {
  pname = "mgba";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "mgba-emu";
    repo = "mgba";
    rev = version;
    sha256 = "1if82mfaak3696w5d5yshynpzywrxgvg3ifdfi2rwlpvq1gpd429";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ wrapQtAppsHook pkgconfig cmake ];

  buildInputs = [
    epoxy libzip libelf libedit ffmpeg SDL2 imagemagick
    qtbase qtmultimedia qttools minizip
  ];

  postInstall = ''
    cp -r ${desktopItem}/share/applications $out/share
  '';

  meta = with stdenv.lib; {
    homepage = https://mgba.io;
    description = "A modern GBA emulator with a focus on accuracy";

    longDescription = ''
      mGBA is a new Game Boy Advance emulator written in C.

      The project started in April 2013 with the goal of being fast
      enough to run on lower end hardware than other emulators
      support, without sacrificing accuracy or portability. Even in
      the initial version, games generally play without problems. It
      is loosely based on the previous GBA.js emulator, although very
      little of GBA.js can still be seen in mGBA.

      Other goals include accurate enough emulation to provide a
      development environment for homebrew software, a good workflow
      for tool-assist runners, and a modern feature set for emulators
      that older emulators may not support.
    '';

    license = licenses.mpl20;
    maintainers = with maintainers; [ MP2E AndersonTorres ];
    platforms = platforms.linux;
  };
}
