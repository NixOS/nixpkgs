{ lib, stdenv, fetchurl, perl, gd, rrdtool }:

stdenv.mkDerivation rec {
  pname = "mrtg";
  version = "2.17.10";

  src = fetchurl {
    url = "https://oss.oetiker.ch/mrtg/pub/${pname}-${version}.tar.gz";
    sha256 = "sha256-x/EcteIXpQDYfuO10mxYqGUu28DTKRaIu3krAQ+uQ6w=";
  };

  buildInputs = [
    perl
    gd
    rrdtool
  ];

  meta = with lib; {
    description = "The Multi Router Traffic Grapher";
    homepage = "https://oss.oetiker.ch/mrtg/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ robberer ];
    platforms = platforms.unix;
  };
}
