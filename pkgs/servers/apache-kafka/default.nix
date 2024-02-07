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
    "3.4" = {
      kafkaVersion = "3.4.1";
      scalaVersion = "2.13";
      sha256 = "sha256-p28XpSuPLNMd4RVx/zZqcUggtuTgKJOwFZ0J2w7a+Zg=";
      jre = jdk17_headless;
    };
    "3.3" = {
      kafkaVersion = "3.3.2";
      scalaVersion = "2.13";
      sha256 = "sha256-Gv5XrpXnEajH8fSbcfIfURz+QPcqTrJ1oe3SGXYLNRc=";
      jre = jdk17_headless;
    };
    "3.2" = {
      kafkaVersion = "3.2.3";
      scalaVersion = "2.13";
      sha256 = "sha256-tvkbwBP83M1zl31J4g6uu4/LEhqJoIA9Eam48fyT24A=";
      jre = jdk17_headless;
    };
    "3.1" = {
      kafkaVersion = "3.1.2";
      scalaVersion = "2.13";
      sha256 = "sha256-SO1bTQkG3YQSv657QjwBeBCWbDlDqS3E5eUp7ciojnI=";
      jre = jdk17_headless;
    };
    "3.0" = {
      kafkaVersion = "3.0.2";
      scalaVersion = "2.13";
      sha256 = "sha256-G8b6STGlwow+iDqMCeZkF3HTKd94TKccmyfZ7AT/7yE=";
      jre = jdk17_headless;
    };
    "2.8" = {
      kafkaVersion = "2.8.2";
      scalaVersion = "2.13";
      sha256 = "sha256-inZXZJSs8ivtEqF6E/ApoyUHn8vg38wUG3KhowP8mfQ=";
      jre = jdk11_headless;
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
    description = "A high-throughput distributed messaging system";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    maintainers = [ maintainers.ragge ];
    platforms = platforms.unix;
  };
}
