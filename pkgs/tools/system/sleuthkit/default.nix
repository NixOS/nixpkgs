{ stdenv, fetchurl, libewf, afflib, openssl, zlib }:

stdenv.mkDerivation rec {
  version = "4.1.3";
  name = "sleuthkit-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/sleuthkit/${name}.tar.gz";
    sha256 = "09q3ky4rpv18jasf5gc2hlivzadzl70jy4nnk23db1483aix5yb7";
  };

  enableParallelBuilding = true;

  buildInputs = [ libewf afflib openssl zlib ];

  # Hack to fix the RPATH.
  preFixup = "rm -rf */.libs";

  meta = {
    description = "A forensic/data recovery tool";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.ipl10;
    inherit version;
  };
}
