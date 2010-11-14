{ stdenv, fetchurl, cmake, SDL, openal, zlib, libpng, python, libvorbis }:

assert stdenv.gcc.libc != null;

stdenv.mkDerivation rec {
  name = "gemrb-0.6.1";
  
  src = fetchurl {
    url = "mirror://sourceforge/gemrb/${name}.tar.gz";
    sha256 = "1jnid5nrasy0lglnx71zkvv2p59cxsnhvagy7r8lsmjild1k5l93";
  };

  buildInputs = [ cmake python openal SDL zlib libpng libvorbis ];

  # Necessary to find libdl.
  CMAKE_LIBRARY_PATH = "${stdenv.gcc.libc}/lib";

  # Can't have -werror because of the Vorbis header files.
  cmakeFlags = "-DDISABLE_WERROR=ON -DCMAKE_VERBOSE_MAKEFILE=ON";

  meta = {
    description = "A reimplementation of the Infinity Engine, used by games such as Baldur's Gate";
    homepage = http://gemrb.sourceforge.net/;
  };
}
