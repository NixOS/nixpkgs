{ stdenv, fetchurl, jre, makeWrapper, which }:

stdenv.mkDerivation rec {
  name = "elasticmq-0.5";

  src = fetchurl {
    url = "https://github.com/downloads/adamw/elasticmq/${name}.tar.gz";
    sha256 = "1zpv3vzairprh4x9fia82qqr14kf5hpxq1r90mn4ww7ighbv9pf1";
  };

  buildInputs = [ makeWrapper ];

  installPhase =
    ''
      mkdir -p $out/bin
      cp -prd lib conf $out/
      
      cp bin/run.sh $out/bin/elasticmq
      substituteInPlace $out/bin/elasticmq --replace '-DBASEDIR=$BASEDIR' '-DBASEDIR=''${ELASTICMQ_DATA_PREFIX:-.}'

      wrapProgram $out/bin/elasticmq --prefix PATH : "${stdenv.lib.makeBinPath [ which jre ]}"
    '';

  meta = {
    homepage = https://github.com/adamw/elasticmq;
    description = "Message queueing system with Java, Scala and Amazon SQS-compatible interfaces";
    longDescription =
      ''
        ElasticMQ is a message queueing system with Java, Scala and
        Amazon SQS-compatible interfaces.  You should set the
        environment ELASTICMQ_DATA_PREFIX to a writable directory
        where ElasticMQ will store its data and log files.  It also
        looks for its configuration file in
        $ELASTICMQ_DATA_PREFIX/conf/Default.scala.  You can use the
        Default.scala included in the distribution as a template.
      '';
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;
  };
}
