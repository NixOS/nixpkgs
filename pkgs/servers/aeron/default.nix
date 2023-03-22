{
  lib,
  stdenv,
  fetchMavenArtifact,
  jdk11,
  makeWrapper
}:

let
  pname = "aeron";
  version = "1.40.0";
  groupId = "io.aeron";

  aeronAll_1_40_0 = fetchMavenArtifact {
    inherit groupId;
    version = "1.40.0";
    artifactId = "aeron-all";
    hash = "sha512-NyhYaQqOWcSBwzwpje6DMAp36CEgGSNXBSdaRrDyP+Fn2Z0nvh5o2czog6GKKtbjH9inYfyyF/21gehfgLF6qA==";
  };

  aeronAgent_1_40_0 = fetchMavenArtifact {
    inherit groupId;
    version = "1.40.0";
    artifactId = "aeron-agent";
    hash = "sha512-3XZ6XxPwlNchMe4p4MuDNTWntGokFPnetN7AUMlhXzIgeXBExXvn+BdxI2crfq/xgVGrF/hjHD2shwu2NBa0Tg==";
  };

  aeronArchive_1_40_0 = fetchMavenArtifact {
    inherit groupId;
    version = "1.40.0";
    artifactId = "aeron-archive";
    hash = "sha512-tmH+/020d1iNkGb8nvenDG9YU+H4PLuO2hSm2dULUIjSXX5AHLDkkrQ3uVQADV9koRNMtC4UXloqtqncay18kQ==";
  };

  aeronClient_1_40_0 = fetchMavenArtifact {
    inherit groupId;
    version = "1.40.0";
    artifactId = "aeron-client";
    hash = "sha512-y3/8Lu2EgMICRNPEWe0hrKpVhF35pDjCO6ip/Af9nPZ70ZRqGmlfEG7OzWVok11DuI8pYJ64jv6bEtUfSHTYXQ==";
  };

  aeronCluster_1_40_0 =fetchMavenArtifact {
    inherit groupId;
    version = "1.40.0";
    artifactId = "aeron-cluster";
    hash = "sha512-28m14Etjse3MVKBLvaQONujMfvdRQZG0ArezzVcjPEqVqTGd33mrqjPngALV8CG2nJTtcrJmsieRGLEosaXqTw==";
  };

  aeronDriver_1_40_0 = fetchMavenArtifact {
    inherit groupId;
    version = "1.40.0";
    artifactId = "aeron-driver";
    hash = "sha512-SRWHMHR6J1YEtCbSHqSLYm3vo8XgkVXGK3cFQbONT60TZvawP5UlZs7e3eFNpu3qQSA4prqEjjWO9Xc9M/sjKw==";
  };

  aeronSamples_1_40_0 = fetchMavenArtifact {
    inherit groupId;
    version = "1.40.0";
    artifactId = "aeron-samples";
    hash = "sha512-vyAq4mfLDDyaVk7wcIpPvPcxSt92Ek8mxfuuZwaX+0Wu9oJCpwbnjvS9+bvzcE4qSGxzY6eJIIX6nMdw0LkACg==";
  };

  aeronAll = aeronAll_1_40_0;
  aeronArchive = aeronArchive_1_40_0;
  aeronClient = aeronClient_1_40_0;
  aeronCluster = aeronCluster_1_40_0;
  aeronDriver= aeronDriver_1_40_0;
  aeronSamples = aeronSamples_1_40_0;

in stdenv.mkDerivation {

  inherit pname version;

  buildInputs = [
    aeronAll
    aeronArchive
    aeronClient
    aeronCluster
    aeronDriver
    aeronSamples
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir --parents "$out/share/java"
    ln --symbolic "${aeronAll.jar}" "$out/share/java/${pname}-all-${version}.jar"
    ln --symbolic "${aeronArchive.jar}" "$out/share/java/${pname}-archive-${version}.jar"
    ln --symbolic "${aeronClient.jar}" "$out/share/java/${pname}-client-${version}.jar"
    ln --symbolic "${aeronCluster.jar}" "$out/share/java/${pname}-cluster-${version}.jar"
    ln --symbolic "${aeronDriver.jar}" "$out/share/java/${pname}-driver-${version}.jar"
    ln --symbolic "${aeronSamples.jar}" "$out/share/java/${pname}-samples-${version}.jar"

    runHook postInstall
  '';

  postFixup = ''
    function wrap {
      makeWrapper "${jdk11}/bin/java" "$out/bin/$1" \
        --add-flags "--add-opens java.base/sun.nio.ch=ALL-UNNAMED" \
        --add-flags "--class-path ${aeronAll.jar}" \
        --add-flags "$2"
    }

    wrap "${pname}-media-driver" io.aeron.driver.MediaDriver
    wrap "${pname}-stat" io.aeron.samples.AeronStat
    wrap "${pname}-archiving-media-driver" io.aeron.archive.ArchivingMediaDriver
    wrap "${pname}-archive-tool" io.aeron.archive.ArchiveTool
    wrap "${pname}-logging-agent" io.aeron.agent.DynamicLoggingAgent
    wrap "${pname}-cluster-tool" io.aeron.cluster.ClusterTool
  '';

  passthru = {
    jar = aeronAll.jar;
  };

  meta = with lib; {
    description = "Low-latency messaging library";
    homepage = "https://aeron.io/";
    license = licenses.asl20;
    maintainers = [ maintainers.vaci ];
  };
}
