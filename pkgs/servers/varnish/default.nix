{ stdenv, fetchurl, pcre, libxslt, groff, ncurses, pkgconfig }:

stdenv.mkDerivation rec {
  version = "3.0.3";
  name = "varnish-${version}";

  src = fetchurl {
    url = "http://repo.varnish-cache.org/source/${name}.tar.gz";
    sha256 = "1cla2igwfwcm07srvk0z9cqdxh74sga0c1rsmh4b4n1gjn6x2drd";
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
