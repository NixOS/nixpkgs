{ stdenv, fetchurl, cmake, SDL, openal, zlib, libpng, python, libvorbis }:

assert stdenv.gcc.libc != null;

stdenv.mkDerivation rec {
  name = "gemrb-0.8.0.1";
  
  src = fetchurl {
    url = "mirror://sourceforge/gemrb/${name}.tar.gz";
    sha256 = "0v9iypls4iawnfkc91hcdnmc4vyg3ix7v7lmw3knv73q145v0ksd";
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
