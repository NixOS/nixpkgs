{ stdenv, fetchurl, apacheAnt, jdk, unzip }:

stdenv.mkDerivation rec {
  name = "axis2-${version}";
  version = "1.6.4";

  src = fetchurl {
    url = "http://apache.proserve.nl/axis/axis2/java/core/${version}/${name}-bin.zip";
    sha256 = "12ir706dn95567j6lkxdwrh28vnp6292h59qwjyqjm7ckglkmgyr";
  };

  buildInputs = [ unzip apacheAnt jdk ];
  builder = ./builder.sh;

  meta = {
    description = "Web Services / SOAP / WSDL engine, the successor to the widely used Apache Axis SOAP stack";
    platforms = stdenv.lib.platforms.unix;
  };
}
