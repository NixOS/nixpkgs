{ stdenv, fetchurl, pcre, libxslt, groff, ncurses, pkgconfig, readline }:

stdenv.mkDerivation rec {
  version = "3.0.4";
  name = "varnish-${version}";

  src = fetchurl {
    url = "http://repo.varnish-cache.org/source/${name}.tar.gz";
    sha256 = "0y8gml06h3wjiasfqnk7f9wrfrlgx89qz04wz3fjn8knbk5lq12f";
  };

  buildInputs = [ pcre libxslt groff ncurses pkgconfig readline ];

  meta = {
    description = "Web application accelerator also known as a caching HTTP reverse proxy";
    homepage = "https://www.varnish-cache.org";
    license = stdenv.lib.licenses.bsd2;
    maintainers = [ stdenv.lib.maintainers.garbas ];
    platforms = stdenv.lib.platforms.linux;
  };
}
