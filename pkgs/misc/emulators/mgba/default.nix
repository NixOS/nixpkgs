{ stdenv, fetchurl, pkgconfig, cmake, ffmpeg, imagemagick, libzip, SDL2
, qtbase, qtmultimedia }:

stdenv.mkDerivation rec {
  name = "mgba-${meta.version}";
  src = fetchurl {
    url = "https://github.com/mgba-emu/mgba/archive/${meta.version}.tar.gz";
    sha256 = "0z52w4dkgjjviwi6w13gls082zclljgx1sa8nlyb1xcnnrn6980l";
  };

  buildInputs = [
    pkgconfig cmake ffmpeg imagemagick libzip SDL2
    qtbase qtmultimedia
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    version = "0.3.1";
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

