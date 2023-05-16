<<<<<<< HEAD
{ lib, stdenv, fetchurl, jdk, jre, makeBinaryWrapper, runCommand, python3Packages, writeText }:

stdenv.mkDerivation (finalAttrs: {
  pname = "elasticmq-server";
  version = "1.4.3";

  src = fetchurl {
    url = "https://s3-eu-west-1.amazonaws.com/softwaremill-public/${finalAttrs.pname}-${finalAttrs.version}.jar";
    sha256 = "sha256-7eWdhsYkeUKnr7BzJhJ9/jFn76CdK7Qq1eIfV/OG7es=";
  };

  # don't do anything?
  unpackPhase = "${jdk}/bin/jar xf $src favicon.png";

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/share/elasticmq-server

    cp $src $out/share/elasticmq-server/elasticmq-server.jar

    # TODO: how to add extraArgs? current workaround is to use JAVA_TOOL_OPTIONS environment to specify properties
    makeWrapper ${jre}/bin/java $out/bin/elasticmq-server \
      --add-flags "-jar $out/share/elasticmq-server/elasticmq-server.jar"
  '';

  passthru.tests.elasticmqTest = import ./elasticmq-test.nix {
    inherit runCommand python3Packages writeText;
    elasticmq-server = finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "Message queueing system with Java, Scala and Amazon SQS-compatible interfaces";
    homepage = "https://github.com/softwaremill/elasticmq";
    changelog = "https://github.com/softwaremill/elasticmq/releases/tag/v${finalAttrs.version}";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ peterromfeldhk ];
=======
{ lib, stdenv, fetchurl, jdk, jre, makeWrapper, runCommand, python3Packages, writeText }:

let
  elasticmq-server = stdenv.mkDerivation rec {
    pname = "elasticmq-server";
    version = "1.3.14";

    src = fetchurl {
      url = "https://s3-eu-west-1.amazonaws.com/softwaremill-public/${pname}-${version}.jar";
      sha256 = "sha256-diTfRYV51d9QYx1E6ZbSSaM6qDIaqVPum9qsBagIcec=";
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
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      license = licenses.asl20;
      platforms = platforms.unix;
      maintainers = with maintainers; [ peterromfeldhk ];
    };
  };
in elasticmq-server.overrideAttrs (_: {
  passthru.tests.elasticmqTest = import ./elasticmq-test.nix {
    inherit elasticmq-server runCommand python3Packages writeText;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
})
