{ stdenv, fetchurl, perl, perlXMLParser, libX11, libwnck, pkgconfig, glib, gdk_pixbuf, gtk, gettext }:

let version = "0.22"; in

stdenv.mkDerivation {
  name = "devilspie-${version}";

  src = fetchurl {
    url = "http://burtonini.com/computing/devilspie-${version}.tar.gz";
    md5 = "4190e12f99ab92c0427e457d9fbfe231";
  };

  meta = {
    homepage = "http://burtonini.com/blog/computers/devilspie";
    description = "A window-matching utility";
  };

  inherit perl;

  patches = [ ./fix_gdk_display_ftbfs.patch ];

  buildInputs = [
    perl perlXMLParser libX11 libwnck pkgconfig glib gdk_pixbuf gtk gettext
  ];
}
