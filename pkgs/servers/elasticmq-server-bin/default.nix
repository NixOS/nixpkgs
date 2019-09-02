{ stdenv, fetchurl, jdk, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "elasticmq-server";
  version = "0.14.6";

  src = fetchurl {
    url = "https://s3-eu-west-1.amazonaws.com/softwaremill-public/${pname}-${version}.jar";
    sha256 = "1cp2pmkc6gx7gr6109jlcphlky5rr6s1wj528r6hyhzdc01sjhhz";
  };

  # don't do anything?
  unpackPhase = "${jdk}/bin/jar xf $src favicon.png";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/share/elasticmq-server

    cp $src $out/share/elasticmq-server/elasticmq-server.jar

    # TODO: how to add extraArgs? current workaround is to use JAVA_TOOL_OPTIONS environment to specify properties
    makeWrapper ${jre}/bin/java $out/bin/elasticmq-server \
      --add-flags "-jar $out/share/elasticmq-server/elasticmq-server.jar"
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/softwaremill/elasticmq";
    description = "Message queueing system with Java, Scala and Amazon SQS-compatible interfaces";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ peterromfeldhk ];
  };
}
