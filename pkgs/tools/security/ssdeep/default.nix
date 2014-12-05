{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "ssdeep-${version}";
  version = "2.11";

  src = fetchurl {
    url    = "mirror://sourceforge/ssdeep/${name}.tar.gz";
    sha256 = "1izzkvrng4cc2p8gxp3w32k1v60l2yaq2y2hkifgq9s1yh30xk42";
  };

  meta = {
    description = "A program for calculating fuzzy hashes";
    homepage    = "http://www.ssdeep.sf.net";
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
