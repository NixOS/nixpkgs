{ stdenv, fetchurl, pkgconfig, intltool, gtk2 }:

stdenv.mkDerivation rec {
  name = "parcellite-1.1.7";

  src = fetchurl {
    url = "mirror://sourceforge/parcellite/${name}.tar.gz";
    sha256 = "0pszw3yd4a08p6jsz7asayr7jir08bxbwvfb16k01cj7ya4kf3w7";
  };

  buildInputs = [ pkgconfig intltool gtk2 ];

  meta = {
    description = "Lightweight GTK+ clipboard manager";
    homepage = "http://parcellite.sourceforge.net";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };
}
