{ stdenv, lib, fetchurl, fetchFromGitHub
, jre, makeWrapper, bash, gnused }:

stdenv.mkDerivation rec {
  pname = "confluent-platform";
  version = "7.2.1";

  src = fetchurl {
    url = "https://packages.confluent.io/archive/${lib.versions.majorMinor version}/confluent-${version}.tar.gz";
    sha256 = "sha256-vflWZjW8RwaDOwEFy8GHRfcmsHcRKxs8WwFfT66SIM4=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre bash ];

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
        --prefix PATH : "${jre}/bin:${bash}/bin:${gnused}/bin"
    done
  '';

  meta = with lib; {
    homepage = "https://www.confluent.io/";
    description = "Confluent event streaming platform based on Apache Kafka";
    license = licenses.asl20;
    maintainers = with maintainers; [ zoedsoupe ];
    platforms = platforms.unix;
  };
}
