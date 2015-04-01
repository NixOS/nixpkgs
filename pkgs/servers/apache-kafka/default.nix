{ stdenv, fetchurl, jre, makeWrapper, bash }:

let
  kafkaVersion = "0.8.2.1";
  scalaVersion = "2.10";

in

stdenv.mkDerivation rec {
  version = "${scalaVersion}-${kafkaVersion}";
  name = "apache-kafka-${version}";

  src = fetchurl {
    url = "mirror://apache/kafka/${kafkaVersion}/kafka_${version}.tgz";
    sha256 = "1klri23fjxbzv7rmi05vcqqfpy7dzi1spn2084y1dxsi1ypfkvc9";
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
