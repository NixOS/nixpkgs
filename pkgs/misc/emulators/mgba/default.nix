{ lib
, stdenv
, fetchFromGitHub
, SDL2
, cmake
, epoxy
, ffmpeg
, imagemagick
, libedit
, libelf
, libzip
, makeDesktopItem
, minizip
, pkg-config
, qtbase
, qtmultimedia
, qttools
, wrapQtAppsHook
}:

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
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "mgba-emu";
    repo = "mgba";
    rev = version;
    hash = "sha256-JVauGyHJVfiXVG4Z+Ydh1lRypy5rk9SKeTbeHFNFYJs=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];
  buildInputs = [
    SDL2
    epoxy
    ffmpeg
    imagemagick
    libedit
    libelf
    libzip
    minizip
    qtbase
    qtmultimedia
    qttools
  ];

  postInstall = ''
    cp -r ${desktopItem}/share/applications $out/share
  '';

  meta = with lib; {
    homepage = "https://mgba.io";
    description = "A modern GBA emulator with a focus on accuracy";
    longDescription = ''
      mGBA is a new Game Boy Advance emulator written in C.

      The project started in April 2013 with the goal of being fast enough to
      run on lower end hardware than other emulators support, without
      sacrificing accuracy or portability. Even in the initial version, games
      generally play without problems. It is loosely based on the previous
      GBA.js emulator, although very little of GBA.js can still be seen in mGBA.

      Other goals include accurate enough emulation to provide a development
      environment for homebrew software, a good workflow for tool-assist
      runners, and a modern feature set for emulators that older emulators may
      not support.
    '';

    license = licenses.mpl20;
    maintainers = with maintainers; [ MP2E AndersonTorres ];
    platforms = platforms.linux;
  };
}
# TODO [ AndersonTorres ]: use desktopItem functions
