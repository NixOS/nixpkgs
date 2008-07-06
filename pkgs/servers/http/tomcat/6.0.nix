{stdenv, fetchurl, jdk}:

stdenv.mkDerivation {

  name = "apache-tomcat-6.0.16";

  builder = ./builder-6.0.sh;

  src = fetchurl {
    url = http://apache.mirrors.webazilla.nl/tomcat/tomcat-6/v6.0.16/bin/apache-tomcat-6.0.16.tar.gz;
    md5 = "4985fed02341a9e04ea43e91e6444ace";
  };

  inherit jdk;
}
