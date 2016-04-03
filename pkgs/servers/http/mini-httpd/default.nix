{ stdenv, fetchurl, boost }:

stdenv.mkDerivation rec {
  name = "mini-httpd-1.5";

  src = fetchurl {
    url = "mirror://savannah/mini-httpd/${name}.tar.gz";
    sha256 = "1x4b6x40ymbaamqqq9p97lc0mnah4q7bza04fjs35c8agpm19zir";
  };

  configureFlagsArray = [ "CFLAGS=-ansi" ];

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
