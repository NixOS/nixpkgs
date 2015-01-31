{ stdenv, fetchurl, jre, makeWrapper, bash }:

let
  kafkaVersion = "0.8.1.1";
  scalaVersion = "2.8.0";

in

stdenv.mkDerivation rec {
  version = "${scalaVersion}-${kafkaVersion}";
  name = "apache-kafka-${version}";

  src = fetchurl {
    url = "mirror://apache/kafka/${kafkaVersion}/kafka_${version}.tgz";
    sha256 = "1bya4qs0ccrqibmdivgdxcsyiay4c3vywddrkci1dz9v3ymrqby9";
  };

  buildInputs = [ jre makeWrapper bash ];

  installPhase = ''
    mkdir -p $out
    cp -R config libs $out

    mkdir -p $out/bin
    cp bin/kafka* $out/bin

    # allow us the specify logging directory using env
    substituteInPlace $out/bin/kafka-run-class.sh \
      --replace 'LOG_DIR=$base_dir/logs' 'LOG_DIR=$KAFKA_LOG_DIR'

    for p in $out/bin\/*.sh; do
      wrapProgram $p \
        --set JAVA_HOME "${jre}" \
        --set KAFKA_LOG_DIR "/tmp/apache-kafka-logs" \
        --prefix PATH : "${bash}/bin"
    done
    chmod +x $out/bin\/*
  '';

  meta = with stdenv.lib; {
    homepage = "http://kafka.apache.org";
    description = "A high-throughput distributed messaging system";
    license = licenses.asl20;
    maintainers = [ maintainers.ragge ];
    platforms = platforms.unix;
  };

}
