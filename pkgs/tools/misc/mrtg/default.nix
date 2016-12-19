{ stdenv, fetchurl, perl, gd, rrdtool }:

stdenv.mkDerivation rec {

  version = "2.17.4";
  name = "mrtg-${version}";

  src = fetchurl {
    url = "http://oss.oetiker.ch/mrtg/pub/${name}.tar.gz";
    sha256 = "0r93ipscfp7py0b1dcx65s58q7dlwndqhprf8w4945a0h2p7zyjy";
  };

  buildInputs = [
    perl gd rrdtool
  ];

  meta = {
    description = "The Multi Router Traffic Grapher";
    homepage = http://oss.oetiker.ch/mrtg/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.robberer ];
    platforms = stdenv.lib.platforms.unix;
  };
}
