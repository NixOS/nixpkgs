{ stdenv, fetchurl, autoconf, automake, libtool, dos2unix, libpgf, freeimage, doxygen }:

with stdenv.lib;

let
  version = "6.14.12";
in
stdenv.mkDerivation {
  pname = "pgf";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/libpgf/pgf-console-src-${version}.tar.gz";
    sha256 = "1vfm12cfq3an3xg0679bcwdmjq2x1bbij1iwsmm60hwmrm3zvab0";
  };

  buildInputs = [ autoconf automake libtool dos2unix libpgf freeimage doxygen ];

  patchPhase = ''
      sed 1i'#include <inttypes.h>' -i src/PGF.cpp
      sed s/__int64/int64_t/g -i src/PGF.cpp
      rm include/FreeImage.h include/FreeImagePlus.h
  '';

  preConfigure = "dos2unix configure.ac; sh autogen.sh";

# configureFlags = optional static "--enable-static --disable-shared";

  meta = {
    homepage = "https://www.libpgf.org/";
    description = "Progressive Graphics Format command line program";
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
