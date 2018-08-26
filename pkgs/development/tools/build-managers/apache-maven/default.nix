{ stdenv, fetchurl, jdk, makeWrapper }:

assert jdk != null;

let version = "3.5.4"; in
stdenv.mkDerivation rec {
  name = "apache-maven-${version}";

  builder = ./builder.sh;

  src = fetchurl {
    url = "mirror://apache/maven/maven-3/${version}/binaries/${name}-bin.tar.gz";
    sha256 = "0kd1jzlz3b2kglppi85h7286vdwjdmm7avvpwgppgjv42g4v2l6f";
  };

  buildInputs = [ makeWrapper ];

  inherit jdk;

  meta = with stdenv.lib; {
    description = "Build automation tool (used primarily for Java projects)";
    homepage = http://maven.apache.org/;
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ cko ];
  };
}
