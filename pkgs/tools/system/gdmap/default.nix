{ stdenv, fetchurl, gtk, pkgconfig, libxml2, intltool, gettext }:

stdenv.mkDerivation {
  name = "gdmap-0.8.1";
  
  src = fetchurl {
    url = http://downloads.sourceforge.net/gdmap/gdmap-0.8.1.tar.gz;
    sha256 = "0nr8l88cg19zj585hczj8v73yh21k7j13xivhlzl8jdk0j0cj052";
  };

  buildInputs = [ gtk pkgconfig libxml2 intltool gettext ];

  meta = {
    description = "Recursive rectangle map of disk usage";
  };
}
