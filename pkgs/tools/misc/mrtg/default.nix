{ lib, stdenv, fetchurl, perl, gd, rrdtool }:

stdenv.mkDerivation rec {

  version = "2.17.7";
  pname = "mrtg";

  src = fetchurl {
    url = "https://oss.oetiker.ch/mrtg/pub/${pname}-${version}.tar.gz";
    sha256 = "1hrjqfi290i936nblwpfzjn6v8d8p69frcrvml206nxiiwkcp54v";
  };

  buildInputs = [
    perl gd rrdtool
  ];

  meta = {
    description = "The Multi Router Traffic Grapher";
    homepage = "https://oss.oetiker.ch/mrtg/";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.robberer ];
    platforms = lib.platforms.unix;
  };
}
