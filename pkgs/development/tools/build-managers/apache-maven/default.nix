{ stdenv, fetchurl, jdk, makeWrapper }:

assert jdk != null;

let version = "3.5.0"; in
stdenv.mkDerivation rec {
  name = "apache-maven-${version}";

  builder = ./builder.sh;

  src = fetchurl {
    url = "mirror://apache/maven/maven-3/${version}/binaries/${name}-bin.tar.gz";
    sha256 = "0d7hjnj77hc7qqnnfmqlwij8n6pcldfavvd6lilvv5ak4hci9fdy";
  };

  buildInputs = [ makeWrapper ];

  inherit jdk;

  meta = with stdenv.lib; {
    description = "Build automation tool (used primarily for Java projects)";
    homepage = http://maven.apache.org/;
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
