{ stdenv, fetchurl, pkgconfig, libxml2, libxslt, popt
, glib, pango, libgnomeprint, pangoxsl, gtk}:

stdenv.mkDerivation {
  name = "xmlroff-0.3.5";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/xmlroff-0.3.5.tar.gz;
    md5 = "4f03dffa0451c28e7c777f6ee1fa38da";
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
