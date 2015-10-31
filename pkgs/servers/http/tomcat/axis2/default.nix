{stdenv, fetchurl, apacheAnt, jdk, unzip}:

stdenv.mkDerivation {
  name = "axis2-1.6.3";

  src = fetchurl {
    url = http://apache.proserve.nl/axis/axis2/java/core/1.6.3/axis2-1.6.3-bin.zip;
    sha256 = "0a49m7g1gxb904d0az2kbkab8rg02wm8nzbyipiad9k028masr6r";
  };

  buildInputs = [ unzip apacheAnt jdk ];
  builder = ./builder.sh;

  meta = {
    description = "Web Services / SOAP / WSDL engine, the successor to the widely used Apache Axis SOAP stack";
  };
}
