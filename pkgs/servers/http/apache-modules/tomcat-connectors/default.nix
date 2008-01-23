{stdenv, fetchurl, apacheHttpd, jdk}:

stdenv.mkDerivation {
  name = "tomcat-connectors-1.2.26";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://apache.proserve.nl/tomcat/tomcat-connectors/jk/source/jk-1.2.26/tomcat-connectors-1.2.26-src.tar.gz;
    md5 = "feaec245136bc4d99a9dde95a00ea93c";
  };

  inherit apacheHttpd;
  buildInputs = [apacheHttpd jdk];
}
