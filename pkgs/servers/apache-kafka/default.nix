{ stdenv, fetchurl, jre, makeWrapper, bash,
  majorVersion ? "0.9" }:

let
  versionMap = {
    "0.8" = { kafkaVersion = "0.8.2.2";
              scalaVersion = "2.10";
              sha256 = "1azccf1k0nr8y1sfpjgqf9swyp87ypvgva68ci4kczwcx1z9d89v";
            };
    "0.9" = { kafkaVersion = "0.9.0.1";
              scalaVersion = "2.11";
              sha256 = "0ykcjv5dz9i5bws9my2d60pww1g9v2p2nqr67h0i2xrjm7az8a6v";
            };
    "0.10" = { kafkaVersion = "0.10.1.1";
               scalaVersion = "2.11";
               sha256 = "0a89dyvisa5vilfa0h0ljrb00l5n9h730yxy1058z7a2g43q0h0m";
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
    homepage = "http://kafka.apache.org";
    description = "A high-throughput distributed messaging system";
    license = licenses.asl20;
    maintainers = [ maintainers.ragge ];
    platforms = platforms.unix;
  };

}
