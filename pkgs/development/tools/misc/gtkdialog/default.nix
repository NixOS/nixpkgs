{stdenv, fetchurl, gtk, pkgconfig, hicolor_icon_theme }:

stdenv.mkDerivation {
  name = "gtkdialog-0.8.3";

  src = fetchurl {
    url = http://gtkdialog.googlecode.com/files/gtkdialog-0.8.3.tar.gz;
    sha256 = "ff89d2d7f1e6488e5df5f895716ac1d4198c2467a2a5dc1f51ab408a2faec38e";
  };

  buildInputs = [ gtk pkgconfig hicolor_icon_theme ];

  meta = {
    homepage = http://gtkdialog.googlecode.com/;
    description = "Small utility for fast and easy GUI building from many scripted and compiled languages";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
