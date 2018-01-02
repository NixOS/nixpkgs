{ stdenv, fetchFromGitHub, fetchpatch
, pkgconfig, cmake, libzip, epoxy, ffmpeg, imagemagick, SDL2
, qtbase, qtmultimedia }:

stdenv.mkDerivation rec {
  name = "mgba-${version}";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "mgba-emu";
    repo = "mgba";
    rev = version;
    sha256 = "1fgxn3j6wc5mcgb81sc6fzy5m4saz02jz4zlms51dgycvy0flbz7";
  };

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [ libzip epoxy ffmpeg imagemagick SDL2 qtbase qtmultimedia ];

  patches = [
    (fetchpatch {
      url = "https://github.com/mgba-emu/mgba/commit/e31373560535203d826687044290a4994706c2dd.patch";
      sha256 = "07582vj0fqgsgryx28pnshiwri9dn88l1rr4vkraib7bzx7cs4f9";
    })

    (fetchpatch {
      url = "https://github.com/mgba-emu/mgba/commit/baabe0090bb1fd5997e531fd9568c2de09b5fc21.patch";
      sha256 = "1kv9dxxna35s050q9af9nzskplz2x1aq8avg0ihbznhxjl8vmxz9";
    })
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
    platforms = with platforms; linux;
  };
}
