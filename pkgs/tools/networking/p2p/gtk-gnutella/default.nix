{ stdenv, fetchurl, bison, pkgconfig
, glib, gtk, libxml2, gettext, zlib }:

let
  name = "gtk-gnutella";
  version = "1.1.5";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${name}-${version}.tar.bz2";
    sha256 = "19d8mmyxrdwdafcjq1hvs9zn40yrcj1127163a2058svi0x08cn3";
  };

  nativeBuildInputs = [ bison pkgconfig ];
  buildInputs = [ glib gtk libxml2 gettext zlib ];

  NIX_LDFLAGS = "-rpath ${zlib.out}/lib";
  configureScript = "./Configure";
  dontAddPrefix = true;
  configureFlags = "-d -e -D prefix=$out -D gtkversion=2 -D official=true";

  meta = with stdenv.lib; {
    homepage = http://gtk-gnutella.sourceforge.net/;
    description = "Server/client for Gnutella";
    license = licenses.gpl2;
    broken = true;
  };
}
