{stdenv, fetchurl, jdk}:

stdenv.mkDerivation {

  name = "apache-tomcat-6.0.26";

  builder = ./builder-6.0.sh;

  src = fetchurl {
    url = http://apache.proserve.nl/tomcat/tomcat-6/v6.0.26/bin/apache-tomcat-6.0.26.tar.gz;
    sha256 = "0rxaz7wkw6xas9f2jslb6kp1prllhpqmq7c3h0ig19j146mrjbls";
  };

  inherit jdk;
}
