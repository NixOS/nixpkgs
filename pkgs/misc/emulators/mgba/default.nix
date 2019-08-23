{ stdenv, fetchFromGitHub, makeDesktopItem, wrapQtAppsHook, pkgconfig
, cmake, epoxy, libzip, ffmpeg, imagemagick, SDL2, qtbase, qtmultimedia, libedit
, qttools, minizip }:

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
  name = "mgba-${version}";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "mgba-emu";
    repo = "mgba";
    rev = version;
    sha256 = "0g0xa1mzvan0sl1p5c784j2g5mcw9kd2b7wiahy06gy0c1nmbcnp";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ wrapQtAppsHook pkgconfig cmake ];

  buildInputs = [
    libzip epoxy ffmpeg imagemagick SDL2 qtbase qtmultimedia libedit minizip
    qttools
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
