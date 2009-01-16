{stdenv, fetchurl, jdk}:

stdenv.mkDerivation {

  name = "apache-tomcat-6.0.18";

  builder = ./builder-6.0.sh;

  src = fetchurl {
    url = http://apache.mirrors.webazilla.nl/tomcat/tomcat-6/v6.0.18/bin/apache-tomcat-6.0.18.tar.gz;
    md5 = "8354e156f097158f8d7b699078fd39c1";
  };

  inherit jdk;
}
