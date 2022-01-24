{ stdenv, lib, fetchurl, fetchFromGitHub
, jre, makeWrapper, bash, gnused }:

stdenv.mkDerivation rec {
  pname = "confluent-platform";
  version = "5.3.0";
  scalaVersion = "2.12";

  src = fetchurl {
    url = "http://packages.confluent.io/archive/${lib.versions.majorMinor version}/confluent-${version}-${scalaVersion}.tar.gz";
    sha256 = "14cilq63fib5yvj40504aj6wssi7xw4f7c2jadlzdmdxzh4ixqmp";
  };

  confluentCli = fetchFromGitHub {
    owner = "confluentinc";
    repo = "confluent-cli";
    rev = "v${version}";
    sha256 = "18yvp56b8l074qfkgr4afirgd43g8b023n9ija6dnk6p6dib1f4j";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre bash ];

  installPhase = ''
    cp -R $confluentCli confluent-cli
    chmod -R +w confluent-cli

    (
      export CONFLUENT_HOME=$PWD
      cd confluent-cli
      make install
    )

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
        --prefix PATH : "${jre}/bin:${bash}/bin:${gnused}/bin"
    done
  '';

  meta = with lib; {
    homepage = "https://www.confluent.io/";
    description = "Confluent event streaming platform based on Apache Kafka";
    license = licenses.asl20;
    maintainers = [ maintainers.offline ];
    platforms = platforms.unix;
  };
}
