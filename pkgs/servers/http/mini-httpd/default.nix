{ stdenv, fetchurl, boost }:

stdenv.mkDerivation {
  name = "mini-httpd-1.1";

  src = fetchurl {
    url = "mirror://savannah/mini-httpd/mini-httpd-1.1.tar.gz";
    sha256 = "12hqvh67hgxmc9b3fhb8gb5ash7j6f7d0mxv47zkmjl7k3vw3ny7";
  };

  buildInputs = [ boost ];

  meta = {
    homepage = "http://mini-httpd.nongnu.org/";
    description = "a minimalistic high-performance web server";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
