{stdenv, fetchurl, jdk}:

stdenv.mkDerivation {

  name = "apache-tomcat-6.0.14";

  builder = ./builder-6.0.sh;

  src = fetchurl {
    url = http://apache.mirrors.webazilla.nl/tomcat/tomcat-6/v6.0.14/bin/apache-tomcat-6.0.14.tar.gz;
    md5 = "3b18ff250d8172737c4f67f11631f68a";
  };

  inherit jdk;
}
