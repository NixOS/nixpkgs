{ stdenv, fetchurl, apacheAnt, jdk, unzip }:

stdenv.mkDerivation rec {
  name = "axis2-${version}";
  version = "1.7.9";

  src = fetchurl {
    url = "http://apache.proserve.nl/axis/axis2/java/core/${version}/${name}-bin.zip";
    sha256 = "0dh0s9bfh95wmmw8nyf2yw95biq7d9zmrbg8k4vzcyz1if228lac";
  };

  buildInputs = [ unzip apacheAnt jdk ];
  builder = ./builder.sh;

  meta = {
    description = "Web Services / SOAP / WSDL engine, the successor to the widely used Apache Axis SOAP stack";
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.asl20;
  };
}
