{ stdenv, fetchurl, ogre, cegui, boost, sfml, openal, cmake, ois }:

stdenv.mkDerivation rec {
  name = "opendungeons-${version}";
  version = "0.6.0";

  src = fetchurl {
    url = "ftp://download.tuxfamily.org/opendungeons/${version}/${name}.tar.xz";
    sha256 = "1g0sjh732794h26cbkr0p96i3c0avm0mx9ip5zbvb2y3sbpjcbib";
  };

  patches = [ ./cmakepaths.patch ];

  buildInputs = [ cmake ogre cegui boost sfml openal ois ];

  meta = with stdenv.lib; {
    description = "An open source, real time strategy game sharing game elements with the Dungeon Keeper series and Evil Genius.";
    homepage = "https://opendungeons.github.io";
    license = [ licenses.gpl3Plus licenses.zlib licenses.mit licenses.cc-by-sa-30 licenses.cc0 licenses.ofl licenses.cc-by-30 ];
    platforms = platforms.linux;
  };
}
