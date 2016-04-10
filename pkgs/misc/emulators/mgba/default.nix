{ stdenv, fetchgit
, pkgconfig, cmake, libzip, epoxy, ffmpeg, imagemagick, SDL2
, qtbase, qtmultimedia }:

stdenv.mkDerivation rec {
  name = "mgba-git-${version}";
  version = "20160325";

  src = fetchgit {
    url = "https://github.com/mgba-emu/mgba.git";
    rev = "be2641c77b4a438e0db487bc82b43bc27a26e0c2";
    sha256 = "0ygsmmp24w14x5fm2qz2v68p59bs2ravn22axrg2ipn5skkgrvxz";
  };

  buildInputs = [
    pkgconfig cmake libzip epoxy ffmpeg imagemagick SDL2
    qtbase qtmultimedia
  ];

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
  };
}
