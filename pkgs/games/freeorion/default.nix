{ stdenv, fetchurl, cmake, boost, SDL2, python2, freetype, openal, libogg, libvorbis, zlib, libpng, libtiff, libjpeg, mesa, glew, doxygen }:

stdenv.mkDerivation rec {
  version = "0.4.5";
  name = "freeorion-${version}";

  src = fetchurl {
    url = "https://github.com/freeorion/freeorion/releases/download/v0.4.5/FreeOrion_v0.4.5_2015-09-01.f203162_Source.tar.gz";
    sha256 = "3b99b92eeac72bd059566dbabfab54368989ba83f72e769bc94eb8dd4fe414c0";
  };

  buildInputs = [ cmake boost SDL2 python2 freetype openal libogg libvorbis zlib libpng libtiff libjpeg mesa glew doxygen ];

  # cherry pick for acceptable performance https://github.com/freeorion/freeorion/commit/92455f97c28055e296718230d2e3744eccd738ec
  patches = [ ./92455f9.patch ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A free, open source, turn-based space empire and galactic conquest (4X) computer game";
    homepage = "http://www.freeorion.org";
    license = [ licenses.gpl2 licenses.cc-by-sa-30 ];
    platforms = platforms.linux;
  };
}
