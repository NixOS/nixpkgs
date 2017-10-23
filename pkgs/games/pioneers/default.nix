{stdenv, fetchurl, gtk2, pkgconfig, intltool } :

stdenv.mkDerivation rec {
  name = "pioneers-0.12.3";
  src = fetchurl {
    url = "mirror://sourceforge/pio/${name}.tar.gz";
    sha256 = "1yqypk5wmia8fqyrg9mn9xw6yfd0fpkxj1355csw1hgx8mh44y1d";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk2 intltool ];

  hardeningDisable = [ "format" ];

  meta = {
    homepage = http://pio.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    description = "Addicting game based on The Settlers of Catan";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
