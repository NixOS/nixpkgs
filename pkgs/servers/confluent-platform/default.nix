{ stdenv, lib, fetchurl, jre, makeWrapper, bash, gnused }:

let 
  scalaVersion = "2.12"; 
in
stdenv.mkDerivation rec {
  name = "confluent-platform-${version}";
  version = "5.2.1";

  src = fetchurl {
    url = "http://packages.confluent.io/archive/${lib.versions.majorMinor version}/confluent-${version}-${scalaVersion}.tar.gz";
    sha256 = "11fdcc557aca782e87352ed6e655c37c71fb7b3a003796ee956970b01dedbbb1";
  };

  buildInputs = [ jre makeWrapper bash ];

  installPhase = ''
    mkdir -p $out
    cp -R bin etc share src $out
    rm -rf $out/bin/windows

    patchShebangs $out/bin

    # allow us the specify logging directory using env
    substituteInPlace $out/bin/kafka-run-class \
      --replace 'LOG_DIR="$base_dir/logs"' 'LOG_DIR="$KAFKA_LOG_DIR"'

    substituteInPlace $out/bin/ksql-run-class \
      --replace 'LOG_DIR="$base_dir/logs"' 'LOG_DIR="$KAFKA_LOG_DIR"'

    for p in $out/bin\/*; do
      wrapProgram $p \
        --set JAVA_HOME "${jre}" \
        --set KAFKA_LOG_DIR "/tmp/apache-kafka-logs" \
        --prefix PATH : "${bash}/bin:${gnused}/bin"
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://www.confluent.io/;
    description = "Confluent event streaming platform based on Apache Kafka";
    license = licenses.asl20;
    maintainers = [ maintainers.offline ];
    platforms = platforms.unix;
  };
}
