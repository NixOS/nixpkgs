{ stdenv, fetchurl, jdk, makeWrapper }:

assert jdk != null;

let version = "3.2.5"; in
stdenv.mkDerivation rec {
  name = "apache-maven-${version}";

  builder = ./builder.sh;

  src = fetchurl {
    url = "mirror://apache/maven/maven-3/${version}/binaries/${name}-bin.tar.gz";
    sha256 = "0md7fizam2lvl0b7fdlfjng6ywm283chmp382agzz4gmpmj046cc";
  };

  buildInputs = [ makeWrapper ];

  inherit jdk;

  meta = with stdenv.lib; {
    description = "Build automation tool (used primarily for Java projects)";
    homepage = http://maven.apache.org/;
    license = licenses.asl20;
  };
}
