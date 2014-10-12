{ stdenv, fetchurl, pkgconfig, libxml2, libxslt, popt
, glib, pango, libgnomeprint, pangoxsl, gtk}:

stdenv.mkDerivation {
  #name = "xmlroff-0.3.5";
  name = "xmlroff-0.3.98";
  src = fetchurl {
    url = mirror://sourceforge/xmlroff/xmlroff-0.3.98.tar.gz;
    sha256 = "0pg7zc8ri0xzmdk30vnyd84wy8yn973h1bnrvibv71q44s6xhwp2";
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

  configureFlags = "--disable-pangoxsl";

  patches = [./xmlroff.patch];
}
