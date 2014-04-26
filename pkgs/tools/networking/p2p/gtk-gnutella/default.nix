{stdenv, fetchurl, pkgconfig, glib, gtk, libxml2, bison, gettext, zlib}:

let
  name = "gtk-gnutella";
  version = "1.0.1";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${name}-${version}.tar.bz2";
    sha256 = "010gzk2xqqkm309qnj5k28ghh9i92vvpnn8ly9apzb5gh8bqfm0g";
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
    broken = true;
  };
}
