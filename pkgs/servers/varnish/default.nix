{ stdenv, fetchurl, pcre, libxslt, groff, ncurses, pkgconfig, readline, libedit
, python, pythonPackages }:

stdenv.mkDerivation rec {
  version = "5.0.0";
  name = "varnish-${version}";

  src = fetchurl {
    url = "http://repo.varnish-cache.org/source/${name}.tar.gz";
    sha256 = "0jizha1mwqk42zmkrh80y07vfl78mg1d9pp5w83qla4xn9ras0ai";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    pcre libxslt groff ncurses readline python libedit
    pythonPackages.docutils
  ];

  buildFlags = "localstatedir=/var/spool";

  # https://github.com/varnishcache/varnish-cache/issues/1875
  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isi686 "-fexcess-precision=standard";

  outputs = [ "out" "dev" "man" ];

  meta = with stdenv.lib; {
    description = "Web application accelerator also known as a caching HTTP reverse proxy";
    homepage = "https://www.varnish-cache.org";
    license = licenses.bsd2;
    maintainers = with maintainers; [ garbas fpletz ];
    platforms = platforms.linux;
  };
}
