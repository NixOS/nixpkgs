{ stdenv, fetchurl, jdk, makeWrapper }:

assert jdk != null;

let version = "3.6.1"; in
stdenv.mkDerivation rec {
  name = "apache-maven-${version}";

  builder = ./builder.sh;

  src = fetchurl {
    url = "mirror://apache/maven/maven-3/${version}/binaries/${name}-bin.tar.gz";
    sha256 = "1rv97g9qr6sifl88rxbsqnz5i79m6ifs36srri08j3y3k5dc6a15";
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
