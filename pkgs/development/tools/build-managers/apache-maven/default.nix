{ stdenv, fetchurl, jdk, makeWrapper }:

assert jdk != null;

stdenv.mkDerivation {
  name = "apache-maven-3.2.3";

  builder = ./builder.sh;

  src = fetchurl {
    url = mirror://apache/maven/maven-3/3.2.3/binaries/apache-maven-3.2.3-bin.tar.gz;
    sha256 = "1vd81bhj68mhnkb0zlarshlk61i2n160pyxxmrc739p3vsm08gxz";
  };

  buildInputs = [ makeWrapper ];

  inherit jdk;

  meta = with stdenv.lib; {
    description = "Build automation tool (used primarily for Java projects)";
    homepage = http://maven.apache.org/;
    license = licenses.asl20;
  };
}
