{stdenv, fetchurl, gtk2, pkgconfig, hicolor-icon-theme }:

stdenv.mkDerivation {
  name = "gtkdialog-0.8.3";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/gtkdialog/gtkdialog-0.8.3.tar.gz";
    sha256 = "ff89d2d7f1e6488e5df5f895716ac1d4198c2467a2a5dc1f51ab408a2faec38e";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk2 hicolor-icon-theme ];

  meta = {
    homepage = https://code.google.com/archive/p/gtkdialog/;
    # community links: http://murga-linux.com/puppy/viewtopic.php?t=111923 -> https://github.com/01micko/gtkdialog
    description = "Small utility for fast and easy GUI building from many scripted and compiled languages";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
