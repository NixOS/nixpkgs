{stdenv, fetchurl, gtk2, pkgconfig, intltool } :

stdenv.mkDerivation rec {
  name = "pioneers-15.4";
  src = fetchurl {
    url = "mirror://sourceforge/pio/${name}.tar.gz";
    sha256 = "1p1d18hrfmqcnghip3shkzcs5qkz6j99jvkdkqfi7pqdvjc323cs";
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
