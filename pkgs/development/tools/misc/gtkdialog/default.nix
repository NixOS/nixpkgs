{stdenv, fetchurl, gtk, pkgconfig}:

stdenv.mkDerivation {
  name = "gtkdialog-0.7.9";

  src = fetchurl {
    url = ftp://linux.pte.hu/pub/gtkdialog/gtkdialog-0.7.9.tar.gz;
    sha256 = "142k8fnh1b8jclm7my2rhk7n8j1b0xh76b2gg712r738r94qwka2";
  };

  buildInputs = [ gtk pkgconfig ];

  meta = {
    homepage = http://linux.pte.hu/~pipas/gtkdialog/;
    description = "Small utility for fast and easy GUI building from many scripted and compiled languages";
    license = "GPLv2+";
  };
}
