{ stdenv, fetchurl, libewf, afflib, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "sleuthkit-3.2.2";

  src = fetchurl {
    url = "mirror://sourceforge/sleuthkit/${name}.tar.gz";
    sha256 = "02hik5xvbgh1dpisvc3wlhhq1aprnlsk0spbw6h5khpbq9wqnmgj";
  };

  enableParallelBuilding = true;

  buildInputs = [ libewf afflib openssl zlib ];

  # Hack to fix the RPATH.
  preFixup = "rm -rf */.libs";

  meta = {
    description = "A forensic/data recovery tool";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
    license = "IBM Public License";
  };
}
