{ stdenv, fetchurl, jdk, makeWrapper }:

assert jdk != null;

let version = "3.6.3"; in
stdenv.mkDerivation rec {
  pname = "apache-maven";
  inherit version;

  builder = ./builder.sh;

  src = fetchurl {
    url = "mirror://apache/maven/maven-3/${version}/binaries/${pname}-${version}-bin.tar.gz";
    sha256 = "1i9qlj3vy4j1yyf22nwisd0pg88n9qzp9ymfhwqabadka7br3b96";
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
