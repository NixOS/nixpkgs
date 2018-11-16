{ stdenv, fetchFromGitHub, fetchpatch, makeDesktopItem, makeWrapper, pkgconfig
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
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "mgba-emu";
    repo = "mgba";
    rev = version;
    sha256 = "0m1pkxa6i94gq95cankv390wsbp88b3x41c7hf415rp9rkfq25vk";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ makeWrapper pkgconfig cmake ];

  buildInputs = [
    libzip epoxy ffmpeg imagemagick SDL2 qtbase qtmultimedia libedit minizip
    qttools
  ];

  patches = [(fetchpatch {
      url = "https://github.com/mgba-emu/mgba/commit/7f41dd354176b720c8e3310553c6b772278b9dca.patch";
      sha256 = "0j334v8wf594kg8s1hngmh58wv1pi003z8avy6fjhj5qpjmbbavh";
  })];

  postInstall = ''
    cp -r ${desktopItem}/share/applications $out/share
    wrapProgram $out/bin/mgba-qt --suffix QT_PLUGIN_PATH : \
      ${qtbase.bin}/${qtbase.qtPluginPrefix}
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
