{ stdenv, fetchurl, apacheAnt, jdk, unzip }:

stdenv.mkDerivation rec {
  name = "axis2-${version}";
  version = "1.7.8";

  src = fetchurl {
    url = "http://apache.proserve.nl/axis/axis2/java/core/${version}/${name}-bin.zip";
    sha256 = "0k1ppxb9v6agx4gcfkpgwcri6v29ng3arjyc0b0mxcby6ck85mny";
  };

  buildInputs = [ unzip apacheAnt jdk ];
  builder = ./builder.sh;

  meta = {
    description = "Web Services / SOAP / WSDL engine, the successor to the widely used Apache Axis SOAP stack";
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.asl20;
  };
}
