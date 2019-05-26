{ stdenv, fetchFromGitHub, ogre, cegui, boost, sfml, openal, cmake, ois, pkgconfig }:

stdenv.mkDerivation rec {
  name = "opendungeons-${version}";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "OpenDungeons";
    repo = "OpenDungeons";
    rev = version;
    sha256 = "0nipb2h0gn628yxlahjgnfhmpfqa19mjdbj3aqabimdfqds9pryh";
  };

  patches = [ ./cmakepaths.patch ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake ogre cegui boost sfml openal ois ];
  NIX_LDFLAGS = [
    "-lpthread"
  ];

  meta = with stdenv.lib; {
    description = "An open source, real time strategy game sharing game elements with the Dungeon Keeper series and Evil Genius.";
    homepage = https://opendungeons.github.io;
    license = [ licenses.gpl3Plus licenses.zlib licenses.mit licenses.cc-by-sa-30 licenses.cc0 licenses.ofl licenses.cc-by-30 ];
    platforms = platforms.linux;
  };
}
