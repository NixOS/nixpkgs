{ stdenv, fetchurl, jre, makeWrapper, bash, coreutils, gnugrep, gnused, ps,
  majorVersion ? "2.2" }:

let
  versionMap = {
    "0.11" = {
      kafkaVersion = "0.11.0.3";
      scalaVersion = "2.12";
      sha256 = "0zkzp9a8lcfcpavks131119v10hpn90sc0pw4f90jc4zn2yw3rgd";
    };
    "1.1" = {
      kafkaVersion = "1.1.1";
      scalaVersion = "2.12";
      sha256 = "13vg0wm2fsd06pfw05m4bhcgbjmb2bmd4i31zfs48w0f7hjc8qf2";
    };
    "2.1" = {
      kafkaVersion = "2.1.1";
      scalaVersion = "2.12";
      sha256 = "1gm7xiqkbg415mbj9mlazcndmky81xvg4wmz0h94yv1whp7fslr0";
    };
    "2.2" = {
      kafkaVersion = "2.2.1";
      scalaVersion = "2.12";
      sha256 = "1svdnhdzq9a6jsig513i0ahaysfgar5i385bq9fz7laga6a4z3qv";
    };
    "2.3" = {
      kafkaVersion = "2.3.1";
      scalaVersion = "2.12";
      sha256 = "0bldfrvd351agm237icnvn36va67crpnzmbh6dlq84ip910xsgas";
    };
    "2.4" = {
      kafkaVersion = "2.4.0";
      scalaVersion = "2.12";
      sha256 = "1vng5ipkjzqy0wijc706w2m1rjl5d0nsgbxiacci739y1jmjnn5r";
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

  buildInputs = [ jre makeWrapper bash gnugrep gnused coreutils ps ];

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

  meta = with stdenv.lib; {
    homepage = http://kafka.apache.org;
    description = "A high-throughput distributed messaging system";
    license = licenses.asl20;
    maintainers = [ maintainers.ragge ];
    platforms = platforms.unix;
  };

}
