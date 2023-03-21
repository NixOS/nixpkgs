{ stdenv
, fetchFromGitHub
, lib
, maven
, jdk11
, protobuf
, protoc-gen-grpc-java
, unzip
}:

let
  pname = "janusgraph-unwrapped";
  version = "1.0.0-rc2";
  hash = "sha256-T9SBswO3u0WZfytYTlEqXCrt5Qzb+ATPJ5vnbRCk5GE=";
  outputHash = "sha256-oUfivy2o1Jvtdrb4xKBhXzenipRvC8ZLciGQnk/8qGs=";
  fetchedMavenDeps = { pname, src, version, ... }: stdenv.mkDerivation {
    pname = "${pname}-maven-deps";
    inherit src version;

    nativeBuildInputs = [
      (maven.override { jdk = jdk11; })
      jdk11
      protobuf
      protoc-gen-grpc-java
    ];

    postPatch = ''
      sed -i 's|<protocArtifact>.*</protocArtifact>|<protocExecutable>${protobuf}/bin/protoc</protocExecutable>|g; /<pluginArtifact>/d' janusgraph-grpc/pom.xml
    '';

    buildPhase = ''
      runHook preBuild
      mvn package \
        -Dmaven.repo.local=$out \
        -Pjanusgraph-release \
        -Dmaven.test.failure.ignore=true \
        -Dgpg.skip=true \
        -Dadditionalparam=-Xdoclint:none \
        -DadditionalJOption=-Xdoclint:none
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      find $out -type f \
        -name \*.lastUpdated -or \
        -name resolver-status.properties -or \
        -name _remote.repositories \
        -delete
      runHook postInstall
    '';

    dontFixup = true;
    dontConfigure = true;
    outputHashMode = "recursive";
    inherit outputHash;
  };
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "JanusGraph";
    repo = "janusgraph";
    rev = "v${version}";
    inherit hash;
  };
  fetchedMavenDeps = fetchedMavenDeps finalAttrs;

  inherit (finalAttrs.fetchedMavenDeps) postPatch;

  nativeBuildInputs = finalAttrs.fetchedMavenDeps.nativeBuildInputs ++ [ unzip ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild
    mvn package \
        --offline \
        -Dmaven.repo.local=${finalAttrs.fetchedMavenDeps} \
        -Pjanusgraph-release \
        -Dgpg.skip=true \
        -DskipTests=true \
        -Dmaven.test.failure.ignore=true
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    unzip -q janusgraph-dist/target/janusgraph-full-*.zip -d $out
    f=("$out"/*) && mv "$out"/*/* "$out" && rmdir "''${f[@]}"
    runHook postInstall
  '';

  meta = with lib; {
    description = "An open-source, distributed graph database";
    homepage = "https://janusgraph.org/";
    mainProgram = "janusgraph-server";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.ners ];
  };
})
