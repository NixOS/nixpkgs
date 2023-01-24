{ lib, stdenv, fetchurl, autoconf, automake, libtool, dos2unix, libpgf, freeimage, doxygen }:

stdenv.mkDerivation rec {
  pname = "pgf";
  version = "6.14.12";

  src = fetchurl {
    url = "mirror://sourceforge/libpgf/pgf-console-src-${version}.tar.gz";
    sha256 = "1vfm12cfq3an3xg0679bcwdmjq2x1bbij1iwsmm60hwmrm3zvab0";
  };

  nativeBuildInputs = [ autoconf automake ];
  buildInputs = [ libtool dos2unix libpgf freeimage doxygen ];

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
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
}
