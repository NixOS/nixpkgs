{ stdenv, fetchurl, boostHeaders }:

stdenv.mkDerivation rec {
  name = "mini-httpd-1.2";

  src = fetchurl {
    url = "mirror://savannah/mini-httpd/${name}.tar.gz";
    sha256 = "1547312rg2phxwny9vm1bkyid251n7wy4p1mgs6f5yq6ypwrsr6p";
  };

  buildInputs = [ boostHeaders ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://mini-httpd.nongnu.org/";
    description = "a minimalistic high-performance web server";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
