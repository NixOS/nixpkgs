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

  # !!! Ugly.  CMake passes library dependencies to the linker using
  # the full path of the library rather than `-l...', and the
  # ld-wrapper doesn't add the necessary `-rpath' flag.
  NIX_LDFLAGS = "-rpath ${zlib}/lib -rpath ${libpng}/lib -rpath ${python}/lib -rpath ${openal}/lib -rpath ${SDL}/lib -rpath ${libvorbis}/lib";

  meta = {
    description = "A reimplementation of the Infinity Engine, used by games such as Baldur's Gate";
    homepage = http://gemrb.sourceforge.net/;
  };
}
