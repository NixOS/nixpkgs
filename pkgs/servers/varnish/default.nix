{ stdenv, fetchurl, pcre, libxslt, groff, ncurses, pkgconfig, readline, python
, pythonPackages }:

stdenv.mkDerivation rec {
  version = "4.0.3";
  name = "varnish-${version}";

  src = fetchurl {
    url = "http://repo.varnish-cache.org/source/${name}.tar.gz";
    sha256 = "01l2iypajkdanxpbvzfxm6vs4jay4dgw7lmchqidnivz15sa3fcl";
  };

  buildInputs = [ pcre libxslt groff ncurses pkgconfig readline python
    pythonPackages.docutils];

  buildFlags = "localstatedir=/var/spool";

  meta = {
    description = "Web application accelerator also known as a caching HTTP reverse proxy";
    homepage = "https://www.varnish-cache.org";
    license = stdenv.lib.licenses.bsd2;
    maintainers = [ stdenv.lib.maintainers.garbas ];
    platforms = stdenv.lib.platforms.linux;
  };
}
