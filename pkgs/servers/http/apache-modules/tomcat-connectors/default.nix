{stdenv, fetchurl, apacheHttpd, jdk}:

stdenv.mkDerivation {
  name = "tomcat-connectors-1.2.31";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://apache.hippo.nl//tomcat/tomcat-connectors/jk/source/jk-1.2.31/tomcat-connectors-1.2.31-src.tar.gz;
    sha256 = "0604mcxj7zdzdl2f8krpj8ig1r5qkga3hia28pijdpvy9n6pxij8";
  };

  inherit apacheHttpd;
  buildInputs = [apacheHttpd jdk];
}
