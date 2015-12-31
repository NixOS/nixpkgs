{ stdenv, fetchurl, jdk, makeWrapper }:

assert jdk != null;

let version = "3.3.9"; in
stdenv.mkDerivation rec {
  name = "apache-maven-${version}";

  builder = ./builder.sh;

  src = fetchurl {
    url = "mirror://apache/maven/maven-3/${version}/binaries/${name}-bin.tar.gz";
    sha256 = "6e3e9c949ab4695a204f74038717aa7b2689b1be94875899ac1b3fe42800ff82";
  };

  buildInputs = [ makeWrapper ];

  inherit jdk;

  meta = with stdenv.lib; {
    description = "Build automation tool (used primarily for Java projects)";
    homepage = http://maven.apache.org/;
    license = licenses.asl20;
  };
}
