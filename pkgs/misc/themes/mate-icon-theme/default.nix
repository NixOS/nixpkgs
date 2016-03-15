{ stdenv, fetchurl, pkgconfig, intltool, gtk2, iconnamingutils }:

stdenv.mkDerivation {
  name = "mate-icon-theme-1.6.3";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/1.6/mate-icon-theme-1.6.3.tar.xz";
    sha256 = "1r3qkx4k9svmxdg453r9d3hs47cgagxsngzi8rp6yry0c9bw5r5w";
  };

  buildInputs = [ pkgconfig intltool gtk2 iconnamingutils ];

  meta = {
    description = "Icon themes from MATE";
    homepage = "http://mate-desktop.org";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
