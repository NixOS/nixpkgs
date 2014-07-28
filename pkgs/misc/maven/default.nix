{ stdenv, fetchurl, jdk, makeWrapper }:

assert jdk != null;

stdenv.mkDerivation {
  name = "apache-maven-3.1.1";

  builder = ./builder.sh;

  src = fetchurl {
    url = mirror://apache/maven/binaries/apache-maven-3.1.1-bin.tar.gz;
    sha256 = "06ymc5y8bp5crcz74z2m9pf58aid5q11v2klnjmxb4ar8mkd8zh7";
  };

  buildInputs = [ makeWrapper ];

  inherit jdk;

  meta = with stdenv.lib; {
    description = "Build automation tool (used primarily for Java projects)";
    homepage = http://maven.apache.org/;
    license = licenses.asl20;
  };
}
