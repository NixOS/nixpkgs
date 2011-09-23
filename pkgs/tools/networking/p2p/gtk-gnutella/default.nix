{stdenv, fetchurl, pkgconfig, glib, gtk, libxml2, bison, gettext, zlib}:

let
  name = "gtk-gnutella";
  version = "0.97";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${name}-${version}.tar.bz2";
    sha256 = "0l2gdzp517hjk31318djq0sww6kzckzl9rfqvhgspihn874lm9hb";
  };

  buildInputs = [pkgconfig glib gtk libxml2 bison gettext zlib];

  NIX_LDFLAGS = "-rpath ${zlib}/lib";
  configureScript = "./Configure";
  dontAddPrefix = true;
  configureFlags = "-d -e -D prefix=$out -D gtkversion=2 -D official=true";

  meta = {
    homepage = "http://gtk-gnutella.sourceforge.net/";
    description = "a server/client for Gnutella";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
