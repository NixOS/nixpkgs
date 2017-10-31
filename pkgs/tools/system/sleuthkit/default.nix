{ stdenv, fetchurl, libewf, afflib, openssl, zlib }:

stdenv.mkDerivation rec {
  version = "4.2.0";
  name = "sleuthkit-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/sleuthkit/${name}.tar.gz";
    sha256 = "08s7c1jwn2rjq2jm8859ywaiq12adrl02m61hc04iblqjzqqgcli";
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
