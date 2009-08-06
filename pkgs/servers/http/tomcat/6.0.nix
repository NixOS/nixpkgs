{stdenv, fetchurl, jdk}:

stdenv.mkDerivation {

  name = "apache-tomcat-6.0.20";

  builder = ./builder-6.0.sh;

  src = fetchurl {
    url = http://apache.mirrors.webazilla.nl/tomcat/tomcat-6/v6.0.20/bin/apache-tomcat-6.0.20.tar.gz;
    sha256 = "0vh48rvbynawivqm3hs7453527g8qns9kcj7vmihjpf21mrc2hx4";
  };

  inherit jdk;
}
