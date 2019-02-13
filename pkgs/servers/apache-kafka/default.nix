{ stdenv, fetchurl, jre, makeWrapper, bash, coreutils, gnugrep, gnused,
  majorVersion ? "1.0" }:

let
  versionMap = {
    "0.9" = {
      kafkaVersion = "0.9.0.1";
      scalaVersion = "2.11";
      sha256 = "0ykcjv5dz9i5bws9my2d60pww1g9v2p2nqr67h0i2xrjm7az8a6v";
    };
    "0.10" = {
      kafkaVersion = "0.10.2.2";
      scalaVersion = "2.12";
      sha256 = "13wibnz7n7znv2g13jlpkz1r0y73qy5b02pdqhsq7cl72h9s6wms";
    };
    "0.11" = {
      kafkaVersion = "0.11.0.3";
      scalaVersion = "2.12";
      sha256 = "0zkzp9a8lcfcpavks131119v10hpn90sc0pw4f90jc4zn2yw3rgd";
    };
    "1.0" = {
      kafkaVersion = "1.0.2";
      scalaVersion = "2.12";
      sha256 = "0cmq8ww1lbkp3ipy9d1q8c1yz4kfwj0v4ynnhsk1i48sqlmvwybj";
    };
    "1.1" = {
      kafkaVersion = "1.1.1";
      scalaVersion = "2.12";
      sha256 = "13vg0wm2fsd06pfw05m4bhcgbjmb2bmd4i31zfs48w0f7hjc8qf2";
    };
    "2.0" = {
      kafkaVersion = "2.0.1";
      scalaVersion = "2.12";
      sha256 = "0i62q3542cznf711kiskaa30l06gq9ckszlxja4k1vs1flxz5khl";
    };
    "2.1" = {
      kafkaVersion = "2.1.0";
      scalaVersion = "2.12";
      sha256 = "11jgxyqxsw4hc85ba2czc8wdzlnywyb4ab8qd5f2y27mhak482x7";
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

  buildInputs = [ jre makeWrapper bash gnugrep gnused coreutils ];

  installPhase = ''
    mkdir -p $out
    cp -R config libs $out

    mkdir -p $out/bin
    cp bin/kafka* $out/bin
    cp bin/connect* $out/bin

    # allow us the specify logging directory using env
    substituteInPlace $out/bin/kafka-run-class.sh \
      --replace 'LOG_DIR="$base_dir/logs"' 'LOG_DIR="$KAFKA_LOG_DIR"'

    for p in $out/bin\/*.sh; do
      wrapProgram $p \
        --set JAVA_HOME "${jre}" \
        --set KAFKA_LOG_DIR "/tmp/apache-kafka-logs" \
        --prefix PATH : "${bash}/bin:${coreutils}/bin:${gnugrep}/bin:${gnused}/bin"
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
