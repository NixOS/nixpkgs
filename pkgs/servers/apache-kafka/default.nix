{ lib, stdenv, fetchurl, jdk8_headless, jdk11_headless, makeWrapper, bash, coreutils, gnugrep, gnused, ps,
  majorVersion ? "1.0" }:

let
  jre8 = jdk8_headless;
  jre11 = jdk11_headless;
  versionMap = {
    "2.4" = {
      kafkaVersion = "2.4.1";
      scalaVersion = "2.12";
      sha256 = "0ahsprmpjz026mhbr79187wfdrxcg352iipyfqfrx68q878wnxr1";
      jre = jre8;
    };
    "2.5" = {
      kafkaVersion = "2.5.1";
      scalaVersion = "2.12";
      sha256 = "1wn4iszrm2rvsfyyr515zx79k5m86davjkcwcwpxcgc4k3q0z7lv";
      jre = jre8;
    };
    "2.6" = {
      kafkaVersion = "2.6.1";
      scalaVersion = "2.13";
      sha256 = "1a2kd4r6f8z7qf886nnq9f350sblzzdi230j2hll7x156888573y";
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
    homepage = "http://kafka.apache.org";
    description = "A high-throughput distributed messaging system";
    license = licenses.asl20;
    maintainers = [ maintainers.ragge ];
    platforms = platforms.unix;
  };
  passthru = { inherit jre; };
}
