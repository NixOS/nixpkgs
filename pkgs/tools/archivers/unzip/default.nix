{ stdenv, fetchurl, bzip2
, enableNLS ? false, libnatspec }:

stdenv.mkDerivation ({
  name = "unzip-6.0";
  
  src = fetchurl {
    url = mirror://sourceforge/infozip/unzip60.tar.gz;
    sha256 = "0dxx11knh3nk95p2gg2ak777dd11pr7jx5das2g49l262scrcv83";
  };

  nativeBuildInputs = [ bzip2 ];
  buildInputs = [ bzip2 ] ++ stdenv.lib.optional enableNLS libnatspec;

  makefile = "unix/Makefile";

  NIX_LDFLAGS = [ "-lbz2" ] ++ stdenv.lib.optional enableNLS "-lnatspec";

  buildFlags = "generic D_USE_BZ2=-DUSE_BZIP2 L_BZ2=-lbz2";

  preConfigure = ''
    sed -i -e 's@CF="-O3 -Wall -I. -DASM_CRC $(LOC)"@CF="-O3 -Wall -I. -DASM_CRC -DLARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 $(LOC)"@' unix/Makefile
  '';

  installFlags = "prefix=$(out)";

  meta = {
    homepage = http://www.info-zip.org;
    description = "An extraction utility for archives compressed in .zip format";
    license = "free"; # http://www.info-zip.org/license.html
    platforms = stdenv.lib.platforms.all;
  };
} // (if enableNLS then {
  patches =
    [ ( fetchurl {
        url =
        "http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/app-arch/unzip/files/unzip-6.0-natspec.patch?revision=1.1";
        name = "unzip-6.0-natspec.patch";
        sha256 = "67ab260ae6adf8e7c5eda2d1d7846929b43562943ec4aff629bd7018954058b1";
      })
    ];
} else {}))
