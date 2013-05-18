{ stdenv, fetchurl, pkgconfig, intltool, gtk2 }:

stdenv.mkDerivation rec {
  name = "parcellite-1.1.4";

  src = fetchurl {
    url = "mirror://sourceforge/parcellite/${name}.tar.gz";
    sha256 = "10lr2gx81i7nlxvafa9j9hnlj402k1szyi08xsl841hs1m9zdwan";
  };

  buildInputs = [ pkgconfig intltool gtk2 ];

  meta = {
    description = "Lightweight GTK+ clipboard manager";
    homepage = "http://parcellite.sourceforge.net";
    license = "GPLv3+";
  };
}
