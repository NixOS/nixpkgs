{
  lib,
  fetchFromGitHub,
  jdk11,
  gradle,
  makeWrapper,
}:

let
  pname = "aeron";
  version = "1.40.0";

  src = fetchFromGitHub {
    owner = "real-logic";
    repo = pname;
    rev = version;
    sha256 = "sha256-4C5YofA/wxwa7bfc6IqsDrw8CLQWKoVBCIe8Ec7ifAg=";
  };

in gradle.buildPackage rec {
  inherit pname src version;

  gradleOpts = {
    depsHash = "sha256-fe3NSOPIPgBAYQxFOfS6njo5i72VKMHpo6q6RpTlqXk=";
    lockfileTree = ./lockfiles;
    flags = [
      "--console" "plain"
      "--project-prop" "VERSION=${version}"
      "--system-prop" "org.gradle.java.home=${jdk11.home}"
    ];
  };

  buildInputs = [
    jdk11
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    install -D --mode=0444 --target-directory="$out/share/java" \
      "./aeron-all/build/libs/aeron-all-${version}.jar" \
      "./aeron-agent/build/libs/aeron-agent-${version}.jar" \
      "./aeron-archive/build/libs/aeron-archive-${version}.jar" \
      "./aeron-client/build/libs/aeron-client-${version}.jar"

    runHook postInstall
  '';

  postFixup = ''
    function wrap {
      makeWrapper "${jdk11}/bin/java" "$out/bin/$1" \
        --add-flags "--add-opens java.base/sun.nio.ch=ALL-UNNAMED" \
        --add-flags "--class-path $out/share/java/aeron-all-${version}.jar" \
        --add-flags "$2"
    }

    wrap "${pname}-media-driver" io.aeron.driver.MediaDriver
    wrap "${pname}-stat" io.aeron.samples.AeronStat
    wrap "${pname}-archiving-media-driver" io.aeron.archive.ArchivingMediaDriver
    wrap "${pname}-archive-tool" io.aeron.archive.ArchiveTool
    wrap "${pname}-logging-agent" io.aeron.agent.DynamicLoggingAgent
    wrap "${pname}-cluster-tool" io.aeron.cluster.ClusterTool
  '';

  meta = with lib; {
    description = "Low-latency messaging library";
    homepage = "https://aeron.io/";
    license = licenses.asl20;
    maintainers = [ maintainers.vaci ];
  };
}
