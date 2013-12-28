{stdenv, fetchurl, pkgconfig, glib, gtk, libxml2, bison, gettext, zlib}:

let
  name = "gtk-gnutella";
  version = "1.0.0";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${name}-${version}.tar.bz2";
    sha256 = "11nri43q99zbxql9wg3pkq98vcgzvbndpzc3a1jlg3lzh7css0hc";
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
