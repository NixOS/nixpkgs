{ stdenv, lib, fetchurl, fetchzip
, jre, makeWrapper, bash, gnused }:

stdenv.mkDerivation rec {
  pname = "confluent-platform";
  version = "5.5.0";
  scalaVersion = "2.12";
  confluentCliVersion = "1.10.0";

  src = fetchurl {
    url = "https://packages.confluent.io/archive/${lib.versions.majorMinor version}/confluent-${version}-${scalaVersion}.tar.gz";
    sha256 = "0bfc2dsryyb000m1if0sqvncsjxrf1i415h7azjr02f5vbhs83ci";
  };

  confluentCli = fetchzip (if stdenv.hostPlatform.isDarwin then {
      url = "https://s3-us-west-2.amazonaws.com/confluent.cloud/confluent-cli/archives/${confluentCliVersion}/confluent_v${confluentCliVersion}_darwin_amd64.tar.gz";
      sha256 = "07g09c6yy74hmmk3wn0jzhq37nkc5qmcpl14zw01700albn22y79";
    } else {
      url = "https://s3-us-west-2.amazonaws.com/confluent.cloud/confluent-cli/archives/${confluentCliVersion}/confluent_v${confluentCliVersion}_linux_amd64.tar.gz";
      sha256 = "1m2c9r84lykv0shj990k81cfjhcb3ljzi0ibjkaavsif1b0llq14";
    });

  buildInputs = [ jre makeWrapper bash ];

  installPhase = ''
    mkdir -p $out

    cp -R bin etc share src $out
    rm -rf $out/bin/windows

    cp -R $confluentCli confluent-cli
    mkdir -p $out/share/doc/confluent-cli
    cp confluent-cli/confluent $out/bin/
    cp confluent-cli/LICENSE $out/share/doc/confluent-cli/
    cp -r confluent-cli/legal $out/share/doc/confluent-cli/

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
        --set CONFLUENT_HOME "$out" \
        --prefix PATH : "${jre}/bin:${bash}/bin:${gnused}/bin"
    done
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.confluent.io/";
    description = "Confluent event streaming platform based on Apache Kafka";
    license = licenses.unfree;
    maintainers = [ maintainers.offline ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
