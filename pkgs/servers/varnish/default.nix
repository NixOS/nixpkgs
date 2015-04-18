{ stdenv, fetchurl, pcre, libxslt, groff, ncurses, pkgconfig, readline, python }:

stdenv.mkDerivation rec {
  version = "3.0.6";
  name = "varnish-${version}";

  src = fetchurl {
    url = "http://repo.varnish-cache.org/source/${name}.tar.gz";
    sha256 = "1dw0nrplx5pa09z8vbjpncniv3qib5bh3qp3yqbk2d774n7ys3c4";
  };

  buildInputs = [ pcre libxslt groff ncurses pkgconfig readline python ];

  meta = {
    description = "Web application accelerator also known as a caching HTTP reverse proxy";
    homepage = "https://www.varnish-cache.org";
    license = stdenv.lib.licenses.bsd2;
    maintainers = [ stdenv.lib.maintainers.garbas ];
    platforms = stdenv.lib.platforms.linux;
  };
}
