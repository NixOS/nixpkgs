{ stdenv, fetchurl, boost }:

stdenv.mkDerivation rec {
  name = "mini-httpd-1.4";

  src = fetchurl {
    url = "mirror://savannah/mini-httpd/${name}.tar.gz";
    sha256 = "1i46klkx2ca1cgmlilajkx8gf7b7d7c2sj58llxfllh184pb6cpd";
  };

  buildInputs = [ boost ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://mini-httpd.nongnu.org/";
    description = "a minimalistic high-performance web server";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
