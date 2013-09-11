{ stdenv, fetchurl, pkgconfig, intltool, gtk2, iconnamingutils }:

stdenv.mkDerivation {
  name = "mate-icon-theme-1.6.1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/1.6/mate-icon-theme-1.6.1.tar.xz";
    sha256 = "154x0mcsvjmz84vi94kjh8hpydny3ab9lbg58wxh1lskmbc2473x";
  };

  buildInputs = [ pkgconfig intltool gtk2 iconnamingutils ];

  meta = {
    description = "Icon themes from MATE";
    homepage = "http://mate-desktop.org";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };
}
