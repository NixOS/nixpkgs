{ stdenv, fetchurl, perl, gd, rrdtool }:

stdenv.mkDerivation rec {

  version = "2.17.7";
  name = "mrtg-${version}";

  src = fetchurl {
    url = "https://oss.oetiker.ch/mrtg/pub/${name}.tar.gz";
    sha256 = "1hrjqfi290i936nblwpfzjn6v8d8p69frcrvml206nxiiwkcp54v";
  };

  buildInputs = [
    perl gd rrdtool
  ];

  meta = {
    description = "The Multi Router Traffic Grapher";
    homepage = https://oss.oetiker.ch/mrtg/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.robberer ];
    platforms = stdenv.lib.platforms.unix;
  };
}
