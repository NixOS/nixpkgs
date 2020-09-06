{ lib, stdenv, fetchurl, jdk, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "elasticmq-server";
  version = "0.15.7";

  src = fetchurl {
    url = "https://s3-eu-west-1.amazonaws.com/softwaremill-public/${pname}-${version}.jar";
    sha256 = "01jmb6rwh570f2y30b2if5fhcbpdnb2vkxylp9xa09c0x7a2vv4q";
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

  meta = with lib; {
    homepage = "https://github.com/softwaremill/elasticmq";
    description = "Message queueing system with Java, Scala and Amazon SQS-compatible interfaces";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ peterromfeldhk ];
  };
}
