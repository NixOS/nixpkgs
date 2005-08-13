{ stdenv, fetchurl, pkgconfig, libxml2, libxslt, popt
, glib, pango, libgnomeprint, pangoxsl, gtk}:

stdenv.mkDerivation {
  name = "xmlroff-0.3.4";
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/xmlroff/xmlroff-0.3.4.tar.gz;
    md5 = "f6432e8a66e6f934823463a3f127e4ca";
  };

  buildInputs = [
    pkgconfig
    libxml2
    libxslt
    glib
    pango
    libgnomeprint
    pangoxsl
    gtk
    popt
  ];
}
