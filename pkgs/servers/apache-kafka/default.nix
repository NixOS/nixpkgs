{ stdenv, fetchurl, jre, makeWrapper, bash,
  majorVersion ? "1.0" }:

let
  versionMap = {
    "0.9" = {
      kafkaVersion = "0.9.0.1";
      scalaVersion = "2.11";
      sha256 = "0ykcjv5dz9i5bws9my2d60pww1g9v2p2nqr67h0i2xrjm7az8a6v";
    };
    "0.10" = {
      kafkaVersion = "0.10.2.1";
      scalaVersion = "2.12";
      sha256 = "0iszr6r0n9yjgq7kcp1hf00fg754m86gs4jzqc18542an94b88z5";
    };
    "0.11" = {
      kafkaVersion = "0.11.0.1";
      scalaVersion = "2.12";
      sha256 = "1wj639h95aq5n132fq1rbyzqh5rsa4mlhbg3c5mszqglnzdz4xn7";
    };
    "1.0" = {
      kafkaVersion = "1.0.0";
      scalaVersion = "2.12";
      sha256 = "1cs4nmp39m99gqjpy5klsffqksc0h9pz514jkq99qb95a83x1cfm";
    };
  };
in

with versionMap.${majorVersion};

stdenv.mkDerivation rec {
  version = "${scalaVersion}-${kafkaVersion}";
  name = "apache-kafka-${version}";

  src = fetchurl {
    url = "mirror://apache/kafka/${kafkaVersion}/kafka_${version}.tgz";
    inherit sha256;
  };

  buildInputs = [ jre makeWrapper bash ];

  installPhase = ''
    mkdir -p $out
    cp -R config libs $out

    mkdir -p $out/bin
    cp bin/kafka* $out/bin

    # allow us the specify logging directory using env
    substituteInPlace $out/bin/kafka-run-class.sh \
      --replace 'LOG_DIR="$base_dir/logs"' 'LOG_DIR="$KAFKA_LOG_DIR"'

    for p in $out/bin\/*.sh; do
      wrapProgram $p \
        --set JAVA_HOME "${jre}" \
        --set KAFKA_LOG_DIR "/tmp/apache-kafka-logs" \
        --prefix PATH : "${bash}/bin"
    done
    chmod +x $out/bin\/*
  '';

  meta = with stdenv.lib; {
    homepage = http://kafka.apache.org;
    description = "A high-throughput distributed messaging system";
    license = licenses.asl20;
    maintainers = [ maintainers.ragge ];
    platforms = platforms.unix;
  };

}
