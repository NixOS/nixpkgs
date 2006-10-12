{ stdenv, fetchurl, pkgconfig, libxml2, libxslt, popt
, glib, pango, libgnomeprint, pangoxsl, gtk}:

stdenv.mkDerivation {
  #name = "xmlroff-0.3.5";
  name = "xmlroff-0.3.98";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/xmlroff-0.3.98.tar.gz;
    md5 = "6c1d05b6480e98870751bf9102ea68e2";
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
