{ lib, stdenv, fetchurl, jdk, makeWrapper }:

assert jdk != null;

stdenv.mkDerivation rec {
  pname = "apache-maven";
  version = "3.8.2";

  builder = ./builder.sh;

  src = fetchurl {
    url = "mirror://apache/maven/maven-3/${version}/binaries/${pname}-${version}-bin.tar.gz";
    sha256 = "sha256-ja4QsJ/re45MB5/DmhHzKWq2MP2bxE7OoPsojOx3cPc=";
  };

  nativeBuildInputs = [ makeWrapper ];

  inherit jdk;

  meta = with lib; {
    description = "Build automation tool (used primarily for Java projects)";
    homepage = "http://maven.apache.org/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ cko ];
  };
}
