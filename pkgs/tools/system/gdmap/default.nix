{ stdenv, fetchurl, gtk, pkgconfig, libxml2, intltool, gettext }:

stdenv.mkDerivation rec {
  name = "gdmap-0.8.1";

  src = fetchurl {
    url = "mirror://sourceforge/gdmap/${name}.tar.gz";
    sha256 = "0nr8l88cg19zj585hczj8v73yh21k7j13xivhlzl8jdk0j0cj052";
  };

  buildInputs = [ gtk pkgconfig libxml2 intltool gettext ];

  patches = [ ./get_sensitive.patch ./set_flags.patch ];

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    homepage = http://gdmap.sourceforge.net;
    description = "Recursive rectangle map of disk usage";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
