{ lib, stdenv, fetchurl, jdk17_headless, jdk11_headless, makeWrapper, bash, coreutils, gnugrep, gnused, ps,
  majorVersion ? "1.0" }:

let
  versionMap = {
    "3.6" = {
      kafkaVersion = "3.6.1";
      scalaVersion = "2.13";
      sha256 = "sha256-49tWjH+PzMf5gep7CUQmiukxBZLHPuDrV56/2/zy08o=";
      jre = jdk17_headless;
    };
    "3.5" = {
      kafkaVersion = "3.5.2";
      scalaVersion = "2.13";
      sha256 = "sha256-vBryxHFLPFB8qpFFkMKOeBX2Zxp0MkvEd+HIOohUg8M=";
      jre = jdk17_headless;
    };
  };
in

with versionMap.${majorVersion};

stdenv.mkDerivation rec {
  version = "${scalaVersion}-${kafkaVersion}";
  pname = "apache-kafka";

  src = fetchurl {
    url = "mirror://apache/kafka/${kafkaVersion}/kafka_${version}.tgz";
    inherit sha256;
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre bash gnugrep gnused coreutils ps ];

  installPhase = ''
    mkdir -p $out
    cp -R config libs $out

    mkdir -p $out/bin
    cp bin/kafka* $out/bin
    cp bin/connect* $out/bin

    # allow us the specify logging directory using env
    substituteInPlace $out/bin/kafka-run-class.sh \
      --replace 'LOG_DIR="$base_dir/logs"' 'LOG_DIR="$KAFKA_LOG_DIR"'

    substituteInPlace $out/bin/kafka-server-stop.sh \
      --replace 'ps' '${ps}/bin/ps'

    for p in $out/bin\/*.sh; do
      wrapProgram $p \
        --set JAVA_HOME "${jre}" \
        --set KAFKA_LOG_DIR "/tmp/apache-kafka-logs" \
        --prefix PATH : "${bash}/bin:${coreutils}/bin:${gnugrep}/bin:${gnused}/bin"
    done
    chmod +x $out/bin\/*
  '';

  passthru = {
    inherit jre; # Used by the NixOS module to select the supported jre
  };

  meta = with lib; {
    homepage = "https://kafka.apache.org";
    description = "High-throughput distributed messaging system";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    maintainers = [ maintainers.ragge ];
    platforms = platforms.unix;
  };
}
