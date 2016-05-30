{ stdenv, fetchurl, pcre, libxslt, groff, ncurses, pkgconfig, readline, python
, pythonPackages }:

stdenv.mkDerivation rec {
  version = "4.1.2";
  name = "varnish-${version}";

  src = fetchurl {
    url = "http://repo.varnish-cache.org/source/${name}.tar.gz";
    sha256 = "1i28wgaybwmpgr9m8layvzs1x0sc5jf7kdks1vlmpsr89nadla4p";
  };

  buildInputs = [ pcre libxslt groff ncurses pkgconfig readline python
    pythonPackages.docutils];

  meta = {
    description = "Web application accelerator also known as a caching HTTP reverse proxy";
    homepage = "https://www.varnish-cache.org";
    license = stdenv.lib.licenses.bsd2;
    maintainers = [ stdenv.lib.maintainers.garbas ];
    platforms = stdenv.lib.platforms.linux;
  };
}
