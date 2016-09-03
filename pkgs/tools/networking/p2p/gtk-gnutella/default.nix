{ stdenv, fetchurl, bison, pkgconfig
, glib, gtk, libxml2, gettext, zlib, binutils, gnutls }:

let
  name = "gtk-gnutella";
  version = "1.1.9";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${name}-${version}.tar.bz2";
    sha256 = "1zvadgsskmpm82id9mbj24a2lyq38qv768ixv7nmfjl3d4wr2biv";
  };

  nativeBuildInputs = [ bison binutils gettext pkgconfig ];
  buildInputs = [ glib gnutls gtk libxml2 zlib ];

  hardeningDisable = [ "bindnow" "fortify" "pic" "relro" ];

  configureScript = "./build.sh --configure-only";

  meta = with stdenv.lib; {
    homepage = http://gtk-gnutella.sourceforge.net/;
    description = "Server/client for Gnutella";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
