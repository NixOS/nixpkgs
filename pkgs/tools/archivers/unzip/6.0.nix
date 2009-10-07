{ stdenv, fetchurl, bzip2 }:

stdenv.mkDerivation {
  name = "unzip-6.0";
  
  src = fetchurl {
    url = mirror://sourceforge/infozip/unzip60.tar.gz;
    sha256 = "0dxx11knh3nk95p2gg2ak777dd11pr7jx5das2g49l262scrcv83";
  };

  buildInputs = [ bzip2 ];

  makefile = "unix/Makefile";

  NIX_LDFLAGS = "-lbz2";

  buildFlags = "generic D_USE_BZ2=-DUSE_BZIP2 L_BZ2=-lbz2";

  installFlags = "prefix=$(out)";

  meta = {
    homepage = http://www.info-zip.org;
    description = "An extraction utility for archives compressed in .zip format";
    license = "free"; # http://www.info-zip.org/license.html
    meta.platforms = [ stdenv.lib.platforms.all ];
  };
}
