{ stdenv, fetchurl, makeWrapper, jre, lib }:

stdenv.mkDerivation rec {
  pname = "avro-tools";
  version = "1.11.0";

  src = fetchurl {
    url =
    "mirror://maven/org/apache/avro/avro-tools/${version}/${pname}-${version}.jar";
    sha256 = "sha256-XnfvND5WPojzIS8t0ntwn+3+Zjz9ABEUK2FO6aD4ulw=";
  };

  dontUnpack = true;

  buildInputs = [ jre ];
  nativeBuildInputs = [ makeWrapper ];
  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/libexec/avro-tools
    cp $src $out/libexec/avro-tools/${pname}.jar

    makeWrapper ${jre}/bin/java $out/bin/avro-tools \
    --add-flags "-jar $out/libexec/avro-tools/${pname}.jar"
  '';

  meta = with lib; {
    homepage    = "https://avro.apache.org/";
    description = "Avro command-line tools and utilities";
    license     = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
