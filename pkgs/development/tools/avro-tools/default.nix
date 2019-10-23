{ stdenv, fetchurl, makeWrapper, jre, lib }:

stdenv.mkDerivation rec {
  pname = "avro-tools";
  version = "1.9.1";

  src = fetchurl {
    url =
    "https://repo1.maven.org/maven2/org/apache/avro/avro-tools/${version}/${pname}-${version}.jar";
    sha256 = "0d73qbfx59pa4mgsjwgl5dvc4895rm90pdwr4sbd77biscjad94s";
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

  meta = with stdenv.lib; {
    homepage    = https://avro.apache.org/;
    description = "Avro command-line tools and utilities";
    license     = lib.licenses.asl20;
    maintainers = [ lib.maintainers.nequissimus ];
  };
}
