{ stdenv, fetchurl, pkgconfig, intltool, gtk2, iconnamingutils }:

stdenv.mkDerivation {
  name = "mate-icon-theme-1.6.2";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/1.6/mate-icon-theme-1.6.2.tar.xz";
    sha256 = "1ahijywk6vj8yyiglqdpc56dkczyj1v99ziblaaclmhi4sxxb5jm";
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
