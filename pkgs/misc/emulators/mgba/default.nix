{ stdenv, fetchFromGitHub
, pkgconfig, cmake, libzip, epoxy, ffmpeg, imagemagick, SDL2
, qtbase, qtmultimedia }:

stdenv.mkDerivation rec {
  name = "mgba-${version}";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "mgba-emu";
    repo = "mgba";
    rev = version;
    sha256 = "1ysxyy888qdwjbgsh3xdzsx8f3a5yd1gqx54xvndpv9v3zqgr2jf";
  };

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ libzip epoxy ffmpeg imagemagick SDL2 qtbase qtmultimedia ];

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
