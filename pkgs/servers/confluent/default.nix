{ stdenv, lib, fetchurl, jre, makeWrapper, bash, gnused }:

with lib;

let
  confluentVersion = "4.1.1";
  scalaVersion = "2.11";
  sha256 = "e00eb4c6c7445ad7a43c9cd237778d1cd184322aebf5ff64a8e9806ba2cc27aa";
in stdenv.mkDerivation rec {
  name = "confluent-${version}";
  version = "${confluentVersion}-${scalaVersion}";

  src = fetchurl {
    url = "http://packages.confluent.io/archive/${versions.majorMinor confluentVersion}/confluent-oss-${version}.tar.gz";
    inherit sha256;
  };

  buildInputs = [ jre makeWrapper bash ];

  installPhase = ''
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
        --prefix PATH : "${bash}/bin:${gnused}/bin"
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://www.confluent.io/;
    description = "Confluent platform";
    license = licenses.asl20;
    maintainers = [ maintainers.offline ];
    platforms = platforms.unix;
  };
}
