{ stdenv, fetchurl, pkgconfig, intltool, gtk2 }:

stdenv.mkDerivation rec {
  name = "parcellite-1.1.9";

  src = fetchurl {
    url = "mirror://sourceforge/parcellite/${name}.tar.gz";
    sha256 = "1m0igxny8f8hlbwcbsr4vg08808sqwy05h61ia2bxsrf122rba6b";
  };

  buildInputs = [ pkgconfig intltool gtk2 ];

  meta = {
    description = "Lightweight GTK+ clipboard manager";
    homepage = "http://parcellite.sourceforge.net";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
