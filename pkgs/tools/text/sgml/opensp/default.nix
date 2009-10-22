{stdenv, fetchurl}:

stdenv.mkDerivation {
  # OpenSP-1.5.1 requires gcc 3.3 to build.
  # The next release is likely to be compatible with newer gccs.
  # If so the overrideGCC in top-level/all-packages should be removed.
  name = "OpenSP-1.5.1";

  src = fetchurl {
    url = "http://prdownloads.sourceforge.net/openjade/OpenSP-1.5.1.tar.gz";
    sha256 = "0svkgk85m6f848fi3nxnrkzg62422wxr739w5r1yrmn31n24j1iz";
  };

  meta = {
    description = "A suite of SGML/XML processing tools";
    license = "BSD";
    homepage = http://openjade.sourceforge.net/;
  };
}
