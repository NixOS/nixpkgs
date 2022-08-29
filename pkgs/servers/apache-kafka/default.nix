{ lib, stdenv, fetchurl, jdk8_headless, jdk11_headless, makeWrapper, bash, coreutils, gnugrep, gnused, ps,
  majorVersion ? "1.0" }:

let
  jre8 = jdk8_headless;
  jre11 = jdk11_headless;
  versionMap = {
    "2.7" = {
      kafkaVersion = "2.7.1";
      scalaVersion = "2.13";
      sha256 = "1qv6blf99211bc80xnd4k42r9v9c5vilyqkplyhsa6hqymg32gfa";
      jre = jre11;
    };
    "2.8" = {
      kafkaVersion = "2.8.1";
      scalaVersion = "2.13";
      sha256 = "0fgil47hxdnc374k0p9sxv6b163xknp3pkihv3r99p977czb1228";
      jre = jre11;
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

  meta = with lib; {
    homepage = "https://kafka.apache.org";
    description = "A high-throughput distributed messaging system";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    maintainers = [ maintainers.ragge ];
    platforms = platforms.unix;
  };
  passthru = { inherit jre; };
}
