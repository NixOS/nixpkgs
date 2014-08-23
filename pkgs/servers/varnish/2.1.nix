{ stdenv, fetchurl, pcre, libxslt, groff, ncurses, pkgconfig }:

stdenv.mkDerivation rec {
  version = "2.1.5";
  name = "varnish-${version}";

  src = fetchurl {
    url = "http://repo.varnish-cache.org/source/${name}.tar.gz";
    sha256 = "10zgwn482gfmfb7n6xwi7p841bs3j58jnk55wg83b85d2jz4k01d";
  };

  buildInputs = [ pcre libxslt groff ncurses pkgconfig ];

  meta = {
    description = "Web application accelerator also known as a caching HTTP reverse proxy";
    homepage = "https://www.varnish-cache.org";
    license = stdenv.lib.licenses.bsd2;
    maintainers = [ stdenv.lib.maintainers.garbas ];
    platforms = stdenv.lib.platforms.linux;
  };
}
