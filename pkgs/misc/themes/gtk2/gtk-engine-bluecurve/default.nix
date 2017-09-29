{ stdenv, fetchurl, pkgconfig, intltool, gtk2 }:

stdenv.mkDerivation {
  name = "gtk-engine-bluecurve-1.0";

  src = fetchurl {
    url = "http://ftp.gnome.org/pub/gnome/teams/art.gnome.org/archive/themes/gtk2/GTK2-Wonderland-Engine-1.0.tar.bz2";
    sha256 = "1nim3lhmbs5mw1hh76d9258c1p923854x2j6i30gmny812c7qjnm";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  buildInputs = [ gtk2 ];

  meta = {
    description = "Original Bluecurve engine from Red Hat's artwork package";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.gnidorah ];
  };
}
