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
      kafkaVersion = "1.0.1";
      scalaVersion = "2.12";
      sha256 = "1fxn6i0kanwksj1dhcnlni0cn542k50wdg8jkwhfmf4qq8yfl90m";
    };
    "1.1" = {
      kafkaVersion = "1.1.0";
      scalaVersion = "2.12";
      sha256 = "04idhsr6pbkb0xkx38faxv2pn5nkjcflz6wl4s3ka82h1fbq74j9";
    };
    "2.0" = {
      kafkaVersion = "2.0.0";
      scalaVersion = "2.12";
      sha256 = "0mbrp8rafv1bra9nrdicpxy6w59ixanaj50c9pkgdrih82f57wdm";
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
