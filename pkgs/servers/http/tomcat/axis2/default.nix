{ lib, stdenv, fetchurl, apacheAnt, jdk, unzip }:

stdenv.mkDerivation rec {
  pname = "axis2";
  version = "1.7.9";

  src = fetchurl {
    url = "http://apache.proserve.nl/axis/axis2/java/core/${version}/${pname}-${version}-bin.zip";
    sha256 = "0dh0s9bfh95wmmw8nyf2yw95biq7d9zmrbg8k4vzcyz1if228lac";
  };

  buildInputs = [ unzip apacheAnt jdk ];

  installPhase = ''
    mkdir -p $out
    cp -av * $out
    cd webapp
    ant
    cd ..
    mkdir -p $out/webapps
    cp dist/axis2.war $out/webapps
    cd $out/webapps
    mkdir axis2
    cd axis2
    unzip ../axis2.war
  '';

  meta = {
    description = "Web Services / SOAP / WSDL engine, the successor to the widely used Apache Axis SOAP stack";
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
  };
}
