{
  bash
, fetchurl
, gnused
, jre
, lib
, makeBinaryWrapper
, stdenv
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "confluent-platform";
  version = "7.6.0";

  src = fetchurl {
    url = "https://packages.confluent.io/archive/${lib.versions.majorMinor finalAttrs.version}/confluent-${finalAttrs.version}.tar.gz";
    hash = "sha256-bHT8VWSUqxiM/g7opRXZmEOAs2d61dWBTtuwwlzPgBc=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  buildInputs = [
    bash
    jre
  ];

  installPhase = ''
    runHook preInstall

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

    runHook postInstall
  '';

  meta = {
    description = "Confluent event streaming platform based on Apache Kafka";
    homepage = "https://www.confluent.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ zoedsoupe autophagy ];
    platforms = lib.platforms.unix;
  };
})
