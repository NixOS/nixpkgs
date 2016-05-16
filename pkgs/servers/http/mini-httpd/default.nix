{ stdenv, fetchurl, boost }:

stdenv.mkDerivation rec {
  name = "mini-httpd-1.6";

  src = fetchurl {
    url = "http://download-mirror.savannah.gnu.org/releases/mini-httpd/${name}.tar.gz";
    sha256 = "04azr1qa70l0fnpbx7nmyxz1lkykjjs2b6p4lhkpg86hs3lrmxly";
  };

  buildInputs = [ boost ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://mini-httpd.nongnu.org/";
    description = "a minimalistic high-performance web server";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.peti ];
  };
}
